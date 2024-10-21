@flag BypassVariableAntiFilter

function createTag(valuetype, name, value, parent) {
    tag = Instance.new(valuetype, parent)
    tag.Name = name
    tag.Value = value
    return tag
}

parent = workspace.Server.Common.Badges
createTag("IntValue", "Survived a Disaster", 1, parent)
createTag("IntValue", "Survived 10 Disasters", 2, parent)
createTag("IntValue", "Survived 25 Disasters", 3, parent)
createTag("IntValue", "Survived 50 Disasters", 4, parent)
createTag("IntValue", "Survived 100 Disasters", 5, parent)
createTag("IntValue", "Survived 200 Disasters", 6, parent)
createTag("IntValue", "Survived 400 Disasters", 7, parent)
createTag("IntValue", "Chance", 8, parent)
createTag("IntValue", "Master of Disaster", 9, parent)
createTag("IntValue", "High Survive Five!", 10, parent)
createTag("IntValue", "Surf's Up!", 11, parent)
createTag("IntValue", "Barn Fire", 12, parent)
createTag("IntValue", "Close Call", 13, parent)
createTag("IntValue", "House Flood", 14, parent)
createTag("IntValue", "GET TO THE CHOPPA!", 15, parent)
createTag("IntValue", "Adventurer", 16, parent)
createTag("IntValue", "Tornado vs. Trailer Park", 17, parent)
