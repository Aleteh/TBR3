function giff_heal(event)
	event.target:EmitSound("Hero_Omniknight.Purification")
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1)) + event.caster.spellPower
	event.target:Heal( heal_amount , event.caster)
	PopupHealing(event.target, heal_amount)
end

					-- handle, 2 ability handles, 2 booleans
function SwapAbilities(unit, ability1, ability2, enable1, enable2)
	--swaps ability and ability2, disables 1 and enables 2
	print("swapping ".. ability1:GetName() .. " with ".. ability2:GetName())
	unit:SwapAbilities(ability1:GetName(), ability2:GetName(), enable1, enable2)
	ability1:SetHidden(enable2)
	ability2:SetHidden(enable1)

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
	local power_percent = 0.1 * event.ability:GetLevelSpecialValueFor("power_bonus_percent", (event.ability:GetLevel()-1))
	if hero:IsRealHero() then

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