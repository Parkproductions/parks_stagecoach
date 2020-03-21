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

-- Prompt Menu
local StageCoachPrompt

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

-- Check if Player is close to Marker/NPC

local function IsNearZone ( location )

    local player = PlayerPedId()
    local playerloc = GetEntityCoords(player, 0)

    for i = 1, #location do
        if #(playerloc - location[i]) < 10.0 then
            
            return true, i
        else
            return false, i
        end

    end
end

Citizen.CreateThread(function()
    
    local npc_spawned = { ["Saint Dennis"] = false, ["Rhodes"] = false,}

    local player = PlayerPedId()

    while true do
    Wait(10)
    
    	for _, zone in pairs(Config.Marker) do

            if GetDistanceBetweenCoords(zone.x, zone.y, zone.z,GetEntityCoords(PlayerPedId()),false)<1 then
                StageCoach()
                local menu_trigger_loc = zone.name
                
            elseif (GetDistanceBetweenCoords(zone.x, zone.y, zone.z,GetEntityCoords(PlayerPedId()),false)>2 and zone.name == menu_trigger_loc) then
                Wait(200)
                PromptDelete(StageCoachPrompt)
            end

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



