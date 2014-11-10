function rejuvenation( event )
	local hero = event.caster
	local healingPower = hero.healingPower
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1))
	local duration = event.ability:GetLevelSpecialValueFor("duration", (event.ability:GetLevel()-1))
	local heal_tick = (heal_amount + healingPower) / duration 
	event.target:Heal( heal_tick, hero)	
	PopupHealing(even.target, heal_tick)
end

function natures_wrath_dot( event )
	local target = event.target
	local hero = event.caster
	local damage = event.Damage
	local spellPower = hero.spellPower
	local duration = event.ability:GetLevelSpecialValueFor("duration", (event.ability:GetLevel()-1))
	local damage_tick = (damage + spellPower) / duration
	
	ApplyDamage({ victim = target, attacker = hero, damage = damage_tick, damage_type = DAMAGE_TYPE_MAGICAL	})
end

function call_lightning( event )
	local target = event.target_points[1]
    local hero = event.caster
    local damage = event.Damage
    local spellPower = hero.spellPower
    local half_damage = (damage+spellPower)/2

    -- find enemies in 400 aoe
    enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), event.caster:GetAbsOrigin(),  nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do half damage
    for _,enemy in pairs(enemies) do
      ApplyDamage({
        victim = enemy,
        attacker = hero,
        damage = half_damage,
        damage_type = DAMAGE_TYPE_MAGICAL
        })
    end

    -- find enemies in 200 center aoe
    enemies2 = FindUnitsInRadius(event.caster:GetTeamNumber(), event.caster:GetAbsOrigin(),  nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do another half damage
    for _,enemy in pairs(enemies2) do
      ApplyDamage({
        victim = enemy,
        attacker = hero,
        damage = half_damage,
        damage_type = DAMAGE_TYPE_MAGICAL
        })
    end
end