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
	
	hit, endpos, _ = Ray.findPart(startpos, vec*length, "Blacklist", "[]")	
	return hit, endpos
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

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {
	giveguis(storage.BlizzardGui)

	function thread1(_) {
		wait(1)
		clouds(100)
	}
	spawn(thread1, _)
	
	function thread12(_) {
		wait(12)
		game.Lighting.Brightness = 0.8
		weatherdome.Transparency = 0.8
		game.Lighting.FogColor = blizfogcolor
		game.Lighting.FogEnd = 5000
		game.Lighting.FogStart = 0
	}
	spawn(thread12, _)

	function thread18(_) {
		wait(18)
		game.Lighting.Brightness = 0.6
		weatherdome.Transparency = 0.4
		game.Lighting.FogEnd = 2500
		oldcontent.Sounds.Wind:Play()
	}
	spawn(thread18, _)

	function thread26(_) {
		wait(26)
		game.Lighting.Brightness = 0.4
		weatherdome.Transparency = 0.1
		game.Lighting.FogEnd = 1000
	}
	spawn(thread26, _)

	function thread32(_) {
		wait(32)
		game.Lighting.Brightness = 0.2
		weatherdome.Transparency = 0.05
		game.Lighting.FogEnd = 550
	}
	spawn(thread32, _)

	function thread39(_) {
		wait(39)
		game.Lighting.Brightness = 0
		weatherdome.Transparency = 0
		game.Lighting.FogEnd = 400
	}
	spawn(thread39, _)
}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	oldcontent.Sounds.IntenseWind:Play()
	blizzing = true
	blizvecunits = table.create(Vector3.new(1,0,0), Vector3.new(0.5,0,0.5), Vector3.new(0,0,1), Vector3.new(-0.5,0,0.5), Vector3.new(-1,0,0), Vector3.new(-0.5,0,-0.5), Vector3.new(0,0,-1), Vector3.new(0.5,0,-0.5))
	freezelength = 16
	windvec = Vector3.normalize(Vector3.new(blankrandom() - 0.5, 0, blankrandom() - 0.5))

	mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
		while blizzing == true {
			wait(rate)
			tableloop _, v in game.Players:GetChildren() {
				if blankrandom() <= 0.2 and v.Character ~= nil {
					chr = v.Character
					t = chr:FindFirstChild("Torso")
					h = chr:FindFirstChild("Humanoid")
					st = chr:FindFirstChild("SurvivalTag")

					if t ~= nil and h ~= nil and st ~= nil {
						etag = st:FindFirstChild("ExposureTag")
						if etag ~= nil {
							exposure = 0
							tableloop _, bvec in blizvecunits {
								bvec2 = Vector3.normalize(bvec + (Vector3.new(blankrandom() - 0.5, (blankrandom() - 0.5) * 0.5, blankrandom() - 0.5) * 0.15))
								hit, pos = castray(t.Position + ((bvec2 * -1) * freezelength), bvec2, freezelength)
								if hit ~= nil and hit.Parent == chr {
									exposure = exposure+1
								}
							}

							damage = math.min(1, (exposure - 4) / 2)
							if damage > 0 {
								h.Health = h.Health - damage
							}
							etag.Value = exposure
						}
					}
				}
			}

			if blankrandom() <= 0.15 {
				blowableparts = table.create()
				tableloop _, mdl2 in workspace.Structure:GetDescendants() {
					if mdl2 ~= nil {
						bvel = mdl2:FindFirstChild("BodyVelocity")
						bfor = mdl2:FindFirstChild("BodyForce")

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
					for i = 1, math.random(2, 3) {
						rp = blowableparts[math.random(1, table.length(blowableparts))]
						if rp ~= nil {
							rp.BrickColor = BrickColor.new("Institutional white")
							rp.Material = "Sand"
						}
					}

					rp = blowableparts[math.random(1, table.length(blowableparts))]
					if rp ~= nil {
						rp:BreakJoints()
						bf = Instance.new("BodyForce", rp)
						bf.force = windvec * 300 * rp.Mass
					}
				}
				blowableparts = nil
			}
		}
		mockspawn:Destroy()
	}
	mockspawn:Fire()

	wait(90)
	blizzing=false
	oldcontent.Sounds.IntenseWind:Stop()
	oldcontent.Sounds.Wind:Stop()
	game.Lighting.Brightness = 1
	weatherdome.Transparency = 1
	game.Lighting.FogColor = Color3.fromRGB(171, 208, 217)
	game.Lighting.FogEnd = 5000
	game.Lighting.FogStart = 500
}

disaster = table.create()
disaster["Name"] = "Blizzard"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
