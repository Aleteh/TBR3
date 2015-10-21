
-- called when 1 hero enters an area

function SpawnArea( trigger )
	local areaName = trigger.caller:GetName()
	local caller = trigger.caller
	local activator = trigger.activator

	Timers:CreateTimer(1, function() 
		if caller:IsTouching(activator) and not IsAreaActive( areaName ) then
			
			print("\n Spawning units of "..areaName.. "\n")
			
			-- initialize the table to store all the creeps in the area
			InitializeCreepList( areaName )

			SetAreaActive( areaName, true )

			-- Spawn Initial Units
			local AreaInfoList = GameRules.SpawnInfoKV[ areaName ]
			DeepPrintTable(AreaInfoList)
			for k,v in pairs( AreaInfoList ) do
				--v.Name is the unit to spawn
				--v.MaxSpawn is how many
				print("Spawning",v.MaxSpawn,k)
				for i=1,v.MaxSpawn do
					-- Get a spawn location for a particular unit
					local spawnLocation = GetFreePositionInAreaFor(areaName,k)

					if spawnLocation ~= nil then	
						local unit = CreateUnitByName(k, spawnLocation:GetOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
						unit:SetForwardVector(RandomVector(5000)) -- variate facing of the unit
						unit.area = areaName -- set the area to respawn easier
						table.insert( GetAreaCreepList(areaName) ,unit) -- store the unit in the area table
					else
						print("No spawn location found")
					end
				end	
			end		
		end
	end)
end

-- called after all the heroes leave the area
function DespawnArea( trigger )
	print("DespawnArea called")

	local areaName = trigger.caller:GetName()
	local caller = trigger.caller
	local activator = trigger.activator

	if not caller:IsTouching(activator) and IsAreaActive( areaName ) then
		SetAreaActive( areaName, false )
		print("\n Despawning units of "..areaName.. " \n")

		local creepsDeleted = 0
		local creep_list = GetAreaCreepList( areaName )
		for _,creep in pairs(creep_list) do
			if IsValidEntity(creep) and creep:IsAlive() then 
				creep:RemoveSelf()
				creepsDeleted = creepsDeleted+1
			else print("Creep is not alive or has not respawned yet, ignoring.") end
		end
		print("Deleted ",creepsDeleted," creeps")
	end
end

-- called after a unit dies, starts a timer to spawn a new unit near the original spawn location
function RespawnCreep( event )

	-- get the unit name to respawn
	local unit = event.caster 
	local unit_name = unit:GetUnitName()

	-- get the area the unit belongs to
	local unit_area = unit.area
	local area_table = GameRules.SpawnInfoKV[unit_area]

	-- get the unit respawn time from the spawn_info table
	local unitTableIndex = getUnitIndex(area_table,unit_name)
	local respawn_time = area_table[unit_name].RespawnTime

	Timers:CreateTimer({
    endTime = respawn_time,
    callback = function()
    	-- we have to check to which area this unit belongs
    	if IsAreaActive(unit_area) then
			-- get a new position and create the unit
			local new_position = GetFreePositionInAreaFor(unit_area,unit_name)
			local new_unit = CreateUnitByName(unit_name, new_position:GetOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
			print("Respawned unit in "..respawn_time.. " seconds on ",new_position:GetOrigin())

			-- variate facing of the unit
			new_unit:SetForwardVector(RandomVector(5000))
			-- set the area to respawn easier
			new_unit.area = unit_area 

			-- get the creep list to add and remove
			local creep_list = GetAreaCreepList(unit_area)

			-- add the new_unit handle to the area creep list
			table.insert(creep_list,new_unit)
			-- remove the old unit
			table.remove(creep_list,getIndex(creep_list, unit))
		end
    end
  	})

end

------------------
-- Area Methods --
------------------

-- returns whether the area is activate or not, that is, there are still players inside the area
function IsAreaActive( areaName )
	print("Checking if ",areaName," is active")
	return SPAWNS[areaName]['Active']
end
 
-- sets the area active or inactive
function SetAreaActive( areaName, bool )
	print("Setting ",areaName," as active area")
    SPAWNS[areaName]['Active'] = bool
end
 
function InitializeCreepList( areaName )
	print("Initializing creep list for ",areaName)
    SPAWNS[areaName]['Creeps'] = {}
end
 
-- returns the list in which the creeps of the area are stored
function GetAreaCreepList( areaName )
	print("Getting creep list for ",areaName)
    return SPAWNS[areaName]['Creeps']
end
 
-- Gives a new position from the available for that type of creature
function GetFreePositionInAreaFor( areaName, unitName )
    print("Finding free position in ",areaName," for ",unitName)
    return GetEmptyPosition(SPAWNS[areaName][unitName.."_spawnLocations"])
end

function GetEmptyPosition( list )
	print("Finding empty location")
	local counter = 0
	position = list[RandomInt(1, #list)]
	local nearbyUnits = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, position:GetOrigin(),nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL,	DOTA_UNIT_TARGET_FLAG_NONE,	FIND_ANY_ORDER,false)
	
	-- find until theres an empty position
	while #nearbyUnits > 0 do
		-- care of infinite loop
		if counter <= #list then
			counter = counter+1
			position = list[RandomInt(1, #list)]
			nearbyUnits = FindUnitsInRadius( DOTA_TEAM_NEUTRALS, position:GetOrigin(),nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER,false)
			--print(nearbyUnits)
		else
			nearbyUnits = 0
			print("Couldn't find empty position, returning random instead")
		end
	end

	return position
end

------------------
-- Boss Methods --
------------------


function SpawnBoss( trigger )
    local unitName = trigger.caller:GetName() --The trigger should be named the same as the unit to spawn

    local ent = Entities:FindByName(nil, unitName.."_spawner") --Such as titan_whatever_spawner or any name format
    local position = ent:GetAbsOrigin()

    print("Attempting to spawn ",unitName,"at",position)
    local unit = CreateUnitByName(unitName, position, true, nil, nil, DOTA_TEAM_BADGUYS) --Or team neutrals, depends if you want to have colored ability icons :D
    -- The unit should be stored somewhere probably, such as BOSSES[unitName] = unit, and the trigger should disallow spawning it more than once if it's still valid and alive
end