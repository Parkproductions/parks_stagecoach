
RegisterServerEvent("parks_stagecoach:NpcStart")
AddEventHandler("parks_stagecoach:NpcStart", function (pos)
    Fighters[pos] = _source
    TriggerClientEvent("parks_stagecoach:CreateNPC", -1, pos, true)
end)

RegisterServerEvent("parks_stagecoach:buy_small_stagecoach")
AddEventHandler("parks_stagecoach:buy_small_stagecoach", function ()
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source function(user)
	user.removeMoney(100)
	end)
end)