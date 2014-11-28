function Teleport(event)
	local hero = event.target
	Timers:CreateTimer(1,function()
	    FindClearSpaceForUnit(hero, Vector(0,0,0), true)
	    hero:Stop()
	end)
end

function TeleportToCity(event)
	local hero = event.target
	
	local destination = Entities:FindByName(nil, "athens_city")
    FindClearSpaceForUnit(hero, destination, true)
end