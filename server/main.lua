
-- Generate Job Giver NPC's

RegisterServerEvent("parks_stagecoach:CreateNPC")
AddEventHandler("parks_stagecoach:CreateNPC", function (pos)
    print('stage_coach triggered')

    model = GetHashKey( "S_M_M_BankClerk_01" )
                
                --[[RequestModel( model )

                    while not HasModelLoaded( model ) do
                        Wait(500)
                    end--]]
                
                npc = CreatePed( model, 1254.05, -1327.07, 76.89, 272.0, 1, 1 )
                print(npc)
                Citizen.InvokeNative( 0x283978A15512B2FE , npc, true )
    
end)