function holy_light(event)
	event.target:EmitSound("Hero_Omniknight.Purification")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", event.ability:GetLevel()-1) + event.caster.healingPower
	event.target:Heal( heal_amount, event.caster)
	PopupHealing(event.target, heal_amount)
end

function regen(event)
	local hero = event.caster
	local healingPower = hero.healingPower
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1))
	local duration = event.ability:GetLevelSpecialValueFor("duration", (event.ability:GetLevel()-1))
	local heal_tick = (heal_amount + healingPower) / duration 
	event.target:Heal( heal_tick, hero)
	PopupHealing(event.target, math.floor(heal_tick))
end

function fire_of_heaven(event)
	local target = event.target
	local hero = event.caster
	local spellPower = hero.spellPower

	local aoe = event.ability:GetSpecialValueFor("radius")

	local damage = event.ability:GetAbilityDamage() + spellPower
	print(damage)
	local aoe_damage =  event.ability:GetLevelSpecialValueFor("aoe_damage", event.ability:GetLevel()-1)
	local slow_duration = event.ability:GetSpecialValueFor("slow_duration")

	-- do main target damage
	ApplyDamage({ victim = target, attacker = hero, damage = damage + spellPower, damage_type = DAMAGE_TYPE_MAGICAL })
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())

	-- find enemies nearby
	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	--SendToConsole('Say Please Print Dawg Damage: '..damage.." and spellpower: "..spellPower.." and aoe_damage: "..aoe_damage) 

	-- do damage and slow nearby targets
	for _,enemy in pairs(enemies) do
		if enemy ~= target then -- should we ignore the main target?
	        ApplyDamage({ victim = enemy, attacker = hero, damage = aoe_damage + spellPower * 3 / 4, damage_type = DAMAGE_TYPE_MAGICAL })
	    end
	    event.ability:ApplyDataDrivenModifier(hero, enemy, "fire_of_heaven_slow", nil)
    end
end

function cleansing_flame(event)
	local target = event.target
	local hero = event.caster
	local spellpower = hero.spellPower
	local healpower = hero.healingPower

	local aoe = event.ability:GetSpecialValueFor("aoe")
	local damage = event.ability:GetLevelSpecialValueFor("damage", event.ability:GetLevel()-1) + spellpower
	local heal = event.ability:GetLevelSpecialValueFor("damage", event.ability:GetLevel()-1) + healpower

	-- NOTE: Doesn't seem to do AoE Damage in WC3 v1.36

	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	allies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL }) 
	end
	for _,ally in pairs(allies) do
		ally:Heal(heal, hero)
		PopupHealing(ally, heal)
	end

end

function rebirth(event)
	if event.target:GetUnitName() == "player_gravestone" then
		local target_hero = event.target:GetOwnerEntity()
		local location = Vector(event.target:GetAbsOrigin().x, event.target:GetAbsOrigin().y, event.target:GetAbsOrigin().z+100)
		local health_difference = target_hero:GetMaxHealth() * ( (event.ability:GetLevelSpecialValueFor("hp", event.ability:GetLevel()-1) / 100))
		local mana_difference = target_hero:GetMaxMana() * (1 - (event.ability:GetLevelSpecialValueFor("mana", event.ability:GetLevel()-1) / 100))
		local hero = event.caster

		if target_hero:UnitCanRespawn() then
			--target_hero:RespawnUnit() --doesn't actually respawn heroes, the 'Killed by' still remains.
			target_hero:SetTimeUntilRespawn(0)

			--need to wait a bit for the hero to respawn	   
			Timers:CreateTimer({
		    	endTime = 0.1,
		    	callback = function()
		    		FindClearSpaceForUnit(target_hero, location, true)
		    		EmitSoundOn("Hero_Chen.HandOfGodHealHero", target_hero)
		    		target_hero:ModifyHealth(health_difference, nil, false, 0)
					target_hero:ReduceMana(mana_difference)
    				particle = ParticleManager:CreateParticle("particles/frostivus_gameplay/wraith_king_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, target_hero)
    				ParticleManager:SetParticleControl(particle, 0, target_hero:GetAbsOrigin())
    				ParticleManager:SetParticleControl(particle, 1, target_hero:GetAbsOrigin())
    				ParticleManager:SetParticleControl(particle, 2, target_hero:GetAbsOrigin())
    				ParticleManager:SetParticleControl(particle, 3, target_hero:GetAbsOrigin())
    				particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_holy_persuasion_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, target_hero)
    				ParticleManager:SetParticleControl(particle, 0, target_hero:GetAbsOrigin())
    				ParticleManager:SetParticleControl(particle, 1, target_hero:GetAbsOrigin())

    		 	end
		  	})
			
		end
	else
		event.ability:RefundManaCost()
		event.ability:EndCooldown()
		EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", event.caster:GetPlayerOwner())
		FireGameEvent( 'custom_error_show', { player_ID = pID, _error = "Ability Must Target Tombstones" } )
	end
end