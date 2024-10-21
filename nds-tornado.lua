@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

-- tornado ---------------------
tornadodparts = table.create()
tornadopos = Vector3.new(0, 0, 0)
maxheight = 300
low = 40
speed = 100
push = 0.1
pull = -0.5
lift = 0.25
breakradius = 35
cycloneradius = 10
-- -----------------------------

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

function updatetornado(mdl) {
	if mdl ~= nil {
		if mdl:IsA("BasePart") {
			if mdl.Anchored == false and mdl.Position.Y < maxheight {
				dist = Vector3.magnitude((mdl.Position * Vector3.new(1,0,1)) - tornadopos, Vector3.new(0, 0, 0))
				if dist < breakradius {
					h = mdl.Parent:FindFirstChild("Humanoid")
					if h == nil {
						mdl:BreakJoints()
					}

					pushpull = pull
					hightpercentage = (mdl.Position.Y / (maxheight - low))
					pushpull = pull + ((push - pull) * hightpercentage)
					if dist < cycloneradius {
						pushpull = push
					}

					angle = math.atan2(mdl.Position.X - tornadopos.X, mdl.Position.Z - tornadopos.Z)
					ncf = (CFrame.new(tornadopos, Vector3.new(0, 0, 0)) + Vector3.new(0, mdl.Position.Y, 0)) * CFrame.Angles(0, angle + 0.1, 0) * cfp(0, 0, dist + pushpull)
					
                    marker = workspace:FindFirstChild("Marker")
					if marker ~= nil {
						workspace.Marker.CFrame = ncf
					}

					vec = Vector3.normalize((ncf.Position-mdl.Position))
					speedpercent = (dist-cycloneradius)/(breakradius-cycloneradius)
					if speedpercent < 0 {
						speedpercent = 0
					}

					speedpercent = 1 - speedpercent
					speedpercent = speedpercent + 0.1
					if speedpercent > 1 {
						speedpercent = 1
					}

					mdl.Velocity = (vec*speedpercent*speed*(1+(2*hightpercentage)))+Vector3.new(0,(lift*(speedpercent+hightpercentage)*speed),0)
					-- mdl.RotVelocity=mdl.RotVelocity+Vector3.new(math.random(-1,1),math.random(-1,1)+.1,math.random(-1,1))

					if tornadodparts[mdl] == nil {
						if h ~= nil {
							if mdl.Name == "HumanoidRootPart" and h.PlatformStand == false {
								h.PlatformStand = true

								mockspawn = Instance.new("BindableEvent", game.Debris)
								event mockspawn.Event(_) {
									wait(5)
									if h ~= nil {
										h.PlatformStand = false
									}
									mockspawn:Destroy()
								}
								mockspawn:Fire()
							}
						} else {
							if math.random(1, 2) ==1 {
								mdl:Destroy()
							} else {
								tornadodparts[mdl] = true
							}
						}
					}
				}
			}
		}

		if mdl ~= nil {
			if mdl.Parent ~= nil {
				tableloop _, v3 in mdl:GetChildren() {
					if v3 ~= nil {
						updatetornado(v3)
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
	tornadoing = true
	tornadoposes = table.create()
	tornadostartpos = Vector3.new(math.random(-85,70), 0, math.random(-90,80))
	tornadopos = tornadostartpos

	for i = 1, 10 {
		table.append(tornadoposes, Vector3.new(math.random(-85, 70), 0, math.random(-90, 80)))
    }

	tp = storage.TornadoPart:Clone()
	tp.CFrame = CFrame.new(tornadostartpos + Vector3.new(0, low, 0), Vector3.new(0, 0, 0))
	tp.Parent = game.Workspace.Structure
	wait(0.2)

	iwsound = tp:FindFirstChild("IntenseWind")
	if iwsound ~= nil {
		iwsound:Play()
    }
	a = 0

    mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
        starttime = retrostudio.OsClock()
		endtime = starttime + 90
		tornadodparts = table.create()

		while tornadoing == true {
			a = a + 1
			if a % 2 == 0 {
				totalpercent = math.min(1,math.max(0,(retrostudio.OsClock() - starttime)/(endtime-starttime)))
				posframe = math.ceil(table.length(tornadoposes) * totalpercent)
				pospercent = (totalpercent-((posframe-1)/table.length(tornadoposes)))*table.length(tornadoposes)
				lastposframe = tornadoposes[posframe-1]
                if lastposframe == nil {
                    lastposframe = tornadostartpos
                }
				tornadopos = lastposframe+((tornadoposes[posframe] - lastposframe)*pospercent)
				if tp ~= nil {
					tp.CFrame = CFrame.new(tornadopos+Vector3.new(0,low,0), Vector3.new(0, 0, 0))
                }
				updatetornado(game.Workspace.Structure)
            } else  {
				tableloop _,v in game.Players:GetChildren() {
					if v ~= nil {
						if v.Character ~= nil {
							updatetornado(v.Character)
                        }
                    }
                }
            }
			wait(rate)
        }
    }
    mockspawn:Fire()

	wait(90)
	tornadodparts = nil
	tornadoing = false
	oldcontent.Sounds.Wind:Stop()
}

disaster = table.create()
disaster["Name"] = "Tornado"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
