sp = script.Parent
spf = sp.StatsPage.Frame

lastplayer = nil
disasters = table.create("Meteor Shower","Flash Flood","Thunder Storm","Fire","Tornado","Tsunami","Blizzard","Sandstorm","Volcanic Eruption","Earthquake","Acid Rain")

common = workspace.Server:WaitForChild("Common")
function awardBadge(player, badgename) {
	common.Functions.GiveBadge:Fire(player, badgename)
}

function loadlist(plr) {
	playerData = plr:FindFirstChild("PlayerData")
	if plr ~= nil and plr.Parent == game.Players and playerData ~= nil {
		tableloop _, v in spf.List:GetChildren() {
			v:Destroy()
		}

		list1 = table.create()
		list2 = table.create()

		if spf.CategoryButton.Text == "Disaster" {
			masterdisasterbadge = 0
			tableloop i,v in disasters {
				if spf.StatTypeButton.Text == "Percent" {
					list1[i] = v
					scsval = playerData.Disasters.Survived:FindFirstChild(v)
					scpval = playerData.Disasters.Played:FindFirstChild(v)
					scs = scsval.Value
					scp = scpval.Value
					fscp = 1

					if scp > 0 and scs <= scp {
						fscp = scs / scp
					}
					list2[i] = fscp
				} else {
					list1[i] = v
					if spf.StatTypeButton.Text == "Survived" {
						val = playerData.Disasters.Survived:FindFirstChild(v)
						list2[i] = val.Value
					} else {
						val = playerData.Disasters.Played:FindFirstChild(v)
						list2[i] = val.Value
					}

					if spf.StatTypeButton.Text == "Survived" and list2[i] >= 1 {
						masterdisasterbadge = masterdisasterbadge+1
					}
				}
			}

			if masterdisasterbadge == table.length(disasters) {
				awardBadge(plr, "Master of Disaster")
			}
		} else {
			if spf.CategoryButton.Text == "Map" {
				travelerbadge = 0
				tableloop i, v in game.Lighting.Storage.Structures:GetChildren() {
					if spf.StatTypeButton.Text == "Percent" {
						list1[i] = v.Name
						scsval = playerData.Maps.Survived:FindFirstChild(v.Name)
						scpval = playerData.Maps.Played:FindFirstChild(v.Name)
						scs = scsval.Value
						scp = scpval.Value
						fscp = 1
						
						if scp > 0 and scs <= scp {
							fscp = scs / scp
						}
						list2[i] = fscp
					} else {
						list1[i] = v.Name
						if spf.StatTypeButton.Text == "Survived" {
							val = playerData.Maps.Survived:FindFirstChild(v.Name)
							list2[i] = val.Value
						} else {
							val = playerData.Maps.Played:FindFirstChild(v.Name)
							list2[i] = val.Value
						}

						if spf.StatTypeButton.Text == "Played" and list2[i] >= 1 {
							travelerbadge = travelerbadge+1
						}
					}
				}

				structures = game.Lighting.Storage.Structures:GetChildren()
				if travelerbadge == table.length(structures) {
					awardBadge(plr, "Adventurer")
				}
			}
		}

		n = 0
		lis = math.floor(spf.List.AbsoluteSize.Y/(table.length(list1)))
		tableloop i, v in list1 {
			n = n + 1

			nl = spf.NameLabel:Clone()
			nl.Text = v
			nl.Size = UDim2.new(0, 135, 0, lis)
			nl.Position = UDim2.new(0, 10, 0, (lis * n) - lis)
			nl.Parent = spf.List
			nl.Visible = true

			sl = spf.StatLabel:Clone()
			if spf.StatTypeButton.Text=="Percent" {
                numper = math.floor((list2[i]*100)+0.5)
				result = compiler.InsertBlockConnectedLast("CombinePercentage", "CombineNumberWithString", numper, "%")
				sl.Text = result
			} else {
				sl.Text = tostring(list2[i])
			}
			sl.Position = UDim2.new(1, -62, 0, (lis * n) - lis)
			sl.Parent = spf.List
			sl.Visible = true
		}
	}
}

function loadstats(plr) {
	if plr ~= nil {
        userid = plr.UserId
		format = compiler.InsertBlockConnectedLast("CombineAvatar", "CombineStringWithNumber", "rbxthumb://type=Avatar&w=420&h=420&id=", userid)
		lastplayer = plr
		spf.PlayerButton.Text = plr.Name
		spf.PlayerImage.Image = format
		loadlist(plr)
		sp.StatsPage.Visible = true
	}
}

event sp.StatsButton.LeftButtonDown() {
	if sp.StatsPage.Visible == true {
		sp.StatsPage.Visible = false
	} else {
		loadstats(sp.Parent.Parent)
	}
}

event spf.CategoryButton.LeftButtonDown() {
	if spf.CategoryButton.Text == "Disaster" {
		spf.CategoryButton.Text = "Map"
	} else {
		if spf.CategoryButton.Text == "Map" {
			spf.CategoryButton.Text = "Disaster"
		}
	}
	loadlist(lastplayer)
}

event spf.StatTypeButton.LeftButtonDown() {
	if spf.StatTypeButton.Text == "Survived" {
		spf.StatTypeButton.Text = "Played"
	} else {
		if spf.StatTypeButton.Text == "Played" {
			spf.StatTypeButton.Text = "Percent"
		} else {
			if spf.StatTypeButton.Text == "Percent" {
				spf.StatTypeButton.Text = "Survived"
			}
		}
	}
	loadlist(lastplayer)
}
