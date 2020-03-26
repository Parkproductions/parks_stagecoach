coach = false
driving = false
local keys = { ['SPACE'] = 0xD9D0E1C0 }
    
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


-- Successful Drop Off / Pay Fare

RegisterNetEvent("parks_stagecoach:successful_dropoff")
AddEventHandler("parks_stagecoach:successful_dropoff", function (fare, npc_id)
    
    while true do
    
        TriggerServerEvent("parks_stagecoach:pay_fare", 10)
        local fare_paid = true
        RemoveBlip(p1)
        ClearGpsMultiRoute()
        passenger_spawned = false
        TriggerEvent("parks_stagecoach:StartCoachJob", zone_name, spawn_coach, passenger_spawned)

        Wait(30000)
        print(npc_id)
        DeleteEntity(npc_id)
        if fare_paid == true then
            break
        end
    
    end

end)


-- PassengerOnboard

RegisterNetEvent("parks_stagecoach:PassengerOnboard")
AddEventHandler("parks_stagecoach:PassengerOnboard", function (zone_name, route)
    
    print('passenger_onboard')
    RemoveBlip(p1)
    ClearGpsMultiRoute()

    StartGpsMultiRoute(5, true, true)
    AddPointToGpsMultiRoute(Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z)
    AddPointToGpsMultiRoute(Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y, Config.Destination[zone_name][route].z)
    SetGpsMultiRouteRender(true)

    p1 = N_0x554d9d53f696d002(1664425300, Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y, Config.Destination[zone_name][route].z)
    SetBlipSprite(p1, Config.Destination[zone_name][route].sprite, 5)
    SetBlipScale(p1, 1)
    Citizen.InvokeNative(0x9CB1A1623062F402, p1, Config.Destination[zone_name][route].name)
    passenger_onboard = true
    
    while true do
    Wait(10)
        
        if GetDistanceBetweenCoords(Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y, Config.Destination[zone_name][route].z, GetEntityCoords(PlayerPedId()),false)<5 and passenger_onboard ~= false then
            
            local spawn_coach = GetVehiclePedIsIn(PlayerPedId(),false)
            TaskLeaveVehicle(passenger_1_female, spawn_coach, 0)
            TaskGoToCoordAnyMeans(passenger_1_female, Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y +50, Config.Destination[zone_name][route].z, 1.0, 0, 0, 786603, 0xbf800000)
            npc_id = GetPedIndexFromEntityIndex(passenger_1_female)
            TriggerEvent("parks_stagecoach:successful_dropoff", 10, npc_id)
            passenger_onboard = false
            
        end
    
        if passenger_onboard == false then
            break
        end
    end

end)


-- StartCoachJob

RegisterNetEvent("parks_stagecoach:StartCoachJob")
AddEventHandler("parks_stagecoach:StartCoachJob", function (zone_name, spawn_coach)


    local passenger_despawned = true
    route = math.random(3)
    player_loc = GetEntityCoords(PlayerPedId())

    StartGpsMultiRoute(012, false, true)
    AddPointToGpsMultiRoute(player_loc)
    AddPointToGpsMultiRoute(Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z)
    SetGpsMultiRouteRender(true)

    p1 = N_0x554d9d53f696d002(1664425300, Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z)
    SetBlipSprite(p1, Config.PickUp[zone_name][route].sprite, 1)
    SetBlipScale(p1, 1)
    Citizen.InvokeNative(0x9CB1A1623062F402, p1, Config.PickUp[zone_name][route].name)
    isTransfering = true
    
    while (passenger_despawned == true) do
    Wait(10)
        
            if GetDistanceBetweenCoords(Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z,GetEntityCoords(PlayerPedId()),false)<500 and passenger_despawned == true then

                local model = GetHashKey("A_F_M_BlWUpperClass_01")
                
                RequestModel( model )

                    while not HasModelLoaded( model ) do
                        Wait(500)
                    end
                
                passenger_1_female = CreatePed( model, Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z, Config.PickUp[zone_name][route].h, 1, 1)
                print(passenger_1_female)
                Citizen.InvokeNative( 0x283978A15512B2FE , passenger_1_female, true )
                passenger_despawned = false
                Wait(10000)
                
            end
        if passenger_despawned == false then
            break
        end
    end

    while true do
    Wait(10)
        
        if GetDistanceBetweenCoords(Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z, GetEntityCoords(PlayerPedId()),false)<10 then
            
            spawn_coach = GetVehiclePedIsIn(PlayerPedId(),false)
            
            SetEntityAsMissionEntity(spawn_coach, false, false)
            SetEntityAsMissionEntity(passenger_1_female, false, false)
            
            npc_group = GetPedRelationshipGroupHash(passenger_1_female)
            SetRelationshipBetweenGroups(1 , GetHashKey("PLAYER") , npc_group)
            print(npc_group)

            Wait(1000)       
            TaskEnterVehicle(passenger_1_female, spawn_coach, -1, -2, 1.0, 1, 0)

            passenger_onboard = true
            TriggerEvent("parks_stagecoach:PassengerOnboard", zone_name, route)

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

-- Buy Stage Coach Prompt Menu

local StageCoachPrompt
local active = false


function StageCoach()
    Citizen.CreateThread(function()
        local str = 'Stage Coach Co.'
        StageCoachPrompt = PromptRegisterBegin()
        PromptSetControlAction(StageCoachPrompt, 0xDFF812F9)
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
    
    
    local stage_coach =  GetHashKey("BUGGY01")
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
    driving = true
    TriggerEvent("parks_stagecoach:StartCoachJob", zone_name, spawn_coach)
    TriggerEvent("parks_stagecoach:DrivingStatus", driving)
    
end)

-- Driving Status Menu

RegisterNetEvent("parks_stagecoach:stop_driving")
AddEventHandler("parks_stagecoach:stop_driving", function (spawn_coach)
    
    local player = PlayerPedId()
    local spawn_coach = GetVehiclePedIsIn(PlayerPedId(),false)
    TaskLeaveVehicle(player, spawn_coach, 0)
    RemoveBlip(p1)
    ClearGpsMultiRoute()
    passenger_spawned = false
    driving = false
    TriggerEvent("parks_stagecoach:DrivingStatus", driving)
    
end)

RegisterNetEvent("parks_stagecoach:replace_stagecoach")
AddEventHandler("parks_stagecoach:replace_stagecoach", function (spawn_coach)

end)

-- Warmenu Stage Coach

Citizen.CreateThread(function()
    WarMenu.CreateMenu('DrivingStatus', 'DrivingStatus')
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('DrivingStatus') then
            WarMenu.Display()
            if WarMenu.Button("Stop Driving") then
                TriggerEvent("parks_stagecoach:stop_driving", 0)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Replace Wagon") then
                TriggerServerEvent("parks_stagecoach:replace_stagecoach", 500)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Exit") then
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            end

        end
    end
end)


function OpenDrivingStatusMenu()
    WarMenu.OpenMenu('DrivingStatus')
end

RegisterNetEvent("parks_stagecoach:DrivingStatus")
AddEventHandler("parks_stagecoach:DrivingStatus", function (driving)   
    
    local active = false
    local driving_status = driving
    print(driving_status)

    while (driving_status == true) do
        
        Wait(100)
        print(driving_status)

            if IsControlJustPressed(0, keys['SPACE']) then 
                if active == false then
                    OpenDrivingStatusMenu()
                    active = true
                elseif active == true then
                    WarMenu.CloseMenu()
                    active = false
                end
            end
        
        if driving_status == false then
            break
        end
    end


end)