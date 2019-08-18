Player = game.Players:WaitForChild("bob371")
Character = game.Workspace:WaitForChild("bob371")
script.Parent = Character

wait(2)
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
	p.BrickColor = BrickColor.new(co)
	p.Material = ma
	p.Name = na
	p.Size = Vector3.new(sx,sy,sz)
	p.Parent = pa
	return p
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
	local _library = {}
	
	local _poi = Model('Poi', arm)
	table.insert(_library,_poi)
	
	local _knob = Part('Knob', 'Medium stone grey', 'Plastic', 0.17, 0.17, 0.17, _poi) 
	local _handle = Weld(arm, _knob, CfrAng(0.5,-1,0,0,0,0))
	
	local _ropeA = Part('RopeTop', 'Medium stone grey', 'Plastic', 0.1, 1, 0.1, _poi)
	local _knobToRopeA = Weld(_knob, _ropeA, CfrAng(0,-0.6,0, 0,0,0))
	local _ropeJ = Part('RopeJoint', 'Black', 'Plastic', 0.12, 0.12, 0.12, _poi) 
	local _ropeAtoJ = Weld(_ropeA, _ropeJ, CfrAng(0,-0.4,0, 0,0,0))
	
	local _ropeB = Part('RopeBottom', 'Medium stone grey', 'Plastic', 0.1, 1, 0.1, _poi)
	local _ropeJtoB = Weld(_ropeJ, _ropeB, CfrAng(0,-0.4,0, 0,0,0))
	
	local _head = Part('Head', 'Medium stone grey', 'Plastic', 0.77, 0.77, 0.77, _poi)
	_head.Shape = "Ball"
	local _ropeBtoHead = Weld(_ropeB, _head, CfrAng(0,-0.6,0, 0,0,0))
	
	function _library.handleSpin(xyz)
		if xyz == 'x' then
			for i = 1, 4 do
				_handle.C0 = _handle.C0 * Ang(math.pi/32.0,0,0)
			end
		elseif xyz == 'y' then
			for i = 1, 4 do
				_handle.C0 = _handle.C0 * Ang(0,math.pi/32.0,0)
			end
		elseif xyz == 'z' then
			for i = 1, 4 do
				_handle.C0 = _handle.C0 * Ang(0,0,math.pi/32.0)
			end
		end
	end
	
	return _library
end

function manipulateCharacter()
	local leftPoi = buildPoi(Character['LeftLowerArm'])
	local rightPoi = buildPoi(Character['RightLowerArm'])
	leftPoi.handleSpin('x')
	while true do wait()
		leftPoi.handleSpin('x')
		rightPoi.handleSpin('x')
	end
end

manipulateCharacter()
