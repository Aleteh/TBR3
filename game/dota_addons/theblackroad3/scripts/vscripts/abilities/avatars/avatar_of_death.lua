avatar_of_death = nil

function SummonSkeletons(keys)
	avatar_of_death = keys.caster
	
	local Origin = avatar_of_death:GetAbsOrigin()
	local Angles = avatar_of_death:GetAngles()
	
	local vectorPOSmele = {
		Vector(250,300,0),
		Vector(350,100,0),
		Vector(350,-100,0),
		Vector(250,-300,0)
	}
	
	local vectorPOSranged = {
		Vector(-400,150,0),
		Vector(-400,-150,0)
	}

	for i=1,4 do
		local rotated = RotatePosition(Vector(0,0,0),Angles,vectorPOSmele[i])
		local pos = Origin + rotated
		local unit = CreateUnitByName("npc_avatar_of_death_mele", pos, true, nil, nil, avatar_of_death:GetTeam())
		unit:SetAngles(Angles.x, Angles.y, Angles.z)
	end
	
	for i=1,2 do
		local rotated = RotatePosition(Vector(0,0,0),Angles,vectorPOSranged[i])
		local pos = Origin + rotated
		local unit = CreateUnitByName("npc_avatar_of_death_ranged", pos, true, nil, nil, avatar_of_death:GetTeam())
		unit:SetAngles(Angles.x, Angles.y, Angles.z)
	end
end