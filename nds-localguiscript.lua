sp = script.Parent

plr = game.Players.LocalPlayer
sps = sp.SurviversPage.Frame
doubledgui = sp:WaitForChild("DoubleDisasterSplash")
oldcontent = game.Workspace:WaitForChild("ContentModel")
sharedstorage = game.Lighting.Shared
eventobject = sharedstorage:WaitForChild("Event")
notificationholder = sp:WaitForChild("NotificationHolder")

testing = false
disasters = table.create("Meteor Shower","Flash Flood","Thunder Storm","Fire","Tornado","Tsunami","Blizzard","Sandstorm","Volcanic Eruption","Earthquake","Acid Rain")

status = oldcontent.Status
event status.AnyPropertyChanged(_) {
	if status.Value=="Survivers" {
		tableloop _, v5 in sps.List:GetChildren() {
			v5:Destroy()
		}

		survivers = oldcontent.Survivers:GetChildren()
		tableloop i6, v6 in survivers {
			nnt = sps.NameLabel:Clone()
			if table.length(survivers) <= 10 {
				nnt.Size = UDim2.new(1,0,0,25)
				nnt.Position = UDim2.new(0, 0, 0, 25*((i6-1)%10))
			} else {
				if table.length(survivers) <= 20 {
					nnt.Size = UDim2.new(0.5, 0, 0, 25)
				nnt.Position = UDim2.new(math.floor((i6-1)/10)/2,0,0,25*((i6-1)%10))
				} else {
					nnt.Size = UDim2.new(0.33, 0, 0, 25)
					nnt.Position = UDim2.new(math.floor((i6-1)/10)/3,0,0,25*((i6-1)%10))
				}
			}
			nnt.Text = v6.Name
			nnt.Parent = sps.List
			nnt.Visible = true
		}

		if table.length(survivers) == 0 {
			sp.SurviversPage.Frame.NooneWins.Visible = true
		} else {
			sp.SurviversPage.Frame.NooneWins.Visible = false
		}

		sp.SurviversPage.Visible = true
		sp.NextMapPage.Visible = false

		waitduration = 10
		if table.length(survivers) == 0 {
			waitduration = 5
		}

		wait(waitduration)
		sp.SurviversPage.Visible = false
	}
	
	if status.Value == "New Map" {
		sp.NextMapPage.Frame.List.MapTitle.Text = oldcontent.Information.Value
		sp.NextMapPage.Visible = true
		sp.SurviversPage.Visible = false

		wait(5)
		sp.NextMapPage.Visible = false
	}

	if status.Value == "Double Disaster" {
		doubledgui.Visible = true
		sizex = 400
		sizey = 300
		doubledgui.Size = UDim2.new(0, sizex*0.5, 0, sizey*0.5)
		doubledgui.Position = UDim2.new(0, (sizex*-1)*0.25, 0.5, (sizey*-1)*0.25)
		TweenService.TweenProperty(doubledgui, "Position", UDim2.new(0.5, (sizex*-1)*0.25, 0.4, (sizey*-1)*0.25), 1, "Quad", "Out", 0, false)
		wait(1)
		TweenService.TweenProperty(doubledgui, "Position", UDim2.new(0.5, (sizex*-1)*0.5, 0.4, (sizey*-1)*0.5), 0.5, "Quad", "Out", 0, false)
		TweenService.TweenProperty(doubledgui, "Size", UDim2.new(0, sizex, 0, sizey), 0.5, "Quad", "Out", 0, false)
		wait(5)
		TweenService.TweenProperty(doubledgui, "Position", UDim2.new(0.5, (sizex*-1)*0.25, 0.4, (sizey*-1)*0.25), 0.5, "Quad", "Out", 0, false)
		TweenService.TweenProperty(doubledgui, "Size", UDim2.new(0, sizex*0.5, 0, sizey*0.5), 0.5, "Quad", "Out", 0, false)
		wait(0.5)
		TweenService.TweenProperty(doubledgui, "Position", UDim2.new(1, 10, 0.5, (sizey*-1)*0.25), 1, "Quad", "Out", 0, false)
		wait(2)
		doubledgui.Visible = false
	}
}
