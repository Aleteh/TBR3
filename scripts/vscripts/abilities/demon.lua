function Warglaives( event )
    local hero = event.caster
	print("No Draw")
	--event.caster:AddNoDraw()
	--event.caster:RemoveNoDraw()
	--local weapon1 = Entities:FindByModel(nil, "models/heroes/terrorblade/horns.vmdl")
    --local weapon2 = EntitiesFindByModelWithin(event.caster, string modelName, Vector origin, float maxRadius) --[[Returns:handle
    --Find entities by model name within a radius. Pass ''nil'' to start an iteration, or reference to a previously found entity to continue a search
    --]]

	--DeepPrintTable(weapon)
    --weapon:SetModelScale(0) --doesn't seem to work

    --weapon:SetModel("models/development/invisiblebox.vmdl")

    local wearables = {}
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model ~= nil and model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            print(model:GetModelName())
            if string.find(model:GetModelName(), "weapon") ~= nil then
                table.insert(wearables, model)
                model:SetModel("models/development/invisiblebox.vmdl")  
            end
        end
        model = model:NextMovePeer()
    end
    
    Timers:CreateTimer({
        endTime = 5,
        callback = function()
            print(#wearables)
            for i = 1, #wearables do
                print(wearables[i]:GetModelName())
                wearables[i]:SetModel("models/heroes/terrorblade/weapon.vmdl")
            end
        end
    })
   

--models/heroes/terrorblade/horns.vmdl
--models/heroes/terrorblade/armor.vmdl
--models/heroes/terrorblade/wings.vmdl
--models/heroes/terrorblade/weapon.vmdl
--models/heroes/terrorblade/terrorblade_weapon_planes.vmdl
--models/heroes/terrorblade/horns_arcana.vmdl
--models/heroes/terrorblade/demon.vmdl
                        
end