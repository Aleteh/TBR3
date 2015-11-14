function SpawnTreants(keys)
	local caster = keys.caster
	local origin = caster:GetOrigin()
	local angle = VectorToAngles(caster:GetForwardVector())
	
	local vector_mod = {
		Vector(250,-500,0),
		Vector(-250,-500,0)
	}
	
	for i=1,2 do
		vector_pos = RotatePosition(vector_mod[i], angle, Vector(0,0,128))
		local place = origin + vector_pos
		CreateUnitByName("npc_avatar_of_nature_treant", place, true, nil, nil, caster:GetTeam())
	end
end