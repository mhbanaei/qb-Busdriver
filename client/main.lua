local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

-- Global variables for mission data
local currentTerminal = nil  -- will be set to 1 or 2 when a terminal is used
local route = 1              -- current route index for the active terminal
local max = 0                -- number of NPC locations for the active terminal
local busBlips = {}          -- table to store blips for each terminal

local NpcData = {
    Active = false,
    CurrentNpc = nil,
    LastNpc = nil,
    Npc = nil,
    NpcBlip = nil,
    PickupBlip = nil,
    NpcTaken = false,
    NpcDelivered = false,
    CountDown = 180
}

local BusData = {
    Active = false,
    Vehicle = nil,         -- Store the spawned bus vehicle
    PassengerOnBus = false -- Set to true when the NPC boards
}

--------------------------------------------------
-- Helper Functions
--------------------------------------------------
local function resetNpcTask()
    if NpcData.NpcBlip then RemoveBlip(NpcData.NpcBlip) end
    if NpcData.PickupBlip then RemoveBlip(NpcData.PickupBlip) end
    NpcData = {
        Active = false,
        CurrentNpc = nil,
        LastNpc = nil,
        Npc = nil,
        NpcBlip = nil,
        PickupBlip = nil,
        NpcTaken = false,
        NpcDelivered = false,
    }
    BusData.PassengerOnBus = false
end

-- Create blips for terminals (always visible if the player has the bus job)
local function updateBlips()
    if PlayerData.job and PlayerData.job.name == Config.JobName then
        for terminalID, termData in pairs(Config.Terminals) do
            if not busBlips[terminalID] then
                busBlips[terminalID] = AddBlipForCoord(termData.BusSpawn.x, termData.BusSpawn.y, termData.BusSpawn.z)
                SetBlipSprite(busBlips[terminalID], Config.Blip.Sprite)
                SetBlipDisplay(busBlips[terminalID], 4)
                SetBlipScale(busBlips[terminalID], Config.Blip.Scale)
                SetBlipAsShortRange(busBlips[terminalID], true)
                SetBlipColour(busBlips[terminalID], Config.Blip.Colour)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentSubstringPlayerName(Config.Blip.Name)
                EndTextCommandSetBlipName(busBlips[terminalID])
            end
        end
    else
        for k, v in pairs(busBlips) do
            RemoveBlip(v)
            busBlips[k] = nil
        end
    end
end

local function whitelistedVehicle()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local retval = false
    if veh and veh ~= 0 then
        local vehModel = GetEntityModel(veh)
        for i = 1, #Config.AllowedVehicles do
            if vehModel == Config.AllowedVehicles[i].model then
                retval = true
                break
            end
        end
    end
    return retval
end

-- Updated nextStop: اگر هنوز به انتها نرسیده باشد، اندیس را افزایش می‌دهد
local function nextStop()
    if route < max then
        route = route + 1
    end
end

-- Returns the active terminal's configuration.
local function getActiveTerminalConfig()
    return Config.Terminals[currentTerminal]
end

-- New function: GetPickupLocation
-- اگر هنوز مسیر به پایان نرسیده باشد، بلپ جدید ساخته می‌شود
local function GetPickupLocation()
    nextStop()  -- افزایش اندیس در صورت امکان
    local termConfig = getActiveTerminalConfig()
    local loc = termConfig.NPCLocations.Locations[route]
    
    if NpcData.PickupBlip then
        RemoveBlip(NpcData.PickupBlip)
        NpcData.PickupBlip = nil
    end

    NpcData.PickupBlip = AddBlipForCoord(loc.x, loc.y, loc.z)
    SetBlipColour(NpcData.PickupBlip, 3)
    SetBlipRoute(NpcData.PickupBlip, true)
    SetBlipRouteColour(NpcData.PickupBlip, 3)
    NpcData.LastPickup = route

    resetNpcTask()
    TriggerEvent('qb-busjob:client:DoBusNpc')
end

local function closeMenuFull()
    exports['qb-menu']:closeMenu()
end

--------------------------------------------------
-- Bus Menu & Vehicle Spawning
--------------------------------------------------
local function busGarage()
    local vehicleMenu = {
        { header = Lang.t('Tahvil Otubus Shahrdari'), isMenuHeader = true }
    }
    for _, v in pairs(Config.AllowedVehicles) do
        vehicleMenu[#vehicleMenu + 1] = {
            header = v.label,
            params = { event = "qb-busjob:client:TakeVehicle", args = { model = v.model } }
        }
    end
    vehicleMenu[#vehicleMenu + 1] = {
        header = Lang.t('Bastane Menu'),
        params = { event = "qb-menu:client:closeMenu" }
    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

RegisterNetEvent("qb-busjob:client:TakeVehicle", function(data)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.Notify("Zamani ke dar khodro hasti, nemitavanid khodro jadid spawn konid", "error")
        return
    end

    local termConfig = getActiveTerminalConfig()
    local coords = termConfig.BusSpawn
    local spawnPos = vector3(coords.x, coords.y, coords.z)
    local nearbyVehicle = GetClosestVehicle(spawnPos.x, spawnPos.y, spawnPos.z, 5.0, 0, 70)
    if nearbyVehicle and nearbyVehicle ~= 0 then
        QBCore.Functions.Notify("Dar Makane Spawn Khodroei Hast", "error")
        return
    end
    if BusData.Active then
        QBCore.Functions.Notify(Lang.t('Aval Otubos Ghabli Ro Tahvil Bedahid'), 'error')
        return
    else
        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
            local veh = NetToVeh(netId)
            SetVehicleNumberPlateText(veh, Lang.t('LS___BUS') .. tostring(math.random(1000, 9999)))
            exports['lc_fuel']:SetFuel(veh, 100.0)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
            SetVehicleEngineOn(veh, true, true)
            BusData.Active = true
            BusData.Vehicle = veh
            BusData.PassengerOnBus = false
        end, data.model, coords, true)
        Wait(1000)
        TriggerEvent('qb-busjob:client:DoBusNpc')
    end
end)

--------------------------------------------------
-- NPC Mission (Pickup)
--------------------------------------------------
RegisterNetEvent('qb-busjob:client:DoBusNpc', function()
    if whitelistedVehicle() then
        if not NpcData.Active then
            local Gender = math.random(1, #Config.NpcSkins)
            local PedSkin = math.random(1, #Config.NpcSkins[Gender])
            local model = Config.NpcSkins[Gender][PedSkin]
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end

            local termConfig = getActiveTerminalConfig()
            local loc = termConfig.NPCLocations.Locations[route]
            NpcData.Npc = CreatePed(3, model, loc.x, loc.y, loc.z - 0.98, loc.w, false, true)
            PlaceObjectOnGroundProperly(NpcData.Npc)
            FreezeEntityPosition(NpcData.Npc, true)
            if NpcData.NpcBlip then RemoveBlip(NpcData.NpcBlip) end
            QBCore.Functions.Notify(Lang.t('Be Istgah Harkat konid'), 'primary')
            NpcData.NpcBlip = AddBlipForCoord(loc.x, loc.y, loc.z)
            SetBlipColour(NpcData.NpcBlip, 3)
            SetBlipRoute(NpcData.NpcBlip, true)
            SetBlipRouteColour(NpcData.NpcBlip, 3)
            NpcData.LastNpc = route
            NpcData.Active = true

            local PolyZone = CircleZone:Create(vector3(loc.x, loc.y, loc.z), 5, {
                name = "busjobpickupzone",
                useZ = true,
                -- debugPoly = true
            })

            PolyZone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                    FreezeEntityPosition(veh, true)
                    QBCore.Functions.Notify("10 Saniye Zaman Savar Shodane Mosaferan ...", "primary")
                    Wait(10000)  -- 10 ثانیه صبر جهت سوارسازی
                    FreezeEntityPosition(veh, false)
                    
                    local ped = PlayerPedId()
                    veh = GetVehiclePedIsIn(ped, false)
                    local maxSeats = GetVehicleMaxNumberOfPassengers(veh)
                    local freeSeat = nil
                    for i = maxSeats - 1, 0, -1 do
                        if IsVehicleSeatFree(veh, i) then
                            freeSeat = i
                            break
                        end
                    end
                    if freeSeat == nil then
                        for seat = 0, maxSeats - 1 do
                            if not IsVehicleSeatFree(veh, seat) then
                                local occupant = GetPedInVehicleSeat(veh, seat)
                                if occupant and occupant ~= 0 then
                                    TaskLeaveVehicle(occupant, veh, 16)
                                end
                            end
                        end
                        Wait(2000)
                        freeSeat = nil
                        for i = maxSeats - 1, 0, -1 do
                            if IsVehicleSeatFree(veh, i) then
                                freeSeat = i
                                break
                            end
                        end
                    end
                    ClearPedTasksImmediately(NpcData.Npc)
                    FreezeEntityPosition(NpcData.Npc, false)
                    TaskEnterVehicle(NpcData.Npc, veh, -1, freeSeat, 1.0, 0)
                    BusData.PassengerOnBus = true
                    if NpcData.NpcBlip then RemoveBlip(NpcData.NpcBlip) end

                    -- اگر هنوز مسیر کامل نشده باشد، تنظیم نقطه برداشت بعدی انجام می‌شود
                    if route < max then
                        GetPickupLocation()
                    else
                        QBCore.Functions.Notify("Shoma Khat Terminal Ro Tey Kardid , Khodro Ro be Terminal Tahvil Bedahid", "success")
                    end
                    NpcData.NpcTaken = true

                    QBCore.Functions.TriggerCallback('qb-busjob:server:GetTerminalReward', function(reward)
                        TriggerServerEvent('qb-busjob:server:AddMoney', reward)
                    end, currentTerminal)

                    TriggerServerEvent('qb-busjob:server:NpcPay')
                    exports["qb-core"]:HideText()
                    PolyZone:destroy()
                else
                    exports["qb-core"]:HideText()
                end
            end)
        else
            QBCore.Functions.Notify(Lang.t('Dar hale Ranandegi hastid!'), 'error')
        end
    else
        QBCore.Functions.Notify(Lang.t('Dakhele Otubus Nistid'), 'error')
    end
end)

--------------------------------------------------
-- Terminal Zones – Spawn and Deposit
--------------------------------------------------
for terminalID, termData in pairs(Config.Terminals) do
    CreateThread(function()
        local inRange = false
        local spawnZone = CircleZone:Create(vector3(termData.BusSpawn.x, termData.BusSpawn.y, termData.BusSpawn.z), 5, {
            name = "busSpawnZone_" .. terminalID,
            useZ = true,
            debugPoly = false
        })
        spawnZone:onPlayerInOut(function(isPointInside)
            inRange = isPointInside
            if isPointInside and PlayerData.job and PlayerData.job.name == Config.JobName then
                exports["qb-core"]:DrawText("E Bezan Ta Otubus Ro Tahvil Begiri/Bedi (Terminal " .. terminalID .. ")", "left")
            else
                exports["qb-core"]:HideText()
            end
        end)
        while true do
            Wait(5)
            if inRange and PlayerData.job and PlayerData.job.name == Config.JobName then
                if IsControlJustReleased(0, 38) then
                    currentTerminal = terminalID
                    route = 1
                    max = #termData.NPCLocations.Locations
                    busGarage()
                    exports["qb-core"]:HideText()
                end
            end
        end
    end)
end

for terminalID, termData in pairs(Config.Terminals) do
    CreateThread(function()
        local inRange = false
        local depositZone = CircleZone:Create(vector3(termData.BusDeposit.x, termData.BusDeposit.y, termData.BusDeposit.z), 5, {
            name = "busDepositZone_" .. terminalID,
            useZ = true,
            debugPoly = false
        })
        depositZone:onPlayerInOut(function(isPointInside)
            inRange = isPointInside
            if isPointInside and PlayerData.job and PlayerData.job.name == Config.JobName then
                exports["qb-core"]:DrawText("E Bezan Ta Otubus Ro Tahvil Begiri/Bedi (Terminal " .. terminalID .. ")", "left")
            else
                exports["qb-core"]:HideText()
            end
        end)
        while true do
            Wait(5)
            if inRange and PlayerData.job and PlayerData.job.name == Config.JobName then
                if IsControlJustReleased(0, 38) then
                    if BusData.Active and BusData.Vehicle and DoesEntityExist(BusData.Vehicle) then
                        TriggerEvent("vehiclekeys:client:RemoveOwner", QBCore.Functions.GetPlate(BusData.Vehicle))
                        QBCore.Functions.Notify("Dar Hale Tahvil Otubos Va Piyade Shodane Mosafer Ha ..", "primary")
                        CreateThread(function()
                             Wait(5000)  -- Wait 5 seconds before deleting passengers
                             local maxSeats = GetVehicleMaxNumberOfPassengers(BusData.Vehicle)
                             for seat = -1, maxSeats - 1 do
                                 local ped = GetPedInVehicleSeat(BusData.Vehicle, seat)
                                 if ped and ped ~= 0 and ped ~= PlayerPedId() then
                                     DeletePed(ped)
                                 end
                             end
                             if NpcData.Npc and DoesEntityExist(NpcData.Npc) then
                                 DeletePed(NpcData.Npc)
                                 NpcData.Npc = nil
                             end
                             DeleteVehicle(BusData.Vehicle)
                             BusData.Active = false
                             BusData.Vehicle = nil
                             QBCore.Functions.Notify("Otubus Ro Tahvil Dadid!", "success")
                        end)
                    else
                        QBCore.Functions.Notify("Otubos Khadamati Ro Entekhab Konid", "error")
                    end
                end
            end
        end
    end)
end

--------------------------------------------------
-- Mission Cancellation Monitor
--------------------------------------------------
CreateThread(function()
    while true do
        Wait(1000)
        if NpcData.Active then
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                local timeOut = 1
                local timer = 0
                while timer < timeOut do
                    Wait(1000)
                    if IsPedInAnyVehicle(PlayerPedId(), false) then break end
                    timer = timer + 1
                end
                if timer >= timeOut and not IsPedInAnyVehicle(PlayerPedId(), false) then
                    QBCore.Functions.Notify("Chon Otubus Ro Tark Kardid , Kar Az Shoma Gerefte Shod !", "error")
                    if NpcData.NpcBlip then RemoveBlip(NpcData.NpcBlip) NpcData.NpcBlip = nil end
                    if NpcData.PickupBlip then RemoveBlip(NpcData.PickupBlip) NpcData.PickupBlip = nil end
                    if NpcData.Npc and DoesEntityExist(NpcData.Npc) then
                        DeletePed(NpcData.Npc)
                    end
                    resetNpcTask()
                    if BusData.Active and BusData.Vehicle and DoesEntityExist(BusData.Vehicle) then
                        DeleteVehicle(BusData.Vehicle)
                        BusData.Active = false
                        BusData.Vehicle = nil
                        BusData.PassengerOnBus = false
                    end
                end
            end
        end
    end
end)

--------------------------------------------------
-- Resource & Job Event Handlers
--------------------------------------------------
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        updateBlips()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    updateBlips()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    updateBlips()
end)

--------------------------------------------------
-- (Optional) Command to print current Terminal Configs
--------------------------------------------------
RegisterCommand("printbusconfig", function()
    print("======== Bus Job Terminals Config ========")
    for id, term in pairs(Config.Terminals) do
        print("Terminal " .. id .. " Spawn: " .. tostring(term.BusSpawn))
        print("Terminal " .. id .. " Deposit: " .. tostring(term.BusDeposit))
        print("Terminal " .. id .. " NPC Locations:")
        for i, loc in ipairs(term.NPCLocations.Locations) do
            print(i, tostring(loc))
        end
    end
    QBCore.Functions.Notify("Bus Terminal configuration printed to console.", "success")
end, false)
