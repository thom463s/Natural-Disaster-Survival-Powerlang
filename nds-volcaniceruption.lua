@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

mapradius = 200
rate = 1/30
pi = math.rad(180)
quarterpi = pi / 4
zero = Vector3.new(0, 0, 0)

dirtpart = Instance.new("Part", game.Lighting)
dirtpart.Material = "Slate"
dirtpart.BrickColor = BrickColor.new("Brown")
dirtpart.FormFactor = "Custom"
dirtpart.Anchored = true
dirtpart.Name = "VolcanoPart"

function cfp(x, y, z) {
	return CFrame.new(Vector3.new(x, y, z), Vector3.new(0, 0, 0))
}

function blankrandom() {
	return math.random(0, 1000) / 1000
}

function makefragment(dist, rotation, position, crownradius, baseradius, height, roughness) {
	idist = 1-dist
	p = dirtpart:Clone()
	p.Size = Vector3.new((baseradius / pi) * (0.5 + (dist * 0.5)), height * 0.142 * (0.5 + blankrandom() * 0.5), (baseradius - crownradius) * (0.3 + (blankrandom() * 0.2)))
	p.CFrame = CFrame.new(position - Vector3.new(0, p.Size.Y * 0.5, 0), zero) * CFrame.Angles(0, rotation, 0) * CFrame.new(Vector3.new(0, height * (idist ^ 1.5), crownradius + (p.Size.Z * 0.25) + (dist * (baseradius - p.Size.Z - crownradius))), zero) * CFrame.Angles(idist * quarterpi, 0, (idist + 0.1) * roughness * (blankrandom() - 0.5))
	return p
}

function createvolcano(position, crownradius, baseradius, height, roughness) {
	volcanomodel = Instance.new("Model", game.Lighting)
	volcanomodel.Name = "Volcano"
	hitotal = 4
						
	for hi = 1, hitotal {
		ritotal = 10 + hi * 10
		for ri = 1, ritotal {
			fragment = makefragment((hi - 1) / (hitotal - 1), (ri / ritotal) * 2 * pi, position, crownradius, baseradius, height, roughness)
			fragment.Parent = volcanomodel															
		}
	}
						
	for i = 1, 150 {
		fragment = makefragment(blankrandom(),blankrandom()*2*pi,position,crownradius,baseradius,height,roughness)
		fragment.Parent = volcanoModel										
	}
						
	for i = 1, 3 {
		p = dirtpart:Clone()
		p.Name = "Lava"
		p.BrickColor = BrickColor.new("Bright orange")
		p.Size = Vector3.new(crownradius*2,1,crownradius*2)
		p.CFrame = CFrame.new(position+Vector3.new(0,height*0.9,0), zero)*CFrame.Angles(0,pi*(i/3),0)
		p.CanCollide = false
		p.Parent = volcanomodel
	}
						
	volcanomodel.Parent = workspace.Structure
	return volcanomodel
}

lavacolors = table.create(BrickColor.new("Bright red"), BrickColor.new("Bright orange"), BrickColor.new("Bright yellow"))
lavacolorsdirty = table.create(BrickColor.new("Reddish brown"), BrickColor.new("Brown"), BrickColor.new("Bright red"), BrickColor.new("Bright orange"), BrickColor.new("Bright yellow"))

function makelavalthrow(pos, lavaclr) {
	p = Instance.new("Part", game.Lighting)
	p.Name = "Lava"
	p.BrickColor = lavaclr
	p.TopSurface = "Smooth"
	p.BottomSurface = "Smooth"
	p.FormFactor = "Custom"
	p.Material = "Sand"
	p.Size = Vector3.new(5 + blankrandom() * 5, 5 + blankrandom() * 5, 5 + blankrandom() * 5) * (1 + blankrandom())
	p.Anchored = false
	p.CanCollide = false

	p:SetPartPhysicalProperties(0, 0.3, 0.7, 1, 1)

	enabled = true								
	event p.Touched(hit) {
		if enabled == true {
			if p ~= nil and hit ~= nil {
				if hit.Anchored == false and Vector3.magnitude(p.Position, zero) < 300 {
					hit:BreakJoints()
					if p.CanCollide == false {
						hit.Velocity = hit.Velocity - (p.Velocity * 0.3)
						wait(0.05)
						p.CanCollide = true
					}
				}
			}
		}
	}
	
	function cool(_) {
		wait(4)
		if p ~= nil {
			p.CanCollide = true
		}
		wait(math.random(20,30))
		if p ~= nil {
			p.BrickColor = BrickColor.new("Black")
			p.Material = "Slate"
		}
		enabled = false
		wait(30)
		if p ~= nil {
			p:Destroy()
		}
	}
	spawn(cool, _)
	
	p.CFrame = CFrame.new(pos, zero) * CFrame.Angles(0, blankrandom() * 2 * pi, blankrandom()) * CFrame.new(Vector3.new(0, 10, 0), zero)
	p.Velocity = (Vector3.normalize((p.Position - pos) + Vector3.new(0, 0.1, 0)) * 250) + (Vector3.new(blankrandom() - 0.5, blankrandom() - 0.5, blankrandom() - 0.5) * (50 + blankrandom() * 50))
	p.RotVelocity = Vector3.new(blankrandom() - 0.5, blankrandom() - 0.5, blankrandom() - 0.5) * 20
	p.Parent = game.Workspace.Structure
}

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {
	
}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	volcanocf = CFrame.Angles(0, blankrandom() * 2 * pi, 0) * cfp(0, 10, 300)
	volcanopos = volcanocf.Position
	spoutpos = volcanopos + Vector3.new(0, 60, 0)
	createvolcano(volcanopos, 30, 200, 60, 0.2)

	wait(15)
	oldcontent.Sounds.Explosion1:Play()
	oldcontent.Sounds.Explosion2:Play()
	oldcontent.Sounds.RockSound:Play()
	oldcontent.Sounds.DirtSound:Stop()
	oldcontent.Sounds.DirtSound:Play()
	erupting = true

	for i = 1, 30 {
		color = lavacolorsdirty[math.random(1, table.length(lavacolorsdirty))]
		makelavalthrow(spoutpos, color)
	}

	mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
		nextexplodesound = retrostudio.OsClock() + 1 + blankrandom()
		while erupting == true {
			for _ = 1, math.random(1, 2) {
				color = lavacolors[math.random(1, table.length(lavacolors))]
				makelavalthrow(spoutpos, color)
			}

			if retrostudio.OsClock() > nextexplodesound {
				nextexplodesound = retrostudio.OsClock() + 1 + blankrandom()

				esound = nil
				if blankrandom() < 0.5 {
					esound = oldcontent.Sounds:FindFirstChild("RockSound")
				} else {
					esound = oldcontent.Sounds:FindFirstChild("Explosion2")
				}

				if esound ~= nil {
					esound:Play()
				}
			}
			wait(0.03 + blankrandom() * 0.4)
		}
		mockspawn:Destroy()
	}
	mockspawn:Fire()

	wait(90)
	oldcontent.Sounds.DirtSound:Stop()
	erupting = false
	game.Lighting.Brightness = 1
	weatherdome.Transparency = 1
	game.Lighting.FogColor = Color3.fromRGB(171, 208, 217)
	game.Lighting.FogEnd = 5000
	game.Lighting.FogStart = 500
}

disaster = table.create()
disaster["Name"] = "Volcanic Eruption"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
