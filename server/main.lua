RegisterNetEvent('rpa-housing:server:buyHouse', function(houseId)
    local src = source
    local player = exports['rpa-lib']:GetFramework().Functions.GetPlayer(src)
    local house = Config.Houses[houseId]
    
    if player.Functions.RemoveMoney('bank', house.price) then
        exports['rpa-lib']:Notify(src, "You bought " .. house.label, "success")
        -- Save to DB logic here
    else
        exports['rpa-lib']:Notify(src, "Not enough money", "error")
    end
end)
