local currentHouse = nil
local spawnedShell = nil

local function CreateShell(spawnInfo)
    local model = Config.Shells[spawnInfo.tier].model
    -- For testing without real shell props, we won't actually spawn object but just TP to a location
    -- In real impl: Spawn object at Z - 50, freeze it
    
    local shellCoords = vector3(spawnInfo.coords.x, spawnInfo.coords.y, spawnInfo.coords.z - 50.0)
    SetEntityCoords(PlayerPedId(), shellCoords.x, shellCoords.y, shellCoords.z)
    
    -- Target to leave
    exports['rpa-lib']:AddTargetZone('house_exit', shellCoords, vector3(1, 1, 2), {
        options = {
            {
                label = "Leave House",
                icon = "fas fa-door-open",
                action = function()
                    SetEntityCoords(PlayerPedId(), spawnInfo.coords.x, spawnInfo.coords.y, spawnInfo.coords.z)
                    exports['rpa-lib']:RemoveZone('house_exit')
                    currentHouse = nil
                end
            }
        }
    }, false)
end

CreateThread(function()
    for id, house in pairs(Config.Houses) do
        exports['rpa-lib']:AddTargetZone('house_'..id, house.coords, vector3(1, 1, 2), {
            options = {
                {
                    label = "Enter House",
                    icon = "fas fa-door-closed",
                    action = function()
                        currentHouse = id
                        CreateShell(house)
                    end
                },
                {
                    label = "Buy House",
                    icon = "fas fa-money-bill",
                    action = function()
                        TriggerServerEvent('rpa-housing:server:buyHouse', id)
                    end
                }
            }
        }, false)
        
        -- Blip
        local blip = AddBlipForCoord(house.coords.x, house.coords.y, house.coords.z)
        SetBlipSprite(blip, 40)
        SetBlipScale(blip, 0.6)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
    end
end)
