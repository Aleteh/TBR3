--dota_launch_custom_game blackroad test_env

print("Assassin's abilities are loading")

function walk_the_shadows_cast( event )
		event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "assassin_walk_the_shadows_buff", nil)
		event.caster:AddNewModifier(event.caster, event.ability, "modifier_invisible", {duration = 25}) 
		
end

function walk_the_shadows_interrupt( event )
	event.caster:RemoveModifierByName("assassin_walk_the_shadows_buff")
	event.caster:RemoveModifierByName("modifier_invisible")
end

function walk_the_shadows_attack( event )
	
	event.caster:RemoveModifierByName("assassin_walk_the_shadows_buff")
	
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
end


function disable ( event )
	if event.target:IsHero() == true then
		event.ability:ApplyDataDrivenModifier( event.caster, event.target, "assassin_disable_debuff", {duration = 3.5})
	else
		event.ability:ApplyDataDrivenModifier( event.caster, event.target, "assassin_disable_debuff", {duration = 8})
	end
end


function assassinate( event )
	if event.ability:IsCooldownReady() == true then
		event.ability:PayManaCost()
		event.ability:StartCooldown(event.ability:GetCooldown(1))
		ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
		if event.target:HasModifier("assassin_disable_debuff") == true then
			ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.caster:GetAgility() * 3 + event.ability:GetLevelSpecialValueFor("bonus_disabled_target", (event.ability:GetLevel() - 1)) ), damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
		end	
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_hit.vpcf", PATTACH_ROOTBONE_FOLLOW, event.target)
		ParticleManager:SetParticleControl(particle, 3, event.target:GetAbsOrigin())

		EmitSoundOn("Hero_BountyHunter.Jinada", event.target)
	end
end


function garrote( event )
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})	
	if event.target:IsHero() == true then
		event.ability:ApplyDataDrivenModifier( event.caster, event.target, "assassin_garrote_bleed_modifier", {duration = 8})
	else
		event.ability:ApplyDataDrivenModifier( event.caster, event.target, "assassin_garrote_bleed_modifier", {duration = 12})
	end
end

function garrote_bleed( event )
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.caster:GetAgility() + event.ability:GetAbilityDamage() * 0.6 ), damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
end


