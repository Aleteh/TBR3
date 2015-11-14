require 'timers'

avatar_of_earth = nil

function EnterArena(trigger)
	local unit = trigger.activator
	local caller = trigger.caller
	if unit:IsRealHero() then
		if avatar_of_earth == nil then
			avatar_of_earth = CreateUnitByName("tbr_avatar_of_earth", caller:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
			for i=0, 1 do
				local ability = avatar_of_earth:GetAbilityByIndex(i)
				if ability then
					ability:SetLevel(1)
				end
			end
		end
	end
end

function MeteorThink(keys)
	local targets = keys.target_entities
	avatar_of_earth = keys.caster
	local ability = avatar_of_earth:FindAbilityByName("tbr_avatar_of_earth_meteor")
	
	local units_present = 0
	local challengers = {}
	
	for i=0,10 do
		if targets[i] then
			challengers[units_present] = targets[i]
			units_present = units_present + 1
		end
	end
	if units_present > 0 then
		local randomNum = math.random(0,units_present - 1)
		avatar_of_earth:CastAbilityOnPosition(challengers[randomNum]:GetOrigin(), ability, 0)
	end
end