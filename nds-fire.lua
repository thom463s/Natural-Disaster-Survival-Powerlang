@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

region3part = workspace:WaitForChild("_Region3Part", 30)

mapradius = 200
rate = 1/30
pi = math.rad(180)

function cfp(x, y, z) {
	return CFrame.new(Vector3.new(x, y, z), Vector3.new(0, 0, 0))
}

function blankrandom() {
	return math.random(0, 1000) / 1000
}

function findPartsInRegion3(region, maxParts) {
    partsInRegion = table.create()
    min = region[1]
    max = region[2]

    region3part.Size = max - min
    region3part.Position = (min + max) / 2
    touching = region3part:GetTouchingParts()

    tableloop i, part in touching {
        if part ~= nil and part:IsA("BasePart") {
            table.append(partsInRegion, part)
            if maxParts ~= nil and table.length(partsInRegion) >= maxParts {
                break
            }
		}
	}

    return partsInRegion
}

function startfire(mdl) {
    tableloop _, obj in mdl:GetDescendants() {
        if obj ~= nil {
            if obj.Name == "FireStarter" {
                if obj:IsA("BasePart") {
                    ft = Instance.new("IntValue", obj)
                    ft.Name = "FireTag"
                    ft.Value = 0
                }
            }
        }
    }
}

function updatefireparts(obj) {
    hit = table.create()

    tableloop _, mdl in obj:GetDescendants() {
        if mdl ~= nil {
            if mdl:IsA("BasePart") {
                ft = mdl:FindFirstChild("FireTag")
                if mdl.Anchored == false and ft ~= nil {
                    ft.Value = ft.Value+1
                    if ft.Value == 1 and mdl.Transparency == 0 {
                        f = Instance.new("Fire", mdl)
                    } else {
                        if ft.Value == 5 {
                            mdl.BrickColor = BrickColor.new("Black")
                        }
                        if ft.Value == 10 {
                            mdl:BreakJoints()
                        }
                        if ft.Value == 20 and blankrandom() <= 0.6 {
                            mdl:Destroy()
                        }
                        if ft.Value == 30 {
                            if mdl ~= nil {
                                f = mdl:FindFirstChild("Fire")
                                if f ~= nil {
                                    f:Destroy()
                                }
                            }
                        }
                    }
    
                    if ft.Value > 5 and ft.Value < 30 {
                        cf = mdl.CFrame * CFrame.new(mdl.Size*0.5, Vector3.new(0, 0, 0))
                        prerange = cf.Position - mdl.Position
                        range = Vector3.new(math.abs(prerange.X)+0.5,math.abs(prerange.Y)+0.5,math.abs(prerange.Z)+0.5)
                        stuff = findPartsInRegion3(table.create(mdl.Position-range, mdl.Position+range), 100)

                        tableloop _, v2 in stuff {
                            if v2 ~= nil {
                                if v2:IsA("BasePart") {
                                    vft = v2:FindFirstChild("FireTag")
                                    if v2.Anchored == false and vft == nil {
                                        h = v2.Parent:FindFirstChild("Humanoid")
                                        if h ~= nil {
                                            alreadyhit = table.find(hit, h)
                                            if alreadyhit == nil {
                                                h.Health = h.Health - 16
                                                table.append(hit, h)
                                            }
                                        } else {
                                            if blankrandom() > 0.25 {
                                                fta = Instance.new("IntValue", v2)
                                                fta.Name = "FireTag"
                                                fta.Value = 0
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {
	
}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	startfire(game.Workspace.Structure)
	burning = true

    mockspawn = Instance.new("BindableEvent", game.Debris)
    event mockspawn.Event(_) {
        while burning == true {
			wait(1)
			updatefireparts(game.Workspace.Structure)
        }
        mockspawn:Destroy()
    }
    mockspawn:Fire()

	wait(90)
	burning = false
}

disaster = table.create()
disaster["Name"] = "Fire"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
