function frost_bolt( event )
	local target = event.target_points[1]
	
	-- icewall starting from the caster up to the target point (or use a fixed distance)
end

function flame_spire(event)

	--macropyre

	local hero = event.caster
	local spellpower = hero.spellPower

	local aoe = event.ability:GetSpecialValueFor("radius")
	local duration = event.ability:GetSpecialValueFor("duration")
	local tick_rate = event.ability:GetSpecialValueFor("tick_interval")
	local damage_per_tick = 1 / (duration / tick_rate)
	local aoe_damage =  (event.ability:GetLevelSpecialValueFor("aoe_damage", event.ability:GetLevel()-1) + spellpower) * damage_per_tick

	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = hero, damage = aoe_damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end
end

function flash_point( event )
	
	-- light strike arraw with fireworks
end

function meteor_shower( event )
	local target = event.target_points[1]

	-- delay impact of 6~7 meteors in a line from the caster and the target point
end

function freezing_field( event )

	--random frost blast? field in a big aoe
	
end

function refresh_cooldowns( event )
	print("refreshing cooldowns")

  	Timers:CreateTimer({
    	endTime = 0.1,
    	callback = function()
      		local hero = event.caster
			for i=0,4 do
				local ability = hero:GetAbilityByIndex(i)
				--if not ability:IsCooldownReady() then
				ability:EndCooldown()
				--end
			end
    	end
  	})
	
end