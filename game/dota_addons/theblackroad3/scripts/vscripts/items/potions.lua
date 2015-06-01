function RemoveRegeneration( event )
	local caster = event.caster
	caster:RemoveModifierByName("modifier_potion_of_lesser_regeneration")
	caster:RemoveModifierByName("modifier_potion_of_regeneration")
	caster:RemoveModifierByName("modifier_potion_of_greater_regeneration")
	caster:RemoveModifierByName("modifier_potion_of_super_regeneration")
	caster:RemoveModifierByName("modifier_potion_of_mega_regeneration")
	print("Removed Regeneration Buffs")
end