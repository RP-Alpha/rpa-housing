local currentHouse = nil
local spawnedShell = nil
local HouseOwnership = {} -- Cache: [houseId] = citizenid

-- Sync ownership from server
RegisterNetEvent('rpa-housing:client:updateOwnership', function(houseId, citizenid)
    HouseOwnership[houseId] = citizenid
end)

-- Ownership check result
RegisterNetEvent('rpa-housing:client:ownershipResult', function(houseId, isOwner, isOwned)
    if isOwner then
        currentHouse = houseId
        CreateShell(Config.Houses[houseId])
    elseif isOwned then
        exports['rpa-lib']:Notify("This house is owned by someone else", "error")
    else
        exports['rpa-lib']:Notify("You don't own this house", "error")
    end
end)

local function CreateShell(spawnInfo)
    local model = Config.Shells[spawnInfo.tier].model
    
    -- Load shell model with timeout
    local hash = GetHashKey(model)
    if IsModelValid(hash) then
        RequestModel(hash)
        local timeout = 0
        while not HasModelLoaded(hash) and timeout < 500 do
            Wait(10)
            timeout = timeout + 1
        end
        
        if HasModelLoaded(hash) then
            -- Spawn shell prop below ground
            local shellCoords = vector3(spawnInfo.coords.x, spawnInfo.coords.y, spawnInfo.coords.z - 50.0)
            spawnedShell = CreateObject(hash, shellCoords.x, shellCoords.y, shellCoords.z, false, false, false)
            FreezeEntityPosition(spawnedShell, true)
            SetEntityCoords(PlayerPedId(), shellCoords.x, shellCoords.y, shellCoords.z + 1.0)
        else
            -- Fallback: TP to underground coords without shell
            local shellCoords = vector3(spawnInfo.coords.x, spawnInfo.coords.y, spawnInfo.coords.z - 50.0)
            SetEntityCoords(PlayerPedId(), shellCoords.x, shellCoords.y, shellCoords.z)
        end
    else
        -- Fallback for testing without shell props
        local shellCoords = vector3(spawnInfo.coords.x, spawnInfo.coords.y, spawnInfo.coords.z - 50.0)
        SetEntityCoords(PlayerPedId(), shellCoords.x, shellCoords.y, shellCoords.z)
    end
    
    -- Target to leave
    exports['rpa-lib']:AddTargetZone('house_exit', GetEntityCoords(PlayerPedId()), vector3(1, 1, 2), {
        options = {
            {
                label = "Leave House",
                icon = "fas fa-door-open",
                action = function()
                    SetEntityCoords(PlayerPedId(), spawnInfo.coords.x, spawnInfo.coords.y, spawnInfo.coords.z)
                    exports['rpa-lib']:RemoveZone('house_exit')
                    
                    -- Cleanup shell
                    if spawnedShell and DoesEntityExist(spawnedShell) then
                        DeleteEntity(spawnedShell)
                        spawnedShell = nil
                    end
                    
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
                        -- Request ownership check from server
                        TriggerServerEvent('rpa-housing:server:checkOwnership', id)
                    end
                },
                {
                    label = "Buy House ($" .. house.price .. ")",
                    icon = "fas fa-money-bill",
                    action = function()
                        TriggerServerEvent('rpa-housing:server:buyHouse', id)
                    end,
                    canInteract = function()
                        return HouseOwnership[id] == nil
                    end
                },
                {
                    label = "Sell House",
                    icon = "fas fa-hand-holding-usd",
                    action = function()
                        TriggerServerEvent('rpa-housing:server:sellHouse', id)
                    end,
                    canInteract = function()
                        -- Only show if player owns this house (basic check, server validates)
                        local citizenid = exports['rpa-lib']:GetFramework().Functions.GetPlayerData().citizenid
                        return HouseOwnership[id] == citizenid
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
