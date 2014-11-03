--[[ In a single target spell
	"RunScript"
 	{
	    "ScriptFile"	"damage.lua"
	    "Function"		"DoDamage"
	    "Damage"		"%dmg"
  	}
]]
function DoDamage (event)
	local target = event.target
	local hero = event.caster
	local damage = event.Damage
	local spellPower = hero.spellPower
	
	ApplyDamage({
		victim = target,
		attacker = hero,
		damage = damage + spellPower,
		damage_type = DAMAGE_TYPE_MAGICAL
		})
end

--[[ In an AoE target spell
	"ActOnTargets"
	{
		"Target" //adapt as needed
		{
			"Center"		"TARGET"
			"Radius"		"%radius"
			"Teams"			"DOTA_UNIT_TARGET_TEAM_ENEMY"
			"Types"			"DOTA_UNIT_TARGET_HERO | DOTA_UNIT_TARGET_BASIC"
		}
		"RunScript"
	 	{
		    "ScriptFile"	"damage.lua"
		    "Function"		"DoAoEDamage"
		    "Target"		"TARGET"
	  	}
  	}
]]
function DoAoEDamage (event)
	local targets = event.target_entities
	local hero = event.caster
	local damage = event.Damage
	local spellPower = hero.spellPower
	
	for _,enemy in pairs(targets) do
		ApplyDamage({
			victim = enemy,
			attacker = hero,
			damage = damage + spellPower,
			damage_type = DAMAGE_TYPE_MAGICAL
			})
    end
end