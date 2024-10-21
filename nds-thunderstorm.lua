@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

region3part = workspace:WaitForChild("_Region3Part", 30)

mapradius = 200
rate = 1/30
pi = math.rad(180)

lightningsounds = table.create(oldcontent.Sounds.Lightning1, oldcontent.Sounds.Lightning2, oldcontent.Sounds.Lightning3, oldcontent.Sounds.Lightning4, oldcontent.Sounds.Lightning5)

common = workspace.Server:WaitForChild("Common")
function awardBadge(player, badgename) {
	common.Functions.GiveBadge:Fire(player, badgename)
}

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

function createlightning(islast) {
	m = Instance.new("Model", game.Lighting)
	m.Name = "Lightning"

	ls = storage.LightningScript:Clone()
	ls.Disabled = false
	ls.Parent = m

	origin = Vector3.new(math.random((mapradius*-1)/2,mapradius/2), 300, math.random((mapradius*-1)/2,mapradius/2))
	lastpoint = origin
	depth = 300
	nothit = true
	segments = 0

	while depth > 0 and nothit == true and segments < 20 {
		segments = segments + 1
		range = 40
		casted = false
		nextpoint = lastpoint + Vector3.new(math.random((range*-1), range), math.random((range*-1) * 2, -5), math.random((range*-1), range))
		stuff = findPartsInRegion3(table.create(lastpoint - Vector3.new(range / 2, range * 2, range / 2), lastpoint + Vector3.new(range / 2, -5, range / 2)), 100)
		
		if stuff ~= nil {
			if table.length(stuff) > 0 {
				highest = nextpoint
				tableloop _, v2 in stuff {
					if v2 ~= nil {
						if v2.Position.Y > highest.Y {
							highest = v2.Position
						}
					}
				}
				nextpoint = highest
			}
		}

        region3part.Size = Vector3.new(1, 1, 1)
        region3part.Position = Vector3.new(0, 0, 0)

		dist = Vector3.magnitude((lastpoint - nextpoint), Vector3.new(0, 0, 0))
		hit, pos, _ = Ray.findPart(lastpoint, nextpoint - lastpoint, "Blacklist", "[]")

		if hit ~= nil and pos ~= nil {
			nothit = false
			e = Instance.new("Explosion", game.Lighting)
			e.BlastRadius = 7
			e.BlastPressure = 2000000
			e.Position = pos

			if islast == true {
				event e.ExplosionHit(hit2, distnc) {
					if hit2.Parent ~= nil and hit2.Parent:IsA("Model") and hit2.Name == "Head" {
						dedman = Players.GetPlayerFromCharacter(hit2.Parent)
						if dedman ~= nil {
							awardBadge(dedman, "Chance")
						}
					}
				}
			}
			e.Parent = game.Workspace
		}

		if pos ~= nil {
			nextpoint = pos
		}
		depth = nextpoint.Y

		p = storage.LightningPart:Clone()
		dist = Vector3.magnitude((lastpoint - nextpoint), Vector3.new(0, 0, 0))
		p.Size = Vector3.new(0.75, dist, 0.75)
		p.CFrame = CFrame.new(lastpoint, Vector3.rotation(lastpoint, nextpoint)) * CFrame.Angles(pi/2, 0, 0) * cfp(0, (dist*-1)/2, 0)
		p.Parent = m
		lastpoint = nextpoint
	}

	lightningsound = lightningsounds[math.random(1, table.length(lightningsounds))]
	if lightningsound ~= nil {
		lightningsound:Play()
	}

	game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	game.Lighting.Brightness = 2
	m.Parent = game.Workspace.Structure

	function callback(_) {
		wait(0.1)
		game.Lighting.Ambient = Color3.fromRGB(128, 128, 128)
		game.Lighting.Brightness = 1
	}
	spawn(callback, _)
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
	thundering = true

	mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
		while thundering {
			wait(1.5 + blankrandom())
			inverse = true
			if thundering == true {
				inverse = false
			}
			createlightning(inverse)
		}
		mockspawn:Destroy()
	}
	mockspawn:Fire()

	wait(90)
	thundering = false

	wait(3)
	oldcontent.Sounds.Wind:Stop()
}

disaster = table.create()
disaster["Name"] = "Thunder Storm"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
