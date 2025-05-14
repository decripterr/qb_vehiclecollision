local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("qb_vehiclecollision:logCrash", function(data)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return end

    local coords = data.location
    local logMessage = string.format(
        "[VEHICLE COLLISION] %s (%s) crashed vehicle [%s] at %.2f km/h | Damage: %.1f | Engine: %.1f | Body: %.1f | Location: %.2f, %.2f, %.2f",
        player.PlayerData.name,
        player.PlayerData.citizenid,
        data.plate,
        data.speed,
        data.damage,
        data.engineHealth,
        data.bodyHealth,
        coords.x, coords.y, coords.z
    )

    print(logMessage)

    -- 🛠️ Set vehicle metadata: damage = true
    MySQL.Async.execute(
        'UPDATE player_vehicles SET metadata = JSON_SET(COALESCE(metadata, "{}"), "$.damage", true) WHERE plate = ?',
        { data.plate }
    )

    -- 🔔 Alert mechanics
    TriggerClientEvent("qb_vehiclecollision:mechanicAlert", -1, {
        plate = data.plate,
        location = coords,
        name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    })
end)
