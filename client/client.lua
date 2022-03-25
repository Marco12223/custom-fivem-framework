Framework                        = {}
Framework.Player                 = {}
Framework.LastSkin               = nil
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

AddEventHandler('playerSpawned', function()
    Citizen.CreateThread(function()

        Framework.TriggerServerCallback('skin:getPlayerSkin', function(skin, jobSkin)
            if skin == nil then
                TriggerEvent("myCreator:openMenu")
                --TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
                Citizen.Wait(100)
                skinLoaded = true
            else
                TriggerEvent('skinchanger:loadSkin', skin)
                Citizen.Wait(100)
                skinLoaded = true
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
