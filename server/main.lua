

RegisterServerEvent("parks_stagecoach:buy_stagecoach")
AddEventHandler("parks_stagecoach:buy_stagecoach", function (stagecoach_cost)
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
	user.removeMoney(stagecoach_cost)
		if stagecoach_cost == 0 then
			TriggerClientEvent("parks_stagecoach:SpawnBorrowedWagon",  _source, stagecoach_cost)
		end
	end)
	
	
end)