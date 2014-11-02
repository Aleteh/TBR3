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