function giff_heal(event)
	event.target:EmitSound("Hero_Omniknight.Purification")
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1)) + event.caster.spellPower
	event.target:Heal( heal_amount , event.caster)
	PopupHealing(event.target, heal_amount)
end