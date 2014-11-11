function counter( event )
	local damage = event.ability:GetAbilityDamage()
	local damage_type = event.ability:GetAbilityDamageType()
	for key, unit in pairs(event.target_entities) do
		ApplyDamage({victim = unit, attacker = event.caster, damage = damage, damage_type = damage_type, ability = event.ability})
	end
end

function impale( event )
	if event.ability:IsCooldownReady() == true then
		event.ability:PayManaCost()
		event.ability:StartCooldown(event.ability:GetCooldown(1))
		ApplyDamage({ victim = event.target, attacker = event.caster, damage = event.ability:GetAbilityDamage(), damage_type = event.ability:GetAbilityDamageType(), ability = event.ability	})
		ApplyDamage({ victim = event.target, attacker = event.caster, damage = (event.caster:GetAgility() * 6) , damage_type = DAMAGE_TYPE_MAGICAL , ability = event.ability	})
	end
end

function winds_of_war( event )
	event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "warlord_winds_of_war_modifier", nil) 
	local point = event.ability:GetCursorPosition()
	local caster_point = event.caster:GetAbsOrigin()
	local vector_between = (point - caster_point)
	local hypotenyse = (vector_between.x ^ 2 + vector_between.y ^ 2) ^ 0.5
	event.ability.x_of_movement = caster_point.x
	event.ability.y_of_movement = caster_point.y
	event.ability.sin = vector_between.y / hypotenyse
	event.ability.cos = vector_between.x / hypotenyse
	event.ability.damaged_group = nil
	event.ability.damaged_group = {}
	--event.caster:SetAbsOrigin(GetGroundPosition(Vector(caster_point.x + cos * 400, caster_point.y + sin * 400, 0), event.caster))

	event.caster:SetContextThink("winds_of_war_animation", 
	function ()
		if event.caster:HasModifier("warlord_winds_of_war_modifier") == true then
			event.caster:RemoveModifierByName("warlord_winds_of_war_animation")
			event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "warlord_winds_of_war_animation", nil)

			return  0.4
		else
			event.caster:RemoveModifierByName("warlord_winds_of_war_animation")
			return nil
		end
	end
	, 0)
end

function SpinHero(keys)
    local caster = keys.caster
    local total_degrees = keys.Angle
    print("Spinning ", total_degrees, "degrees about center")
    caster:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,total_degrees,0), caster:GetForwardVector()))
end

function winds_of_war_think( event )
	local caster_point = event.caster:GetAbsOrigin()
	local next_x = event.ability.x_of_movement + event.ability.cos * 15
	local next_y = event.ability.y_of_movement + event.ability.sin * 15
	local next_point = GetGroundPosition(Vector(next_x, next_y, 0), event.caster)

	--FindClearSpaceForUnit(event.caster, next_point, true) 
	event.caster:SetAbsOrigin(next_point)

	event.ability.x_of_movement = next_x
	event.ability.y_of_movement = next_y

	local group = FindUnitsInRadius( event.caster:GetTeamNumber(), event.caster:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local caster_team = event.caster:GetTeamNumber()
	local caster_agility = event.caster:GetAgility() 
	local spell_damage = event.ability:GetAbilityDamage()
	local damage_type = event.ability:GetAbilityDamageType()



	for key,unit in pairs(group) do
		if unit ~= event.caster then
			local unit_point = unit:GetAbsOrigin()
			local push_point = (unit_point - caster_point):Normalized() * 25 + unit_point

			--FindClearSpaceForUnit(unit, push_point, true)
			unit:SetAbsOrigin(push_point)

			if unit:GetTeamNumber() ~= caster_team then
				if unit:HasModifier("warlord_winds_of_war_damaged_modifier") == false then
					ApplyDamage({ victim = unit, attacker = event.caster, damage = (spell_damage + caster_agility), damage_type = damage_type, ability = event.ability	})
					event.ability:ApplyDataDrivenModifier(event.caster, unit, "warlord_winds_of_war_damaged_modifier", nil)
				end
			end

		end
	end
end


function winds_of_war_anti_stuck( event )
	FindClearSpaceForUnit(event.target, event.target:GetAbsOrigin(), true)
end

function winds_of_war_anti_stuck_b(event )
	FindClearSpaceForUnit(event.target, event.target:GetAbsOrigin(), true)

end