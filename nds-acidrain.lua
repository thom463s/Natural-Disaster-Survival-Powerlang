@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")
weatherdome = workspace:WaitForChild("WeatherDome")

mapradius = 200
rate = 1/30
zero = Vector3.new(0, 0, 0)

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

function cfp(x, y, z) {
    return CFrame.new(Vector3.new(x, y, z), Vector3.new(0, 0, 0))
}

function castray(startpos, vec, length) {
	if length > 999 {
		length = 999
	}
	
	hit, endpos, _ = Ray.findPart(startpos, vec * length, "Blacklist", "[]")
    return hit, endpos
}

function acidtouch(hit) {
    if hit ~= nil {
        if hit.Parent ~= nil and blankrandom() < 0.5 {
            h = hit.Parent:FindFirstChild("Humanoid")
            if h ~= nil {
                h.Health = h.Health - 1
            }
        }
    }
}

raincolors = table.create(BrickColor.new("Medium green"), BrickColor.new("Sand green"), BrickColor.new("Deep blue") ,BrickColor.new("Grime"), BrickColor.new("Medium blue"), BrickColor.new("Dark stone grey"), BrickColor.new("Black"))
recoloracid = table.create()
acidsounds = table.create()

recoloracid["Medium stone grey"] = BrickColor.new("Medium green")
recoloracid["Medium green"] = BrickColor.new("Sand green")
recoloracid["Sand green"] = BrickColor.new("Grime")
recoloracid["Grime"] = BrickColor.new("Black")

table.insert(acidsounds, oldcontent.Sounds.Acid1, 1)
table.insert(acidsounds, oldcontent.Sounds.Acid2, 2)

function makerainray(vec, forplayer) {
	frames = math.random(5, 15)
	vec = Vector3.normalize((vec + (Vector3.new(blankrandom() - 0.5, blankrandom() - 0.5, blankrandom() - 0.5) * 0.1)))
	startpos = nil

	if forplayer ~= nil {
		startpos = forplayer - (vec * 300)
	} else {
		startpos = Vector3.new((blankrandom() - 0.5) * 300, 250, (blankrandom() - 0.5) * 300)
	}

	hit, pos = castray(startpos, vec, 400)
    if pos == nil {
        pos = startpos + (vec * 400)
    }
	damagedealt = false
	
	if hit ~= nil {
        if hit.Parent ~= nil {
            h = hit.Parent:FindFirstChild("Humanoid")
            tag = hit.Parent:FindFirstChild("SurvivalTag")

		    if h ~= nil and tag ~= nil {
		    	h.Health = h.Health - 6
		    	frames = 4
		    	damagedealt = true
		    }
        
		    if hit.Anchored == false and forplayer == nil {
		    	bc = hit.BrickColor
                bcname = bc["Name"]

		    	if bcname == "Black" {
		    		if h == nil {
		    			hit:Destroy()
		    		}
		    	} else {
                    newbc = recoloracid[bcname]
		    		if newbc == nil {
		    			newbc = BrickColor.new("Medium stone grey")
		    		}

		    		hit.BrickColor = newbc
		    		newbc = hit.BrickColor
                    newbcname = newbc["Name"]

		    		if newbcname == "Medium green" {
		    			if h == nil {
		    				hit:BreakJoints()
		    				event hit.Touched(_hit) {
		    					acidtouch(_hit)
		    				}
		    			}

                        function bind(_) {
                            acidsound = acidsounds[math.random(1, 2)]
		    				acidsound = acidsound:Clone()
		    				acidsound.Pitch = 0.5 + blankrandom()
		    				acidsound.Parent = hit
		    				wait(rate)

		    				acidsound:Play()
		    				wait(5)

		    				acidsound:Stop()
		    				acidsound:Destroy()
                        }
                        spawn(bind, _)
                    }
                }
            }
        }
    }

	if forplayer == nil or damagedealt == true {
		dustdist = Vector3.magnitude((startpos - pos), zero)
		dust = Instance.new("Part", game.Lighting)
		dust.Name = "AcidRain"
		dust.BrickColor = raincolors[math.random(1, table.length(raincolors))]
		dust.Transparency = 0.5
		dust.Anchored = true
		dust.CanCollide = true
		dust.FormFactor = "Custom"
		dust.Size = Vector3.new(0.2, 0.2, 0.2)

		bm = Instance.new("BlockMesh", dust)
		bm.Scale = Vector3.new(1, 1, dustdist * 5 / (frames * 0.5))
		
		dust.CFrame = CFrame.new(startpos, Vector3.rotation(startpos, pos)) * cfp(0, 100, 0)
		dust.Parent = workspace.Structure

		for i = 1, frames {
			if bm ~= nil {
				bm.Offset = Vector3.new(0, -100, (dustdist * -1) * ((i - 0.5) / frames))
				wait(rate)
			}
		}

		if dust ~= nil {
			dust:Destroy()
		}
	}
}

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {
    oldcontent.Sounds.Wind:Play()
    function thread1(_) {
        wait(1)
        clouds(100)
    }
    spawn(thread1, _)
}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	oldcontent.Sounds.Rain:Play()

	raining = true
	windvec = Vector3.normalize(Vector3.new(blankrandom() - 0.5, 0, blankrandom() - 0.5))
	rainvec = Vector3.normalize(Vector3.new(0, -1, 0) + windvec * 0.25)

    function thread(_) {
        while raining == true {
            function rain(_) {
                for i = 1, 4 {
					makerainray(rainvec)
                }
            }
            spawn(rain, _)

			tableloop _, v in game.Players:GetChildren() {
				if blankrandom() <= 0.03 and v.Character ~= nil {
					chr = v.Character
					t = chr:FindFirstChild("Torso")
					h = chr:FindFirstChild("Humanoid")
					st = chr:FindFirstChild("SurvivalTag")

					if t ~= nil and h ~= nil and st ~= nil {
						makerainray(rainvec, t.Position)
                    }
                }
            }
			wait(rate)
        }
    }
    spawn(thread, _)

	wait(90)
	raining = false
	oldcontent.Sounds.Wind:Stop()
	oldcontent.Sounds.Rain:Stop()

    weatherdome.Transparency = 1
	game.Lighting.Brightness = 1
	game.Lighting.FogColor = Color3.fromRGB(171, 208, 217)
	game.Lighting.FogEnd = 5000
	game.Lighting.FogStart = 500
}

disaster = table.create()
disaster["Name"] = "Acid Rain"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
