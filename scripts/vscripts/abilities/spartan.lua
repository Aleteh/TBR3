function dispatch ( event )
    local target = event.target
    local hero = event.caster
    local damage = event.ability:GetAbilityDamage() + ( hero:GetStrength() * 2 )
    local spellPower = hero.spellPower

    -- Adds double your Strength plus xxxx damage to your next attack against a single target for xxx mana. 
    print("Dispatching for " .. damage .. " damage with " .. spellPower .. " spellPower")
    hero:PerformAttack(target, false, true, false, false) --[[ Params: Target, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis  ]]
    ApplyDamage({
        victim = target,
        attacker = hero,
        damage = damage + spellPower,
        damage_type = DAMAGE_TYPE_PHYSICAL
    })

    -- handle the stacks
    if not target:HasModifier("modifier_spartan_dispatch") then
        print("Apply Bleed")
        event.ability:ApplyDataDrivenModifier(hero, target, "modifier_spartan_dispatch", {duration = 8})
        target:SetModifierStackCount("modifier_spartan_dispatch", event.ability, 1)
    else --it has bleeding mods, count how many
        local modifierCount = target:GetModifierStackCount("modifier_spartan_dispatch",nil)
        print("Target has " .. modifierCount .. " bleeding modifiers, applying one more")
        target:SetModifierStackCount("modifier_spartan_dispatch", event.ability, modifierCount + 1)
    end
   
end

function dispatch_bleed ( event )
    local target = event.target
    local hero = event.caster
    local damage = event.ability:GetAbilityDamage() + ( hero:GetStrength() * 4 )
    local spellPower = hero.spellPower --does this apply to the bleed too? I assume it does.
    local bleed_damage_tick = (damage + hero.spellPower) / 8 --calculated dinamically, might be an issue
    local modifierCount = target:GetModifierStackCount("modifier_spartan_dispatch",nil)

    if target:IsAlive() then
        print("Bleeding for " .. bleed_damage_tick)
        ApplyDamage({
            victim = target,
            attacker = hero,
            damage = bleed_damage_tick * modifierCount,
            damage_type = DAMAGE_TYPE_PHYSICAL
        })
        PopupBleedingOverTime(target, math.floor(bleed_damage_tick * modifierCount))
    end
                             

end

function spartan_throw( event ) -- not to be confused with 300, which was tactical feeding
    point = event.target_points[1]
    caster = event.caster
    ability = event.ability

    local info = {
        EffectName =  "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf", --"particles/units/heroes/hero_huskar/huskar_base_attack.vpcf",
        Ability = ability,
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = 1000,
        fStartRadius = 150,
        fEndRadius = 150,
        Source = caster,
        bHasFrontalCone = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
        --fMaxSpeed = 5200,
        fExpireTime = GameRules:GetGameTime() + 4.0,
    }

    local speed = event.ability:GetLevelSpecialValueFor("throw_speed", (event.ability:GetLevel() - 1))

    point.z = 0
    local pos = caster:GetAbsOrigin()
    pos.z = 0
    local diff = point - pos
    info.vVelocity = diff:Normalized() * speed

    ProjectileManager:CreateLinearProjectile( info )
end

function javelin_particle ( event )
    local javelin_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(javelin_particle, 3, event.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(javelin_particle, 1, event.target:GetAbsOrigin())
end

function phalanx( event )
    local manacost_per_second = event.ability:GetLevelSpecialValueFor("mana_cost_per_second", (event.ability:GetLevel() - 1))
    if event.caster:GetMana() >= manacost_per_second then
        event.caster:SpendMana( manacost_per_second, event.ability)
    else
        event.ability:ToggleAbility()
    end
end

function charge( event )
    local target = event.target
    local hero = event.caster
    local single_target_damage = event.ability:GetAbilityDamage() + ( hero:GetStrength() )
    local spellPower = hero.spellPower
    local radius = event.ability:GetLevelSpecialValueFor("radius", (event.ability:GetLevel()-1))
    local aoe_damage = event.ability:GetLevelSpecialValueFor("aoe_damage", (event.ability:GetLevel()-1)) + ( hero:GetStrength() / 2 )
    local daze_duration = event.ability:GetLevelSpecialValueFor("daze_duration", (event.ability:GetLevel()-1))
    local taunt_duration = event.ability:GetLevelSpecialValueFor("taunt_duration", (event.ability:GetLevel()-1))

    -- charge physics
    local unit = event.caster
    
    Physics:Unit(unit)
    
    if target==nil then
      return
    end
    
    unit:PreventDI(true)
    unit:SetAutoUnstuck(false)
    unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
    unit:FollowNavMesh(false)
    
    local distance = target:GetAbsOrigin() - unit:GetAbsOrigin()
    local direction = target:GetAbsOrigin() - unit:GetAbsOrigin()
    direction = direction:Normalized()
    unit:SetPhysicsFriction(0)
    
    local gravity = 1
    local velocity = 1000
    local timetotarget = distance:Length() / velocity
    local jump = gravity * (timetotarget) * -1
    --jump = jump/2
    
    unit:SetPhysicsVelocity(direction * velocity)
    
    unit:AddPhysicsAcceleration(Vector(0,0,gravity))
    unit:AddPhysicsVelocity(Vector(0,0,jump))
    
    Timers:CreateTimer(math.min(timetotarget, .5),
    function()
      local groundpos = GetGroundPosition(unit:GetAbsOrigin(), unit)
      if unit:GetAbsOrigin().z - groundpos.z <= 20 then
          unit:SetPhysicsAcceleration(Vector(0,0,0))
          unit:SetPhysicsVelocity(Vector(0,0,0))
          unit:OnPhysicsFrame(nil)
          unit:PreventDI(false)
          unit:SetNavCollisionType(PHYSICS_NAV_SLIDE)
          unit:SetAutoUnstuck(true)
          unit:FollowNavMesh(true)
          unit:SetPhysicsFriction(.05)
          FindClearSpaceForUnit(unit, target:GetAbsOrigin(), true)

          -- Do the Damage and effects after the movement is completed
           -- The charged unit will suffer xxxx damage plus your Strength
            hero:MoveToTargetToAttack(target)
            ApplyDamage({
                victim = target,
                attacker = hero,
                damage = single_target_damage + spellPower,
                damage_type = DAMAGE_TYPE_MAGICAL
            })

            -- All nearby units will suffer xxxx damage plus half your Strength and will be dazed for up to 5 seconds. 
            -- Find enemies
            enemies = FindUnitsInRadius(event.caster:GetTeamNumber(),
                                  target:GetAbsOrigin(),
                                  nil,
                                  radius,
                                  DOTA_UNIT_TARGET_TEAM_ENEMY,
                                  DOTA_UNIT_TARGET_ALL,
                                  DOTA_UNIT_TARGET_FLAG_NONE,
                                  FIND_ANY_ORDER,
                                  false)

            -- Do damage in AoE
            for _,enemy in pairs(enemies) do
                if enemy ~= target then -- exclude the original target
                    ApplyDamage({
                        victim = enemy,
                        attacker = event.caster,
                        damage =  aoe_damage + spellPower,
                        damage_type = DAMAGE_TYPE_MAGICAL
                        })
                end
                -- While dazed, the affected units will have their movement and attack speed reduced by 50%.
                event.ability:ApplyDataDrivenModifier(hero, enemy, "modifier_charge_daze", {duration = daze_duration})
            end

            -- If used against a unit in melee range, the target will be forced to attack you for 4 seconds. 
            -- I'll ignore the unit in melee range stuff for now, feels like a pointless limitation.
            event.ability:ApplyDataDrivenModifier(hero, target, "modifier_spartan_taunt", {duration = taunt_duration})
          return nil
      end
      return 0.01
    end)
   
end

function taunt( event )
    local taunt_duration = event.ability:GetLevelSpecialValueFor("taunt_duration", (event.ability:GetLevel()-1))

    event.target:SetForceAttackTarget(event.caster)
   
    local particle = ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_immortal_dragon/dragon_knight_dragon_tail_dragonform_iron_dragon.vpcf", PATTACH_OVERHEAD_FOLLOW, event.target)
    ParticleManager:SetParticleControl(particle, 4, event.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 2, event.caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, event.caster:GetAbsOrigin())

    Timers:CreateTimer({
    endTime = 1,
    callback = function()
        local particle = ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_immortal_dragon/dragon_knight_dragon_tail_dragonform_iron_dragon.vpcf", PATTACH_OVERHEAD_FOLLOW, event.target)
        ParticleManager:SetParticleControl(particle, 4, event.target:GetAbsOrigin())
    end
    })

    Timers:CreateTimer({
    endTime = 2,
    callback = function()
        local particle = ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_immortal_dragon/dragon_knight_dragon_tail_dragonform_iron_dragon.vpcf", PATTACH_OVERHEAD_FOLLOW, event.target)
        ParticleManager:SetParticleControl(particle, 4, event.target:GetAbsOrigin())
    end
    })

   Timers:CreateTimer({
    endTime = 3,
    callback = function()
        local particle = ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_immortal_dragon/dragon_knight_dragon_tail_dragonform_iron_dragon.vpcf", PATTACH_OVERHEAD_FOLLOW, event.target)
        ParticleManager:SetParticleControl(particle, 4, event.target:GetAbsOrigin())
    end
    })

    Timers:CreateTimer({
    endTime = taunt_duration,
    callback = function()
      event.target:SetForceAttackTarget(nil)
    end
    })
end





-- I'll just keep here this for later
function SpinHero(keys)
    local caster = keys.caster
    local total_degrees = keys.Angle
    print("Spinning ", total_degrees, "degrees about center")
    caster:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,total_degrees,0), caster:GetForwardVector()))
end
-- Taken from https://github.com/Dli42/Dota_Hero_Script_Testing/blob/f9db344555adff7cf4d78f67e576be98a517cc3a/scripts/vscripts/custom_scripted_abilities.lua
-- many good stuff to learn from there