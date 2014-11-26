-- OnEquip an item with Spell Power
function GiveSpellPower(event)
	--DeepPrintTable(event)
	local hero = event.caster
	if hero:IsRealHero() then
		print("+" .. event.BonusPower .. " Spell Power")
		hero.spellPower = hero.spellPower + event.BonusPower
		print("Current Spell Power: " .. hero.spellPower)
	end
end

-- OnDestroy 
function RemoveSpellPower(event)
	--DeepPrintTable(event)
	local hero = event.caster
	if hero:IsRealHero() then
		print("-" .. event.BonusPower .. " Spell Power")
		hero.spellPower = hero.spellPower - event.BonusPower
		print("New Spell Power: " .. hero.spellPower)
	end
end

function GiveHealingPower(event)
	--DeepPrintTable(event)
	local hero = event.caster
	if hero:IsRealHero() then
		print("+" .. event.BonusPower .. " Healing Power")
		hero.healingPower = hero.healingPower + event.BonusPower
		print("Current Healing Power: " .. hero.healingPower)
	end
end

function RemoveHealingPower(event)
	--DeepPrintTable(event)
	local hero = event.caster
	if hero:IsRealHero() then
		print("+" .. event.BonusPower .. " Healing Power")
		hero.healingPower = hero.healingPower - event.BonusPower
		print("Current Healing Power: " .. hero.healingPower)
	end
end



-- Item Functions

function AresLifesteal(event)
	-- Regenerate .33% of your maximum life total. 

	local hero = event.caster
	local heroHP = hero:GetMaxHealth()
	local lifesteal_total = event.ability:GetSpecialValueFor("lifesteal_total")
	local health_recovered = heroHP * lifesteal_total * 0.01

	hero:Heal(health_recovered, hero)
	PopupHealing(hero, math.floor(health_recovered))
end

function HeliosMeteors(event)

	-- Copy of Magician Spell
	-- TODO: Improve and make it more unique
	local point = event.target_points[1]
	local caster = event.caster

	local aoe = event.ability:GetSpecialValueFor("radius")
	local min_damage = event.ability:GetSpecialValueFor("meteor_min_damage")
	local max_damage = event.ability:GetSpecialValueFor("meteor_max_damage")
	local spellPower = event.caster.spellPower
	local damage = RandomInt(max_damage,min_damage) + spellPower
	
 	print("Creating meteor particle")
    local dummy = CreateUnitByName("dummy_unit", caster:GetOrigin(), false, caster, caster, caster:GetTeam())
    dummy:AddAbility("magician_meteor_shower_proxy")
    local ability = dummy:FindAbilityByName("magician_meteor_shower_proxy")
    ability:SetLevel(1)

    Timers:CreateTimer({
		endTime = 0.05,
		callback = function()
			local dir = (event.target_points[1] - caster:GetAbsOrigin()):Normalized()
			local dist = dir * 10

			local position = point + dist
			dummy:CastAbilityOnPosition(position, ability, -1)
		end
		})

    Timers:CreateTimer({
		endTime = 1.5,
		callback = function()
			-- Do damage on the impact
   			enemies = FindUnitsInRadius(caster:GetTeamNumber(), point,  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			end
		end
	})

    for i=0.5,2,0.5 do
    	local dir = (event.target_points[1] - caster:GetAbsOrigin()):Normalized()
		local dist = dir * i * 400
		local position = point + dist

		Timers:CreateTimer({
		endTime = i,
		callback = function()
			dummy:CastAbilityOnPosition(position, ability, -1)
		end
		})

		Timers:CreateTimer({
		endTime = 1.5+i,
		callback = function()
			-- Do damage on the impact position
   			enemies = FindUnitsInRadius(caster:GetTeamNumber(), position,  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
			end
		end
		})
	end

    Timers:CreateTimer({
		endTime = 10,
		callback = function()
			dummy:RemoveSelf()
			print("Removed meteor dummy")
		end
	})

end

function HephaestusRegen( event )
	-- Regenerates .66% of your maximum life total
	local hero = event.caster
	local liferegen_total = event.ability:GetSpecialValueFor("liferegen_total") * 0.01

	-- ==================================
	-- Adjust health regen on health
	-- ==================================

	-- Get player health
	local health = hero:GetMaxHealth() --8400 * 0.0066 = 55 regen

	--Check if healthRegenBonus is stored on hero, if not set it to 0
	if hero.healthRegenBonus == nil then
		hero.healthRegenBonus = 0
	end

	-- If player health is different this time around, start the adjustment
	if health ~= hero.healthRegenBonus then
		-- Modifier values
		local bitTable = {1024,512,256,128,64,32,16,8,4,2,1}

		-- Gets the list of modifiers on the hero and loops through removing any healthregen modifier
		local modCount = hero:GetModifierCount()
		for i = 0, modCount do
			for u = 1, #bitTable do
				local val = bitTable[u]
				if hero:GetModifierNameByIndex(i) == "modifier_healthregen_mod_" .. val  then
					hero:RemoveModifierByName("modifier_healthregen_mod_" .. val)
				end
			end
		end

		health = health * liferegen_total
		print("HealthRegen .66%: "..health)

		-- Creates temporary item to steal the modifiers from
		local healthUpdater = CreateItem("item_healthregen_modifier", nil, nil) 
		for p=1, #bitTable do
			local val = bitTable[p]
			local count = math.floor(health / val)
			if count >= 1 then
				healthUpdater:ApplyDataDrivenModifier(hero, hero, "modifier_healthregen_mod_" .. val, {})
				health = health - val
			end
		end
		-- Cleanup
		UTIL_RemoveImmediate(healthUpdater)
		healthUpdater = nil
	end
	-- Updates the stored health bonus value for next timer cycle
	hero.healthRegenBonus = hero:GetMaxHealth()

end

function DestroyHephaestusRegen( event )
	-- Remove the health regen
	local hero = event.caster

	-- Modifier values
	local bitTable = {1024,512,256,128,64,32,16,8,4,2,1}

	-- Gets the list of modifiers on the hero and loops through removing any healthregen modifier
	local modCount = hero:GetModifierCount()
	for i = 0, modCount do
		for u = 1, #bitTable do
			local val = bitTable[u]
			if hero:GetModifierNameByIndex(i) == "modifier_healthregen_mod_" .. val  then
				hero:RemoveModifierByName("modifier_healthregen_mod_" .. val)
				print("Removing modifier_healthregen_mod_" .. val)
			end
		end
	end	
end

function HephaestusRespawn( event )
	-- Revived with full hit points and mana
    print("Respawning")
    local ability = event.ability
	local hero = event.caster

	if ability:IsCooldownReady() then
    	Timers:CreateTimer(.01, function()
    		local grave = hero.grave
			--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_ABSORIGIN_FOLLOW, grave)
			local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, grave)
			ParticleManager:SetParticleControl(particle, 0, grave:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(3,0,0))
			ParticleManager:SetParticleControl(particle, 2, Vector(1,0,0))
			--ParticleManager:SetParticleControl(particle, 3, Vector(1,0,0))
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, grave)
			ParticleManager:SetParticleControl(particle, 0, grave:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 3, grave:GetAbsOrigin())
	    	hero:SetTimeUntilRespawn(3)
	    	hero:SetRespawnPosition(grave:GetOrigin())
			ability:StartCooldown(ability:GetCooldownTimeRemaining())
		end)
    end    
end