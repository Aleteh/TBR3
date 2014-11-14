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