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
	local _poi = Model('Poi', parent)
	
	local _knob = Part('Knob', 'Medium stone grey', 'Plastic', 0.4, 0.4, 0.4, _poi) 
	local _handle = Weld(characterPiece, _knob, CfrAng(0,-1.5,0,0,0,0))
	
	local _ropeA = Part('Rope Top', 'Medium stone grey', 'Plastic', 0.2, 0.4, 0.2, _poi)
	local _knobToRopeA = Weld(_knob, _ropeA, CfrAng(0,-0.4,0, 0,0,0))
	
	local _ropeJ = Part('Rope Joint', 'Black', 'Plastic', 0.21, 0.1, 0.21, _poi) 
	local _ropeAtoJ = Weld(_ropeA, _ropeJ, CfrAng(0,-0.2,0, 0,0,0))
	
	local _ropeB = Part('Rope Bottom', 'Medium stone grey', 'Plastic', 0.2, 0.4, 0.2, _poi)
	local _ropeJtoB = Weld(_ropeJ, _ropeB, CfrAng(0,-0.2,0, 0,0,0))
	
	local _head = Part('Head', 'Medium stone grey', 'Plastic', 0.6, 0.6, 0.6, _poi)
	local _ropeBtoHead = Weld(_ropeB, _head, CfrAng(0,-0.4,0, 0,0,0))
	
	return _poi
end

function manipulateCharacter()
	buildPoi(Character['LeftLowerArm'])
	buildPoi(Character['RightLowerArm'])
end

manipulateCharacter()
