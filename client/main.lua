local coach = false
local driving = false
local pressTime = 0
local pressLeft = 0
local recentlySpawned = 0
local keys = { ['O'] = 0xF1301666, ['G'] = 0x5415BE48 }

    
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

    DeleteEntity(npc)
    local model = GetHashKey( "S_M_M_TrainStationWorker_01" )
    local coord = GetEntityCoords(PlayerPedId())
    RequestModel( model )

        while not HasModelLoaded( model ) do
            Wait(500)
        end
                
    npc = CreatePed( model, zone.x, zone.y, zone.z, zone.h, 1, 1 )
   
    Citizen.InvokeNative( 0x283978A15512B2FE , npc, true )

end)

-- Get Current Town Name, Some Towns missing

function GetCurentTownName()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords ,1)
    if town_hash == GetHashKey("Annesburg") then
        return "Annesburg"
    elseif town_hash == GetHashKey("Annesburg") then
        return "Annesburg"
    elseif town_hash == GetHashKey("Armadillo") then
        return "Armadillo"
    elseif town_hash == GetHashKey("Blackwater") then
        return "Blackwater"
    elseif town_hash == GetHashKey("BeechersHope") then
        return "BeechersHope"
    elseif town_hash == GetHashKey("Braithwaite") then
        return "Braithwaite"
    elseif town_hash == GetHashKey("Butcher") then
        return "Butcher"
    elseif town_hash == GetHashKey("Caliga") then
        return "Caliga"
    elseif town_hash == GetHashKey("cornwall") then
        return "Cornwall"
    elseif town_hash == GetHashKey("Emerald") then
        return "Emerald"
    elseif town_hash == GetHashKey("lagras") then
        return "lagras"
    elseif town_hash == GetHashKey("Manzanita") then
        return "Manzanita"
    elseif town_hash == GetHashKey("Rhodes") then
        return "Rhodes"
    elseif town_hash == GetHashKey("Siska") then
        return "Siska"
    elseif town_hash == GetHashKey("StDenis") then
        return "Saint Denis"
    elseif town_hash == GetHashKey("Strawberry") then
        return "Strawberry"
    elseif town_hash == GetHashKey("Tumbleweed") then
        return "Tumbleweed"
    elseif town_hash == GetHashKey("valentine") then
        return "Valentine"
    elseif town_hash == GetHashKey("VANHORN") then
        return "Vanhorn"
    elseif town_hash == GetHashKey("Wallace") then
        return "Wallace"
    elseif town_hash == GetHashKey("wapiti") then
        return "Wapiti"
    elseif town_hash == GetHashKey("AguasdulcesFarm") then
        return "Aguasdulces Farm"
    elseif town_hash == GetHashKey("AguasdulcesRuins") then
        return "Aguasdulces Ruins"
    elseif town_hash == GetHashKey("AguasdulcesVilla") then
        return "Aguasdulces Villa"
    elseif town_hash == GetHashKey("Manicato") then
        return "Manicato"
    end
end

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
        DeleteEntity(npc_id)
        
        if fare_paid == true then
            break
        end
    end
end)

-- Unuccessful Drop Off / No Fare Payment

RegisterNetEvent("parks_stagecoach:unsuccessful_dropoff")
AddEventHandler("parks_stagecoach:unsuccessful_dropoff", function (fare, npc_id)

    while true do
    
        local fare_paid = true
        RemoveBlip(p1)
        ClearGpsMultiRoute()
        passenger_spawned = false
        TriggerEvent("parks_stagecoach:StartCoachJob", zone_name, spawn_coach, passenger_spawned)
        Wait(30000)
        DeleteEntity(npc_id)
        
        if fare_paid == true then
            break
        end
    end
end)

-- PassengerOnboard

RegisterNetEvent("parks_stagecoach:PassengerOnboard")
AddEventHandler("parks_stagecoach:PassengerOnboard", function (zone_name, route)
 
    RemoveBlip(p1)
    ClearGpsMultiRoute()

    StartGpsMultiRoute(5, true, true)
    AddPointToGpsMultiRoute(Config.PickUp[zone_name][route].x + 5, Config.PickUp[zone_name][route].y + 5, Config.PickUp[zone_name][route].z)
    AddPointToGpsMultiRoute(Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y, Config.Destination[zone_name][route].z)
    SetGpsMultiRouteRender(true)

    p1 = N_0x554d9d53f696d002(1664425300, Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y, Config.Destination[zone_name][route].z)
    SetBlipSprite(p1, Config.Destination[zone_name][route].sprite, 5)
    SetBlipScale(p1, 1)
    Citizen.InvokeNative(0x9CB1A1623062F402, p1, Config.Destination[zone_name][route].name)
    passenger_onboard = true
    
    while true do
    Wait(10)   

        if GetDistanceBetweenCoords(Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y, Config.Destination[zone_name][route].z, GetEntityCoords(passenger),false)<5 and passenger_onboard ~= false then
            
            local spawn_coach = GetVehiclePedIsIn(PlayerPedId(),false)
            TaskLeaveVehicle(passenger, spawn_coach, 0)
            TaskGoToCoordAnyMeans(passenger, Config.Destination[zone_name][route].x, Config.Destination[zone_name][route].y +40, Config.Destination[zone_name][route].z, 1.0, 0, 0, 786603, 0xbf800000)
            npc_id = GetPedIndexFromEntityIndex(passenger)
            TriggerEvent("parks_stagecoach:successful_dropoff", 10, npc_id)
            passenger_onboard = false
            
        end       

        if IsEntityDead(passenger) then
            TriggerEvent("parks_stagecoach:unsuccessful_dropoff", 0, npc_id)
            passenger_onboard = false
        end

        if GetVehicleBodyHealth(spawn_coach) == 0 then
            TaskLeaveVehicle(passenger, spawn_coach, 0)
            TriggerEvent("parks_stagecoach:unsuccessful_dropoff", 0, npc_id)
        end
    
        if passenger_onboard == false then
            break
        end
    end

end)


-- StartCoachJob

RegisterNetEvent("parks_stagecoach:StartCoachJob")
AddEventHandler("parks_stagecoach:StartCoachJob", function (zone_name, spawn_coach, driving)
    
    TriggerEvent("drivingtrue")
    zone_name = GetCurentTownName()
    local passenger_despawned = true
    route = math.random(2)
    player_loc = GetEntityCoords(PlayerPedId())
    passenger_onboard = false

    StartGpsMultiRoute(012, false, true)
    AddPointToGpsMultiRoute(player_loc)
    AddPointToGpsMultiRoute(Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z)
    SetGpsMultiRouteRender(true)

    p1 = N_0x554d9d53f696d002(1664425300, Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z)
    SetBlipSprite(p1, Config.PickUp[zone_name][route].sprite, 1)
    SetBlipScale(p1, 1)
    Citizen.InvokeNative(0x9CB1A1623062F402, p1, Config.PickUp[zone_name][route].name)
    
    while (passenger_despawned == true) do
    Wait(10)

            if GetDistanceBetweenCoords(Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z,GetEntityCoords(PlayerPedId()),false)<500 and passenger_despawned == true then

                local model = GetHashKey(Config.PickUp[zone_name][route].model)
                
                RequestModel( model )

                    while not HasModelLoaded( model ) do
                        Wait(500)
                    end
                
                passenger = CreatePed( model, Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z, Config.PickUp[zone_name][route].h, 1, 1)
                print(passenger)
                Citizen.InvokeNative( 0x283978A15512B2FE , passenger, true )
                passenger_despawned = false
                Wait(10)
                
            end
        if passenger_despawned == false then
            break
        end
    end
    
    
    while (passenger_onboard == false) do
    Wait(10)
        
        if GetDistanceBetweenCoords(Config.PickUp[zone_name][route].x, Config.PickUp[zone_name][route].y, Config.PickUp[zone_name][route].z, GetEntityCoords(PlayerPedId()),false)<10 then
            
            spawn_coach = GetVehiclePedIsIn(PlayerPedId(),false)
            
            SetEntityAsMissionEntity(spawn_coach, false, false)
            SetEntityAsMissionEntity(passenger, false, false)
            
            npc_group = GetPedRelationshipGroupHash(passenger)
            SetRelationshipBetweenGroups(1 , GetHashKey("PLAYER") , npc_group)
            print(npc_group)

            Wait(500)       
            TaskEnterVehicle(passenger, spawn_coach, -1, 1, 1.0, 1, 0)

            passenger_onboard = true
            TriggerEvent("parks_stagecoach:PassengerOnboard", zone_name, route)

        end

        if passenger_onboard == true then
            
            break
        end
    end
    
end)

-- Spawn Buy Stage Coach NPC Location Trigger

Citizen.CreateThread(function()
    
    local npc_spawned = { ["Saint Denis"] = false, ["Rhodes"] = false,}
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

RegisterNetEvent("parks_stagecoach:SpawnWagon")
AddEventHandler("parks_stagecoach:SpawnWagon", function (_model)
    
    DeleteVehicle(spawn_coach)
    RequestModel(_model)

    while not HasModelLoaded(_model) do
        Citizen.Wait(0)
    end

    zone_name = GetCurentTownName()

    spawn_coach = CreateVehicle(_model, Config.StageCoachSpawn[zone_name].x, Config.StageCoachSpawn[zone_name].y, Config.StageCoachSpawn[zone_name].z, Config.StageCoachSpawn[zone_name].h, true, false)
    SetVehicleOnGroundProperly(spawn_coach)
    SetModelAsNoLongerNeeded(_model)
    local player = PlayerPedId()
    DoScreenFadeOut(500)

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
    TriggerEvent("parks_stagecoach:StartCoachJob", zone_name, spawn_coach, driving)

end)

RegisterNetEvent("parks_stagecoach:stop_driving")
AddEventHandler("parks_stagecoach:stop_driving", function (spawn_coach)
    
    local player = PlayerPedId()
    local spawn_coach = GetVehiclePedIsIn(PlayerPedId(),false)
    zone_name = GetCurentTownName()
    
    TaskLeaveVehicle(passenger, spawn_coach, 0)
    RemoveBlip(p1)
    ClearGpsMultiRoute()
    
    passenger_spawned = false
    driving = false

end)

-- Replace Wagon If Damaged

RegisterNetEvent("parks_stagecoach:replace_stagecoach")
AddEventHandler("parks_stagecoach:replace_stagecoach", function (spawn_coach)

end)

-- COACHES ARRAY DATA

local Coaches = {
    {
        ['Text'] = "Borrow Coach - $0.",
        ['SubText'] = "",
        ['Desc'] = "It's for a reason.",
        ['Param'] = {
            ['Price'] = 0,
            ['Model'] = "WAGON06X",
            ['Level'] = 0
        }
    },
    {
        ['Text'] = "Small Coach - $100",
        ['SubText'] = "",
        ['Desc'] = "It's got a roof and 2 seats.",
        ['Param'] = {
            ['Price'] = 100,
            ['Model'] = "COACH5",
            ['Level'] = 0
        }
    },
    {
        ['Text'] = "Fancy Small Coach - $500",
        ['SubText'] = "",
        ['Desc'] = "The nicest small coach we sell.",
        ['Param'] = {
            ['Price'] = 500,
            ['Model'] = "COACH4",
            ['Level'] = 0
        }
    },
}

-- Warmenu with Coach with Params 

--[[function OpenBuyStageCoachMenu()
    WarMenu.OpenMenu('Stagecoach')
end

Citizen.CreateThread( function()
    WarMenu.CreateMenu('Stagecoach', 'Stagecoach')
    repeat
        if WarMenu.IsMenuOpened('Stagecoach') then
            for i = 1, #Coaches do
                if WarMenu.Button(Coaches[i]['Text'], Coaches[i]['SubText'], Coaches[i]['Desc']) then
                    TriggerServerEvent('parks_stagecoach:buy_stagecoach', Coaches[i]['Param'])
                    WarMenu.CloseMenu()
                end
            end
            WarMenu.Display()
        end
        Citizen.Wait(0)
    until false
end)--]]


function OpenStageCoachMenu()
    WarMenu.OpenMenu('Stagecoach_MainMenu')
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

-- Main Stage Coach Menu Prompt Location Trigger

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



-- Warmenu Stop Driving Options

Citizen.CreateThread(function()
    WarMenu.CreateMenu('DrivingStatus', 'Coach Menu')
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('DrivingStatus') then
            WarMenu.Display()
            if WarMenu.Button("Stop Driving") then
                    TriggerEvent("parks_stagecoach:stop_driving")
                    WarMenu.CloseMenu()
                    Wait(600)
                    WarMenu.Display()
            elseif WarMenu.Button("Replace Wagon") then
                    TriggerServerEvent("parks_stagecoach:loadstagecoach")
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

-- Warmenu Start Driving Options

Citizen.CreateThread(function()
    WarMenu.CreateMenu('DrivingStatusFalse', 'Coach Menu')
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('DrivingStatusFalse') then
            WarMenu.Display()
            if WarMenu.Button("Start Driving") then
                    TriggerEvent("parks_stagecoach:StartCoachJob", zone_name, spawn_coach, true)
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

-- Warmenu Main Menu 

Citizen.CreateThread(function()
    WarMenu.CreateMenu('Stagecoach_MainMenu', 'Coach Menu')
        WarMenu.CreateSubMenu('Stagecoach', 'Stagecoach_MainMenu', 'Buy a Stage Coach')
        

        while true do
            Citizen.Wait(0)
            if WarMenu.IsMenuOpened('Stagecoach_MainMenu') then

                if WarMenu.MenuButton('Stagecoach', 'Buy Coach') then end

                WarMenu.Display()

                    if WarMenu.Button("Owned Coaches") then
                            TriggerServerEvent('parks_stagecoach:loadstagecoach')
                            WarMenu.CloseMenu()
                            Wait(600)
                            WarMenu.Display()
                    elseif WarMenu.IsMenuOpened('Stagecoach') then
                        for i = 1, #Coaches do
                            if WarMenu.Button(Coaches[i]['Text'], Coaches[i]['SubText'], Coaches[i]['Desc']) then
                                TriggerServerEvent('parks_stagecoach:buy_stagecoach', Coaches[i]['Param'])
                                WarMenu.CloseMenu()
                            end
                        end
                        WarMenu.Display()
                    elseif WarMenu.Button("Buy Coach") then
                            OpenBuyStageCoachMenu()
                            Wait(600)
                            
                    elseif WarMenu.Button("Exit") then
                            WarMenu.CloseMenu()
                            Wait(600)
                            WarMenu.Display()
                    end
                    
            end
        end
end)

-- List Coaches Menu Function

function OpenListStageCoachMenu(HasStagecoaches)    
    WarMenu.OpenMenu('ListStagecoaches')
end

-- List Coaches Menu Event

RegisterNetEvent("parks_stagecoach:LoadCoachesMenu")
AddEventHandler("parks_stagecoach:LoadCoachesMenu", function (HasStagecoaches)

Citizen.CreateThread( function()
   
    WarMenu.CreateMenu('ListStagecoaches', 'Coaches')
    WarMenu.OpenMenu('ListStagecoaches')
    repeat
        if WarMenu.IsMenuOpened('ListStagecoaches') then
            
            for key, value in pairs(HasStagecoaches) do 
                 print(value['stagecoach'])
                if WarMenu.Button(value['stagecoach']) then
                    TriggerEvent('parks_stagecoach:SpawnWagon', value['stagecoach'])
                    WarMenu.CloseMenu()
                    Wait(600)
                    WarMenu.Display()
                end
            end
            WarMenu.Display()
        end
        Citizen.Wait(0)
    until false
end)    
end)

-- Warmenu Driving Status Menu Options Switch

function OpenDrivingStatusMenu()
   
    if driving == true then
    WarMenu.OpenMenu('DrivingStatus')
    else
    WarMenu.OpenMenu('DrivingStatusFalse')
    end    
end

-- Update Driving Status Function

RegisterNetEvent("drivingtrue")
AddEventHandler("drivingtrue", function()
    driving = true
end)
    
-- Check For Button Press Menu Open

Citizen.CreateThread(function()
    local active = false
    while true do

        if IsControlJustReleased(0, keys['O']) then
            print('O Key')
            if active == false then
                OpenDrivingStatusMenu()
                active = true
            elseif active == true then
                    WarMenu.CloseMenu()
                    active = false
            end
        end
        Citizen.Wait(0)
    end
end)

-- Command to check current town /intown

RegisterCommand("intown", function()
function GetCurentTownName()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords ,1)
    if town_hash == GetHashKey("Annesburg") then
        return "Annesburg"
    elseif town_hash == GetHashKey("Annesburg") then
        return "Annesburg"
    elseif town_hash == GetHashKey("Armadillo") then
        return "Armadillo"
    elseif town_hash == GetHashKey("Blackwater") then
        return "Blackwater"
    elseif town_hash == GetHashKey("BeechersHope") then
        return "BeechersHope"
    elseif town_hash == GetHashKey("Braithwaite") then
        return "Braithwaite"
    elseif town_hash == GetHashKey("Butcher") then
        return "Butcher"
    elseif town_hash == GetHashKey("Caliga") then
        return "Caliga"
    elseif town_hash == GetHashKey("cornwall") then
        return "Cornwall"
    elseif town_hash == GetHashKey("Emerald") then
        return "Emerald"
    elseif town_hash == GetHashKey("lagras") then
        return "lagras"
    elseif town_hash == GetHashKey("Manzanita") then
        return "Manzanita"
    elseif town_hash == GetHashKey("Rhodes") then
        return "Rhodes"
    elseif town_hash == GetHashKey("Siska") then
        return "Siska"
    elseif town_hash == GetHashKey("StDenis") then
        return "Saint Denis"
    elseif town_hash == GetHashKey("Strawberry") then
        return "Strawberry"
    elseif town_hash == GetHashKey("Tumbleweed") then
        return "Tumbleweed"
    elseif town_hash == GetHashKey("valentine") then
        return "Valentine"
    elseif town_hash == GetHashKey("VANHORN") then
        return "Vanhorn"
    elseif town_hash == GetHashKey("Wallace") then
        return "Wallace"
    elseif town_hash == GetHashKey("wapiti") then
        return "Wapiti"
    elseif town_hash == GetHashKey("AguasdulcesFarm") then
        return "Aguasdulces Farm"
    elseif town_hash == GetHashKey("AguasdulcesRuins") then
        return "Aguasdulces Ruins"
    elseif town_hash == GetHashKey("AguasdulcesVilla") then
        return "Aguasdulces Villa"
    elseif town_hash == GetHashKey("Manicato") then
        return "Manicato"
    end
end

intown = GetCurentTownName()
print(intown)
end)
