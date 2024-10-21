-- Constants
KEY = "NDSPlayerData_"
SHARED = false

-- Variables
disasters = table.create("Meteor Shower","Flash Flood","Thunder Storm","Fire","Tornado","Tsunami","Blizzard","Sandstorm","Volcanic Eruption","Earthquake","Acid Rain")

-- Build
function createTag(type, name, value, parent) {
    tag = Instance.new(type, parent)
    tag.Name = name
    tag.Value = value
    return tag
}

function createFolder(name, parent) {
    folder = Instance.new("Folder", parent)
    folder.Name = name
    return folder
}

function init() {
    template = createFolder("PlayerData", script)

    disastersSection = createFolder("Disasters", template)
    disastersSurvived = createFolder("Survived", disastersSection)
    disastersPlayed = createFolder("Played", disastersSection)

    mapsSection = createFolder("Maps", template)
    mapsSurvived = createFolder("Survived", mapsSection)
    mapsPlayed = createFolder("Played", mapsSection)

    createTag("IntValue", "PlayedTotal", 0, template)
    createTag("IntValue", "SurvivedTotal", 0, template)
    createTag("IntValue", "ConsecutiveWins", 0, template)

    tableloop _, disaster in disasters {
        createTag("IntValue", disaster, 0, disastersSurvived)
        createTag("IntValue", disaster, 0, disastersPlayed)
    }

    tableloop _, structure in game.Lighting.Storage.Structures:GetChildren() {
        name = structure.Name
        createTag("IntValue", name, 0, mapsSurvived)
        createTag("IntValue", name, 0, mapsPlayed)
    }

    return template
}
init()

function getKey(player) {
    id = player.UserId
    result = compiler.InsertBlockConnectedLast("CombineKeyWithUserId", "CombineStringWithNumber", KEY, id)
    return result
}

function savePlayerData(player) {
    shouldCancelValue = player:FindFirstChild("CancelDataSave")
    playerData = player:FindFirstChild("PlayerData")

    if shouldCancelValue == nil and playerData ~= nil {
        data = table.create()
        data["PlayedTotal"] = playerData.PlayedTotal.Value
        data["SurvivedTotal"] = playerData.SurvivedTotal.Value
        data["ConsecutiveWins"] = playerData.ConsecutiveWins.Value

        mapsTable = table.create()
        mapsPlayed = table.create()
        mapsSurvived = table.create()

        tableloop _, map in playerData.Maps.Played:GetChildren() {
            mapsPlayed[map.Name] = map.Value
        }
        tableloop _, map in playerData.Maps.Survived:GetChildren() {
            mapsSurvived[map.Name] = map.Value
        }

        mapsTable["Survived"] = mapsSurvived
        mapsTable["Played"] = mapsPlayed
        data["Maps"] = mapsTable

        disastersTable = table.create()
        disastersPlayed = table.create()
        disastersSurvived = table.create()

        tableloop _, disaster in playerData.Disasters.Played:GetChildren() {
            disastersPlayed[disaster.Name] = disaster.Value
        }
        tableloop _, disaster in playerData.Disasters.Survived:GetChildren() {
            disastersSurvived[disaster.Name] = disaster.Value
        }

        disastersTable["Survived"] = disastersSurvived
        disastersTable["Played"] = disastersPlayed
        data["Disasters"] = disastersTable

        key = getKey(player)
        DataStore.SaveVariable(data, key, SHARED)
    }
}

-- Studio
forceSave = Instance.new("BindableEvent", script)
event forceSave.Event(player) {
    savePlayerData(player)
}
forceSave.Name = "ForceSave"

-- Events
event PlayerAdded(player) {
    key = getKey(player)
    success, data = DataStore.LoadVariable(key, SHARED)

    if success == true {
        playerData = script.PlayerData:Clone()
        if data ~= nil {
            playerData.PlayedTotal.Value = data["PlayedTotal"]
            playerData.SurvivedTotal.Value = data["SurvivedTotal"]
            playerData.ConsecutiveWins.Value = data["ConsecutiveWins"]

            tableloop key, value in data["Disasters"]["Survived"] {
                entry = playerData.Disasters.Survived:FindFirstChild(key)
                if entry ~= nil {
                    entry.Value = value
                }
            }
            tableloop key, value in data["Disasters"]["Played"] {
                entry = playerData.Disasters.Played:FindFirstChild(key)
                if entry ~= nil {
                    entry.Value = value
                }
            }

            tableloop key, value in data["Maps"]["Survived"] {
                entry = playerData.Maps.Survived:FindFirstChild(key)
                if entry ~= nil {
                    entry.Value = value
                }
            }
            tableloop key, value in data["Maps"]["Played"] {
                entry = playerData.Maps.Played:FindFirstChild(key)
                if entry ~= nil {
                    entry.Value = value
                }
            }
        }
        playerData.Parent = player
    } else {
        createTag("BoolValue", "CancelDataSave", true, player)
        player:Kick()
    }
}

event PlayerRemoving(player) {
    savePlayerData(player)
}
