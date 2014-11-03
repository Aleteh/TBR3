function taunt( event )
	event.target:SetForceAttackTarget(event.caster)
	
--[[
	<BMD> you can issue an attack order
	<BMD> and set MODIFIER_STATE_COMMAND_RESTRICTED via a modifier
	<BMD> then remove it when the taunt it done]]

	-- 8 second delayed, run once using gametime (respect pauses)
  	Timers:CreateTimer({
    endTime = 8,
    callback = function()
      event.target:SetForceAttackTarget(nil)
    end
  	})

end

function leap( event )
	print("Starting Leap")
	local point = event.target_points[1]
	local unit = event.caster
	Physics:Unit(unit)
	unit:SetPhysicsFriction(0)
	unit:PreventDI(true)
	--unit:FollowNavMesh(false)
	--unit:SetAutoUnstuck(false)
	--unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)

	-- check http://hastebin.com/anolahazet.coffee

	local distance = VectorDistance(event.caster:GetAbsOrigin(), event.target_points[1])
	print("Distance " .. distance)
	
	unit:SetPhysicsVelocity(unit:GetForwardVector() * distance*2)
	unit:SetPhysicsAcceleration(Vector(0,0,-(distance*10)))
	
	unit:AddPhysicsVelocity(Vector(0,0,distance*2))

	Timers:CreateTimer(.5, function() 
			unit:SetPhysicsVelocity(Vector(0,0,0)); 
			unit:PreventDI(false);		
	end)
	
	Timers:CreateTimer(.6, function() 
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_WORLDORIGIN, event.caster)
			ParticleManager:SetParticleControl(particle, 0, event.caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(225,225,225))

			-- Find enemies
    		enemies = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              event.caster:GetAbsOrigin(),
                              nil,
                              225,
                              DOTA_UNIT_TARGET_TEAM_ENEMY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)

    		-- Do damage
    		for _,enemy in pairs(enemies) do
       			ApplyDamage({
						victim = enemy,
						attacker = unit,
						damage = ( event.caster:GetStrength() * 2 ) + event.ability:GetLevelSpecialValueFor("landing_damage", (event.ability:GetLevel()-1)),
						damage_type = DAMAGE_TYPE_MAGICAL
						})
       			-- Stun
       			event.ability:ApplyDataDrivenModifier(event.caster, enemy, "modifier_mighty_leap_stun", nil)
    		end

	end)

end


function cleave ( event )
	local radius = event.ability:GetLevelSpecialValueFor("radius", (event.ability:GetLevel()-1))
	local single_target_damage = event.ability:GetLevelSpecialValueFor("damage", (event.ability:GetLevel()-1))
	local aoe_damage = event.ability:GetLevelSpecialValueFor("aoe_damage", (event.ability:GetLevel()-1))

	-- Adds four times your Strength plus xxxx bonus damage to your next attack against a single target
	local target = event.target
		ApplyDamage({
				victim = target,
				attacker = event.caster,
				damage = ( event.caster:GetStrength() * 4 ) + damage,
				damage_type = DAMAGE_TYPE_PHYSICAL
				})

	-- causes three times your Strength plus xxxx damage to nearby enemy units for xx mana. 
	-- Find enemies
	enemies = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                      event.caster:GetAbsOrigin(),
                      nil,
                      radius,
                      DOTA_UNIT_TARGET_TEAM_ENEMY,
                      DOTA_UNIT_TARGET_ALL,
                      DOTA_UNIT_TARGET_FLAG_NONE,
                      FIND_ANY_ORDER,
                      false)

	-- Do damage in AoE
	for _,enemy in pairs(enemies) do
		if enemy ~= target then -- exclude the original target
			ApplyDamage({
				victim = enemy,
				attacker = unit,
				damage = ( event.caster:GetStrength() * 3 ) + aoe_damage,
				damage_type = DAMAGE_TYPE_MAGICAL
				})
		end
    end

    --TODO: Add Cleave Particle effect

end 



function bloodbath ( event )
	-- Dealing twice your Strength plus xxxx damage to a target enemy unit
 	local damage_done = ( event.caster:GetStrength() * 2 ) + event.ability:GetLevelSpecialValueFor("damage", (event.ability:GetLevel()-1))

 	ApplyDamage({
				victim = event.target,
				attacker = event.caster,
				damage = damage_done,
				damage_type = DAMAGE_TYPE_MAGICAL
				})

 	-- All damage dealt in this way will be added to your health. 
	event.caster:Heal(damage_done, event.ability) 

	--TODO: Popup for Heal, Particle, Axe sound.

end