function flame_spire(event)
	local hero = target.CASTER
	local spellpower = hero:spellPower

	local aoe = event.ability:GetSpecialValueFor("radius")
	local duration = event.abilit:GetSpecialValueFor("duration")
	local tick_rate = event.ability:GetSpecialValueFor("tick_interval")
	local damage_per_tick = 1 / (duration / tick_rate)
	local aoe_damage =  (event.ability:GetLevelSpecialValueFor("aoe_damage", event.ability:GetLevel()-1) + spellpower) * damage_per_tick

	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = hero, damage = aoe_damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end
end