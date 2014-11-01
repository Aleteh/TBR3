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
			spawnPoint = owner:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( spawnPoint, newItem )
			newItem:LaunchLoot( false, 200, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 150 ) ) )
	        
	        --finally, remove the item
	        bank:RemoveItem(Item)
	    end
    end
end

function DropItemInSlot(event)
	local bank = event.caster
    local owner = event.caster:GetOwner()
    local itemSlot = event.slot

end
