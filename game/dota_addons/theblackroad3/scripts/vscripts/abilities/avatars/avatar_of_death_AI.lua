avatar_of_death = nil

function EnterArena(trigger)
	local unit = trigger.activator
	local caller = trigger.caller
	if unit:IsRealHero() then
		if avatar_of_death == nil then
			avatar_of_death = CreateUnitByName("tbr_avatar_of_death", caller:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
			for i=0, 5 do
				local ability = avatar_of_death:GetAbilityByIndex(i)
				if ability then
					ability:SetLevel(1)
				end
			end
		end
	end
end

function AI_Thinker(keys)
	avatar_of_death = keys.caster
	local targets = keys.target_entities
	local ability_cripple = avatar_of_death:FindAbilityByName("tbr_avatar_of_death_cripple")
	local ability_summon = avatar_of_death:FindAbilityByName("tbr_avatar_of_death_summon")
	
	local entities = FindUnitsInRadius(avatar_of_death:GetTeam(), avatar_of_death:GetOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local entity_count = 0
	local skeleton_m_count = 0
	local skeleton_r_count = 0
	
	--[ Cripple target
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
		avatar_of_death:CastAbilityOnTarget(challengers[randomNum], ability_cripple, 0)
	end
	
	local elapsedTime = 0
	local ctime = GameRules:GetGameTime()
	
	if avatar_of_death.cast_time ~= nil then
		elapsedTime = GameRules:GetGameTime() - avatar_of_death.cast_time
	end
	
	--[ Spawn skeletons
	while entity_count>-1 do
		if entities[entity_count + 1] ~= nil then
			if entities[entity_count + 1]:GetUnitName() == "npc_avatar_of_death_mele" then
				entity_count =  entity_count + 1
				skeleton_m_count = skeleton_m_count + 1
			elseif entities[entity_count + 1]:GetUnitName() == "npc_avatar_of_death_ranged" then
				entity_count =  entity_count + 1
				skeleton_r_count = skeleton_r_count + 1
			else
				entity_count = entity_count + 1
			end
		else
			break
		end
	end
	
	print(skeleton_m_count)
	print(skeleton_r_count)
	if elapsedTime > 5 or avatar_of_death.cast_time == nil then
		if skeleton_m_count == 0 and skeleton_r_count == 0 or skeleton_r_count == 0 and skeleton_m_count < 3 then
			avatar_of_death:CastAbilityNoTarget(ability_summon, 1)
			avatar_of_death.cast_time = GameRules:GetGameTime()
		end
	end
end