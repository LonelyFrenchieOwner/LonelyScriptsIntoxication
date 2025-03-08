local drunkLevel = 0
local isDrunkActive = false

RegisterNetEvent("drunkdrive:setDrunkLevel")
AddEventHandler("drunkdrive:setDrunkLevel", function(level)
    if level == 0 then
        clearDrunkEffects()
        return
    end
    local p = PlayerPedId()
    if not IsPedInAnyVehicle(p, false) then
        TriggerEvent('chat:addMessage', {args = {"^1Error:", "You must be in a vehicle (driver's seat) to use /intoxicated!"}})
        return
    end
    local v = GetVehiclePedIsIn(p, false)
    if GetPedInVehicleSeat(v, -1) ~= p then
        TriggerEvent('chat:addMessage', {args = {"^1Error:", "You must be the driver to use /intoxicated!"}})
        return
    end
    if not Config.DrunkLevels[level] then
        TriggerEvent('chat:addMessage', {args = {"^1Error:", "Drunk level must be 1, 2, or 3."}})
        return
    end
    drunkLevel = level
    activateDrunkEffects()
end)

function activateDrunkEffects()
    if isDrunkActive then return end
    isDrunkActive = true
    local d = Config.DrunkLevels[drunkLevel]
    SetTimecycleModifier(d.timecycle)
    SetTimecycleModifierStrength(d.timecycleStrength)
    ShakeGameplayCam("DRUNK_SHAKE", d.shakeIntensity)
    if d.screenEffect then
        StartScreenEffect(d.screenEffect, 0, true)
    end
    SetPedMotionBlur(PlayerPedId(), true)
    SetPedIsDrunk(PlayerPedId(), true)
    Citizen.CreateThread(function()
        while drunkLevel > 0 do
            local p = PlayerPedId()
            if IsPedInAnyVehicle(p, false) then
                local vv = GetVehiclePedIsIn(p, false)
                if vv ~= 0 and GetPedInVehicleSeat(vv, -1) == p then
                    applyRandomDrunkEffect(vv, drunkLevel)
                end
            end
            Citizen.Wait(Config.DrunkVehicleTick)
        end
    end)
end

function clearDrunkEffects()
    drunkLevel = 0
    isDrunkActive = false
    ClearTimecycleModifier()
    StopGameplayCamShaking(true)
    for lvl, data in pairs(Config.DrunkLevels) do
        if data.screenEffect then
            StopScreenEffect(data.screenEffect)
        end
    end
    SetPedMotionBlur(PlayerPedId(), false)
    SetPedIsDrunk(PlayerPedId(), false)
end

function applyRandomDrunkEffect(v, lvl)
    local d = Config.DrunkLevels[lvl]
    local s = GetEntitySpeed(v)
    if s < Config.MinSpeedForEffects then return end
    local r = math.random(1, 100)
    if r <= d.swerveChance then
        forcedSwerve(v, math.random() > 0.5 and 1.0 or -1.0, d.swerveDuration)
    elseif r <= (d.swerveChance + d.handbrakeChance) then
        quickHandbrake(v, 600)
    else
        invertSteeringFor(d.invertDuration)
    end
end

function forcedSwerve(v, dir, dur)
    Citizen.CreateThread(function()
        local e = GetGameTimer() + dur
        while GetGameTimer() < e and drunkLevel > 0 do
            DisableControlAction(0, 59, true)
            SetVehicleSteerBias(v, dir)
            Citizen.Wait(0)
        end
        SetVehicleSteerBias(v, 0.0)
    end)
end

function quickHandbrake(v, dur)
    Citizen.CreateThread(function()
        SetVehicleHandbrake(v, true)
        Citizen.Wait(dur)
        SetVehicleHandbrake(v, false)
    end)
end

function invertSteeringFor(dur)
    Citizen.CreateThread(function()
        local e = GetGameTimer() + dur
        while GetGameTimer() < e and drunkLevel > 0 do
            local p = PlayerPedId()
            local vv = GetVehiclePedIsIn(p, false)
            if vv ~= 0 and GetPedInVehicleSeat(vv, -1) == p then
                DisableControlAction(0, 59, true)
                local st = GetDisabledControlNormal(0, 59)
                if st < -0.1 then
                    SetVehicleSteerBias(vv, 1.0)
                elseif st > 0.1 then
                    SetVehicleSteerBias(vv, -1.0)
                else
                    SetVehicleSteerBias(vv, 0.0)
                end
            end
            Citizen.Wait(0)
        end
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            SetVehicleSteerBias(veh, 0.0)
        end
    end)
end
