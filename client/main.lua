coach = false

-- Create Wagon Wheel Map Marker

Citizen.CreateThread(function()
    for _, marker in pairs(Config.Marker) do
        local blip = N_0x554d9d53f696d002(1664425300, marker.x, marker.y, marker.z)
        SetBlipSprite(blip, marker.sprite, 1)
        SetBlipScale(blip, 0.2)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, marker.name)
    end  
end)

-- Generate Job Giver NPC's

RegisterNetEvent("parks_stagecoach:CreateNPC")
AddEventHandler("parks_stagecoach:CreateNPC", function (zone)
    print('stage_coach triggered')

    local model = GetHashKey( "S_M_M_BankClerk_01" )
                local coord = GetEntityCoords(PlayerPedId())
                RequestModel( model )

                    while not HasModelLoaded( model ) do
                        Wait(500)
                    end
                
                npc = CreatePed( model, zone.x, zone.y, zone.z, zone.h, 1, 1 )
                print(npc)
                Citizen.InvokeNative( 0x283978A15512B2FE , npc, true )
    
end)

-- Warmenu Stage Coach

Citizen.CreateThread(function()
    WarMenu.CreateMenu('Stagecoach', 'Stagecoach')
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('Stagecoach') then
            WarMenu.Display()
            if WarMenu.Button("Borrow Coach - $0 ") then
                TriggerServerEvent("parks_stagecoach:buy_stagecoach", 0)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Small Stage Coach - $100") then
                TriggerServerEvent("parks_stagecoach:buy_stagecoach", 100)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Medium Stage Coach - $500") then
                TriggerServerEvent("parks_stagecoach:buy_stagecoach", 500)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Large Stage Coach - $850") then
                TriggerServerEvent("parks_stagecoach:buy_stagecoach", 850)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Deluxe Stage Coach - $1000") then
                TriggerServerEvent("parks_stagecoach:buy_stagecoach", 1000)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            end

        end
    end
end)



function OpenStageCoachMenu()
    WarMenu.OpenMenu('Stagecoach')
end

-- Prompt Menu

local StageCoachPrompt
local active = false


function StageCoach()
    Citizen.CreateThread(function()
        local str = 'Stage Coach Co.'
        StageCoachPrompt = PromptRegisterBegin()
        PromptSetControlAction(StageCoachPrompt, 0xC7B5340A)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(StageCoachPrompt, str)
        PromptSetEnabled(StageCoachPrompt, true)
        PromptSetVisible(StageCoachPrompt, true)
        PromptSetHoldMode(StageCoachPrompt, true)
        PromptSetGroup(StageCoachPrompt, group)
        PromptRegisterEnd(StageCoachPrompt)
 
    end)
end

Citizen.CreateThread(function()
    while true do
    Wait(10)
    for _, zone in pairs(Config.Marker) do
            if GetDistanceBetweenCoords(zone.x, zone.y, zone.z,GetEntityCoords(PlayerPedId()),false)<1 then
                if active == false then
                    StageCoach()
                    menu_trigger_loc = zone.name
                    active = true

                end
            elseif GetDistanceBetweenCoords(zone.x, zone.y, zone.z,GetEntityCoords(PlayerPedId()),false)>1.5 and zone.name == menu_trigger_loc then
                if active == true then
                    Wait(200)
                    PromptDelete(StageCoachPrompt)
                    
                    active = false
                end
            end
    end
    if PromptHasHoldModeCompleted(StageCoachPrompt) then
                        OpenStageCoachMenu()
                        PromptDelete(StageCoachPrompt)
                        active = true
    end
end
end)


Citizen.CreateThread(function()
    
    local npc_spawned = { ["Saint Dennis"] = false, ["Rhodes"] = false,}

    local player = PlayerPedId()

    while true do
    Wait(10)
    
    	for _, zone in pairs(Config.Marker) do
    		if npc_spawned[zone.name] == false then
                
    			if GetDistanceBetweenCoords(zone.x, zone.y, zone.z,GetEntityCoords(PlayerPedId()),false)<500 then
    				TriggerEvent("parks_stagecoach:CreateNPC", zone)
                    npc_spawned[zone.name] = true                   
    			end
    		end
    	end
        if npc_spawned == true then
            break
        end
    end
end)              

-- Client Event for Wagon Spawn

RegisterNetEvent("parks_stagecoach:SpawnBorrowedWagon")
AddEventHandler("parks_stagecoach:SpawnBorrowedWagon", function (stagecoach_cost)
    
    
    local stage_coach =  GetHashKey("BUGGY01")
    print(stage_coach)
    RequestModel(stage_coach)
    while not HasModelLoaded(stage_coach) do
        Citizen.Wait(0)
    end
    spawn_coach = CreateVehicle(stage_coach, 1269.4, -1315.75, 76.4, 38.42, true, false)
    SetVehicleOnGroundProperly(spawn_coach)
    SetModelAsNoLongerNeeded(stage_coach)
    print(spawn_coach)
    local player = PlayerPedId()
    DoScreenFadeOut(500)

    CreateCamWithParams('overhead_a', 1269.4, -1315.75, 86.4, 0, 0, 0, 90, true, 0)
    CreateCamWithParams('overhead_b', 1279.4, -1315.75, 86.4, 0, 0, 0, 90, true, 0)
    SetCamActiveWithInterp(overhead_a, overhead_b, 10, 1, 0)

    print(overhead_a)
    Wait(500)
    SetPedIntoVehicle(player, spawn_coach, -1)
    Wait(500)
    DoScreenFadeIn(500)
    

end)



        