Framework                        = {}
Framework.Player                 = {}
Framework.LastSkin               = nil
Framework.skinLoaded             = false
Framework.isPlayerLoaded         = false
Framework.isPlayerSpawned        = false
Framework.RequestId              = 0
Framework.ServerCallbacks        = {}

Citizen.CreateThread(function()

    exports.spawnmanager:setAutoSpawn(false)

end)

AddEventHandler('Framework:getSharedObject', function(cb)
    cb(Framework)
end)

AddEventHandler('skin:getLastSkin', function(cb)
    cb(Framework.LastSkin)
end)

AddEventHandler('skin:setLastSkin', function(skin)
    Framework.LastSkin = skin
end)

RegisterNetEvent('Framework:LastPosition')
AddEventHandler('Framework:LastPosition', function(PosX, PosY, PosZ)

    Citizen.Wait(1)
    SetEntityCoords(GetPlayerPed(PlayerId()), PosX, PosY, PosZ, 1, 0,0, 1)

end)

RegisterNetEvent('Framework:serverCallback')
AddEventHandler('Framework:serverCallback', function(requestId, ...)
    Framework.ServerCallbacks[requestId](...)
    Framework.ServerCallbacks[requestId] = nil
end)

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent("Framework:SpawnPlayer")
end)

--- INIT EXISTED PLAYER

AddEventHandler('playerSpawned', function()
    Citizen.CreateThread(function()

        Framework.TriggerServerCallback('skin:getPlayerSkin', function(skin)
            if skin ~= nil then
                TriggerEvent('skinchanger:loadSkin', skin)
                Citizen.Wait(100)
                Framework.skinLoaded = true

                TriggerServerEvent("Framework:SpawnPlayer")

            end

        end)

    end)
end)

--- FUNCTIONS

function RequestToSave()

    local Coords = GetEntityCoords(GetPlayerPed(-1), true)
    TriggerServerEvent("Framework:SavePlayerPosition", Coords.x, Coords.y, Coords.z)

end

function Framework.TriggerServerCallback(name, cb, ...)
    Framework.ServerCallbacks[Framework.RequestId] = cb

    TriggerServerEvent('Framework:triggerServerCallback', name, Framework.RequestId, ...)

    if Framework.RequestId < 65535 then
        Framework.RequestId = Framework.RequestId + 1
    else
        Framework.RequestId = 0
    end
end

--- Threads

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(5000)
        RequestToSave()

    end
end)
