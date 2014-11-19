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
	local hero = event.caster
	local spellPower = hero.spellPower

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

function flame_spire_fx( event )
	local target = event.target:GetAbsOrigin()
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	ParticleManager:SetParticleControl(particle, 0, target) -- origin
	ParticleManager:SetParticleControl(particle, 1, target) -- origin
    ParticleManager:SetParticleControl(particle, 2, Vector(3,0,0)) -- duration

    --not sure if I should keep this:
    local particle = ParticleManager:CreateParticle("particles/dire_fx/bad_ancient002_pit_lava_blast.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
end

function flash_point( event )
	local hero = event.caster
	local radius = event.ability:GetSpecialValueFor("radius")

	--[[local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(radius,0,0))
	ParticleManager:SetParticleControl(particle, 3, hero:GetAbsOrigin())]]

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin())
	
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(particle1, 0, hero:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle1, 3, hero:GetAbsOrigin())
	
	local particle2 = ParticleManager:CreateParticle("particles/holdout_lina/holdout_wildfire_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(particle2, 0, hero:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, hero:GetAbsOrigin())
end

function meteor_shower( event )
	local point = event.target_points[1]
	local caster = event.caster

	local aoe = event.ability:GetSpecialValueFor("radius")
	local spellPower = event.caster.spellPower
	local damage = event.ability:GetAbilityDamage() + spellPower
	
 	print("Creating meteor particle")
    local dummy = CreateUnitByName("dummy_unit", caster:GetOrigin(), false, caster, caster, caster:GetTeam())
    dummy:AddAbility("magician_meteor_shower_proxy")
    local ability = dummy:FindAbilityByName("magician_meteor_shower_proxy")
    ability:SetLevel(1)

    Timers:CreateTimer({
		endTime = 0.05,
		callback = function()
			local dir = (event.target_points[1] - caster:GetAbsOrigin()):Normalized()
			local dist = dir * 10

			local position = point + dist
			dummy:CastAbilityOnPosition(position, ability, -1)
		end
		})

    Timers:CreateTimer({
		endTime = 1.5,
		callback = function()
			-- Do damage on the impact
   			enemies = FindUnitsInRadius(caster:GetTeamNumber(), point,  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			end
		end
	})

    for i=0.5,2,0.5 do
    	local dir = (event.target_points[1] - caster:GetAbsOrigin()):Normalized()
		local dist = dir * i * 400
		local position = point + dist

		Timers:CreateTimer({
		endTime = i,
		callback = function()
			dummy:CastAbilityOnPosition(position, ability, -1)
		end
		})

		Timers:CreateTimer({
		endTime = 1.5+i,
		callback = function()
			-- Do damage on the impact position
   			enemies = FindUnitsInRadius(caster:GetTeamNumber(), position,  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			end
		end
		})
	end

    Timers:CreateTimer({
		endTime = 10,
		callback = function()
			dummy:RemoveSelf()
			print("Removed meteor dummy")
		end
	})

end

function freezing_field_start( event )
	local hero = event.caster
    hero.FF_particle0 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(event.caster.FF_particle0, 0, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(event.caster.FF_particle0, 1, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(event.caster.FF_particle0, 3, hero:GetAbsOrigin())

	event.caster.FF_particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(hero.FF_particle1, 0, hero:GetAbsOrigin())
	ParticleManager:SetParticleControl(hero.FF_particle1, 1, Vector(600,600,0))

	EmitSoundOn("Hero_Crystal.CrystalNova.Yulsaria", hero)
	EmitSoundOn("hero_Crystal.freezingField.wind", hero)
end

function freezing_field_end( event )
	local hero = event.caster
	ParticleManager:DestroyParticle(hero.FF_particle1,false) --ice effect on the ground still remains
	ParticleManager:ReleaseParticleIndex(hero.FF_particle1)
end

function freezing_field( event )

	local position = event.caster:GetAbsOrigin() + RandomVector(RandomInt(50, 600))

	local dummy = CreateUnitByName("dummy_unit", position, false, event.caster, event.caster, event.caster:GetTeam())
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle, 0, dummy:GetAbsOrigin())

	if RandomInt(0,1)==0 then 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
		ParticleManager:SetParticleControl(particle, 0, dummy:GetAbsOrigin())
	end

	--Each Explosion deals xx + 1/20 Spelldamage in 200 AoE.
	local aoe = event.ability:GetSpecialValueFor("blast_radius")
	local spellPower = event.caster.spellPower
	local explosion_damage = event.ability:GetLevelSpecialValueFor("dmg", event.ability:GetLevel()-1) + (spellPower/20)

	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), position,  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		event.ability:ApplyDataDrivenModifier( hero, enemy, "call_lightning_modifier", {duration = daze_duration})
		--Damage reduced by 75% and 50% reduction on units that have already been hit.
		if enemy.FF == nil then	--first time being hit by a FF blast, do full damage
			enemy.FF = 1
			ApplyDamage({ victim = enemy, attacker = event.caster, damage = explosion_damage, damage_type = DAMAGE_TYPE_MAGICAL })
		elseif enemy.FF == 1 then
			enemy.FF = 2
			ApplyDamage({ victim = enemy, attacker = event.caster, damage = explosion_damage*0.75, damage_type = DAMAGE_TYPE_MAGICAL })
		elseif enemy.FF == 2 then
			ApplyDamage({ victim = enemy, attacker = event.caster, damage = explosion_damage*0.5, damage_type = DAMAGE_TYPE_MAGICAL })
		end
		EmitSoundOn("hero_Crystal.freezingField.explosion", enemy)

		--reset the FF counters
		Timers:CreateTimer({
			endTime = 4,
			callback = function()
				enemy.FF = nil
			end
		})
    end

    Timers:CreateTimer({
		endTime = 1,
		callback = function()
			dummy:RemoveSelf()
		end
	})

end

function refresh_cooldowns( event )
	print("refreshing cooldowns")

	local particle = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
	ParticleManager:SetParticleControl(particle, 0, event.caster:GetAbsOrigin())

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