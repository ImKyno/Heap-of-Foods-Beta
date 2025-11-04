local map = require("map/forest_map")
local WSO = require("worldsettings_overrides")

local customizations_worldsettings =
{	
	-- WORLDSETTING
	aloes_setting            = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 0,   world = { "forest" }},
	asparaguses_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 1,   world = { "forest", "cave" }},
	coffeebushes_setting     = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 2,   world = { "forest", "cave" }},
	fennels_setting          = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 3,   world = { "cave" }},
	giantparznips_setting    = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 4,   world = { "cave" }},
	mushstumps_setting       = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 5,   world = { "forest", "cave" }},
	truffles_setting         = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 6,   world = { "forest" }},
	parznips_setting         = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 7,   world = { "cave" }},
	radishes_setting         = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 8,   world = { "forest" }},
	rockflippables_setting   = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 9,   world = { "forest", "cave" }},
	sweetpotatoes_setting    = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 10,  world = { "forest" }},
	turnips_setting          = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 11,  world = { "forest", "cave" }},
	wildwheats_setting       = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_r",           order = 12,  world = { "forest" }},
	
	-- OCEANSETTING
	lotusplants_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_ocean_r",     order = 0,   world = { "forest" }},
	oceancrates_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_ocean_r",     order = 1,   world = { "forest" }},
	oceanwrecks_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_ocean_r",     order = 2,   world = { "forest" }},
	seacucumbers_setting     = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_ocean_r",     order = 3,   world = { "forest" }},
	taroroots_setting        = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_ocean_r",     order = 4,   world = { "forest" }},
	waterycresses_setting    = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_ocean_r",     order = 5,   world = { "forest" }},
	weedsea_setting          = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_ocean_r",     order = 6,   world = { "forest" }},
	
	-- OCEANCREATURESSETTING
	chickens_setting         = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 0,   world = { "forest" }},
	dogfishes_setting        = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 9,   world = { "forest" }},
	fishermerms_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 5,   world = { "forest" }},
	hermitwobsters_setting   = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 8,   world = { "forest" }},
	jellyfishes_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 6,   world = { "forest" }},
	jellyfishes2_setting     = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 7,   world = { "forest" }},
	pebblecrabs_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 1,   world = { "forest" }},
	pikos_setting            = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 3,   world = { "forest" }},
	pikosorange_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 4,   world = { "forest" }},
	sugarflies_setting       = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 2,   world = { "forest" }},
	swordfishes_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "frequency_descriptions", group = "hof_creatures_r", order = 10,  world = { "forest" }},
	
	-- SERENITYSETTING
    saltponds_setting        = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_serenity_r",  order = 2,   world = { "forest" }},
	spotbushes_setting       = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_serenity_r",  order = 3,   world = { "forest" }},
	sugarflowers_setting     = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_serenity_r",  order = 5,   world = { "forest" }},
	sugartrees_setting       = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_serenity_r",  order = 6,   world = { "forest" }},
	sapsugartrees_setting    = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_serenity_r",  order = 7,   world = { "forest" }},
	sap2sugartrees_setting   = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_serenity_r",  order = 8,   world = { "forest" }},
	ruinedsugartrees_setting = { category = LEVELCATEGORY.SETTINGS, desc = "yesno_descriptions",     group = "hof_serenity_r",  order = 9,   world = { "forest" }},
	
	-- MEADOWSETTING
	islandcrates_setting     = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_meadow_r",    order = 1,   world = { "forest" }},
	kokonuttrees_setting     = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_meadow_r",    order = 3,   world = { "forest" }},
	limpetrocks_setting      = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_meadow_r",    order = 2,   world = { "forest" }},
	pineapplebushes_setting  = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_meadow_r",    order = 7,   world = { "forest" }},
    sandhills_setting        = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_meadow_r",    order = 8,   world = { "forest" }},
	teatrees_setting         = { category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions",     group = "hof_meadow_r",    order = 6,   world = { "forest" }},
}

local function OverrideTuningVariables(tuning)
	if tuning ~= nil then
		for k, v in pairs(tuning) do
			ORIGINAL_TUNING[k] = TUNING[k]
			TUNING[k] = v
		end
	end
end

local SPAWN_MODE_FN =
{
	never  = "SpawnModeNever",
	always = "SpawnModeHeavy",
	often  = "SpawnModeMed",
	rare   = "SpawnModeLight",
}

local function SetSpawnMode(spawner, difficulty)
	if spawner ~= nil then
		local fn_name = SPAWN_MODE_FN[difficulty]
		
		if fn_name then
			spawner[fn_name](spawner)
		end
	end
end

local MULTIPLY = 
{
	["never"]    = 0,
	["veryrare"] = 0.25,
	["rare"]     = 0.5,
	["uncommon"] = 0.75,
	["default"]  = 1,
	["often"]    = 1.5,
	["mostly"]   = 1.75,
	["always"]   = 2,
	["insane"]   = 4,
}
local MULTIPLY_COOLDOWNS = 
{
	["never"]    = 0,
	["veryrare"] = 2,
	["rare"]     = 1.5,
	["default"]  = 1,
	["often"]    = .5,
	["always"]   = .25,
}

local NEVER_TIME = TUNING.TOTAL_DAY_TIME * 9999999999 -- This is actually a base game thing lmao.

WSO.Pre.aloes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_ALOE_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_ALOE_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_ALOE_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_ALOE_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_ALOE_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.asparaguses_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_ASPARGOS_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_ASPARGOS_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_ASPARGOS_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_ASPARGOS_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_ASPARGOS_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.coffeebushes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_COFFEEBUSH_GROWTIME = NEVER_TIME,
		},

		veryslow = 
		{
			KYNO_COFFEEBUSH_GROWTIME = 3840,
		},
		
		slow = 
		{
			KYNO_COFFEEBUSH_GROWTIME = 2880,
		},
            
		fast = 
		{
			KYNO_COFFEEBUSH_GROWTIME = 1280,
		},
		
		veryfast = 
		{
			KYNO_COFFEEBUSH_GROWTIME = 480,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.fennels_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_FENNEL_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_FENNEL_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_FENNEL_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_FENNEL_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_FENNEL_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.giantparznips_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_PARZNIP_BIG_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_PARZNIP_BIG_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_PARZNIP_BIG_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_PARZNIP_BIG_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_PARZNIP_BIG_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.mushstumps_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_MUSHSTUMP_GROWTIME = NEVER_TIME,
			KYNO_MUSHSTUMP_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_MUSHSTUMP_GROWTIME = 4800,
			KYNO_MUSHSTUMP_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_MUSHSTUMP_GROWTIME = 3600,
			KYNO_MUSHSTUMP_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_MUSHSTUMP_GROWTIME = 1600,
			KYNO_MUSHSTUMP_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_MUSHSTUMP_GROWTIME = 960,
			KYNO_MUSHSTUMP_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.truffles_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_TRUFFLES_GROWTIME = NEVER_TIME,
			KYNO_TRUFFLES_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_TRUFFLES_GROWTIME = 9600,
			KYNO_TRUFFLES_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_TRUFFLES_GROWTIME = 7200,
			KYNO_TRUFFLES_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_TRUFFLES_GROWTIME = 3200,
			KYNO_TRUFFLES_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_TRUFFLES_GROWTIME = 2400,
			KYNO_TRUFFLES_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.parznips_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_PARZNIP_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_PARZNIP_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_PARZNIP_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_PARZNIP_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_PARZNIP_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.radishes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_RADISH_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_RADISH_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_RADISH_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_RADISH_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_RADISH_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.rockflippables_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_FLIPPABLE_ROCK_REPOPULATE_TIME = NEVER_TIME,
			KYNO_FLIPPABLE_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_FLIPPABLE_ROCK_REPOPULATE_TIME = 4800,
			KYNO_FLIPPABLE_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_FLIPPABLE_ROCK_REPOPULATE_TIME = 3600,
			KYNO_FLIPPABLE_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_FLIPPABLE_ROCK_REPOPULATE_TIME = 1600,
			KYNO_FLIPPABLE_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_FLIPPABLE_ROCK_REPOPULATE_TIME = 960,
			KYNO_FLIPPABLE_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.sweetpotatoes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SWEETPOTATO_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_SWEETPOTATO_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_SWEETPOTATO_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_SWEETPOTATO_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_SWEETPOTATO_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.turnips_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_TURNIP_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_TURNIP_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_TURNIP_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_TURNIP_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_TURNIP_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.wildwheats_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_WILDWHEAT_GROWTIME = NEVER_TIME,
			KYNO_WILDWHEAT_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_WILDWHEAT_GROWTIME = 2880,
			KYNO_WILDWHEAT_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_WILDWHEAT_GROWTIME = 2160,
			KYNO_WILDWHEAT_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_WILDWHEAT_GROWTIME = 960,
			KYNO_WILDWHEAT_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_WILDWHEAT_GROWTIME = 480,
			KYNO_WILDWHEAT_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.jellyfishes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_JELLYFISH_ENABLED = false,
		},

		few = 
		{
			KYNO_JELLYFISH_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 8,
			KYNO_JELLYFISH_AMOUNT = 3,
		},
		
		many = 
		{
			KYNO_JELLYFISH_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 2,
			KYNO_JELLYFISH_AMOUNT = 5,
		},
            
		always = 
		{
			KYNO_JELLYFISH_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 1,
			KYNO_JELLYFISH_AMOUNT = 6,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.jellyfishes2_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_JELLYFISH_RAINBOW_ENABLED = false,
		},

		few = 
		{
			KYNO_JELLYFISH_RAINBOW_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 8,
			KYNO_JELLYFISH_RAINBOW_AMOUNT = 3,
		},
		
		many = 
		{
			KYNO_JELLYFISH_RAINBOW_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 2,
			KYNO_JELLYFISH_RAINBOW_AMOUNT = 4,
		},
            
		always = 
		{
			KYNO_JELLYFISH_RAINBOW_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 1,
			KYNO_JELLYFISH_RAINBOW_AMOUNT = 5,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.dogfishes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_DOGFISH_ENABLED = false,
		},

		few = 
		{
			KYNO_DOGFISH_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 6,
		},
		
		many = 
		{
			KYNO_DOGFISH_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2,
		},
            
		always = 
		{
			KYNO_DOGFISH_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 1,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.hermitwobsters_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_WOBSTER_MONKEYISLAND_DEN_ENABLED = false,
		},

		few = 
		{
			KYNO_WOBSTER_MONKEYISLAND_DEN_SPAWN_TIME = 150,
			KYNO_WOBSTER_MONKEYISLAND_DEN_REGEN_TIME = 200,
			KYNO_WOBSTER_MONKEYISLAND_DEN_AMOUNT = 1,
		},
		
		many = 
		{
			KYNO_WOBSTER_MONKEYISLAND_DEN_SPAWN_TIME = 80,
			KYNO_WOBSTER_MONKEYISLAND_DEN_REGEN_TIME = 100,
			KYNO_WOBSTER_MONKEYISLAND_DEN_AMOUNT = 3,
		},
            
		always = 
		{
			KYNO_WOBSTER_MONKEYISLAND_DEN_SPAWN_TIME = 40,
			KYNO_WOBSTER_MONKEYISLAND_DEN_REGEN_TIME = 80,
			KYNO_WOBSTER_MONKEYISLAND_DEN_AMOUNT = 4,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.swordfishes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SWORDFISH_ENABLED = false,
		},

		few = 
		{
			KYNO_SWORDFISH_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2,
		},
		
		many = 
		{
			KYNO_SWORDFISH_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 2,
		},
            
		always = 
		{
			KYNO_SWORDFISH_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 4,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.lotusplants_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_LOTUS_GROWTIME = NEVER_TIME,
		},

		veryslow = 
		{
			KYNO_LOTUS_GROWTIME = 2880,
		},
		
		slow = 
		{
			KYNO_LOTUS_GROWTIME = 2160,
		},
            
		fast = 
		{
			KYNO_LOTUS_GROWTIME = 960,
		},
		
		veryfast = 
		{
			KYNO_LOTUS_GROWTIME = 480,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.oceancrates_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_CRATE_GROWTIME = NEVER_TIME,
			KYNO_CRATE_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_CRATE_GROWTIME = 6720,
			KYNO_CRATE_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_CRATE_GROWTIME = 5040,
			KYNO_CRATE_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_CRATE_GROWTIME = 2240,
			KYNO_CRATE_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_CRATE_GROWTIME = 1680,
			KYNO_CRATE_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.oceanwrecks_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_OCEAN_WRECK_GROWTIME = NEVER_TIME,
			KYNO_OCEAN_WRECK_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_OCEAN_WRECK_GROWTIME = 2880,
			KYNO_OCEAN_WRECK_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_OCEAN_WRECK_GROWTIME = 2160,
			KYNO_OCEAN_WRECK_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_OCEAN_WRECK_GROWTIME = 960,
			KYNO_OCEAN_WRECK_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_OCEAN_WRECK_GROWTIME = 480,
			KYNO_OCEAN_WRECK_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.seacucumbers_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_CUCUMBER_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_CUCUMBER_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_CUCUMBER_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_CUCUMBER_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_CUCUMBER_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.taroroots_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_TAROSEA_GROWTIME = NEVER_TIME,
			KYNO_TAROROOT_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_TAROSEA_GROWTIME = 3840,
			KYNO_TAROROOT_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_TAROSEA_GROWTIME = 2880,
			KYNO_TAROROOT_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_TAROSEA_GROWTIME = 1280,
			KYNO_TAROROOT_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_TAROSEA_GROWTIME = 480,
			KYNO_TAROROOT_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.waterycresses_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_WATERYCRESS_GROWTIME = NEVER_TIME,
			KYNO_WATERYCRESS_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_WATERYCRESS_GROWTIME = 4800,
			KYNO_WATERYCRESS_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_WATERYCRESS_GROWTIME = 3600,
			KYNO_WATERYCRESS_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_WATERYCRESS_GROWTIME = 1600,
			KYNO_WATERYCRESS_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_WATERYCRESS_GROWTIME = 960,
			KYNO_WATERYCRESS_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.weedsea_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_WEEDSEA_GROWTIME = NEVER_TIME,
			KYNO_WEEDSEA_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_WEEDSEA_GROWTIME = 2880,
			KYNO_WEEDSEA_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_WEEDSEA_GROWTIME = 2160,
			KYNO_WEEDSEA_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_WEEDSEA_GROWTIME = 960,
			KYNO_WEEDSEA_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_WEEDSEA_GROWTIME = 480,
			KYNO_WEEDSEA_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.chickens_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_CHICKEN_ENABLED = false,
		},

		few = 
		{
			KYNO_CHICKEN_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 8,
			KYNO_CHICKEN_AMOUNT = 3,
		},
		
		many = 
		{
			KYNO_CHICKEN_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 2,
			KYNO_CHICKEN_AMOUNT = 4,
		},
            
		always = 
		{
			KYNO_CHICKEN_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 1,
			KYNO_CHICKEN_AMOUNT = 5,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.pebblecrabs_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_PEBBLECRAB_ENABLED = false,
		},

		few = 
		{
			KYNO_PEBBLECRAB_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 8,
			KYNO_PEBBLECRAB_AMOUNT = 2,
		},
		
		many = 
		{
			KYNO_PEBBLECRAB_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 2,
			KYNO_PEBBLECRAB_AMOUNT = 3,
		},
            
		always = 
		{
			KYNO_PEBBLECRAB_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 1,
			KYNO_PEBBLECRAB_AMOUNT = 4,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.saltponds_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SALTRACK_REGROW_TIME = NEVER_TIME,
		},

		veryslow = 
		{
			KYNO_SALTRACK_REGROW_TIME = 3840,
		},
		
		slow = 
		{
			KYNO_SALTRACK_REGROW_TIME = 2880,
		},
            
		fast = 
		{
			KYNO_SALTRACK_REGROW_TIME = 1280,
		},
		
		veryfast = 
		{
			KYNO_SALTRACK_REGROW_TIME = 480,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.spotbushes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SPOTBUSH_GROWTIME = NEVER_TIME,
			KYNO_SPOTBUSH_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_SPOTBUSH_GROWTIME = 2880,
			KYNO_SPOTBUSH_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_SPOTBUSH_GROWTIME = 2160,
			KYNO_SPOTBUSH_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_SPOTBUSH_GROWTIME = 960,
			KYNO_SPOTBUSH_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_SPOTBUSH_GROWTIME = 480,
			KYNO_SPOTBUSH_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.sugarflies_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			MAX_KYNO_SUGARFLIES = 0,
		},

		rare = 
		{
			MAX_KYNO_SUGARFLIES = 2,
		},
		
		often = 
		{
			MAX_KYNO_SUGARFLIES = 7,
		},
            
		always = 
		{
			MAX_KYNO_SUGARFLIES = 10,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.sugarflowers_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SUGARFLOWER_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_SUGARFLOWER_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_SUGARFLOWER_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_SUGARFLOWER_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_SUGARFLOWER_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.sugartrees_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SUGARTREE_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_SUGARTREE_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_SUGARTREE_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_SUGARTREE_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_SUGARTREE_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.sapsugartrees_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SAP_GROWTIME = NEVER_TIME,
		},

		veryslow = 
		{
			KYNO_SAP_GROWTIME = 2880,
		},
		
		slow = 
		{
			KYNO_SAP_GROWTIME = 2160,
		},
            
		fast = 
		{
			KYNO_SAP_GROWTIME = 960,
		},
		
		veryfast = 
		{
			KYNO_SAP_GROWTIME = 480,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.sap2sugartrees_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SAP_RUINED_GROWTIME = NEVER_TIME,
		},

		veryslow = 
		{
			KYNO_SAP_RUINED_GROWTIME = 2880,
		},
		
		slow = 
		{
			KYNO_SAP_RUINED_GROWTIME = 2160,
		},
            
		fast = 
		{
			KYNO_SAP_RUINED_GROWTIME = 960,
		},
		
		veryfast = 
		{
			KYNO_SAP_RUINED_GROWTIME = 480,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.ruinedsugartrees_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_SAP_SPOILS = false,
		},

		veryslow = 
		{
			KYNO_SAP_SPOILTIME = 9600,
		},
		
		slow = 
		{
			KYNO_SAP_SPOILTIME = 7200,
		},
            
		fast = 
		{
			KYNO_SAP_SPOILTIME = 3200,
		},
		
		veryfast = 
		{
			KYNO_SAP_SPOILTIME = 2400,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.fishermerms_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_MERMFISHER_ENABLED = false,
		},

		few = 
		{
			KYNO_MERMFISHER_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 8,
			KYNO_MERMFISHER_AMOUNT = 2,
		},
		
		many = 
		{
			KYNO_MERMFISHER_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 2,
			KYNO_MERMFISHER_AMOUNT = 3,
		},
            
		always = 
		{
			KYNO_MERMFISHER_REGEN_TIME = TUNING.TOTAL_DAY_TIME * 1,
			KYNO_MERMFISHER_AMOUNT = 4,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.islandcrates_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_ISLANDCRATE_GROWTIME = NEVER_TIME,
			KYNO_ISLANDCRATE_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_ISLANDCRATE_GROWTIME = 6720,
			KYNO_ISLANDCRATE_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_ISLANDCRATE_GROWTIME = 5040,
			KYNO_ISLANDCRATE_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_ISLANDCRATE_GROWTIME = 2240,
			KYNO_ISLANDCRATE_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_ISLANDCRATE_GROWTIME = 1680,
			KYNO_ISLANDCRATE_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.kokonuttrees_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_KOKONUTTREE_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_KOKONUTTREE_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_KOKONUTTREE_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_KOKONUTTREE_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_KOKONUTTREE_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.limpetrocks_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_LIMPETROCK_GROWTIME = NEVER_TIME,
			KYNO_LIMPETROCK_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_LIMPETROCK_GROWTIME = 2880,
			KYNO_LIMPETROCK_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_LIMPETROCK_GROWTIME = 2160,
			KYNO_LIMPETROCK_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_LIMPETROCK_GROWTIME = 960,
			KYNO_LIMPETROCK_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_LIMPETROCK_GROWTIME = 480,
			KYNO_LIMPETROCK_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.pikos_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_PIKO_ENABLED = false,
		},

		few = 
		{
			KYNO_PIKO_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 6,
		},
		
		many = 
		{
			KYNO_PIKO_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2,
		},
            
		always = 
		{
			KYNO_PIKO_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 1,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.pikosorange_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_PIKO_ORANGE_ENABLED = false,
		},
		
		few = 
		{
			-- KYNO_PIKO_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 6,
			KYNO_PIKO_ORANGE_CHANCE = .30,
		},
		
		many = 
		{
			-- KYNO_PIKO_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2,
			KYNO_PIKO_ORANGE_CHANCE = .60,
		},
            
		always = 
		{
			-- KYNO_PIKO_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 1,
			KYNO_PIKO_ORANGE_CHANCE = .80,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.pineapplebushes_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_PINEAPPLEBUSH_GROWTIME = NEVER_TIME,
			KYNO_PINEAPPLEBUSH_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_PINEAPPLEBUSH_GROWTIME = 5760,
			KYNO_PINEAPPLEBUSH_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_PINEAPPLEBUSH_GROWTIME = 4320,
			KYNO_PINEAPPLEBUSH_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_PINEAPPLEBUSH_GROWTIME = 1920,
			KYNO_PINEAPPLEBUSH_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_PINEAPPLEBUSH_GROWTIME = 960,
			KYNO_PINEAPPLEBUSH_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.sandhills_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_MEADOWISLAND_SAND_REGROW = NEVER_TIME,
			KYNO_MEADOWISLAND_SAND_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_MEADOWISLAND_SAND_REGROW = 5760,
			KYNO_MEADOWISLAND_SAND_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_MEADOWISLAND_SAND_REGROW = 4320,
			KYNO_MEADOWISLAND_SAND_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_MEADOWISLAND_SAND_REGROW = 1920,
			KYNO_MEADOWISLAND_SAND_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_MEADOWISLAND_SAND_REGROW = 960,
			KYNO_MEADOWISLAND_SAND_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.teatrees_setting = function(difficulty)
	local tuning_vars =
	{
		never = 
		{
			KYNO_MEADOWISLAND_TREE_REGROWTH_TIME_MULT = 0,
		},

		veryslow = 
		{
			KYNO_MEADOWISLAND_TREE_REGROWTH_TIME_MULT = .25,
		},
		
		slow = 
		{
			KYNO_MEADOWISLAND_TREE_REGROWTH_TIME_MULT = .50,
		},
            
		fast = 
		{
			KYNO_MEADOWISLAND_TREE_REGROWTH_TIME_MULT = 1.5,
		},
		
		veryfast = 
		{
			KYNO_MEADOWISLAND_TREE_REGROWTH_TIME_MULT = 3,
		},
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end
	
for k, v in pairs(customizations_worldsettings) do
	v.name     = k
	
	v.category = v.category
	v.group    = v.group
	v.order    = v.order
	
	v.value    = v.value or "default"
	v.desc     = v.desc  or "frequency_descriptions"
	v.world    = v.world or {"forest"}
end

return customizations_worldsettings