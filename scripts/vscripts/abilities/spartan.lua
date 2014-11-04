function dispatch ( event )
	print("Dispatching")

end

function spartan_throw( event ) -- not to be confused with 300, which was tactical feeding
	point = event.target_points[1]
	caster = event.caster
	ability = event.ability

  local info = {
    EffectName = "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf", --"particles/units/heroes/hero_huskar/huskar_base_attack.vpcf",
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