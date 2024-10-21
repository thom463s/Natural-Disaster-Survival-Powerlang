@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

mapradius = 200
rate = 1/30
pi = math.rad(180)

function cfp(x, y, z) {
	return CFrame.new(Vector3.new(x, y, z), Vector3.new(0, 0, 0))
}

function blankrandom() {
	return math.random(0, 1000) / 1000
}

function clouds(cloudtime) {
	cloud = storage.Cloud:Clone()
	cloud.Parent = workspace.Structure
	pos1 = Vector3.new(6000, 300, -4000)
	pos2 = Vector3.new(-2000, 300, 2000)

	for i = 1, (1/rate)*cloudtime {
		if cloud ~= nil {
			wait(rate)
			cloud.CFrame = CFrame.new(pos1+((pos2-pos1)*(i/(cloudtime*(1/rate)))), Vector3.new(0, 0, 0))
		}
	}
}

function breakjointsunderhight(mdl, breakhight, breakchance) {
	if mdl ~= nil {
		if mdl:IsA("BasePart") {
			if mdl.Anchored == false and mdl.Position.Y <= breakhight {
				if blankrandom() < breakchance {
					mdl:BreakJoints()
					mdl.Velocity = mdl.Velocity+Vector3.new(math.random(-3,3),math.random(-3,3),math.random(-3,3))
				}
				if blankrandom() < breakchance {
					mdl:Destroy()
				}
			}
		}
		
		if mdl ~= nil {
			if mdl.Parent ~= nil {
				tableloop _, v3 in mdl:GetChildren() {
					if v3 ~= nil {
						breakjointsunderhight(v3, breakhight, breakchance)
					}
				}
			}
		}
	}
}

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {
	function startClouds(_) {
		wait(1)
		clouds(100)
	}
	spawn(startClouds, _)

	function wind(_) {
		wait(15)
		oldcontent.Sounds.Wind:Play()
	}
	spawn(wind, _)
}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	fl = storage.FloodLevel:Clone()
	fl.Parent = game.Workspace.Structure

	totalfloodhight = 70
	floodspeed = 2 * rate
	floodstart = 15
	radius = 3
	wavetime = 10	
	a = 0
	flooding = true

	mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
		while flooding == true {
			wait(rate)
			a = a + 1
			floodhight = floodstart + (a * floodspeed)
			if floodhight > totalfloodhight {
				floodhight = totalfloodhight
			}

			floodhight = floodhight + math.sin((a/(wavetime*30))*pi)*radius
			if fl ~= nil {
				fl.CFrame = cfp(0,floodhight,0)
			}

			if a % 30 == 0 {
				tableloop _, v in game.Players:GetChildren() {
					if v ~= nil {
						if v.Character ~= nil {
							he = v.Character:FindFirstChild("Head")
							hu = v.Character:FindFirstChild("Humanoid")

							if he ~= nil and hu ~= nil {
								if he.Position.Y < floodhight {
									hu.Health = hu.Health - 10
								}
							}
						}
					}
				}
			}

			if (a + 15) % 30 == 0 {
				breakjointsunderhight(game.Workspace.Structure, floodhight, 0.075)
			}
		}
		mockspawn:Destroy()
	}
	mockspawn:Fire()

	wait(60)
	flooding = false
	oldcontent.Sounds.Wind:Stop()
}

disaster = table.create()
disaster["Name"] = "Flash Flood"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
