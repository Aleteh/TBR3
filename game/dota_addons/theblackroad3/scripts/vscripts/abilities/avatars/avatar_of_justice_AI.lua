avatar_of_justice = nil

function EnterArena(trigger)
	local unit = trigger.activator
	local caller = trigger.caller
	if unit:IsRealHero() then
		if avatar_of_justice == nil then
			avatar_of_justice = CreateUnitByName("tbr_avatar_of_justice", caller:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
			avatar_of_justice.bringer = CreateUnitByName("npc_avatar_of_justice_bringer", caller:GetOrigin() + Vector(0,100,0), true, nil, nil, DOTA_TEAM_BADGUYS)
			avatar_of_justice.defender = CreateUnitByName("npc_avatar_of_justice_defender", caller:GetOrigin() + Vector(0,-100,0), true, nil, nil, DOTA_TEAM_BADGUYS)
			print("Called create Justice")
			for i=0, 5 do
				local ability = avatar_of_justice:GetAbilityByIndex(i)
				if ability then
					ability:SetLevel(1)
				end
			end
		end
	end
end

function AI_Thinker(keys)
	local targets = keys.target_entities
	avatar_of_justice = keys.caster
	local ability = avatar_of_justice:FindAbilityByName("tbr_avatar_of_justice_heal")
	
	local elapsedTime = 0
	local ctime = GameRules:GetGameTime()
	local entity_count = 0
	
	if avatar_of_justice.cast_time ~= nil then
		elapsedTime = GameRules:GetGameTime() - avatar_of_justice.cast_time
	end
	
--[[	while entity_count>-1 do
		if targets[entity_count + 1] ~= nil then
			if targets[entity_count + 1]:GetUnitName() == "npc_avatar_of_justice_bringer" then
				avatar_of_justice.bringer = targets[entity_count + 1]
				entity_count = entity_count + 1
			elseif targets[entity_count + 1]:GetUnitName() == "npc_avatar_of_justice_defender" then
				avatar_of_justice.defender = targets[entity_count + 1]
				entity_count = entity_count + 1
			else
				entity_count = entity_count + 1
			end
		else
			break
		end
	end
]]--
	
	if elapsedTime >= 10 or avatar_of_justice.cast_time == nil then
		local avatar_health = avatar_of_justice:GetHealthPercent()
		local bringer_health = 100
		local defender_health = 100
		
		if avatar_of_justice.bringer ~= nil then
			if not avatar_of_justice.bringer:IsNull() then
				bringer_health = avatar_of_justice.bringer:GetHealthPercent()
			end
		end
		
		if avatar_of_justice.defender ~= nil then
			if not avatar_of_justice.defender:IsNull() then
				local defender_health = avatar_of_justice.defender:GetHealthPercent()
			end
		end
		
		local lowest_hp = math.min(avatar_health,bringer_health,defender_health)
		
		if lowest_hp == 100 then
		else
			if lowest_hp == avatar_health then
				avatar_of_justice:CastAbilityOnTarget(avatar_of_justice, ability, DOTA_TEAM_BADGUYS)
				avatar_of_justice.cast_time = GameRules:GetGameTime()
				print("Cast heal on self")
			elseif lowest_hp == bringer_health then
				avatar_of_justice:CastAbilityOnTarget(avatar_of_justice.bringer, ability, DOTA_TEAM_BADGUYS)
				avatar_of_justice.cast_time = GameRules:GetGameTime()
				print("Cast heal on bringer of justice")
			elseif lowest_hp == defender_health then
				avatar_of_justice:CastAbilityOnTarget(avatar_of_justice.defender, ability, DOTA_TEAM_BADGUYS)
				avatar_of_justice.cast_time = GameRules:GetGameTime()
				print("Cast heal on defender of justice")
			end
		end
	end
end