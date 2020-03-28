

--[[RegisterServerEvent("parks_stagecoach:buy_stagecoach")
AddEventHandler("parks_stagecoach:buy_stagecoach", function (stagecoach_cost)
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
	user.removeMoney(stagecoach_cost)	
		TriggerClientEvent("parks_stagecoach:SpawnWagon", _source, stagecoach_cost)		
	end)	
end)--]]


RegisterServerEvent("parks_stagecoach:pay_fare")
AddEventHandler("parks_stagecoach:pay_fare", function (fare)
	local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		user.addMoney(fare)
	end)
end)


--- DATA BASE QUERIES

local function GetAmmoutStagecoaches( Player_ID, Character_ID )

    local HasStagecoaches = MySQL.Sync.fetchAll( "SELECT * FROM stagecoaches WHERE identifier = @identifier AND charid = @charid ", {
        ['identifier'] = Player_ID,
        ['charid'] = Character_ID
    } )

    print(HasStagecoaches)

    if #HasStagecoaches > 0 then return true end
    return false
    end

RegisterServerEvent("parks_stagecoach:buy_stagecoach")
AddEventHandler("parks_stagecoach:buy_stagecoach", function ( args )

    local _src   = source
    local _price = args['Price']
    local _level = args['Level']
    local _model = args['Model']


	TriggerEvent('redemrp:getPlayerFromId', _src, function(user)
        u_identifier = user.getIdentifier()
        u_level = user.getLevel()
        u_charid = user.getSessionVar("charid")
        u_money = user.getMoney()
    end)

    local _resul = GetAmmoutStagecoaches( u_identifier, u_charid )

   --[[ if u_money <= _price then
        TriggerClientEvent( 'UI:DrawNotification', _src, Config.NoMoney )
        return
    end

    if u_level <= _level then
        TriggerClientEvent( 'UI:DrawNotification', _src, Config.LevelMissing )
        return
    end--]]

	TriggerEvent('redemrp:getPlayerFromId', _src, function(user)
        user.removeMoney(_price)
    end)

    --[[TriggerClientEvent("parks_stagecoach:SpawnWagon", _source, stagecoach_cost)--]]

    --[[TriggerClientEvent('elrp:spawnHorse', _src, _model, true)--]]
	TriggerClientEvent("parks_stagecoach:SpawnWagon", _source, model, true)

    if _resul ~= true then
        local Parameters = { ['identifier'] = u_identifier, ['charid'] = u_charid, ['stagecoach'] = _model }
        MySQL.Async.execute("INSERT INTO stagecoaches ( `identifier`, `charid`, `stagecoach` ) VALUES ( @identifier, @charid, @stagecoach )", Parameters)
        --[[TriggerClientEvent( 'UI:DrawNotification', _src, 'You got a new Stagecoach !' )--]]
        print('New Stagecoach')
    else
        local Parameters = { ['identifier'] = u_identifier, ['charid'] = u_charid, ['stagecoach'] = _model }
        MySQL.Async.execute(" UPDATE stagecoaches SET stagecoach = @stagecoach WHERE identifier = @identifier AND charid = @charid ", Parameters)
        print('Updated Stagecoach')
        --[[TriggerClientEvent( 'UI:DrawNotification', _src, 'You update the Stagecoach !' )--]]
    end

end)

RegisterServerEvent( 'parks_stagecoach:loadstagecoach' )
AddEventHandler( 'parks_stagecoach:loadstagecoach', function ( )

    local _src = source

	TriggerEvent('redemrp:getPlayerFromId', _src, function(user)
	    u_identifier = user.getIdentifier()
	    u_charid = user.getSessionVar("charid")
	end)

    local Parameters = { ['identifier'] = u_identifier, ['charid'] = u_charid }
    local HasStagecoaches = MySQL.Sync.fetchAll( "SELECT * FROM stagecoaches WHERE identifier = @identifier AND charid = @charid ", Parameters )

    if HasStagecoaches[1] then
        local horse = HasStagecoaches[1].stagecoach
        print(stagecoach)
        TriggerClientEvent("elrp:spawnHorse", _src, stagecoach, false)
    end

end )