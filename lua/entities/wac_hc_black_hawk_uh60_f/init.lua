
include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

ENT.IgnoreDamage = false
ENT.UsePhysRotor = true
ENT.Submersible	= false
ENT.CrRotorWash	= true
ENT.RotorWidth	= 200
ENT.EngineForce	= 40
ENT.BrakeMul = 1
ENT.AngBrakeMul	= 0.01
ENT.Weight = 8000

ENT.Rockets = {
	{
		ent_name="gb5_proj_howitzer_shell_in",
		pos=Vector(-100, 30, 4),
	},
	{
		ent_name="gb5_proj_howitzer_shell_in",
		pos=Vector(-100, -30, 4)
	},
}

ENT.Wheels = {
	{
		mdl="models/bf2/helicopters/mil mi-28/mi28_w2.mdl",
		pos=Vector(-307,0,4),
		friction=100,
		mass=200,
	},
	{
		mdl="models/bf2/helicopters/mil mi-28/mi28_w1.mdl",
		pos=Vector(46.34,-60.59,5.76),
		friction=100,
		mass=200,
	},
	{
		mdl="models/bf2/helicopters/mil mi-28/mi28_w1.mdl",
		pos=Vector(46.34,60.59,5.76),
		friction=100,
		mass=200,
	},
}

function ENT:SpawnFunction(p, tr)
	if (!tr.Hit) then return end
	local e = ents.Create(ClassName)
	e:SetPos(tr.HitPos + tr.HitNormal*15)
	e.Owner = p
	e:Spawn()
	e:Activate()
	e:SetSkin(math.random(0,3))
	e.EngineForce	= 20
	e.rotorRpm = 10
	e.engineRpm = 10
	e.active = true
	e.Rockets = {
		{
			ent_name="gb5_proj_howitzer_shell_in",
			pos=Vector(-100, 30, 4),
		},
		{
			ent_name="gb5_proj_howitzer_shell_in",
			pos=Vector(-100, -30, 4)
		},
	}
	e.b = false
	e.count_rockets = #e.Rockets or nil
	local array_rockets = {}
	--e.Entity:SetPos(e.Entity:GetPos() + Vector(0, 0, 150))
	for _, rocket in pairs( e.Rockets ) do
		local r = ents.Create(rocket.ent_name)
		r:SetPos(e.Entity:GetPos() + rocket.pos)
		r:SetAngles(e.Entity:GetAngles() + Angle(0, 180, 0))
		r:PhysicsInit(SOLID_VPHYSICS)
		r:SetParent(e.Entity)
		r:Spawn()
		table.insert(array_rockets, r)
		
	end

	local pilot = ents.Create("npc_citizen")--ents.CreateClientProp()
	pilot:SetModel("models/Humans/Group01/male_07.mdl")
	pilot:SetSequence("injured1")
	pilot:SetCollisionGroup(COLLISION_GROUP_WORLD)
	pilot:PhysicsInit(SOLID_NONE)
	pilot:SetMoveType(MOVETYPE_NONE)
	pilot:SetSolid(SOLID_NONE)
	pilot:SetPos(e.Entity:GetPos() + Vector(110, 30, 30))
	pilot:SetParent(e.Entity)
	pilot:Spawn()

	local second_pilot = ents.Create("npc_citizen") --ents.CreateClientProp()
	second_pilot:SetModel("models/Humans/Group01/male_07.mdl")
	second_pilot:SetSequence("sit_breath")
	second_pilot:SetCollisionGroup(COLLISION_GROUP_WORLD)
	second_pilot:PhysicsInit(SOLID_NONE)
	second_pilot:SetMoveType(MOVETYPE_NONE)
	second_pilot:SetSolid(SOLID_NONE)
	second_pilot:SetPos(e.Entity:GetPos() + Vector(110, -30, 30))
	second_pilot:SetParent(e.Entity)
	second_pilot:Spawn()
	
	local r_turret = ents.Create("cup_npc_turret")
	r_turret:SetSolid(SOLID_NONE)
	r_turret:SetPos(e.Entity:GetPos() + Vector(0, -50, 30) )
	r_turret:SetCollisionGroup(COLLISION_GROUP_WORLD)
	r_turret:PhysicsInit(SOLID_NONE)
	r_turret:SetMoveType(MOVETYPE_NONE)
	r_turret:SetAngles(Angle(0,-90,0))
	
	r_turret:Spawn()

	local r_turret_shield = ents.Create("prop_dynamic")
	r_turret_shield:SetModel( "models/props_combine/combine_barricade_short02a.mdl" )
	r_turret_shield:SetSolid(SOLID_NONE)
	e.controls.throttle = 20
	r_turret_shield:SetPos(e.Entity:GetPos() + Vector(0, -50, 30) )
	r_turret_shield:SetCollisionGroup(COLLISION_GROUP_WORLD)
	r_turret_shield:PhysicsInit(SOLID_NONE)
	r_turret_shield:SetMoveType(MOVETYPE_NONE)
	r_turret_shield:SetParent(e.Entity)
	r_turret_shield:SetAngles(Angle(0,-120,0))
	
	r_turret_shield:Spawn()
	
	r_turret:SetParent(r_turret_shield)

	local r_gunner = ents.Create("npc_citizen")
	r_gunner:SetSolid(SOLID_NONE)
	r_gunner:SetPos(e.Entity:GetPos() + Vector(120, -40, 0))
	r_gunner:SetAngles(r_turret_shield:GetAngles())
	r_gunner:SetCollisionGroup(COLLISION_GROUP_WORLD)
	r_gunner:PhysicsInit(SOLID_NONE)
	r_gunner:SetMoveType(MOVETYPE_NONE)
	r_gunner:SetMoveType(MOVETYPE_NONE)
	
	timer.Simple(0.01,function()
		r_gunner:Spawn()
	end)
	timer.Simple(0.1,function()
		r_gunner:SetParent(e.Entity)
	end)
	

	local l_turret = ents.Create("cup_npc_turret")
	l_turret:SetSolid(SOLID_NONE)
	l_turret:SetPos(e.Entity:GetPos() + Vector(0, 50, 30) )
	l_turret:SetCollisionGroup(COLLISION_GROUP_WORLD)
	l_turret:PhysicsInit(SOLID_NONE)
	l_turret:SetMoveType(MOVETYPE_NONE)
	l_turret:SetAngles(Angle(0,90,0))
	l_turret:Spawn()

	local l_turret_shield = ents.Create("prop_dynamic")
	l_turret_shield:SetModel( "models/props_combine/combine_barricade_short02a.mdl" )
	l_turret_shield:SetSolid(SOLID_NONE)
	e.controls.throttle = 20
	l_turret_shield:SetPos(e.Entity:GetPos() + Vector(0, 50, 30) )
	l_turret_shield:SetCollisionGroup(COLLISION_GROUP_WORLD)
	l_turret_shield:PhysicsInit(SOLID_NONE)
	l_turret_shield:SetMoveType(MOVETYPE_NONE)
	l_turret_shield:SetParent(e.Entity)
	l_turret_shield:SetAngles(Angle(0,60,0))

	l_turret_shield:Spawn()
	
	l_turret:SetParent(l_turret_shield)

	local l_gunner = ents.Create("npc_citizen")
	l_gunner:SetSolid(SOLID_NONE)
	l_gunner:SetPos(e.Entity:GetPos() + Vector(120, 40, 0))
	l_gunner:SetAngles(l_turret_shield:GetAngles())
	l_gunner:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	l_gunner:PhysicsInit(SOLID_NONE)
	l_gunner:SetMoveType(MOVETYPE_NONE)
	l_gunner:SetMoveType(MOVETYPE_NONE)

	timer.Simple(0.01,function()
		l_gunner:Spawn()
	end)
	timer.Simple(0.1,function()
		l_gunner:SetParent(e.Entity)
	end)
	

	timer.Create("push"..e.Entity:EntIndex(), 0.5, 0, function()
		-- local dir = Vector(0, 0, -100)
		-- local force = 50
		-- local distance = dir:Length()        // The distance the phys object is from the e
		-- local maxdistance = 200                // The max distance 
		-- local ratio = math.Clamp( (100 - (distance/maxdistance)), 0, 100 )
		-- local vForce = -1*dir * (force * ratio)
		-- e.Entity:GetPhysicsObject():ApplyForceOffset( vForce, dir )
		if IsValid(e.Entity) then
			local vec_pos = e.Entity:GetPos()
			local sphere = ents.FindInSphere( vec_pos, 5000 )
			for _, ply in pairs( sphere ) do
				if IsValid(pilot) then
					if ply:IsPlayer() then
						local vec_pos_ply = ply:GetPos()
						if e.Rockets != nil && e.count_rockets > 0 then -- # - get container size
							-- array_rockets = {}
							
							if e.rotorRpm > 0.1 then
								local diff = Vector(vec_pos.x, vec_pos.y, vec_pos_ply.z)
								print(diff)
								-- print(vec_pos_ply) 
								for _, r in pairs( array_rockets ) do
									-- ply:ChatPrint(diff:Distance(vec_pos_ply))
									if (diff:Distance(vec_pos_ply) < r.ExplosionRadius / 2) && (vec_pos.z > diff.z + r.ExplosionRadius )  then
										ply:ChatPrint( "ALLAH AKBAR" )
										r:PhysicsDestroy()
										r:PhysicsInit(SOLID_VPHYSICS)
										r:GetPhysicsObject():Wake()
										r:Arm()
										r:SetParent(nil)
										e.count_rockets = e.count_rockets - 1
									end
								end
							end
						end

						-- if ply:GetEyeTrace().Entity == e.Entity then
						-- 	e.controls.yaw = math.random(-1, 1)
						-- 	e.controls.throttle = math.random(-1, 1)
						-- end

						local e_rotation = e.Entity:GetAngles()
						local e_rotation_y = e_rotation.y
						
						
						if !e.b then
							-- for _, r in pairs( array_rockets ) do
							if vec_pos.z < vec_pos_ply.z + 1000 then
							--if vec_pos.z < vec_pos_ply.z + 500 then
								e:SetHover(true)
								e.controls.throttle = 0.9
								-- e.controls.pitch = 0.8
								-- e.controls.roll = -0.4
							else
								e.controls.throttle = -0.9
								-- e.controls.pitch = -0.8
								-- e.controls.roll = 0.2
							end
							-- end
						end

						local dist = (vec_pos - vec_pos_ply):Angle()

						dist.y = dist.y + 90

						if dist.y > 360 then
							dist.y = dist.y - 360
						end

						if dist.y > 180 then
							dist.y = dist.y - 180
						end

						if e_rotation_y < dist.y - 20 || e_rotation_y > dist.y + 20 then
							if e_rotation_y < dist.y - 20 then
								e.controls.yaw = 2.5
							end
							if e_rotation_y > dist.y + 20 then
								e.controls.yaw = -1.5
							end
						else
							e.controls.yaw = 0
							
						end
					end
				else
					e.controls.yaw = math.random(1, 5)
					e.controls.throttle = math.random(-5, -1)
					e.controls.pitch = math.random(-3, 3)
					e.controls.roll = math.random(-3, 3)
					
				end
			end
		end	
		

	end)

	return e
end
