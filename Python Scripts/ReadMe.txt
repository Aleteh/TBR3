I am using python 3.3

So the unit parser is almost complete, all that is left is to distinguish their abilities, 
collision size(?), relationshipclass (i have no idea what this is), and make it slightly cleaner. 
Other than that it is finished. Also, is it DAMAGE_TYPE_PHYSICAL or DAMAGE_TYPE_ArmorPhysical?

(N) Edit:
It's DAMAGE_TYPE_ArmorPhysical. Replaced all those occurrences in the parsed.
Also changed every " - " to "0" in case it gives troubles :  (Not sure if it might be better to just remove the lines)
	In StatusMana & StatsManaRegen of units without mana
	In MovementSpeed & MovementTurnRate of units with DOTA_UNIT_CAP_MOVE_NONE
	In AttackAnimationPoint and AttackRange for some non attacking units which for some reason have DOTA_UNIT_CAP_MELEE_ATTACK
Level is still "-"