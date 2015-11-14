function EnterArena(trigger)
	local unit = trigger.activator
	local caller = trigger.caller
	if unit:IsRealHero() then
		if avatar_of_earth == nil then
			avatar_of_earth = CreateUnitByName("tbr_avatar_of_nature", caller:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
			for i=0, 1 do
				local ability = avatar_of_earth:GetAbilityByIndex(i)
				if ability then
					ability:SetLevel(1)
				end
			end
		end
	end
end

function AI_Thinker(keys)
	local caster = keys.caster
	local targets = keys.target_entities
	local ability_treant = caster:FindAbilityByName("tbr_avatar_of_nature_treant")
	local ability_root = caster:FindAbilityByName("tbr_avatar_of_nature_root")
	
	local entities = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local entity_count = 0
	local treant_count = 0
	
	--[ Root target
	local units_present = 0
	local challengers = {}
	for i=0,10 do
		if targets[i] then
			challengers[units_present] = targets[i]
			units_present = units_present + 1
		end
	end
	if units_present > 0 then
		local randomNum = math.random(0,units_present - 1)
		avatar_of_earth:CastAbilityOnTarget(challengers[randomNum], ability_root, 0)
	end
		
	--[ Spawn Treants
	while entity_count>-1 do
		if entities[entity_count + 1] ~= nil then
			if entities[entity_count + 1]:GetUnitName() == "npc_avatar_of_nature_treant" then
				entity_count =  entity_count + 1
				treant_count = treant_count + 1
				print("Entitiy checked")
			else
				print("Failed to check entity name")
				entity_count =  entity_count + 1
			end
		else
			break
		end
	end
	if not treant_count > 0 then
		caster:CastAbilityNoTarget(ability_treant, 1)
	end
end