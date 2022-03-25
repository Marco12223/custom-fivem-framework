Framework                        = {}
Framework.Players                = {}
Framework.Jobs                   = {}
Framework.Items                  = {}
Framework.ServerCallbacks        = {}

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