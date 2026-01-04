-- House ownership storage
local HouseOwners = {} -- Cache: [houseId] = citizenid

-- Load house ownership from database on startup
CreateThread(function()
    Wait(1000) -- Wait for MySQL to be ready
    MySQL.query('SELECT * FROM rpa_housing', {}, function(result)
        if result then
            for _, house in ipairs(result) do
                HouseOwners[house.house_id] = house.citizenid
            end
            print('[rpa-housing] Loaded ' .. #result .. ' house ownerships')
        end
    end)
end)

-- Get player helper
local function GetPlayer(src)
    local Framework = exports['rpa-lib']:GetFramework()
    if Framework then
        return Framework.Functions.GetPlayer(src)
    end
    return nil
end

-- Check if a house is owned
local function IsHouseOwned(houseId)
    return HouseOwners[houseId] ~= nil
end

-- Check if player owns a specific house
local function DoesPlayerOwnHouse(citizenid, houseId)
    return HouseOwners[houseId] == citizenid
end

-- Get all houses owned by a player
local function GetPlayerHouses(citizenid)
    local houses = {}
    for houseId, owner in pairs(HouseOwners) do
        if owner == citizenid then
            table.insert(houses, houseId)
        end
    end
    return houses
end

-- Buy a house
RegisterNetEvent('rpa-housing:server:buyHouse', function(houseId)
    local src = source
    local player = GetPlayer(src)
    local house = Config.Houses[houseId]
    
    if not player then return end
    if not house then
        exports['rpa-lib']:Notify(src, "Invalid house", "error")
        return
    end
    
    local citizenid = player.PlayerData.citizenid
    
    -- Check if already owned
    if IsHouseOwned(houseId) then
        if DoesPlayerOwnHouse(citizenid, houseId) then
            exports['rpa-lib']:Notify(src, "You already own this house", "error")
        else
            exports['rpa-lib']:Notify(src, "This house is already owned", "error")
        end
        return
    end
    
    -- Try to remove money
    if player.Functions.RemoveMoney('bank', house.price) then
        -- Save to database
        MySQL.insert('INSERT INTO rpa_housing (house_id, citizenid, purchase_date) VALUES (?, ?, NOW())', {
            houseId,
            citizenid
        }, function(id)
            if id then
                HouseOwners[houseId] = citizenid
                exports['rpa-lib']:Notify(src, "You bought " .. house.label .. " for $" .. house.price, "success")
                TriggerClientEvent('rpa-housing:client:updateOwnership', -1, houseId, citizenid)
            else
                -- Refund if DB insert failed
                player.Functions.AddMoney('bank', house.price)
                exports['rpa-lib']:Notify(src, "Purchase failed, please try again", "error")
            end
        end)
    else
        exports['rpa-lib']:Notify(src, "Not enough money ($" .. house.price .. " required)", "error")
    end
end)

-- Sell a house
RegisterNetEvent('rpa-housing:server:sellHouse', function(houseId)
    local src = source
    local player = GetPlayer(src)
    local house = Config.Houses[houseId]
    
    if not player or not house then return end
    
    local citizenid = player.PlayerData.citizenid
    
    if not DoesPlayerOwnHouse(citizenid, houseId) then
        exports['rpa-lib']:Notify(src, "You don't own this house", "error")
        return
    end
    
    local sellPrice = math.floor(house.price * 0.7) -- 70% of purchase price
    
    MySQL.query('DELETE FROM rpa_housing WHERE house_id = ? AND citizenid = ?', {
        houseId,
        citizenid
    }, function(result)
        if result and result.affectedRows > 0 then
            HouseOwners[houseId] = nil
            player.Functions.AddMoney('bank', sellPrice)
            exports['rpa-lib']:Notify(src, "Sold " .. house.label .. " for $" .. sellPrice, "success")
            TriggerClientEvent('rpa-housing:client:updateOwnership', -1, houseId, nil)
        end
    end)
end)

-- Check ownership (callback)
RegisterNetEvent('rpa-housing:server:checkOwnership', function(houseId)
    local src = source
    local player = GetPlayer(src)
    
    if not player then return end
    
    local citizenid = player.PlayerData.citizenid
    local isOwner = DoesPlayerOwnHouse(citizenid, houseId)
    local ownerName = nil
    
    TriggerClientEvent('rpa-housing:client:ownershipResult', src, houseId, isOwner, IsHouseOwned(houseId))
end)

-- Exports
exports('IsHouseOwned', IsHouseOwned)
exports('DoesPlayerOwnHouse', DoesPlayerOwnHouse)
exports('GetPlayerHouses', GetPlayerHouses)
