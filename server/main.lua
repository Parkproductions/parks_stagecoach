
RegisterServerEvent("parks_stagecoach:NpcStart")
AddEventHandler("parks_stagecoach:NpcStart", function (pos)
    Fighters[pos] = _source
    TriggerClientEvent("parks_stagecoach:CreateNPC", -1, pos, true)
end)

RegisterServerEvent("parks_stagecoach:buy_stagecoach")
AddEventHandler("parks_stagecoach:buy_stagecoach", function (stagecoach_cost)
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
	user.removeMoney(stagecoach_cost)
	TriggerClientEvent("parks_stagecoach:SpawnWagon", stagecoach_cost, true)
	end)
end)