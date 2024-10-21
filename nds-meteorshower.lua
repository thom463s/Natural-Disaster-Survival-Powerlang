@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

mapradius = 200
rate = 1/30

-- meteors ---------------------
meteorsurfaces = table.create("Universal", "Inlet")
meteorcolors = table.create(BrickColor.new("Dusty Rose"), BrickColor.new("Reddish brown"), BrickColor.new("Black"))
meteorsizes = table.create(2, 5, 10, 15)
-- -----------------------------

meteorsounds = table.create(oldcontent.Sounds:FindFirstChild("Meteor1"), oldcontent.Sounds:FindFirstChild("Meteor2"))

function resurface(p, s) {
	if p ~= nil and s ~= nil {
		p.BackSurface = s
		p.BottomSurface = s
		p.FrontSurface = s 
		p.LeftSurface = s
		p.RightSurface = s
		p.TopSurface = s
	}
}

function createmeteor() {
	m = Instance.new("Part", game.Lighting)
	m.Name = "Meteor"
	m.BrickColor = meteorcolors[math.random(1,table.length(meteorcolors))]
	m.FormFactor = "Symmetric"
	m.Shape = "Ball"
	msize = meteorsizes[math.random(1,table.length(meteorsizes))]
	m.Size = Vector3.new(msize,msize,msize)
	resurface(m, meteorsurfaces[math.random(1,table.length(meteorsurfaces))])
	m.Position = Vector3.new(math.random((mapradius*-1)/2,mapradius/2),500,math.random((mapradius*-1)/2,mapradius/2))
	m.Velocity = Vector3.new(math.random(-100,100),-100,math.random(-100,100))
	m.CanCollide = false
	f = Instance.new("Fire", m)
	f.Size = msize*2
	ms = storage.MeteorScript:Clone()
	ms.Disabled = false
	ms.Parent = m
	s = meteorsounds[math.random(1, 2)]
	if s ~= nil {
		s2 = s:Clone()
		s2.Name = "Sound"
		s2.Parent = m
	}
	Debris.AddItem(m, 12)
	m.Parent = game.Workspace.Structure
}

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {

}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	shower = true

	mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
		while shower == true {
			createmeteor()
			wait(0.5)
			createmeteor()
			wait(0.5)
		}
		mockspawn:Destroy()
	}
	mockspawn:Fire()

	wait(90)
	shower = false
}

disaster = table.create()
disaster["Name"] = "Meteor Shower"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
