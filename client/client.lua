Framework                        = {}
Framework.Player                 = {}
Framework.LastSkin               = nil
Framework.skinLoaded             = false
Framework.isPlayerLoaded         = false
Framework.RequestId              = 0
Framework.ServerCallbacks        = {}

AddEventHandler('Framework:getSharedObject', function(cb)
    cb(Framework)
end)

function Framework.TriggerServerCallback(name, cb, ...)
    Framework.ServerCallbacks[Framework.RequestId] = cb

    TriggerServerEvent('Framework:triggerServerCallback', name, Framework.RequestId, ...)

    if Framework.RequestId < 65535 then
        Framework.RequestId = Framework.RequestId + 1
    else
        Framework.RequestId = 0
    end
end

RegisterNetEvent('Framework:serverCallback')
AddEventHandler('Framework:serverCallback', function(requestId, ...)
    Framework.ServerCallbacks[requestId](...)
    Framework.ServerCallbacks[requestId] = nil
end)

AddEventHandler('playerSpawned', function()
    Citizen.CreateThread(function()

        Framework.TriggerServerCallback('skin:getPlayerSkin', function(skin, jobSkin)
            if skin == nil then
                Citizen.Wait(100)
                Framework.skinLoaded = true
            else
                Citizen.Wait(100)
                Framework.skinLoaded = true
            end

        end)

    end)
end)

AddEventHandler('skin:getLastSkin', function(cb)
    cb(Framework.LastSkin)
end)

AddEventHandler('skin:setLastSkin', function(skin)
    Framework.LastSkin = skin
end)
