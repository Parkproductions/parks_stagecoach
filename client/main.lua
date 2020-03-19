coach = false

Citizen.CreateThread(function()
    for _, marker in pairs(Config.Marker) do
    	print(Marker)
        local blip = N_0x554d9d53f696d002(1664425300, marker.x, marker.y, marker.z)
        SetBlipSprite(blip, Config.StagecoachJobSprite, 1)
        SetBlipScale(blip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, marker.name)
    end  
end)


local function IsNearZone ( location )

    local player = PlayerPedId()
    local playerloc = GetEntityCoords(player, 0)

    for i = 1, #location do
        if #(playerloc - location[i]) < 500.0 then
            
            return true, i
        else
            return false, i
        end

    end
end

