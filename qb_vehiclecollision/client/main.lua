local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)

            if GetPedInVehicleSeat(vehicle, -1) == ped then
                if HasEntityCollidedWithAnything(vehicle) then
                    local speed = GetEntitySpeed(vehicle) * 2.23694 -- Convert to MPH

                    if speed > 20.0 then -- Only damage if above 20 MPH
                        local engineHealth = GetVehicleEngineHealth(vehicle)
                        local bodyHealth = GetVehicleBodyHealth(vehicle)
                        
                        -- Adjusted damage scaling for MPH
                        local damage = math.max((speed - 20.0) * 1.2, 0.0)

                        -- Calculate new health values
                        local newEngineHealth = math.max(engineHealth - damage, 100.0)
                        local newBodyHealth = math.max(bodyHealth - damage, 100.0)

                        -- Apply damage
                        SetVehicleEngineHealth(vehicle, newEngineHealth)
                        SetVehicleBodyHealth(vehicle, newBodyHealth)

                        -- Gradual engine failure logic
                        if newEngineHealth < 120.0 then
                            SetVehicleEngineOn(vehicle, false, true, true)
                            SetVehicleUndriveable(vehicle, true)
                            QBCore.Functions.Notify("❌ Your engine is completely dead! Call a mechanic.", "error", 7500)
                        elseif newEngineHealth < 300.0 then
                            QBCore.Functions.Notify("⚠️ Your engine is heavily damaged! It may stall soon.", "error", 5000)
                        end

                        Wait(1500)
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)
