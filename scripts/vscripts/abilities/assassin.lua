print("Assassin's abilities are loading")

function walk_the_shadows_cast( event )
		event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "assassin_walk_the_shadows_buff", nil)
		event.caster:AddNewModifier(event.caster, event.ability, "modifier_invisible", {duration = 25}) 
		
end

function walk_the_shadows_attack( event )
	
	event.caster:RemoveModifierByName("assassin_walk_the_shadows_buff")
	
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
end