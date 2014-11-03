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

		--[[		"Target"				"POINT"
				"EffectName"			"particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
				"MoveSpeed"				"%shock_speed"
				"StartPosition"			"attach_attack1"
				"StartRadius"			"%shock_width"
				"EndRadius"				"%shock_width"
				"TargetTeams"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
				"TargetTypes"			"DOTA_UNIT_TARGET_CREEP | DOTA_UNIT_TARGET_HERO"
				//"TargetFlags"			"DOTA_UNIT_TARGET_FLAG_NONE"
				"HasFrontalCone"		"1"
				"ProvidesVision"		"1"
				"VisionRadius"			"300"]]
