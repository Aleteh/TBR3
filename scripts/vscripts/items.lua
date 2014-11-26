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