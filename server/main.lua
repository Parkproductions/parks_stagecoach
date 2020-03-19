
RegisterServerEvent("parks_stagecoach:NpcStart")
AddEventHandler("parks_stagecoach:NpcStart", function (pos)
    Fighters[pos] = _source
    TriggerClientEvent("parks_stagecoach:CreateNPC", -1, pos, true)
end)