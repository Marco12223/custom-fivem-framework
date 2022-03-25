Framework                        = {}
Framework.Players                = {}
Framework.Jobs                   = {}
Framework.Items                  = {}
Framework.ServerCallbacks        = {}

RegisterNetEvent('Framework:onPlayerJoined')
AddEventHandler('Framework:onPlayerJoined', function()
    while not next(Framework.Jobs) do Wait(50) end

    if not Framework.Players[source] then
        onPlayerJoined(source)
    end
end)

function onPlayerJoined(playerId)
    local identifier = Framework.GetIdentifier(playerId)
    if identifier then
        if Framework.GetPlayerFromIdentifier(identifier) then
            DropPlayer(playerId, ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(identifier))
        else
            table.insert(Framework.Players, playerId)
        end
    else
        DropPlayer(playerId, 'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
    end
end

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

Framework.RegisterServerCallback('skin:getPlayerSkin', function(source, cb)

    MySQL.Async.fetchAll('SELECT skin FROM users WHERE license = @license', {
        ['@license'] = Framework.GetIdentifier(source)
    }, function(users)
        local user = users[1]
        local skin = nil

        if user.skin ~= nil then
            skin = json.decode(user.skin)
        end

        cb(skin, jobSkin)
    end)
end)