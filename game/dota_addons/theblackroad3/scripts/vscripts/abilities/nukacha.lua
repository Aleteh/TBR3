function NukachaLightning( event )
	local hero = event.caster
	local target = event.target
	local damage = event.ability:GetSpecialValueFor("ability_Damage")
	local bounces = event.ability:GetSpecialValueFor("bounces_count")
	local bounce_range = event.ability:GetSpecialValueFor("bounce_range")
	local decay = event.ability:GetSpecialValueFor("decay_per_jump") * 0.01
	local time = event.ability:GetSpecialValueFor("bounce_time")

	local lightningBolt = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, hero)
	ParticleManager:SetParticleControl(lightningBolt,0,Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z + hero:GetBoundingMaxs().z ))	
	ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))	
	--ParticleManager:SetParticleControlEnt(lightningBolt, 1, target, 1, "attach_hitloc", target:GetAbsOrigin(), true)

	EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)	
	ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	PopupDamage(target,math.floor(damage))

	local targetsStruck = {}
	target.struck_by_nukachas_lightning = true
	table.insert(targetsStruck,target)

	local dummy = nil
	local units = nil

	Timers:CreateTimer(DoUniqueString("nukacha_chain_lightning"), {
		endTime = time,
		callback = function()
	
			-- unit selection and counting
			-- dead flag is for the chain to not stop if the target is killed
			units = FindUnitsInRadius(hero:GetTeamNumber(), target:GetOrigin(), target, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, 
						DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, true)

			-- particle
			targetVec = target:GetAbsOrigin()
			targetVec.z = target:GetAbsOrigin().z + target:GetBoundingMaxs().z
			if dummy ~= nil then
				dummy:RemoveSelf()
			end
			dummy = CreateUnitByName("dummy_unit", targetVec, false, hero, hero, hero:GetTeam())

			-- select a target randomly from the table and deal damage. while loop makes sure the target doesn't select itself.		
			
			local possibleTargetsBounce = {}
			-- Add the 
			for _,v in pairs(units) do
				if not v.struck_by_nukachas_lightning then
					table.insert(possibleTargetsBounce,v)
				end
			end

			target = possibleTargetsBounce[math.random(1,#possibleTargetsBounce)]
			if target then
				target.struck_by_nukachas_lightning = true
				table.insert(targetsStruck,target)		
			else
				-- clear the struck table and end
				for _,v in pairs(targetsStruck) do
			    	v.struck_by_nukachas_lightning = false
			    	v = nil
			    end
				return
			end

			local lightningChain = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_WORLDORIGIN, dummy)
			ParticleManager:SetParticleControl(lightningChain,0,Vector(dummy:GetAbsOrigin().x,dummy:GetAbsOrigin().y,dummy:GetAbsOrigin().z + dummy:GetBoundingMaxs().z ))	
			
			-- damage and decay
			damage = damage - (damage*decay)
			ApplyDamage({ victim = target, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			PopupDamage(target,math.floor(damage))
			print(damage)

			-- play the sound
			EmitSoundOn("Hero_Zuus.ArcLightning.Target",target)

			-- make the particle shoot to the target
			ParticleManager:SetParticleControl(lightningChain,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
	
			-- decrement remaining spell bounces
			bounces = bounces - 1

			-- fire the timer again if spell bounces remain
			if bounces > 0 then
				return time
			end
		end
	})

	
	Timers:CreateTimer(0.6,function() 
		-- double check
		for _,v in pairs(targetsStruck) do
		   	v.struck_by_nukachas_lightning = false
		   	v = nil
		end
	end)

end