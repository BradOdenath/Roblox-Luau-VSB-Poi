local who = "Visualist"

Player = game.Players:WaitForChild(who)
Character = game.Workspace:WaitForChild(who)
script.Parent = Character

weight = {
	density = 0,
	friction = .3,
	elasticity = 1,
	frictionWeight = 1,
	elasticityWeight = 1
}
print(_VERSION)

--Part Instance (Args: 7)
function Part(	
	na,	--p.Name		:String
	co,	--p.Color		:String
	ma,	--p.Material	:MaterialType
	sx,	--p.Size.x		:Decimal
	sy,	--p.Size.y		:Decimal
	sz,	--p.Size.z		:Decimal
	pa	--p.Parent 		:Object
	)
	local p = Instance.new("Part")
	p.Anchored = false --false by default, but doesn't hurt. 
	p.Locked = true
	p.formFactor = "Custom"
	p.TopSurface = 0
	p.BottomSurface = 0
	p.CanCollide = false
	p.BrickColor = BrickColor.new(co)
	p.Material = ma
	p.Transparency = 0
	p.Name = na
	p.Massless = true
	p.Size = Vector3.new(sx,sy,sz)
	p.Parent = pa
	--p.CustomPhysicalProperties = PhysicalProperties.new(weight)
	p:SetNetworkOwner(Player)
	return p
end

function BallSocketConstraint(
	p0,	--CFrame for Part0
	p1, --CFrame for Part1
	cf	--CFrame for C0
	)
	
	local w = Instance.new("BallSocketConstraint")
	local a1, a2 = Instance.new("Attachment"), Instance.new("Attachment")
	a1.Parent = p0
	a2.Parent = p1
	w.Parent = p1
	w.Attachment0 = a1
	w.Attachment1 = a2
	a1.CFrame = cf
	w.LimitsEnabled = true
	w.TwistLimitsEnabled = true
	return a1
	
	--[[local w = Instance.new("Weld")
	w.Parent = p1
	w.Part0 = p0
	w.Part1 = p1
	w.C0 = cf
	return w]]
end

--Light Instance (Args: 1)
function Light(
	pa	--l.Parent	:Object
	)
	local l = Instance.new("PointLight")
	l.Range = 16
	l.Parent = pa
	return l
end

--Mesh Instance (Args: 5)
function Mesh(
	mi, --m.Object	:Object<Mesh>
	sx, --m.Scale.x	:Decimal
	sy, --m.Scale.y	:Decimal
	sz, --m.Scale.z	:Decimal
	pa	--m.Parent	:Object
	)
	local m = Instance.new(mi)
	m.Scale = Vector3.new(sx, sy, sz)
	m.Parent = pa
	return m
end

--Model Instance (Args: 2)
function Model(
	na,	--m.Name	:String 
	pa	--m.Parent	:Object
	)
	local m = Instance.new("Model")
	m.Name = na
	m.Parent = pa
	return m
end

function Fire(
	he,	--f.Heat	:Integer
	si,	--f.Size	:Integer
	pa	--f.Parent	:Object
	)
	local f = Instance.new("Fire")
	f.Heat = he
	f.Size = si
	f.Parent = pa
	return f
end


function Cfr(x,y,z)
	return CFrame.new(x,y,z)
end

--CFrame.Angles
function Ang(rX,rY,rZ)
	return CFrame.Angles(rX,rY,rZ)
end

--Cframe.new * CFrame.Angles
function CfrAng(x,y,z,rX,rY,rZ)
	return Cfr(x,y,z) * Ang(rX,rY,rZ)
end


function buildPoi(arm)
	arm.Massless = true
	local asd = -0.3
	if (string.find(arm.Name,"Hand") == nil) then asd = -1 end
	local _library = {}
	
	local _poi = Model('Poi', arm)
	table.insert(_library,_poi)
	
	local _knob = Part('Knob', 'Institutional white', 'Plastic', 0.17, 0.17, 0.17, _poi) 
	local _mesh = Instance.new("SpecialMesh",_knob)
	local _handle = BallSocketConstraint(arm, _knob, CfrAng(0,asd,0,0,0,0))
	
	local _ropeA = Part('RopeTop', 'Really black', 'Plastic', 0.1, 0.5, 0.1, _poi)
	local _mesh = Instance.new("SpecialMesh",_ropeA)
	local _knobToRopeA = BallSocketConstraint(_knob, _ropeA, CfrAng(0,-0.3,0, 0,0,0))
	local _ropeJ = Part('RopeJoint', 'Really black', 'Plastic', 0.12, 0.12, 0.12, _poi) 
	local _mesh = Instance.new("SpecialMesh",_ropeJ)
	_mesh.MeshType = "Sphere"
	--_ropeJ.Transparency = 1
	local _ropeAtoJ = BallSocketConstraint(_ropeA, _ropeJ, CfrAng(0,-0.2,0, 0,0,0))
	
	local _ropeB = Part('RopeBottom', 'Really black', 'Plastic', 0.1, 0.5, 0.1, _poi)
	local _mesh = Instance.new("SpecialMesh",_ropeB)
	local _ropeJtoB = BallSocketConstraint(_ropeJ, _ropeB, CfrAng(0,-0.2,0, 0,0,0))
	
	local _ropeJ = Part('RopeJoint', 'Really black', 'Plastic', 0.12, 0.12, 0.12, _poi) 
	local _mesh = Instance.new("SpecialMesh",_ropeJ)
	_mesh.MeshType = "Sphere"
	local _ropeAtoJ = BallSocketConstraint(_ropeB, _ropeJ, CfrAng(0,-0.2,0, 0,0,0))
	
	local _ropeC = Part('RopeCottom', 'Really black', 'Plastic', 0.1, 0.5, 0.1, _poi)
	local _mesh = Instance.new("SpecialMesh",_ropeC)
	local _ropeJtoC = BallSocketConstraint(_ropeJ, _ropeC, CfrAng(0,-0.2,0, 0,0,0))
	
	local _head = Part('Head', 'Bright orange', 'Neon', 0.77, 0.77, 0.77, _poi)
	_head.Shape = "Ball"
	_head.CanCollide = true
	local _light = Light(_head)
	_light.Color = _head.Color
	_light.Brightness = 10
	Fire(1,2,_head)
	local _ropeBtoHead = BallSocketConstraint(_ropeC, _head, CfrAng(0,-0.6,0, 0,0,0))
	
	return _library
end

function manipulateCharacter()
	local leftPoi = buildPoi(Character:FindFirstChild('LeftHand') or Character:FindFirstChild("Left Arm"))
	local rightPoi = buildPoi(Character:FindFirstChild('RightHand') or Character:FindFirstChild("Right Arm"))
	
	local ArmRotation = function(Arm)
		coroutine.resume(coroutine.create(function()
			local angl = math.pi/22
			local w = Instance.new("Weld")
			w.Parent = Character.HumanoidRootPart
			w.Part0 = Arm
			if (string.find(Arm.Name, "Upper") ~= nil) then
				w.Part1 = Character.UpperTorso
				if (string.find(Arm.Name, "Left") ~= nil) then
					w.C0 = CFrame.new(-1.5,0,0)
					w.C1 = CFrame.new(0,0.5,0)
					angl = -angl
				else
					w.C0 = CFrame.new(1.5,0,0)
					w.C1 = CFrame.new(0,0.5,0)
				end
			else
				w.Part1 = Character.Torso
				if (string.find(Arm.Name, "Left") ~= nil) then
					w.C0 = CFrame.new(-1.5,0.5,0)
					w.C1 = CFrame.new(0,0.5,0)
					angl = -angl
				else
					w.C0 = CFrame.new(1.5,0.5,0)
					w.C1 = CFrame.new(0,0.5,0)
				end
			end
			
			for i = 1,11 do wait()
				w.C1 = w.C1 * CFrame.Angles(angl,0,0)
			end
			while true do 
				angl = -angl
				for i = 1,22 do wait()
					w.C1 = w.C1 * CFrame.Angles(angl,0,0)
				end
			end
		end))
	end
	pcall(function() ArmRotation(Character["LeftUpperArm"]) end)
	pcall(function() ArmRotation(Character["RightUpperArm"]) end)
	pcall(function() ArmRotation(Character["Left Arm"]) end)
	pcall(function() ArmRotation(Character["Right Arm"]) end)
	
--[[	
	local position = Instance.new("BodyPosition",Character.HumanoidRootPart)

	local position_person = function() 
		position.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		position.Position = Character.HumanoidRootPart.Position + Vector3.new(0,10,0)
	end
	
	local deposition_person = function()
		position.MaxForce = Vector3.new(0,0,0)
	end

	position_person()
	
	wait(2)
		
	buildPoi(Character['LeftFoot'])
	buildPoi(Character['RightFoot'])]]
	
end

manipulateCharacter()