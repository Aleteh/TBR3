function holy_light(event)
	event.target:EmitSound("Hero_Omniknight.Purification")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1)) + event.caster.spellPower
	event.target:Heal( heal_amount, event.caster)
	PopupHealing(event.target, heal_amount)
end

function regen(event)
	local heal_amount = (event.caster.healingPower + event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel1()-1))) / event.ability:GetSpecialValueFor("duration")
	event.target:Heal(heal_amount, event.caster)
	Popuphealing(event.target, heal_amount)
end