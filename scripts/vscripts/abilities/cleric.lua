function holy_light(event)
	event.target:EmitSound("Hero_Omniknight.Purification")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local heal_amount = event.ability:GetLevelSepcialValueFor("heal_amount", (event.ability:GetLevel()-1)) + event.caster.spellPower
	event.target:Heal( heal_amount, event.caster)
	PopupHealing(even.target, heal_amount)
end

function regen(event)
	local heal_amount = 1
end
