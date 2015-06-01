order = {}
hTarget = {}

function Spawn( entityKeyValues )
	hAncient = Entities:FindByName( nil, "tbr_ancient" ) -- The city center entity
	thisEntity:SetContextThink( "AIThink", AIThink, 1)

	order.UnitIndex = thisEntity:entindex()
	order.OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE
	order.Position = hAncient:GetAbsOrigin()
	order.Queue = false
end

function AIThink()

	ExecuteOrderFromTable(order)

	return 2.0
end
