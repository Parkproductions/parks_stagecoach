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

-- StartCoachJob

RegisterNetEvent("parks_stagecoach:StartCoachJob")
AddEventHandler("parks_stagecoach:StartCoachJob", function (zone, spawn_coach)
    
    StartGpsMultiRoute(1, false, true)
    AddPointToGpsMultiRoute(1300.97, -1161.06, 81.08)
    AddPointToGpsMultiRoute(1738.37, -1373.53, 43.51)
    SetGpsMultiRouteRender(true)

    local p1 = N_0x554d9d53f696d002(1664425300, Config.Destination.x, Config.Destination.y, Config.Destination.z)

    SetBlipSprite(p1, Config.Destination.sprite, 5)
    SetBlipScale(p1, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, p1, Config.Destination.name)
    isTransfering = true

    while true do
    Wait(10)
        
            if GetDistanceBetweenCoords(Config.Destination.x, Config.Destination.y, Config.Destination.z,GetEntityCoords(PlayerPedId()),false)<500 then

                local model = GetHashKey("A_F_M_BlWUpperClass_01")
                
                RequestModel( model )

                    while not HasModelLoaded( model ) do
                        Wait(500)
                    end
                
                passenger_1_female = CreatePed( model, 1748.56, -1371.16, 44.04, 108.51, 1, 1 )
                print(passenger_1_female)
                Citizen.InvokeNative( 0x283978A15512B2FE , passenger_1_female, true )
                passenger_spawned = true
            end
        if passenger_spawned == true then
            break
        end
    end

    while true do
    Wait(10)
        if GetDistanceBetweenCoords(Config.Destination.x, Config.Destination.y, Config.Destination.z,GetEntityCoords(PlayerPedId()),false)<5 then
            local spawn_coach = GetVehiclePedIsIn(PlayerPedId(),false)
            TaskEnterVehicle(passenger_1_female, spawn_coach, 20000, 1, 2, 1, 1)
            print(spawn_coach)
            passenger_onboard = true
        end
        if passenger_onboard == true then
            break
        end
    end



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
            if GetDistanceBetweenCoords(zone.x, zone.y, zone.z,GetEntityCoords(PlayerPedId()),false)<2 then
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

-- Destroy Cams

function EndStageCoachCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam_a, false)
    DestroyCam(cam_b, false)

    cam_a = nil
    cam_b = nil
end

-- Client Event for Wagon Spawn

RegisterNetEvent("parks_stagecoach:SpawnBorrowedWagon")
AddEventHandler("parks_stagecoach:SpawnBorrowedWagon", function (stagecoach_cost)
    
    
    local stage_coach =  GetHashKey("STAGECOACH003X")
    print(stage_coach)
    RequestModel(stage_coach)
    while not HasModelLoaded(stage_coach) do
        Citizen.Wait(0)
    end

    while true do
        for _, zone in pairs(Config.Marker) do
            if GetDistanceBetweenCoords(zone.x, zone.y, zone.z,GetEntityCoords(PlayerPedId()),false)<2 then
                zone_name = zone.name
            end
        end
        if zone_name then
            break
        end
    end


    spawn_coach = CreateVehicle(stage_coach, Config.StageCoachSpawn[zone_name].x, Config.StageCoachSpawn[zone_name].y, Config.StageCoachSpawn[zone_name].z, Config.StageCoachSpawn[zone_name].h, true, false)
    SetVehicleOnGroundProperly(spawn_coach)
    SetModelAsNoLongerNeeded(stage_coach)
    print(spawn_coach)
    local player = PlayerPedId()
    DoScreenFadeOut(500)



    --[[cam_a = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1269.4,-1315.75, 86.4, 300.00,0.00,0.00, 100.00, false, 0)
    cam_b = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 1279.4, -1315.75, 86.4, 300.00,0.00,0.00, 100.00, false, 0)--]]

    cam_a = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam_a,  Config.Cams[zone_name]["cam_a"].x, Config.Cams[zone_name]["cam_a"].y, Config.Cams[zone_name]["cam_a"].z)  
    SetCamRot(cam_a, 0.0, 0.0, Config.Cams[zone_name]["cam_a"].h,  true)

    cam_b = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam_b,  Config.Cams[zone_name]["cam_b"].x, Config.Cams[zone_name]["cam_b"].y, Config.Cams[zone_name]["cam_b"].z)
    SetCamRot(cam_b, 0.0, 0.0, Config.Cams[zone_name]["cam_b"].h,  true)

    
    Wait(500)
    SetPedIntoVehicle(player, spawn_coach, -1)
    Wait(500)
    DoScreenFadeIn(500)

    SetCamActiveWithInterp(cam_a, cam_b, 2000, 1, 1)
    IsCinematicCamRendering(true)
    RenderScriptCams(1, 0, cam_a,  true,  true)
    Wait(3000)

    EndStageCoachCam()
    TriggerEvent("parks_stagecoach:StartCoachJob", spawn_coach)

end)



        