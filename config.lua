Config = {}

-- Job name required to use the bus job
Config.JobName = "bus"

-- Two terminals configuration – each terminal has its own spawn, deposit, route (NPC locations), and reward
Config.Terminals = {
    [1] = {
         BusSpawn   = vector4(464.99, -639.28, 28.5, 175.00),   -- Terminal 1 spawn location
         BusDeposit = vector4(464.99, -639.28, 28.5, 175.00),    -- Terminal 1 deposit location
         NPCLocations = {
              Locations = {
				  vector4(304.42, -765.22, 29.31, 246.76),
                  vector4(251.73, -643.92, 39.93, 72.23),
                  vector4(-52.09, -100.12, 57.81, 166.94),
				  vector4(-384.56, -197.19, 36.67, 210.58),
				  vector4(-851.84, -1253.18, 5.15, 149.38)  -- akhar khat 1 va aghaz khat 2
              }
         },
         Reward = 100  -- Reward amount for Terminal 1
    },
    [2] = {
         BusSpawn   = vector4(-853.25, -1255.21, 5.0, 230.00),  -- Terminal 2 spawn location
         BusDeposit = vector4(-853.25, -1255.21, 5.0, 230.00),  -- Terminal 2 deposit location
         NPCLocations = {
              Locations = {
                  vector4(-799.85, -1335.81, 5.15, 357.89),
                  vector4(-307.19, -868.51, 31.71, 352.7),
                  vector4(355.55, -1067.36, 29.57, 0.88),
				  vector4(786.47, -1225.01, 26.29, 277.58),
				  vector4(436.72, -1592.14, 29.29, 144.3),
				  vector4(204.57, -1405.84, 29.29, 156.84),
				  vector4(227.9, -1072.76, 29.28, 78.74),
				  vector4(469.44, -639.58, 28.5, 90.67) -- Akhare khat 2 va aghaz khat 1
              }
         },
         Reward = 150  -- Reward amount for Terminal 2
    },
	    [3] = {
         BusSpawn   = vector4(-559.94, -2157.95, 5.99, 51.46),  -- Terminal 3 spawn location
         BusDeposit = vector4(-559.94, -2157.95, 5.99, 51.46),  -- Terminal 3 deposit location
         NPCLocations = {
              Locations = {
                  vector4(-2978.65, 388.99, 15.01, 76.87),
				  vector4(-2210.4, 4286.42, 47.95, 64.16),
				  vector4(-70.33, 6452.14, 31.42, 56.24),
                  vector4(1935.18, 3717.23, 32.32, 213.83),
				  vector4(2555.62, 479.9, 108.58, 277.21),
				  vector4(427.39, -1584.13, 29.33, 147.57),
				  vector4(-555.83, -2157.76, 5.99, 150.33)
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
        `ig_barry`,
        `ig_bestmen`,
        `ig_beverly`,
        `ig_car3guy1`,
        `ig_car3guy2`,
        `ig_casey`,
        `ig_chef`,
        `ig_chengsr`,
        `ig_chrisformage`,
        `ig_clay`,
        `ig_claypain`,
        `ig_cletus`,
        `ig_dale`,
        `ig_dreyfuss`,
        `ig_fbisuit_01`,
        `ig_floyd`,
        `ig_groom`,
        `ig_hao`,
        `ig_hunter`,
        `csb_prolsec`,
        `ig_joeminuteman`,
        `ig_josef`,
        `ig_josh`,
        `ig_lamardavis`,
        `ig_lazlow`,
        `ig_lestercrest`,
        `ig_lifeinvad_01`,
        `ig_lifeinvad_02`,
        `ig_manuel`,
        `ig_milton`,
        `ig_mrk`,
        `ig_nervousron`,
        `ig_nigel`,
        `ig_old_man1a`,
        `ig_old_man2`,
        `ig_oneil`,
        `ig_orleans`,
        `ig_ortega`,
        `ig_paper`,
        `ig_priest`,
        `ig_prolsec_02`,
        `ig_ramp_gang`,
        `ig_ramp_hic`,
        `ig_ramp_hipster`,
        `ig_ramp_mex`,
        `ig_roccopelosi`,
        `ig_russiandrunk`,
        `ig_siemonyetarian`,
        `ig_solomon`,
        `ig_stevehains`,
        `ig_stretch`,
        `ig_talina`,
        `ig_taocheng`,
        `ig_taostranslator`,
        `ig_tenniscoach`,
        `ig_terry`,
        `ig_tomepsilon`,
        `ig_tylerdix`,
        `ig_wade`,
        `ig_zimbor`,
        `s_m_m_paramedic_01`,
        `a_m_m_afriamer_01`,
        `a_m_m_beach_01`,
        `a_m_m_beach_02`,
        `a_m_m_bevhills_01`,
        `a_m_m_bevhills_02`,
        `a_m_m_business_01`,
        `a_m_m_eastsa_01`,
        `a_m_m_eastsa_02`,
        `a_m_m_farmer_01`,
        `a_m_m_fatlatin_01`,
        `a_m_m_genfat_01`,
        `a_m_m_genfat_02`,
        `a_m_m_golfer_01`,
        `a_m_m_hasjew_01`,
        `a_m_m_hillbilly_01`,
        `a_m_m_hillbilly_02`,
        `a_m_m_indian_01`,
        `a_m_m_ktown_01`,
        `a_m_m_malibu_01`,
        `a_m_m_mexcntry_01`,
        `a_m_m_mexlabor_01`,
        `a_m_m_og_boss_01`,
        `a_m_m_paparazzi_01`,
        `a_m_m_polynesian_01`,
        `a_m_m_prolhost_01`,
        `a_m_m_rurmeth_01`,
    },
    { -- Female skins
        `a_f_m_skidrow_01`,
        `a_f_m_soucentmc_01`,
        `a_f_m_soucent_01`,
        `a_f_m_soucent_02`,
        `a_f_m_tourist_01`,
        `a_f_m_trampbeac_01`,
        `a_f_m_tramp_01`,
        `a_f_o_genstreet_01`,
        `a_f_o_indian_01`,
        `a_f_o_ktown_01`,
        `a_f_o_salton_01`,
        `a_f_o_soucent_01`,
        `a_f_o_soucent_02`,
        `a_f_y_beach_01`,
        `a_f_y_bevhills_01`,
        `a_f_y_bevhills_02`,
        `a_f_y_bevhills_03`,
        `a_f_y_bevhills_04`,
        `a_f_y_business_01`,
        `a_f_y_business_02`,
        `a_f_y_business_03`,
        `a_f_y_business_04`,
        `a_f_y_eastsa_01`,
        `a_f_y_eastsa_02`,
        `a_f_y_eastsa_03`,
        `a_f_y_epsilon_01`,
        `a_f_y_fitness_01`,
        `a_f_y_fitness_02`,
        `a_f_y_genhot_01`,
        `a_f_y_golfer_01`,
        `a_f_y_hiker_01`,
        `a_f_y_hipster_01`,
        `a_f_y_hipster_02`,
        `a_f_y_hipster_03`,
        `a_f_y_hipster_04`,
        `a_f_y_indian_01`,
        `a_f_y_juggalo_01`,
        `a_f_y_runner_01`,
        `a_f_y_rurmeth_01`,
        `a_f_y_scdressy_01`,
        `a_f_y_skater_01`,
        `a_f_y_soucent_01`,
        `a_f_y_soucent_02`,
        `a_f_y_soucent_03`,
        `a_f_y_tennis_01`,
        `a_f_y_tourist_01`,
        `a_f_y_tourist_02`,
        `a_f_y_vinewood_01`,
        `a_f_y_vinewood_02`,
        `a_f_y_vinewood_03`,
        `a_f_y_vinewood_04`,
        `a_f_y_yoga_01`,
        `g_f_y_ballas_01`
    }
}

-- Language / Notification stub (replace with your localization if needed)
Lang = {}
Lang.t = function(text) return text end