function rejuvenation( event )
	local hero = event.caster
	local healingPower = hero.healingPower
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1))
	local duration = event.ability:GetLevelSpecialValueFor("duration", (event.ability:GetLevel()-1))
	local heal_tick = (heal_amount + healingPower) / duration 
	event.target:Heal( heal_tick, hero)	
	PopupHealing(event.target, heal_tick)
end

function natures_wrath_dot( event )
	local target = event.target
	local hero = event.caster
	local damage = event.ability:GetLevelSpecialValueFor("damage_per_second", (event.ability:GetLevel()-1)) 
	local spellPower = hero.spellPower
	local duration = event.ability:GetLevelSpecialValueFor("duration", (event.ability:GetLevel()-1))
	local damage_tick = damage + ( spellPower / duration )
	
	ApplyDamage({ victim = target, attacker = hero, damage = damage_tick, damage_type = DAMAGE_TYPE_MAGICAL	})
end

function call_lightning( event )
	local target = event.target_points[1]
    local hero = event.caster
    local damage = event.ability:GetAbilityDamage()
    local spellPower = hero.spellPower
    local half_damage = (damage+spellPower)/2

    print("Creating lightning particle")
    local dummy = CreateUnitByName("dummy_unit", target, false, event.caster, event.caster, event.caster:GetTeam())
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, dummy)
    ParticleManager:SetParticleControl(particle, 0, Vector(dummy:GetAbsOrigin().x,dummy:GetAbsOrigin().y,2000)) -- height of the bolt
    ParticleManager:SetParticleControl(particle, 1, dummy:GetAbsOrigin()) -- point landing
    ParticleManager:SetParticleControl(particle, 2, dummy:GetAbsOrigin()) -- point origin

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_earthshock_soil1.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    ParticleManager:SetParticleControl(particle, 1, dummy:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, dummy:GetAbsOrigin())

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    ParticleManager:SetParticleControl(particle, 1, dummy:GetAbsOrigin())

    -- find enemies in 400 aoe
    enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target,  nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do half damage
    for _,enemy in pairs(enemies) do
      ApplyDamage({ victim = enemy, attacker = hero, damage = half_damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end

    -- find enemies in 200 center aoe
    enemies2 = FindUnitsInRadius(event.caster:GetTeamNumber(), target,  nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do another half damage
    for _,enemy in pairs(enemies2) do
      ApplyDamage({ victim = enemy, attacker = hero, damage = half_damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end
end

function mind_blast( event )
    local target = event.target
    local hero = event.caster
    local damage = event.ability:GetAbilityDamage()
    local spellPower = hero.spellPower

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
    ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,2000)) -- height of the bolt
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- point landing
    ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin()) -- point origin

     -- find enemies in 200 center aoe
    enemies2 = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do damage
    for _,enemy in pairs(enemies2) do
        -- TODO : Mana Drain, do the particle as a modifier with EffectName
        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
        ApplyDamage({ victim = enemy, attacker = hero, damage = damage + spellPower, damage_type = DAMAGE_TYPE_MAGICAL })
    end

end