RegisterCommand("intoxicated", function(source, args, rawCommand)
    local src = source
    local level = tonumber(args[1])
    if not level then
        TriggerClientEvent('chat:addMessage', src, {args = {"^1Usage:", "/intoxicated [1-3]"}})
        return
    end
    if level < 1 or level > 3 then
        TriggerClientEvent('chat:addMessage', src, {args = {"^1Error:", "Level must be between 1 and 3"}})
        return
    end
    TriggerClientEvent("drunkdrive:setDrunkLevel", src, level)
end)

RegisterCommand("sober", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent("drunkdrive:setDrunkLevel", src, 0)
end)
