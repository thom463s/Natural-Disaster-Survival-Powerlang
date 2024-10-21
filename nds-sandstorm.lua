@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")
weatherdome = workspace:WaitForChild("WeatherDome")

-- blizzard --------------------
blizfogend = 500
blizfogstart = 0
blizfogcolor = Color3.fromRGB(0.9*255, 0.9*255, 0.9*255)
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

function castray(startpos, vec, length) {
	if length > 999 {
		length = 999
	}
	
	hit, endpos, _ = Ray.findPart(startpos, vec * length, "Blacklist", "[]")
    if endpos == nil {
        return hit, startpos + (vec * length)
    } else {
        return hit, endpos
    }
}

function setexposures(exposure) {
	tableloop _, v in game.Players:GetChildren() {
		if v.Character ~= nil {
			chr = v.Character
			t = chr:FindFirstChild("Torso")
			h = chr:FindFirstChild("Humanoid")
			st = chr:FindFirstChild("SurvivalTag")

			if t ~= nil and h ~= nil and st ~= nil {
				etag = st:FindFirstChild("ExposureTag")
				if etag ~= nil {
					etag.Value = exposure
                }
			}
        }
    }
}

function giveguis(a) {
	if a ~= nil {
		tableloop _, v in game.Players:GetChildren() {
			if v ~= nil {
				plrgui = v:FindFirstChild("PlayerGui")
				if v.Character ~= nil and plrgui ~= nil {
					chr = v.Character
					t = chr:FindFirstChild("Torso")
					h = chr:FindFirstChild("Humanoid")
					st = chr:FindFirstChild("SurvivalTag")
					ex = plrgui:FindFirstChild(a.Name)

					if t ~= nil and h ~= nil and st ~= nil and ex == nil {
						cl = a:Clone()
						cl.Parent = plrgui
					}
				}
			}
		}
	}
}

function makesandray(vec) {
	frames = math.random(10, 30)
	startpos = (Vector3.normalize(vec + (Vector3.new(blankrandom() - 0.5, blankrandom() - 0.5, blankrandom() - 0.5) * 0.5)) * -100) + (Vector3.new(blankrandom() - 0.5, blankrandom() * 0.5, blankrandom() - 0.5)) * 300
	rayvec = Vector3.normalize((vec + (Vector3.new(blankrandom() - 0.5, blankrandom() - 0.5, blankrandom() - 0.5) * 0.2)))
    hit, pos, _ = Ray.findPart(startpos, rayvec * 200, "Blacklist", "[]")
	
    if pos == nil {
        pos = startpos + (rayvec * 200)
    }

	if hit ~= nil {
        if hit.Parent ~= nil {
            h = hit.Parent:FindFirstChild("Humanoid")
            tag = hit.Parent:FindFirstChild("SurvivalTag")
    
            if h ~= nil and tag ~= nil {
                h.Health = h.Health - 65
                frames = 4
            }
        }
	}

	dustdist = Vector3.magnitude((startpos - pos), Vector3.new(0, 0, 0))
	dust = Instance.new("Part", game.Lighting)
	dust.Name = "Dust"
	dust.BrickColor = BrickColor.new("Brick yellow")
	dust.Anchored = true
	dust.CanCollide = true
	dust.FormFactor = "Custom"
	dust.Size = Vector3.new(0.2, 0.2, 0.2)
	bm = Instance.new("BlockMesh", dust)
	bm.Scale = Vector3.new(1, 1, dustdist * 5)
	dust.CFrame = CFrame.new(startpos, Vector3.rotation(startpos, pos)) * cfp(0, 100, 0)
	dust.Parent = game.Workspace.Structure
						
	for i = 1, frames {
		if bm ~= nil {
			bm.Offset = Vector3.new(0, -100, (dustdist * -1) * 5 * (((i - 0.5) / frames) - 0.5))
			wait(rate)
		}
	}
	
	if dust ~= nil {
		dust:Destroy()
	}
}

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {
	giveguis(storage.SandstormGui)

	function thread1(_) {
		wait(1)
		clouds(100)
	}
	spawn(thread1, _)
	
	function thread12(_) {
		wait(12)
		game.Lighting.Brightness = 0.8
		weatherdome.Transparency = 0.8
		game.Lighting.FogColor = Color3.fromRGB(190, 191, 169)
		game.Lighting.FogEnd = 5000
		game.Lighting.FogStart = 0
		setexposures(1)
	}
	spawn(thread12, _)

	function thread18(_) {
		wait(18)
		game.Lighting.Brightness = 0.6
		weatherdome.Transparency = 0.4
		game.Lighting.FogEnd = 2500
		oldcontent.Sounds.Wind:Play()
        setexposures(2)
	}
	spawn(thread18, _)

	function thread26(_) {
		wait(26)
		game.Lighting.Brightness = 0.4
		weatherdome.Transparency = 0.1
		game.Lighting.FogEnd = 1000
        setexposures(3)
	}
	spawn(thread26, _)

	function thread32(_) {
		wait(32)
		game.Lighting.Brightness = 0.2
		weatherdome.Transparency = 0.05
		game.Lighting.FogEnd = 550
        setexposures(4)
	}
	spawn(thread32, _)

	function thread39(_) {
		wait(39)
		game.Lighting.Brightness = 0
		weatherdome.Transparency = 0
		game.Lighting.FogEnd = 400
        setexposures(5)
	}
	spawn(thread39, _)

    function thread46(_) {
		wait(46)
		game.Lighting.Brightness = 0
		weatherdome.Transparency = 0
		game.Lighting.FogEnd = 400
        setexposures(8)
	}
	spawn(thread46, _)
}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	oldcontent.Sounds.IntenseWind:Play()
	storming = true
	blizvecunits = table.create(Vector3.new(1,0,0), Vector3.new(0.5,0,0.5), Vector3.new(0,0,1), Vector3.new(-0.5,0,0.5), Vector3.new(-1,0,0), Vector3.new(-0.5,0,-0.5), Vector3.new(0,0,-1), Vector3.new(0.5,0,-0.5))
	freezelength = 16
	windvec = Vector3.normalize(Vector3.new(blankrandom() - 0.5, 0, blankrandom() - 0.5))

	mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
		while storming == true {
			wait(rate)
			if blankrandom() <= 0.3 {
				blowableparts = table.create()
                tableloop _, mdl2 in workspace.Structure:GetDescendants() {
                    if mdl2 ~= nil {
						if mdl2:IsA("BasePart") == true {
							if mdl2.Anchored == false and bvel == nil and bfor == nil {
								keepanchored = mdl2:FindFirstChild("KeepAnchored")
								if keepanchored == nil {
									table.append(blowableparts, mdl2)
								}
							}
						}
                    }
                }

				if table.length(blowableparts) > 0 {
					for i = 1, math.random(1, 2) {
						rp = blowableparts[math.random(1,table.length(blowableparts))]
						if rp ~= nil {
							rp.BrickColor = BrickColor.new("Brick yellow")
							rp.Material = "Sand"
                        }
                    }

					for i = 1, math.random(1, 2) {
						rp = blowableparts[math.random(1,table.length(blowableparts))]
						if rp ~= nil {
							rp:BreakJoints()
							bf = Instance.new("BodyForce", rp)
							bf.force = windvec * 500 * rp.Mass
                        }
                    }
                }

				blowableparts = nil
            }

            function thread(_) {
                makesandray(windvec)
				makesandray(windvec)
            }
            spawn(thread, _)
		}
		mockspawn:Destroy()
	}
	mockspawn:Fire()

	wait(90)
	storming = false
	oldcontent.Sounds.IntenseWind:Stop()
	oldcontent.Sounds.Wind:Stop()
	game.Lighting.Brightness = 1
	weatherdome.Transparency = 1
	game.Lighting.FogColor = Color3.fromRGB(171, 208, 217)
	game.Lighting.FogEnd = 5000
	game.Lighting.FogStart = 500
}

disaster = table.create()
disaster["Name"] = "Sandstorm"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
