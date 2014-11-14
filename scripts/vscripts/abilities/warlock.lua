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

	target.drain_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.drain_particle, 0, target:GetAbsOrigin()) --coordinates of the sucking
    ParticleManager:SetParticleControl(target.drain_particle, 1, Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z+100)) --where to suck to
    --ParticleManager:SetParticleControl(particle, 10, Vector(0,0,0))
    --ParticleManager:SetParticleControl(particle, 11, Vector(0,0,0))

end

function destroy_drain_fx(event)
	local target = event.target
	ParticleManager:DestroyParticle(target.drain_particle,false)
end