function holy_light(event)
	event.target:EmitSound("Hero_Omniknight.Purification")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local heal_amount = event.ability:GetLevelSpecialValueFor("heal_amount", event.ability:GetLevel()-1) + event.caster.healingPower
	event.target:Heal( heal_amount, event.caster)
	PopupHealing(event.target, heal_amount)
end

function regen(event)
	--event.target:EmitSound("Hero_Huskar.Inner_vitality")
	--local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
	local hero = event.caster
	local target = event.target
	local heal_power =  hero.healingPower + 0
	local heal_amount = (heal_power + event.ability:GetLevelSpecialValueFor("heal_amount", (event.ability:GetLevel()-1))) / event.ability:GetSpecialValueFor("duration")
	event.target:Heal(heal_amount, target)
	PopupHealing(event.target, heal_amount)
end

function fire_of_heaven(event)
	local target = event.target
	local hero = even.caster
	local idamage = event.Damage
	local spellpower = event.spellPower
	local tdamage = event.Damage + event.spellPower * 3 / 4
	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), event.target, nil, event.ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false) --[[Returns:table
	Finds the units in a given radius with the given flags. ( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )
	]]
	for _,enemy in pairs(enemies) do
		ApplyDamage({
        victim = enemy,
        attacker = hero,
        damage = tdamage,
		damage_type = DAMAGE_TYPE_MAGICAL
		})
	end	
end