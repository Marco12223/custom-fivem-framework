Framework                        = {}
Framework.Players                = {}
Framework.Jobs                   = {}
Framework.Items                  = {}
Framework.ServerCallbacks        = {}

AddEventHandler('Framework:getSharedObject', function(cb)
    cb(Framework)
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)

    local identifier = Framework.GetIdentifier(source)
    if identifier then
        if Framework.GetPlayerFromIdentifier(identifier) then
            CancelEvent()
            setKickReason(playerId, ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(identifier))
        else
            table.insert(Framework.Players, playerId)
        end
    else
        CancelEvent()
        setKickReason(playerId, 'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
    end

end)

function Framework.RegisterServerCallback(name, cb)
    Framework.ServerCallbacks[name] = cb
end

function Framework.TriggerServerCallback(name, requestId, source, cb, ...)
    if Framework.ServerCallbacks[name] then
        Framework.ServerCallbacks[name](source, cb, ...)
    else
        print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!'):format(name))
    end
end

RegisterServerEvent('Framework:triggerServerCallback')
AddEventHandler('Framework:triggerServerCallback', function(name, requestId, ...)
    local playerId = source

    Framework.TriggerServerCallback(name, requestId, playerId, function(...)
        TriggerClientEvent('Framework:serverCallback', playerId, requestId, ...)
    end, ...)
end)

function Framework.GetPlayerFromId(source)
    return Framework.Players[tonumber(source)]
end

function Framework.GetPlayerFromIdentifier(identifier)
    for k,v in pairs(Framework.Players) do
        if v.identifier == identifier then
            return v
        end
    end
end

function Framework.GetIdentifier(playerId)
    for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'license:') then
            local identifier = string.gsub(v, 'license:', '')
            return identifier
        end
    end
end

RegisterServerEvent('skin:save')
AddEventHandler('skin:save', function(skin)

    MySQL.Async.execute('UPDATE users SET `skin` = @skin WHERE license = @license',
            {
                ['@skin']       = json.encode(skin),
                ['@license'] = Framework.GetIdentifier(source)
            })
end)

RegisterServerEvent('Framework:SpawnPlayer')
AddEventHandler('Framework:SpawnPlayer', function()

    local _source = source

    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {['@license'] = Framework.GetIdentifier(_source)}, function(result)

        local SpawnCoords = json.decode(result[1].position)

        TriggerClientEvent("Framework:LastPosition", _source, SpawnCoords[1], SpawnCoords[2], SpawnCoords[3])

    end)

end)

RegisterServerEvent('Framework:SavePlayerPosition')
AddEventHandler('Framework:SavePlayerPosition', function(x, y, z)

    local _source = source

    MySQL.Async.execute('UPDATE users SET `position` = @position WHERE license = @license',
            {
                ['@position']       = "{ " .. x .. ", ".. y .. ", " .. z .." }",
                ['@license'] = Framework.GetIdentifier(_source)
            })
end)

Framework.RegisterServerCallback('skin:getPlayerSkin', function(source, cb)

    MySQL.Async.fetchAll('SELECT skin FROM users WHERE license = @license', {
        ['@license'] = Framework.GetIdentifier(source)
    }, function(users)
        local user = users[1]
        local skin = nil

        if user.skin ~= nil then
            skin = json.decode(user.skin)
        end

        cb(skin)
    end)
end)