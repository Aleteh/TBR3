function earth_shock( event )
    point = event.target_points[1]
    caster = event.caster
    ability = event.ability

    local info = {
        EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
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

    local speed = event.ability:GetLevelSpecialValueFor("shock_speed", (event.ability:GetLevel() - 1))

    point.z = 0
    local pos = caster:GetAbsOrigin()
    pos.z = 0
    local diff = point - pos
    info.vVelocity = diff:Normalized() * speed

    ProjectileManager:CreateLinearProjectile( info )
end

function DoTremorDamage (event)
    local target = event.target
    local hero = event.caster
    local damage = event.Damage
    local spellPower = hero.spellPower
    local half_damage = (damage+spellPower)/2

    -- find enemies in 500 aoe
    enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), event.caster:GetAbsOrigin(),  nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY,
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

    -- find enemies in 250 aoe
    enemies2 = FindUnitsInRadius(event.caster:GetTeamNumber(), event.caster:GetAbsOrigin(),  nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    -- Do another half damage
    for _,enemy in pairs(enemies2) do
        print("Damageing on 250")
      ApplyDamage({
        victim = enemy,
        attacker = hero,
        damage = half_damage,
        damage_type = DAMAGE_TYPE_MAGICAL
        })
    end
end
