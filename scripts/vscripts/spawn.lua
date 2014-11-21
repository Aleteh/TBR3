
-- called when 1 hero enters an area
function SpawnArea( trigger )
	areaName = trigger.caller:GetName()
	print(areaName)

	-- we should do this on the main tbr.lua at the beggining and just keep the lists in GameMode.
	local allSpawns = Entities:FindAllByClassname("npc_dota_spawner") 
	local possibleLocations = {}

	for _,v in pairs(allSpawns) do
		-- if the spawn name contains the area name, add to possible locations of areaName
		--if string.find(v:GetName(), areaName) then
			table.insert(possibleLocations, v)
		--end
	end
	--
	
	if areaName == "area_spawner1" then
		GameMode.area1Creeps = {} -- initialize the table to store all the creeps in the area
		
		for i=1,10 do
			local spawnLocation = possibleLocations[RandomInt(1, #possibleLocations)]

			if spawnLocation ~= nil then		
				local unit = CreateUnitByName("npc_demon_fire", spawnLocation:GetOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
				unit:SetForwardVector(RandomVector(5000)) -- variate facing of the unit
				unit.original_position = unit:GetAbsOrigin() -- store the original position
				table.insert(GameMode.area1Creeps,unit)
			end
		end
	end
	

	DeepPrintTable(GameMode.area1Creeps)

end

-- called after all the heroes leave the area
function DespawnArea( trigger )
	areaName = trigger.caller:GetName()

	if areaName == "area_spawner1" then
		DeepPrintTable(GameMode.area1Creeps)
		for _,creep in pairs(GameMode.area1Creeps) do
			if creep then creep:RemoveSelf()
			else print("ERROR") end
		end
	end
end

-- called after a unit dies, starts a timer to spawn a new unit near the original spawn location
function RespawnCreep( event )

	--[[Timers:CreateTimer({
    	endTime = 10,
    	callback = function()
    
    	end
  	})]]

	local unit = event.caster --handle of the unit that died
	local unit_name = unit:GetUnitName()
	local unit_position = unit.original_position
	local new_position = unit.original_position + RandomVector(100) -- variate a little away from the spawner entity
	local new_unit = CreateUnitByName(unit_name, new_position, true, nil, nil, DOTA_TEAM_NEUTRALS)

	new_unit:SetForwardVector(RandomVector(5000)) -- variate facing of the unit
	new_unit.original_position = unit.original_position -- keep the original spawn point near the npc_dota_spawner entity

	-- we have to check to which area this unit belongs
	if string.find(unit_name, "demon") ~= nil then -- demon area.
		-- add the new_unit handle to the area creep list
		table.insert(GameMode.area1Creeps,new_unit)
		-- remove the old unit if needed later...
	end

	-- Global unit counter
	--GameMode.creepCounter[unit_name] = GameMode.creepCounter[unit_name] + 1

end