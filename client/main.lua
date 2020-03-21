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
            if WarMenu.Button("Borrow Coach") then
                TriggerServerEvent("parks_stagecoach:borrow_stagecoach", 5)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Small Stage Coach") then
                TriggerServerEvent("parks_stagecoach:buy_small_stagecoach", 10)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Medium Stage Coach") then
                TriggerServerEvent("parks_stagecoach:buy_medium_stagecoach", 25)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Large Stage Coach") then
                TriggerServerEvent("parks_stagecoach:buy_large_stagecoach", 50)
                WarMenu.CloseMenu()
                Wait(600)
                WarMenu.Display()
            elseif WarMenu.Button("Buy Deluxe Stage Coach") then
                TriggerServerEvent("parks_stagecoach:buy_deluxe_stagecoach", 100)
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
                        active = true
                        PromptDelete(StageCoachPrompt)
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


        