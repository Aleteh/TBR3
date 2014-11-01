function Block(keys)
	local caster = keys.caster
	local damageDealt = keys.damage_dealt
	local damageBlocked = keys.damage_blocked
	local casterHealth = caster:GetHealth()

	if damageBlocked > damageDealt then
		caster:Heal(damageDealt, caster)
		PopupDamageBlock(caster, damageDealt)
	elseif damageDealt > (damageBlocked + casterHealth) then
		caster:ForceKill(false)
	elseif damageDealt > damageBlocked then
		caster:Heal(damageBlocked, caster)
		PopupDamageBlock(caster, damageBlocked)
	end
end