@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

mapradius = 200
rate = 1/30

function blankrandom() {
	return math.random(0, 1000) / 1000
}

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {

}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	island = workspace:FindFirstChild("Island")
	shakingstuff = true

	oldcontent.Sounds.RockSound:Play()
	oldcontent.Sounds.DirtSound:Stop()
	oldcontent.Sounds.DirtSound:Play()

	function thread(_) {
        while shakingstuff == true {
            shakedirection = Vector3.new(blankrandom() - 0.5, blankrandom() - 0.5, blankrandom() - 0.5) * 20
			
			tableloop _, v in island:GetChildren() {
				if blankrandom() < 0.5 and v:IsA("BasePart") {
					v.Velocity = shakedirection + Vector3.new(blankrandom() - 0.5, blankrandom() * 0.5, blankrandom() - 0.5) * 20
					v:BreakJoints()
                }
            }
			
			breakableparts = table.create()
            tableloop _, mdl2 in workspace.Structure:GetDescendants() {
                if mdl2 ~= nil {
                    if mdl2:IsA("BasePart") {
                        keepAnchored = mdl2:FindFirstChild("KeepAnchored")
                        if keepAnchored == nil and mdl2.Anchored == false {
                            table.append(breakableparts, mdl2)
                        } else {
                            if blankrandom() < 0.5 {
                                mdl2.Velocity = shakedirection + Vector3.new(blankrandom() - 0.5, blankrandom() * 0.5, blankrandom() - 0.5) * 20
								mdl2:BreakJoints()
                            }
                        }
                    }
                }
            }

            if table.length(breakableparts) > 0 {
                for i = 1, math.random(2, 6) {
                    rp = breakableparts[math.random(1, table.length(breakableparts))]
                    if rp ~= nil {
                        rp:BreakJoints()
                    }
                }
            }

			breakableparts = nil
			wait(blankrandom() * 1)
        }
    }
    spawn(thread, _)

	wait(90)
	tableloop _, v in island:GetChildren() {
		if v:IsA("BasePart") {
            v.Velocity = Vector3.new(0, 0, 0)
        }
    }

	shakingstuff = false
	oldcontent.Sounds.DirtSound:Stop()
	wait(5)

    tableloop _, v in island:GetChildren() {
		if v:IsA("BasePart") {
            v.Velocity = Vector3.new(0, 0, 0)
        }
    }
}

disaster = table.create()
disaster["Name"] = "Earthquake"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
