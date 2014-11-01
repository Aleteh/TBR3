function OnStartTouch(trigger)

	-- Get the position of the "point_teleport_spot"-entity we put in our map
	local point =  Vector(584,0,224)

	-- Find a spot for the hero around 'point' and teleports to it
	FindClearSpaceForUnit(trigger.activator, point, false)

	-- Stop the hero, so he doesn't move
	trigger.activator:Stop()

	-- Refocus the camera of said player to the position of the teleported hero.
	SendToConsole("dota_camera_center")

end
