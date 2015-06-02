function ManaOnAttack( event )
	local hero = event.caster
	local level = hero:GetLevel()

	hero:GiveMana(0.02 * level + 2.5)
end

function counter( event )
	local damage = event.ability:GetAbilityDamage()
	local damage_type = event.ability:GetAbilityDamageType()
	for key, unit in pairs(event.target_entities) do
		ApplyDamage({victim = unit, attacker = event.caster, damage = damage, damage_type = damage_type, ability = event.ability})
	end
end

function impale( event )
	if event.ability:IsCooldownReady() == true then
		event.ability:ApplyDataDrivenModifier( event.caster, event.caster, "warlord_impale_animation", nil)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
		ParticleManager:SetParticleControl(particle, 4, event.target:GetAbsOrigin()) --location
		ParticleManager:SetParticleControlEnt(particle, 1, event.target, 0, "attach_hitloc", event.target:GetAbsOrigin(), false)
		
		event.ability:PayManaCost()
		event.ability:StartCooldown(event.ability:GetCooldown(1))
		ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
		ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.caster:GetAgility() * 6) , damage_type = DAMAGE_TYPE_MAGICAL , ability = event.ability	})
	end
end


------------------
-- Winds of War --
------------------

function WhirlwindMoveToPoint( event )
	local caster = event.caster
	local caster_location = caster:GetAbsOrigin() 
	local target_point = event.target_points[1]
	local ability = event.ability

	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1)) * 0.03
	local distance = (target_point - caster_location):Length2D()
	local direction = (target_point - caster_location):Normalized()
	local traveled_distance = 0

	-- Move the caster towards the point every frame
	-- ToDo: change to use physics for grid nav
	Timers:CreateTimer(function()
		if traveled_distance < distance then
			caster_location = caster_location + direction * speed
			caster:SetAbsOrigin(caster_location)
			traveled_distance = traveled_distance + speed
			return 0.03
		else
			caster:RemoveModifierByName("modifier_whirlwind")
			caster:RemoveModifierByName("modifier_whirlwind_spin")
		end
	end)
end

function WhirlwindStop( event )
	local caster = event.caster
	
	caster:StopSound("Hero_Juggernaut.BladeFuryStart")
end

---

function winds_of_war_anti_stuck( event )
	FindClearSpaceForUnit(event.target, event.target:GetAbsOrigin(), true)
end


function bleed( event )
	event.ability:ApplyDataDrivenModifier( event.caster, event.target, "warlord_bleed_bleed_modifier", nil)
end

function bleed_bleed( event )
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.caster:GetAgility() + event.ability:GetAbilityDamage()), damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
end

function bum_rush( event )
	
	Timers:CreateTimer({
	    endTime = 0.5,
	    callback = function()
	    	FindClearSpaceForUnit(event.caster, event.target:GetAbsOrigin(), true)

	    	if event.target:IsHero() == true then
				event.ability:ApplyDataDrivenModifier( event.caster, event.target, "warlord_bum_rush_disarm", {duration = 3})
				ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.ability:GetAbilityDamage() + event.caster:GetAgility()), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
			else
				event.ability:ApplyDataDrivenModifier( event.caster, event.target, "warlord_bum_rush_disarm", {duration = 5})
				ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.ability:GetAbilityDamage() + event.caster:GetAgility()), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
			end

			local aoe_damage = (event.ability:GetAbilityDamage() + event.caster:GetAgility()) / 3

			for key, unit in pairs(event.target_entities) do 
				if unit:IsHero() == true then
					event.ability:ApplyDataDrivenModifier( event.caster, unit, "warlord_bum_rush_haze", {duration = 6})
				else
					event.ability:ApplyDataDrivenModifier( event.caster, unit, "warlord_bum_rush_haze", {duration = 12})
				end

				ApplyDamage({ victim = unit, attacker = event.caster, damage = aoe_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
			end

	    end
	    -- TODO: add a landing animation fx
	})

end


function bum_rush_deosoriantation( event )

	local vector = event.target:GetAbsOrigin() + RandomVector(600)

	event.target:MoveToPosition(vector)

end