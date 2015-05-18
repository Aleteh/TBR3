function torment_cost( event )
	local self_dmg = event.ability:GetLevelSpecialValueFor("self_damage", (event.ability:GetLevel() - 1))
	ApplyDamage({ victim = event.caster, attacker = event.caster, damage = self_dmg, damage_type = DAMAGE_TYPE_HP_REMOVAL, ability = event.ability }) 
	--might want to use ModifyHealth if this damage can't be lethal. TODO: Check ingame
	PopupDamage(event.caster,self_dmg)
end

function torment( event )
	local hero = event.caster
	local target = event.target
	local spellPower = hero.spellPower
	local spell_multiplier = event.ability:GetSpecialValueFor("bonus_spell_dmg")
	local duration = event.ability:GetDuration()
	local dmg = ( event.ability:GetAbilityDamage() + ( spellPower * 0.01 * spell_multiplier ))  / duration

	ApplyDamage({ victim = target, attacker = hero, damage = dmg, damage_type = event.ability:GetAbilityDamageType(), ability = event.ability })
	PopupDamage(target,math.floor(dmg))
end

function drain_fx(event)
	local hero = event.caster
	local target = event.target

	--hero.drain_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_CUSTOMORIGIN, hero)
	--<BMD> the gist is it's (particleID, CP, entity, dont_remember, attach_type, initial point, dont_remember)
	--ParticleManager:SetParticleControlEnt(hero.drain_particle, 0, hero, 1, "attach_hitloc", hero:GetAbsOrigin(), true)
  	--ParticleManager:SetParticleControlEnt(hero.drain_particle, 1, target, 1, "attach_mouth", target:GetAbsOrigin(), true)
    --ParticleManager:SetParticleControl(hero.drain_particle, 10, Vector(1,0,0)) --use green
    --ParticleManager:SetParticleControl(hero.drain_particle, 11, Vector(0,0,0)) --use blue, false

end

function destroy_drain_fx(event)
	local hero = event.caster
	ParticleManager:DestroyParticle(hero.drain_particle,false)
end

function soul_drain(event)
	local hero = event.caster
	local target = event.target
	local spellPower = hero.spellPower
	local drain = event.ability:GetAbilityDamage() + spellPower

	ApplyDamage({ victim = target, attacker = hero, damage = drain, damage_type = event.ability:GetAbilityDamageType(), ability = event.ability })
	print("drained ",drain," from ",target:GetUnitName())
	hero:Heal( drain, hero )
	PopupHealing( hero, drain )

end

function soul_drain_aoe( event )
	local target = event.target
	local hero = event.caster
	local spellPower = hero.spellPower
	local spell_multiplier = event.ability:GetSpecialValueFor("bonus_spell_dmg")
	local dmg = spellPower * 0.01 * spell_multiplier
	local aoe = event.ability:GetSpecialValueFor("aoe")

	-- find enemies nearby
	enemies = FindUnitsInRadius(hero:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- do damage
	for _,enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = hero, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL })
    end
end

function deathwave_cost( event )
	local self_dmg = event.ability:GetLevelSpecialValueFor("self_damage", (event.ability:GetLevel() - 1))
	ApplyDamage({ victim = event.caster, attacker = event.caster, damage = self_dmg, damage_type = DAMAGE_TYPE_HP_REMOVAL, ability = event.ability }) 
	--might want to use ModifyHealth if this damage can't be lethal. TODO: Check ingame
	PopupDamage(event.caster,self_dmg)
end

function deathwave( event )
	point = event.target_points[1]
    caster = event.caster
    ability = event.ability

    local info = {
        EffectName =  "particles/econ/items/death_prophet/death_prophet_acherontia/death_prophet_acher_swarm.vpcf",
        Ability = ability,
        vSpawnOrigin = point,
        fDistance = 1250,
        fStartRadius = 150,
        fEndRadius = 150,
        Source = caster,
        bHasFrontalCone = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
        --fMaxSpeed = 5200,
        bReplaceExisting = false,
        fExpireTime = GameRules:GetGameTime() + 4.0,
        bDeleteOnHit = false,
		vVelocity = 0.0, --vVelocity = caster:GetForwardVector() * 1800,
		iMoveSpeed = 1000,
    }

    local speed = 1000

    point.z = 0
    local pos = caster:GetAbsOrigin()
    pos.z = 0
    local diff = point - pos
    info.vVelocity = diff:Normalized() * speed

    local explode_time = (diff:Length2D()/1000)-0.1
    print("Creating Deathwave in "..explode_time.. " seconds")

  	Timers:CreateTimer({
    endTime = explode_time,
    callback = function()
      	--Creates the projectiles in 360 degrees
      	EmitSoundOn("Hero_DeathProphet.CarrionSwarm.Mortis", caster)
		for i=-180,180,(360/10) do
			info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * info.iMoveSpeed
			projectile = ProjectileManager:CreateLinearProjectile( info )
		end
    end
  	})
    
end

function deathwave_dmg( event )
	local hero = event.caster
	local target = event.target
	local spellPower = hero.spellPower
	local dmg = event.ability:GetAbilityDamage() + spellPower

	ApplyDamage({ victim = target, attacker = hero, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL })
end

function vengeance( event )
	local hero = event.caster
	local target = event.target
	local spellPower = hero.spellPower
	local dmg = event.ability:GetAbilityDamage() + spellPower

	ApplyDamage({ victim = target, attacker = hero, damage = dmg, damage_type = DAMAGE_TYPE_MAGICAL })

	local self_dmg = event.ability:GetLevelSpecialValueFor("self_damage", (event.ability:GetLevel() - 1))
	ApplyDamage({ victim = event.caster, attacker = event.caster, damage = self_dmg, damage_type = DAMAGE_TYPE_HP_REMOVAL, ability = event.ability }) 
	--might want to use ModifyHealth if this damage can't be lethal. TODO: Check ingame
	PopupDamage(event.caster,self_dmg)
end

function blind( event )

	local max_duration = event.ability:GetLevelSpecialValueFor("blind_max_duration", (event.ability:GetLevel() - 1))
	local random_duration = RandomFloat(1, max_duration)
	event.ability:ApplyDataDrivenModifier( event.caster, event.target, "blind_modifier", {duration = random_duration})

end

function blind_desorient( event )
	local vector = event.target:GetAbsOrigin() + RandomVector(600)
	event.target:MoveToPosition(vector)
end