function SwapAbilities( keys )
	print('SwapAbilities')

	ability1 = keys.caster:GetAbilityByIndex(0):GetAbilityName()
	ability2 = keys.caster:GetAbilityByIndex(6):GetAbilityName()
	keys.caster:SwapAbilities(ability1, ability2, true, true)

	ability1 = keys.caster:GetAbilityByIndex(1):GetAbilityName()
	ability2 = keys.caster:GetAbilityByIndex(7):GetAbilityName()
	keys.caster:SwapAbilities(ability1, ability2, true, true)

	ability1 = keys.caster:GetAbilityByIndex(2):GetAbilityName()
	ability2 = keys.caster:GetAbilityByIndex(8):GetAbilityName()
	keys.caster:SwapAbilities(ability1, ability2, true, true)

	ability1 = keys.caster:GetAbilityByIndex(3):GetAbilityName()
	ability2 = keys.caster:GetAbilityByIndex(9):GetAbilityName()
	keys.caster:SwapAbilities(ability1, ability2, true, true)

	ability1 = keys.caster:GetAbilityByIndex(4):GetAbilityName()
	ability2 = keys.caster:GetAbilityByIndex(10):GetAbilityName()
	keys.caster:SwapAbilities(ability1, ability2, true, true)

	ability1 = keys.caster:GetAbilityByIndex(5):GetAbilityName()
	ability2 = keys.caster:GetAbilityByIndex(11):GetAbilityName()
	keys.caster:SwapAbilities(ability1, ability2, true, true)
end

function IncreaseStat( keys )
	print("IncreaseStat")
	hero = keys.caster
	stat = keys.Stat

	if hero:GetAbilityPoints() > 0 then
		if stat == 'str' then
			hero:ModifyStrength(1)

		end

		if stat == 'agi' then
			hero:ModifyAgility(1)

		end

		if stat == 'int' then
			hero:ModifyIntellect(1)
		end

		hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
	end

end
