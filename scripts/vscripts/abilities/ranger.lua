
function black_arrow( event )
	
	if event.ability:IsCooldownReady() == true then
		event.ability:PayManaCost()
		event.ability:StartCooldown(event.ability:GetCooldown(1))
		ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
		if event.target:IsAlive() == false then
			local group = FindUnitsInRadius( event.caster:GetTeamNumber(), event.target:GetAbsOrigin(), nil, event.ability:GetSpecialValueFor("explosion_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for key, unit in pairs(group) do
				ApplyDamage({ victim = unit, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
			end
		else
			event.ability:ApplyDataDrivenModifier( event.caster, event.target, "ranger_black_arrow_post_damage", nil)
		end
	end
end

function black_arrow_post_damage( event )
	if event.attacker == event.caster then
		if event.unit:IsAlive() == false then
				local group = FindUnitsInRadius( event.caster:GetTeamNumber(), event.unit:GetAbsOrigin(), nil, event.ability:GetSpecialValueFor("explosion_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for key, unit in pairs(group) do
					ApplyDamage({ victim = unit, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
				end
		end
		event.unit:RemoveModifierByName("ranger_black_arrow_post_damage")
	end

end

function stun_shot( event )
	
end

function puncture( event )
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.ability:GetAbilityDamage() + event.caster.spellPower), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
	event.ability:ApplyDataDrivenModifier( event.caster, event.target, "ranger_puncture_bleed_modifier", nil)
end


function puncture_bleed( event )
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.caster:GetAgility() + event.ability:GetAbilityDamage() * 0.75 ), damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
end

function star_dust( event )
	event.ability:ApplyDataDrivenModifier( event.caster, event.target, "ranger_star_dust_modifier", nil)
end

function star_dust_heal( event )
	local group = FindUnitsInRadius( event.caster:GetTeamNumber(), event.target:GetAbsOrigin(), nil, event.ability:GetSpecialValueFor("heal_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for key, unit in pairs(group) do
		unit:Heal((event.ability:GetAbilityDamage() / 3), event.caster)
	end
end

function soul_piercing_shot( event )
	local manaburn = event.ability:GetLevelSpecialValueFor("manaburn", (event.ability:GetLevel() - 1))

	event.target:ReduceMana(manaburn)
	event.caster:GiveMana(manaburn) 
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = manaburn, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
	if math.random(0,4) < 1 then 
		event.caster:PerformAttack(event.target, true, false, true, true)  
	end
end





