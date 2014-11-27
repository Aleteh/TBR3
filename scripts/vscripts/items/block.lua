function Block(keys)
	local caster = keys.caster
	local attacker = keys.attacker

	-- This is buggy, as it wont actually block the total damage done
	local damageIncoming = attacker:GetAverageTrueAttackDamage()

	-- This is also buggy, as it is post mitigation
	local damageDealt = keys.damage_dealt

	local damageBlocked = 10000
	local casterHealth = caster:GetHealth()

	print("Damage Dealt"..damageDealt)

	-- block the attack fully
	if damageBlocked > damageDealt then
		caster:Heal(damageDealt, caster)
		PopupDamageBlock(caster, math.floor(damageDealt))

	-- the damage dealt is more than what the hero can block and it would kill him
	elseif damageDealt > (damageBlocked + casterHealth) then
		caster:ForceKill(false)
	
	-- the damage dealt is more but it wont kill the
	elseif damageDealt > damageBlocked then
		caster:Heal(damageBlocked, caster)
		PopupDamageBlock(caster, math.floor(damageDealt))
	end
end

function Blockerino( event )
	print("Added Blockerino")
	--event.caster:AddNewModifier(event.caster, event.ability, "modifier_item_stout_shield", {})
	--event.caster:AddNewModifier(event.caster, event.ability, "modifier_item_stout_shield", {damage_block_melee = "1000", damage_block_ranged = "1000",block_chance = "60"}) 
	
	event.caster:AddAbility("block_giver")
	print(event.caster:FindAbilityByName("block_giver"))

end

