@flag BypassVariableAntiFilter

storage = game.Lighting.Storage
eventobject = game.Lighting.Shared:WaitForChild("Event")
oldcontent = workspace:WaitForChild("ContentModel")

region3part = workspace:WaitForChild("_Region3Part", 30)

-- tsunami ---------------------
wavedistance = 2000
wavespeed = 40
wavewidth = 20
wavehight = 50
wavelength = 500
segmentradius = 20
wavesegments = wavelength/segmentradius
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

function cframemodel(modl, centercframe, goalcframe) {
	tableloop _, object in modl:GetChildren() {
		object.CFrame = CFrame.toWorldSpace(goalcframe, CFrame.toObjectSpace(centercframe, object.CFrame))
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

-- events
prestart = Instance.new("BindableFunction", script)
event prestart.OnInvoke(_) {
}

start = Instance.new("BindableFunction", script)
event start.OnInvoke(_) {
	waveangle = pi * 2 * blankrandom()
	tsunamiinitial = CFrame.Angles(0, waveangle, 0) * cfp((wavedistance*-1) / 2, 11 + wavehight / 2, 0)
	tsunamifinal = CFrame.Angles(0, waveangle, 0) * cfp(wavedistance / 2, 11 + wavehight / 2, 0)
	wavevec = Vector3.normalize(tsunamiinitial.Position - tsunamifinal.Position)

	tsunamiwave = storage.TsunamiWave:Clone()
	tsunamiwave.Parent = game.Workspace.Structure
	cframemodel(tsunamiwave, tsunamiwave.Center.CFrame, tsunamiinitial * CFrame.Angles(0, pi, 0))

	wavesound = oldcontent.Sounds.Wave:Clone()
	wavesound.Name = "Sound"
	wavesound.Parent = tsunamiwave.Center
	wait(1)

	wavesound:Play()
	tsunaming = true

    mockspawn = Instance.new("BindableEvent", game.Debris)
	event mockspawn.Event(_) {
		starttime = retrostudio.OsClock()
		endtime = starttime + 90
		while tsunaming == true {
			wait(rate)

			wavepercentage = math.min(1, math.max(0, (retrostudio.OsClock() - starttime) / (endtime - starttime)))
			tsunamicurrent = CFrame.Angles(0, waveangle, 0) * cfp(((wavedistance * -1) / 2) + wavedistance * wavepercentage, 11 + wavehight / 2, 0)
			if tsunamiwave ~= nil {
				cframemodel(tsunamiwave, tsunamiwave.Center.CFrame, tsunamicurrent * CFrame.Angles(0, pi, 0))
            }

			for i = 1, wavesegments {
				segcf = (tsunamicurrent * cfp(0, 0, ((wavelength*-1) / 2) + (i * segmentradius)))
                segpos = segcf.Position
				waverange = Vector3.new(segmentradius, wavehight / 2, segmentradius)
				stuff = findPartsInRegion3(table.create(segpos - waverange, segpos + waverange), 100)

				tableloop _,v2 in stuff {
					if v2 ~= nil and v2.Parent ~= nil {
						if v2.Anchored == false {
							v2:BreakJoints()
							if math.random(1, 5) == 1 {
								v2.Velocity = wavevec * -1 * wavespeed
                            }
							if math.random(1, 100) == 1 {
								v2:Destroy()
                            }
                        }
                    }
                }
            }
        }
		mockspawn:Destroy()
	}
	mockspawn:Fire()

	wait(90)
	tsunaming = false
	if wavesound ~= nil {
		wavesound:Stop()
    }
}

disaster = table.create()
disaster["Name"] = "Tsunami"
disaster["PreStart"] = prestart
disaster["Start"] = start

callback = Instance.new("BindableFunction", script)
event callback.OnInvoke(_) {
    return disaster
}
callback.Name = "Retrieve"
