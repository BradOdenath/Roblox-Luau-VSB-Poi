local who = owner.Name or 
	"kingnicholas19"

Player = game.Players:WaitForChild(who)
Character = game.Workspace:WaitForChild(who)
script.Parent = Character

fir = false

weight = {
	density = .1,
	friction = .3,
	elasticity = 3,
	frictionWeight = 0.1,
	elasticityWeight = 1
}
print(_VERSION)

function HopperBin(name, parent)
	local hb = Instance.new("Tool")
	hb.RequiresHandle = false
	hb.CanBeDropped = false
	hb.Name = name
	hb.Parent = parent
	return hb
end

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
	pcall(function() p.BrickColor = BrickColor.new(co) end)
	--pcall(function() p.BrickColor = co end)
	--pcall(function() p.Color = Color3.fromRGB(co) end)
	--pcall(function() p.Color = co end)
	p.Material = 'SmoothPlastic'
	p.Transparency = 0
	p.Reflectance = 0.03
	p.Name = na
	--p.Massless =t ru
	p.Size = Vector3.new(sx,sy,sz)
	p.Parent = pa
	p.CFrame = Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
	p.CustomPhysicalProperties = PhysicalProperties.new(weight)
	p:SetNetworkOwner(Player)
	return p
end

function BallSocketConstraint(p0,p1,cf)
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
	
end

function Weld(
	p0,	--CFrame for Part0
	p1, --CFrame for Part1
	cf	--CFrame for C0
	)
	local w = Instance.new("Weld")
	w.Parent = p1
	w.Part0 = p0
	w.Part1 = p1
	w.C0 = cf
	return w
end

--Light Instance (Args: 1)
function Light(
	pa	--l.Parent	:Object
	)
	local l = Instance.new("PointLight")
	l.Range = 16
	l.Brightness = 0.01
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

local lerpPartToColor = function(part, new_color)
	local _pColor = part.Color
	for i = 0,1,0.05 do wait()
		part.Color = _pColor:lerp(new_color,i)
	end
end

local trailPart = function(_part)
	coroutine.resume(coroutine.create(function()
		while true do wait(0.1)
			local _tp = _part:Clone()
			_tp:BreakJoints()
			for i,v in pairs(_tp:GetChildren()) do v:Remove() end
			local _lig = Light(_tp)
			--_lig.Brightness = 0.1
			_tp.CanCollide = false
			_tp.Anchored = true
			_tp.Size = _part.Size * 0.87
			_tp.BrickColor = BrickColor.new("Insititutional white")
			_tp.Parent = workspace
			_tp.CFrame = _part.CFrame
			coroutine.resume(coroutine.create(function()
				while _tp.Transparency < 1 do wait(0.1)
					_tp.Transparency = _tp.Transparency + 0.01
					_tp.Size = _tp.Size * 0.99
					_tp.Reflectance = _tp.Reflectance + 0.05
				end
				_tp:Remove()
			end))
		end
	end))
end


function buildPoi(arm, col, col_rope, col_knob)
	local asd = -0.2
	if (string.find(arm.Name,"Hand") == nil) then asd = -1 end
	local _library = {}
	
	local _poi = Model('Poi', workspace--[[arm]])
	table.insert(_library,_poi)
	
	local _knob = Part('Knob', col_knob, 'Fabric', 0.17, 0.17, 0.17, _poi) 
	if (fir) then _knob.BrickColor = BrickColor.new("Insititutional white")
	_knob.Transparency = 0.1 end
	local _mesh = Instance.new("SpecialMesh",_knob)
	
	local _handle = BallSocketConstraint(arm, _knob, CfrAng(0,asd,0,0,0,0))
	
	--[[local _ropeA = Part('RopeTop', 'Really black', 'Plastic', 0.1, 0.5, 0.1, _poi)
	local _mesh = Instance.new("SpecialMesh",_ropeA)
	local _knobToRopeA = Weld(_knob, _ropeA, CfrAng(0,-0.3,0, 0,0,0))
	local _ropeJ = Part('RopeJoint', 'Really black', 'Plastic', 0.12, 0.12, 0.12, _poi) 
	local _mesh = Instance.new("SpecialMesh",_ropeJ)
	_mesh.MeshType = "Sphere"
	--_ropeJ.Transparency = 1
	local _ropeAtoJ = Weld(_ropeA, _ropeJ, CfrAng(0,-0.2,0, 0,0,0))
	
	local _ropeB = Part('RopeBottom', 'Really black', 'Plastic', 0.1, 0.5, 0.1, _poi)
	local _mesh = Instance.new("SpecialMesh",_ropeB)
	local _ropeJtoB = Weld(_ropeJ, _ropeB, CfrAng(0,-0.2,0, 0,0,0))
	
	local _ropeJ = Part('RopeJoint', 'Really black', 'Plastic', 0.12, 0.12, 0.12, _poi) 
	local _mesh = Instance.new("SpecialMesh",_ropeJ)
	_mesh.MeshType = "Sphere"
	local _ropeAtoJ = Weld(_ropeB, _ropeJ, CfrAng(0,-0.2,0, 0,0,0))
	
	local _ropeC = Part('RopeCottom', 'Really black', 'Plastic', 0.1, 0.5, 0.1, _poi)
	local _mesh = Instance.new("SpecialMesh",_ropeC)
	local _ropeJtoC = Weld(_ropeJ, _ropeC, CfrAng(0,-0.2,0, 0,0,0))]]
	
	local _headRope = function(_attachment,_cc)		
		local _head = Part('Head', col, 'SmoothPlastic', 0.5, 0.5, 0.5, _poi)
		_head.Shape = "Ball"
		_head.CanCollide = _cc
		--trailPart(_head)
		
		--local _light = Light(_head)
		--_light.Brightness = 1
		
		--local _spark
		if fir then
			_head.BrickColor = BrickColor.new("Really black")
			Fire(2,4,_head)
		else
			--_spark = Instance.new("Sparkles",nil)
		end
		
		local attachment1 = Instance.new("Attachment")
		attachment1.Parent = _head
	
		local _rope = Instance.new("RopeConstraint")
		_rope.Parent = _head
		_rope.Length = 1.8
		_rope.Attachment0 = _attachment
		_rope.Attachment1 = attachment1
		if fir then _rope.Color = BrickColor.new("Sand yellow metallic") else
		_rope.Color = BrickColor.new(col_rope) end
		_rope.Thickness = 0.1
		_rope.Restitution = 0
		_rope.Visible = true
	
		local _anti = Instance.new("BodyForce")
		_anti.Parent = _head
		_anti.Force = Vector3.new(0,_head:GetMass() * workspace.Gravity, 0)
		
		return attachment1
	end
	
	local attachment0 = Instance.new("Attachment")
	attachment0.Parent = _knob
	
	local _last
	for i = 1,1 do wait()
		if (_last) then
			local _head = _headRope(_last,true)
			_last = _head
		else
			_last = _headRope(attachment0,true)
		end
	end
	
	
	--[[coroutine.resume(coroutine.create(function() 
		while true do wait()
			for i,v in pairs(_poi:GetChildren()) do
				if (v:IsA("BasePart") and v.Name == "Head") then
			--_spark.Color = _head.Color
			--lerpPartToColor(_head, Color3.fromRGB(math.random(0,255),math.random(0,255),math.random(0,255)))
					trailPart(_last.Parent)
				end
			end
		end
	end))]]


	
	--[[local _ropeBtoHead = Weld(_ropeC, _head, CfrAng(0,-0.4,0, 0,0,0))]]
	wait()
	return _library
end

local PoiColors = {
	{"Neon orange", "Lime green", "Lapis"},
	{"Bright green", "Lapis", "Neon orange"},
}

function manipulateCharacter(_Character)
	--local leftPoiA = buildPoi(_Character:FindFirstChild('LeftHand') or _Character:FindFirstChild("Left Arm"), "Toothpaste")
	--local rightPoiA = buildPoi(_Character:FindFirstChild('RightHand') or _Character:FindFirstChild("Right Arm"), "Toothpaste")
		
	for i = 1,1 do
		
		local leftPoiA = buildPoi(_Character:FindFirstChild('LeftHand') or _Character:FindFirstChild("Left Arm"), "Neon orange", "Neon green", "Lapis")
		local leftPoiB = buildPoi(_Character:FindFirstChild('LeftHand') or _Character:FindFirstChild("Left Arm"), "Bright green", "Lapis", "Neon orange")
		local leftPoiC = buildPoi(_Character:FindFirstChild('LeftHand') or _Character:FindFirstChild("Left Arm"), "Lapis", "Neon orange", "Bright green")
		local leftPoiD = buildPoi(_Character:FindFirstChild('LeftHand') or _Character:FindFirstChild("Left Arm"), "Institutional white", "Really red", "Bright green")
		
		local rightPoiA = buildPoi(_Character:FindFirstChild('RightHand') or _Character:FindFirstChild("Right Arm"), "Neon orange", "Neon green", "Lapis")
		local rightPoiB = buildPoi(_Character:FindFirstChild('RightHand') or _Character:FindFirstChild("Right Arm"), "Bright green", "Lapis", "Neon orange")
		local rightPoiC = buildPoi(_Character:FindFirstChild('RightHand') or _Character:FindFirstChild("Right Arm"), "Lapis", "Neon orange", "Bright green")
		local rightPoiD = buildPoi(_Character:FindFirstChild('RightHand') or _Character:FindFirstChild("Right Arm"), "Institutional white", "Really red", "Bright green")
		
	end
	local ArmRotation = function(Arm)
		coroutine.resume(coroutine.create(function()
			local angl = math.pi/32
			local w = Instance.new("Weld")
			w.Parent = _Character.HumanoidRootPart
			w.Part0 = Arm
			if (string.find(Arm.Name, "Upper") ~= nil) then
				w.Part1 = _Character.UpperTorso
				if (string.find(Arm.Name, "Left") ~= nil) then
					w.C0 = CFrame.new(-1.5,0,0)
					w.C1 = CFrame.new(0,0.5,0)
					angl = -angl
				else
					w.C0 = CFrame.new(1.5,0,0)
					w.C1 = CFrame.new(0,0.5,0)
				end
			else
				w.Part1 = _Character.Torso
				if (string.find(Arm.Name, "Left") ~= nil) then
					w.C0 = CFrame.new(-1.5,0.5,0)
					w.C1 = CFrame.new(0,0.5,0)
					angl = -angl
				else
					w.C0 = CFrame.new(1.5,0.5,0)
					w.C1 = CFrame.new(0,0.5,0)
				end
			end

			for i = 1,16 do wait()
			w.C1 = w.C1 * CFrame.Angles(angl,0,0)
			end
			while true do 
				angl = -angl
				for i = 1,32 do wait()
				w.C1 = w.C1 * CFrame.Angles(angl,0,0)
				end
				for i = 1,32 do wait()
				w.C1 = w.C1 * CFrame.Angles(0,0.05,0) * CFrame.Angles(0,0,-angl)
				end
				
			end
		end))
	end
	pcall(function() ArmRotation(_Character["LeftUpperArm"]) end)
	pcall(function() ArmRotation(_Character["RightUpperArm"]) end)
	pcall(function() ArmRotation(_Character["Left Arm"]) end)
	pcall(function() ArmRotation(_Character["Right Arm"]) end)
	
	local position = Instance.new("BodyPosition")

	local position_person = function() 
		position.Parent = _Character.HumanoidRootPart
		position.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		position.Position = _Character.HumanoidRootPart.Position + Vector3.new(0,20,0)
	end
	
	local deposition_person = function()
		position.Parent = nil
		position.MaxForce = Vector3.new(0,0,0)
	end

	--position_person()
	
end

manipulateCharacter(owner.Character)

for i,v in pairs(workspace:GetDescendants()) do
	if v:IsA("BasePart") then
	
	end
end