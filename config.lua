Config = {}

-- Job name required to use the bus job
Config.JobName = "bus"

-- Two terminals configuration – each terminal has its own spawn, deposit, route (NPC locations), and reward
Config.Terminals = {
    [1] = {
         BusSpawn   = vector4(463.26, -628.77, 28.46, 171.41),   -- Terminal 1 spawn location
         BusDeposit = vector4(423.92, -610.68, 28.5, 138.99),    -- Terminal 1 deposit location
         NPCLocations = {
              Locations = {
                  vector4(410.17, -669.92, 29.29, 180.73),
                  vector4(353.57, -639.37, 29.09, 145.79),
				  vector4(355.82, -698.08, 29.21, 156.84)
              }
         },
         Reward = 100  -- Reward amount for Terminal 1
    },
    [2] = {
         BusSpawn   = vector4(362.85, -663.0, 29.34, 86.76),  -- Terminal 2 spawn location
         BusDeposit = vector4(362.85, -663.0, 29.34, 86.76),  -- Terminal 2 deposit location
         NPCLocations = {
              Locations = {
                  vector4(412.71, -577.75, 28.72, 323.06),
                  vector4(156.00, 256.00, 30.00, 45.00),
                  vector4(157.00, 257.00, 30.00, 90.00)
              }
         },
         Reward = 150  -- Reward amount for Terminal 2
    },
	    [3] = {
         BusSpawn   = vector4(-559.94, -2157.95, 5.99, 51.46),  -- Terminal 2 spawn location
         BusDeposit = vector4(-559.94, -2157.95, 5.99, 51.46),  -- Terminal 2 deposit location
         NPCLocations = {
              Locations = {
                  vector4(412.71, -577.75, 28.72, 323.06),
                  vector4(156.00, 256.00, 30.00, 45.00),
                  vector4(157.00, 257.00, 30.00, 90.00)
              }
         },
         Reward = 150  -- Reward amount for Terminal 2
    }
}

-- Allowed bus vehicles for the job
Config.AllowedVehicles = {
    { model = `bus`,   label = "City Bus" },
    { model = `coach`, label = "Coach Bus" }
}

-- Blip settings (for the bus terminal/depot)
Config.Blip = {
    Sprite = 513,
    Scale  = 0.6,
    Colour = 49,
    Name   = "Bus Depot"
}

-- NPC ped skins (grouped by gender)
Config.NpcSkins = {
    { -- Male skins
        `a_m_m_business_01`,
        `a_m_m_business_02`
    },
    { -- Female skins
        `a_f_y_business_01`,
        `a_f_y_business_02`
    }
}

-- Language / Notification stub (replace with your localization if needed)
Lang = {}
Lang.t = function(text) return text end