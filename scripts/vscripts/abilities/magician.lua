function frost_bolt( event )
	local caster = event.caster

	local dir = (event.target_points[1] - caster:GetAbsOrigin()):Normalized()
	local dist = dir * 700

	local position = caster:GetAbsOrigin() + dist
	
	-- icewall starting from the caster up to the target point (or use a fixed distance)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_ice_path_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- origin
    ParticleManager:SetParticleControl(particle, 1, position) -- destination
    ParticleManager:SetParticleControl(particle, 2, Vector(2,0,0)) -- duration
    ParticleManager:SetParticleControl(particle, 9, caster:GetAbsOrigin()) -- blast origin

    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
	ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin()) -- origin
    ParticleManager:SetParticleControl(particle2, 1, position) -- destination
    ParticleManager:SetParticleControl(particle2, 2, Vector(0,0,1)) -- normal

  	Timers:CreateTimer({
    	endTime = 2,
    	callback = function()
      		ParticleManager:DestroyParticle(particle, false)
      		ParticleManager:DestroyParticle(particle2, false)
    	end
  	})
	end

function flame_spire(event)

	local target = event.target:GetAbsOrigin()

	--macropyre
	local hero = event.caster
	local spellPower = hero.spellPower

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	ParticleManager:SetParticleControl(particle, 0, target) -- origin
	ParticleManager:SetParticleControl(particle, 1, target) -- origin
    ParticleManager:SetParticleControl(particle, 2, Vector(1,0,0)) -- duration

	local aoe = event.ability:GetSpecialValueFor("radius")
	local duration = event.ability:GetSpecialValueFor("duration")
	local tick_rate = event.ability:GetSpecialValueFor("tick_interval")
	local damage_per_tick = 1 / (duration / tick_rate)
	local damage = event.ability:GetLevelSpecialValueFor("damage", event.ability:GetLevel()-1) + spellPower
	local aoe_damage = damage * damage_per_tick

	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), event.target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
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