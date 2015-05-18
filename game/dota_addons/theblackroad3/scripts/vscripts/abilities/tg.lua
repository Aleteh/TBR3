function giff_heal(event)
	event.target:EmitSound("Hero_Omniknight.Purification")
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1)) + event.caster.spellPower
	event.target:Heal( heal_amount , event.caster)
	PopupHealing(event.target, heal_amount)
end

function pray_toggle_on(event)
	local hero = event.caster
	local ability1 = hero:GetAbilityByIndex(0)
	local ability2 = hero:GetAbilityByIndex(1)
	local ability3 = hero:GetAbilityByIndex(2)
	local new_ability1 = hero:FindAbilityByName("pray_ares")
	local new_ability2 = hero:FindAbilityByName("pray_athena")
	local new_ability3 = hero:FindAbilityByName("pray_zeus")

	hero:SwapAbilities(ability1:GetName(), new_ability1:GetName(), false, true)
	hero:SwapAbilities(ability2:GetName(), new_ability2:GetName(), false, true)
	hero:SwapAbilities(ability3:GetName(), new_ability3:GetName(), false, true)

	local level = hero:FindAbilityByName("templeguardian_pray"):GetLevel()
	new_ability1:SetLevel(level)
	new_ability2:SetLevel(level)
	new_ability3:SetLevel(level)
end

function pray_toggle_off(event)
	local hero = event.caster
	local ability1 = hero:GetAbilityByIndex(0)
	local ability2 = hero:GetAbilityByIndex(1)
	local ability3 = hero:GetAbilityByIndex(2)
	local new_ability1 = hero:FindAbilityByName("templeguardian_gift_of_the_gods")
	local new_ability2 = hero:FindAbilityByName("templeguardian_mark_of_artemis")
	local new_ability3 = hero:FindAbilityByName("templeguardian_fire_of_apollo")

	hero:SwapAbilities(ability1:GetName(), new_ability1:GetName(), false, true)
	hero:SwapAbilities(ability2:GetName(), new_ability2:GetName(), false, true)
	hero:SwapAbilities(ability3:GetName(), new_ability3:GetName(), false, true)
end

function GiveAthenaBuff(event)
	local hero = event.caster
	local power =  event.ability:GetLevelSpecialValueFor("power_bonus_static", (event.ability:GetLevel()-1))
	local power_percent = 0.01 * event.ability:GetLevelSpecialValueFor("power_bonus_percent", (event.ability:GetLevel()-1))
	if hero:IsRealHero() then
		print("Applying Spell & Healing Power granted by Athena")
		-- store how much spell power is given, to know exactly how much to remove later after the buff expires
		hero.athenaSpellPower = ( hero.spellPower * power_percent ) + power
		hero.athenaHealingPower = ( hero.healingPower * power_percent ) + power

		hero.spellPower = hero.spellPower + hero.athenaSpellPower
		hero.healingPower = hero.healingPower + hero.athenaHealingPower
		print("Current Healing Power: " .. hero.healingPower)
		print("Current Spell Power: " .. hero.spellPower)
	end
end

-- OnDestroy 
function RemoveAthenaBuff(event)
	print("Removing Spell & Healing Power granted by Athena")
	local hero = event.caster
	if hero:IsRealHero() then
		print("-" .. hero.athenaSpellPower .. " Spell Power ".." and -"..hero.athenaHealingPower.." Healing Power")
		hero.spellPower = hero.spellPower - hero.athenaSpellPower
		hero.spellPower = hero.healingPower - hero.athenaHealingPower
		print("New Spell Power: " .. hero.spellPower)
		print("New Healing Power: " .. hero.healingPower)
	end
end

function zeus_fx( event )
	local target = event.target
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 1, event.target:GetAbsOrigin())
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", MAX_PATTACH_TYPES, target)
	ParticleManager:SetParticleControl(particle, 1, event.target:GetAbsOrigin())		
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 1, event.target:GetAbsOrigin())	
end

function fire_of_apollo( event )
	local targets = event.target_entities
	local hero = event.caster
	local spellPower = hero.spellPower
	local damage = event.ability:GetLevelSpecialValueFor("damage_base", (event.ability:GetLevel()-1))
	local multipler = event.ability:GetLevelSpecialValueFor("spell_power_multipler", (event.ability:GetLevel()-1))

	for _,enemy in pairs(targets) do
		ApplyDamage({
			victim = enemy,
			attacker = hero,
			damage = damage + (spellPower*multipler),
			damage_type = DAMAGE_TYPE_MAGICAL
			})
    end
end

function fire_of_apollo_dot( event )
	local hero = event.caster
	print(hero:GetUnitName())
	local target = event.target
	print(target:GetUnitName())
	local spellPower = hero.spellPower
	local duration = event.ability:GetDuration()
	local multiplier = event.ability:GetLevelSpecialValueFor("spell_power_multipler", (event.ability:GetLevel()-1))
	print(multiplier)
	local damage_tick = (event.ability:GetLevelSpecialValueFor("damage_over_time", (event.ability:GetLevel()-1)) + spellPower*multiplier) / duration
	--gets bonus of spellPower * multiplier split for the duration

	ApplyDamage({victim = target, attacker = hero, damage = damage_tick,	damage_type = DAMAGE_TYPE_MAGICAL })
end

function fire_apollo_fx( event )
	local particle = ParticleManager:CreateParticle("particles/fire_of_apollo.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.caster)
	ParticleManager:SetParticleControl(particle, 7, event.caster:GetAbsOrigin())

	EmitSoundOn("Hero_DoomBringer.ScorchedEarthAura", event.caster)
	-- 10 second delayed, run once using gametime (respect pauses)
	Timers:CreateTimer({
	    endTime = 11, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
	    callback = function()
	      StopSoundOn("Hero_DoomBringer.ScorchedEarthAura", event.caster)
	    end
	})
end

function hestias_touch( event )
	local attacker = event.attacker
	local unit = event.target
	local mana_transfer = event.ManaTransfer
	local mana_warrior = event.ManaWarrior
	print(mana_transfer,mana_warrior)

	if current_mana and current_mana > 0 then
		attacker:GiveMana(mana_transfer)
		unit:ReduceMana(mana_transfer)
		ApplyDamage({ victim = unit, attacker = attacker, damage = mana_transfer, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability	})
		--TODO implement mana_warrior
	end	

end