function rejuvenation( event )
	local hero = event.caster
	local healingPower = hero.healingPower
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1))
	local duration = event.ability:GetLevelSpecialValueFor("duration", (event.ability:GetLevel()-1))
	local heal_tick = (heal_amount + healingPower) / duration 
	event.target:Heal( heal_tick, hero)	
	PopupHealing(event.target, math.floor(heal_tick))
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
        event.ability:ApplyDataDrivenModifier( hero, enemy, "call_lightning_modifier", {duration = daze_duration})
      ApplyDamage({ victim = enemy, attacker = hero, damage = half_damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end

    -- find enemies in 200 center aoe
    enemies2 = FindUnitsInRadius(event.caster:GetTeamNumber(), target,  nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do another half damage
    for _,enemy in pairs(enemies2) do
      ApplyDamage({ victim = enemy, attacker = hero, damage = half_damage, damage_type = DAMAGE_TYPE_MAGICAL })
    end

    --TODO: Add Purge Effect
end

function mind_blast( event )
    local target = event.target
    local hero = event.caster
    local damage = event.ability:GetAbilityDamage()
    local spellPower = hero.spellPower
    local daze_duration = event.ability:GetSpecialValueFor("daze_duration") 
    local mana_drain = event.ability:GetLevelSpecialValueFor("mana_drain", (event.ability:GetLevel()-1))

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
    ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,2000)) -- height of the bolt
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- point landing
    ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin()) -- point origin

    --Do Main Damage
    ApplyDamage({ victim = target, attacker = hero, damage = damage + spellPower, damage_type = DAMAGE_TYPE_MAGICAL })      

    local initial_mana = target:GetMana()

    --Drain up to xxxx mana from the target. 
    target:ReduceMana(mana_drain)

    local mana_drained = math.floor(initial_mana - target:GetMana())
    print("draining "..mana_drained)

    if mana_drained>0 then
        PopupManaDrain(target,mana_drained)
    end

    -- find enemies in 200 center aoe
    enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do damage equal to the amount of mana drained in AoE, also apply the slow debuff
    for _,enemy in pairs(enemies) do
        event.ability:ApplyDataDrivenModifier( hero, enemy, "mind_blast_modifier", {duration = daze_duration})
        ApplyDamage({ victim = enemy, attacker = hero, damage = mana_drained, damage_type = DAMAGE_TYPE_MAGICAL })    
    end

end

function call_storm( event )
    local target = event.target_points[1]
    local radius = event.ability:GetSpecialValueFor("radius")

    --particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf
    --particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf
    --particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning_sphere.vpcf
    --particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf
    --particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf
    --particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf
    --particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf

    local dummy = CreateUnitByName("dummy_unit", target, false, event.caster, event.caster, event.caster:GetTeam())

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    ParticleManager:SetParticleControl(particle, 1, dummy:GetAbsOrigin())
   
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_OVERHEAD_FOLLOW, dummy)
    ParticleManager:SetParticleControl(particle, 1, dummy:GetAbsOrigin())

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)
    ParticleManager:SetParticleControl(particle, 0, dummy:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, dummy:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, dummy:GetAbsOrigin())

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", MAX_PATTACH_TYPES, dummy)
    ParticleManager:SetParticleControl(particle, 0, dummy:GetAbsOrigin()) --location
    ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius)) --ring/weird
    ParticleManager:SetParticleControl(particle, 2, Vector(6,6,0)) --duration

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_kf_formation.vpcf", MAX_PATTACH_TYPES, dummy)
    ParticleManager:SetParticleControl(particle, 0, dummy:GetAbsOrigin()) --location
    ParticleManager:SetParticleControl(particle, 1, Vector(300,300,1)) --ring/weird
    ParticleManager:SetParticleControl(particle, 2, Vector(6,6,0)) --duration


end

function stormy( event )
    local target = event.target:GetAbsOrigin()
    
    -- find enemies in 350 aoe (center of the storm)
    enemies = FindUnitsInRadius(event.target:GetTeamNumber(), target,  nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- spam lightnings
    for _,enemy in pairs(enemies) do
        Timers:CreateTimer({
            endTime = RandomFloat(0.1, 0.9),
            callback = function()
                EmitSoundOn("Hero_Zuus.StaticField", enemy)
                local lightning_type = RandomInt(1,3)
                local particle
                if lightning_type == 1 then
                    particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, enemy)
                elseif lightning_type == 2 then
                    particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_WORLDORIGIN, enemy)
                elseif lightning_type == 3 then
                    particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_WORLDORIGIN, enemy)
                end
                --shared control points for all the different lightnings
                ParticleManager:SetParticleControl(particle, 0, Vector(enemy:GetAbsOrigin().x,enemy:GetAbsOrigin().y,1000)) -- height of the bolt
                ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin()) -- point landing
                ParticleManager:SetParticleControl(particle, 2, enemy:GetAbsOrigin()) -- point origin  
            end
          })
    end
end