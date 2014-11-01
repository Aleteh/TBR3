function barbarian_leap( event )
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
	--[[
		<BMD> so you want a contsant xy velocity jump most likely
<BMD> so instead of using distance to set the Velocity, you pick a leap speed
<BMD> like 2000 or something
<BMD> or whattever, make it scale with levels who cares
<BMD> then you're going to calculate leap time by taking the distance / leap speed
<BMD> and use that for your timers
<Noya> that would make short leaps end faster, right
<BMD> yes
<BMD> then you decide if you want a constant gravity/curve
<BMD> for the jumop
<BMD> or a constant z height tehy always get to
<Noya> like in this code? http://hastebin.com/anolahazet.coffee
<BMD> for constant gravity, you just set a fixed -z acceleration
<BMD> yeah, i remember helping someone with that
<BMD> can't remember who for the life of me
<Noya> Jiziason linked it to me
<BMD> but that's a constant xy velocity jump
<BMD> with constant gravity curve
<BMD> so the farther away you jump, the higher you go
<BMD> since gravity is the same
<Jiziason> it's Lymbow's code
<BMD> Lymbow, that's the guy
<BMD> yeah i helped him put the rocketman jump stuff together
<tet> who the fuck is that
<Jiziason> lol
<BMD> granted you need to remove the 30*
<BMD> inb the gravity calculation
<BMD> the old version of the physics lib had an issue in it where it forced you to set the acceleration in hammer units per second per frame
<BMD> instead of hammer units per second squared
	]]

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