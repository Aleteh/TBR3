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
    print("creating particle effect")
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