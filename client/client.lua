Framework                        = {}
Framework.Player                 = {}
Framework.isPlayerLoaded         = false
Framework.RequestId              = 0
Framework.ServerCallbacks        = {}

function Framework.TriggerServerCallback(name, cb, ...)
    Framework.ServerCallbacks[Framework.RequestId] = cb

    TriggerServerEvent('Framework:triggerServerCallback', name, Core.CurrentRequestId, ...)

    if Framework.RequestId < 65535 then
        Framework.RequestId = Framework.RequestId + 1
    else
        Framework.RequestId = 0
    end
end
