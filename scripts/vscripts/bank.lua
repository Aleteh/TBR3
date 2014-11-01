function DropAllItems(event)
    print( "Droping all Items in the Bank" )
    local bank = event.caster
    local owner = event.caster:GetOwner()
    for itemSlot = 0, 5, 1 do 
	    local Item = bank:GetItemInSlot( itemSlot )
	    if Item ~= nil then
	    	itemName = Item:GetName()
	    	print("Attempting to drop " .. itemName)
	    	
	        local newItem = CreateItem( itemName, nil, nil )
			newItem:SetPurchaseTime( 0 )
				--newItem:SetCurrentCharges( goldToDrop )
			local spawnPoint = Vector( 0, 0, 0 )
			spawnPoint = bank:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( spawnPoint, newItem )
			newItem:LaunchLoot( false, 200, 0.75, spawnPoint + RandomVector( RandomFloat( 150, 200 ) ) )
	        
	        --finally, remove the item
	        bank:RemoveItem(Item)
	    end
    end
end

function DropItemInSlot(event)
	local bank = event.caster
    local owner = event.caster:GetOwner()
    local itemSlot = 0
    if event.Slot ~= nil then 
    	itemSlot = event.Slot
    end

    local Item = bank:GetItemInSlot( itemSlot )
	if Item ~= nil then
		itemName = Item:GetName()
		print("Dropping Item in Slot" .. itemSlot .. " - " .. itemName)
		
	    local newItem = CreateItem( itemName, nil, nil )
		newItem:SetPurchaseTime( 0 )
			--newItem:SetCurrentCharges( goldToDrop )
		local spawnPoint = Vector( 0, 0, 0 )
		spawnPoint = owner:GetAbsOrigin()
		local drop = CreateItemOnPositionSync( spawnPoint, newItem )
		newItem:LaunchLoot( false, 200, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 150 ) ) )
	    
	    --finally, remove the item
	    bank:RemoveItem(Item)
	end
end

function TransferItemInSlot(event)
	local bank = event.caster
    local owner = event.caster:GetOwner()
    if event.Slot ~= nil then 
    	itemSlot = event.Slot
    end

    local Item = bank:GetItemInSlot( itemSlot )
	if Item ~= nil then
		itemName = Item:GetName()
		
		 -- Look if the player is near
    	units = FindUnitsInRadius(event.caster:GetTeamNumber(), event.caster:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
    								DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER, false)
 
 		--restrict area and if HasRoomForItem
    	for _,unit in pairs(units) do
        	if unit == owner then
				local newItem = CreateItem( itemName, owner, owner )
				newItem:SetPurchaseTime( 0 )
				--newItem:SetCurrentCharges( goldToDrop )
				owner:AddItem(newItem)

				 --finally, remove the item
				bank:RemoveItem(Item)
			else
				print("Owner is not near the bank")
				--add an error message later
			end
    	end		
	end
end