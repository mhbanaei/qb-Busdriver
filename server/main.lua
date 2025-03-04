local QBCore = exports['qb-core']:GetCoreObject()

-- Event to add money to the player's bank account
RegisterNetEvent('qb-busjob:server:AddMoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddMoney('bank', amount, "Bus Job Payment")
    end
end)

-- Event to fetch the terminal's reward amount
QBCore.Functions.CreateCallback('qb-busjob:server:GetTerminalReward', function(source, cb, terminalID)
    local terminalReward = Config.Terminals[terminalID].Reward
    cb(terminalReward)
end)