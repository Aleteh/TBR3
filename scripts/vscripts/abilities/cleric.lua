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
	local hero = event.caster
	local spellpower = hero.spellPower

	local aoe = event.ability:GetSpecialValueFor("radius")

	local damage = event.ability:GetAbilityDamage()
	local aoe_damage =  event.ability:GetLevelSpecialValueFor("aoe_damage", event.ability:GetLevel()-1)
	local slow_duration = event.ability:GetSpecialValueFor("slow_duration")

	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	--SendToConsole('Say Please Print Dawg Damage: '..damage.." and spellpower: "..spellpower.." and aoe_damage: "..aoe_damage) 

	ApplyDamage({ victim = target, attacker = hero, damage = damage + spellpower, damage_type = DAMAGE_TYPE_MAGICAL })

	for _,enemy in pairs(enemies) do
		--target:ApplyDataDrivenModifier(handle source, handle target, string modifier_name, handle modifierArgs)
		event.ability:ApplyDataDrivenModifier(hero, enemy, "fire_of_heaven_slow", nil)
        -- event.ability:ApplyDataDrivenModifier( hero, enemy, "mind_blast_modifier", {duration = daze_duration})
        ApplyDamage({ victim = enemy, attacker = hero, damage = aoe_damage + spellpower * 3 / 4, damage_type = DAMAGE_TYPE_MAGICAL })    
    end
end

function cleansing_flame(event)
	local target = event.target
	local hero = event.caster
	local spellpower = hero.spellPower
	local healpower = hero.healingPower

	local aoe = event.ability:GetSpecialValueFor("aoe")
	local damage = event.ability:GetLevelSpecialValueFor("damage", event.ability:GetLevel()-1) + spellpower
	local heal = event.ability:GetLevelSpecialValueFor("damage", event.ability:GetLevel()-1) + healpower

	enemies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	allies = FindUnitsInRadius(event.caster:GetTeamNumber(), target:GetAbsOrigin(),  nil, aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = hero, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL }) 
	end
	for _,ally in pairs(allies) do
		ally:Heal(heal, hero)
		PopupHealing(ally, heal)
	end
end