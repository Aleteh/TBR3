function AssignMaterials( event )
	print("Assigning Materials to all players around")

	-- handle of the creep that was just killed
	local killedUnit = EntIndexToHScript( event.caster_entindex )
	local materialsToAssign = 0

	-- This could/should be done with a table, but I'm lazy so I'll use a bunch of ifs
	if killedUnit:GetUnitName() == "npc_bandit" then
		materialsToAssign = 1 --placeholder, will use the proper values when we port the units
	end

	-- Find nearby units
	local units = FindUnitsInRadius(event.caster:GetTeamNumber(), event.caster:GetAbsOrigin(), nil, 900,
						DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- Increase the resource of each one
    for _,unit in pairs(units) do
    	if unit:IsRealHero() then
    		unit.materials = unit.materials + materialsToAssign
    		--print("Materials Assigned. " .. unit:GetName() .. " is currently at " .. unit.materials)
    		pID = unit:GetPlayerID()
    		FireGameEvent('cgm_player_materials_changed', { player_ID = pID, materials = unit.materials })
    	end
    end

    -- Display the custom popup (could be done for every player instead of the killedUnit)
    PopupMaterials(killedUnit, 1)
    PopupExperience(killedUnit, math.floor(killedUnit:GetLevel()*5))
end

function GiveMaterialsToPlayer( event )
	local itemName = event.ability:GetAbilityName()
	local hero = event.caster
	local itemTable = GameMode.ItemInfoKV[itemName]

	if itemTable == nil then
		return true
	end

	-- Check Profession Restriction
	print("Name","Profession","Hero Profession")
	print(itemName,itemTable.professionRequired,hero.profession)
	if itemTable.professionRequired then
		if itemTable.professionRequired ~= hero.profession then
			FireGameEvent( 'custom_error_show', { player_ID = pID, _error = "Requires " .. itemTable.professionRequired .." to pick up." } )
			-- Recreate the item
			local newItem = CreateItem( itemName, nil, nil )
			newItem:SetPurchaseTime( 0 )
			--newItem:SetCurrentCharges( goldToDrop )
			local spawnPoint = Vector( 0, 0, 0 )
			spawnPoint = hero:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( spawnPoint, newItem )
			newItem:LaunchLoot( false, 100, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 150 ) ) )

			return
		end
	end

	print("Giving Materials to the player that called this")

	-- ammount passed to assign
	local materialsToAssign = event.Ammount

	-- handle of the player that picked the item
	local picker = event.caster

    if picker:IsRealHero() then
		picker.materials = picker.materials + materialsToAssign
		pID = picker:GetPlayerID()
		FireGameEvent('cgm_player_materials_changed', { player_ID = pID, materials = picker.materials })
    end

    -- Display the custom popup
    PopupMaterials(picker, materialsToAssign)
end