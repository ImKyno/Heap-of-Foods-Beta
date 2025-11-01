local _G                           = GLOBAL
local require                      = _G.require
local SEASONS                      = _G.SEASONS
local FOODGROUP                    = _G.FOODGROUP
local FOODTYPE                     = _G.FOODTYPE
local WORLD_TILES                  = _G.WORLD_TILES

local FISH_DATA                    = require("prefabs/oceanfishdef")
local FISH_DEFS                    = FISH_DATA.fish
local SCHOOL_WEIGHTS               = FISH_DATA.school
local SPECIAL_EVENTS               = FISH_DATA.SpecialEventSetup

local SCHOOL_VERY_COMMON           = 4
local SCHOOL_COMMON                = 2
local SCHOOL_UNCOMMON              = 1
local SCHOOL_RARE                  = 0.25

local SCHOOL_SIZE                  = 
{
	TINY                           = { min = 1, max = 3  },
	SMALL                          = { min = 2, max = 5  },
	MEDIUM                         = { min = 4, max = 6  },
	LARGE                          = { min = 6, max = 10 },
}

local SCHOOL_AREA                  = 
{
	TINY                           = 2,
	SMALL                          = 3,
	MEDIUM                         = 6,
	LARGE                          = 10,
}

local SCHOOL_WORLD_TIME            = 
{
	SHORT                          = { min = 30 * 8,      max = 30 * 16      },
	MEDIUM                         = { min = 30 * 16,     max = 30 * 16 * 2  },
	LONG                           = { min = 30 * 16 * 2, max = 30 * 16 * 4  },
}

local WANDER_DIST                  =
{
	SHORT                          = { min = 5,  max = 15 },
	MEDIUM                         = { min = 15, max = 30 },
	LONG                           = { min = 20, max = 40 },
}

local ARRIVE_DIST                  = 
{
	CLOSE                          = 3,
	MEDIUM                         = 8,
	FAR                            = 12,
}

local WANDER_DELAY                 =
{
	SHORT                          = { min = 0,  max = 10 },
	MEDIUM                         = { min = 10, max = 30 },
	LONG                           = { min = 30, max = 60 },
}

local DIET                         = 
{
	OMNI                           = { caneat = { FOODGROUP.OMNI       } },
	VEGGIE                         = { caneat = { FOODGROUP.VEGETARIAN } },
	MEAT                           = { caneat = { FOODTYPE.MEAT        } },
	BERRY                          = { caneat = { FOODTYPE.BERRY       } },
}

local LOOT                         =
{
	TINY                           = { "fishmeat_small"            },
	SMALL                          = { "fishmeat_small"            },
	SMALL_COOKED                   = { "fishmeat_small_cooked"     },
	MEDIUM                         = { "fishmeat"                  },
	LARGE                          = { "fishmeat", "fishmeat"      },
	HUGE                           = { "fishmeat"                  },
	ICE                            = { "fishmeat", "ice", "ice"    },
	PLANTMEAT                      = { "plantmeat"                 },
	PUFFERFISH                     = { "fishmeat_small", "stinger" },
}

local HEAVY_LOOT                   = 
{
	SMALL                          = { "fishmeat"                                 },
	SMALL_COOKED                   = { "fishmeat_cooked"                          },
	MEDIUM                         = { "fishmeat", "fishmeat_small"               },
	LARGE                          = { "fishmeat", "fishmeat", "fishmeat_small",  },
	ICE                            = { "fishmeat", "fishmeat_small", "ice", "ice" },
	PUFFERFISH                     = { "fishmeat", "stinger", "stinger"           },
}

local PERISH                       = 
{
	TINY                           = "fishmeat_small",
	SMALL                          = "fishmeat_small",
	MEDIUM                         = "fishmeat",
	LARGE                          = "fishmeat",
	HUGE                           = "fishmeat",
	PLANTMEAT                      = "spoiled_food",
}

local COOKING_PRODUCT              = 
{
	TINY                           = "fishmeat_small_cooked",
	SMALL                          = "fishmeat_small_cooked",
	MEDIUM                         = "fishmeat_cooked",
	LARGE                          = "fishmeat_cooked",
	HUGE                           = "fishmeat_cooked",
	PLANTMEAT                      = "plantmeat_cooked",
}

local COOKER_INGREDIENT_SMALL      = { meat = 0.5, fish = 0.5            }
local COOKER_INGREDIENT_MEDIUM     = { meat = 1,   fish  = 1             }
local COOKER_INGREDIENT_MEDIUM_ICE = { meat = 1,   fish  = 1, frozen = 1 }

local EDIBLE_VALUES_SMALL_MEAT     = { health = TUNING.HEALING_TINY,     hunger = TUNING.CALORIES_SMALL, sanity = 0,                    foodtype = FOODTYPE.MEAT   }
local EDIBLE_VALUES_MEDIUM_MEAT    = { health = TUNING.HEALING_MEDSMALL, hunger = TUNING.CALORIES_MED,   sanity = 0,                    foodtype = FOODTYPE.MEAT   }
local EDIBLE_VALUES_SMALL_VEGGIE   = { health = TUNING.HEALING_SMALL,    hunger = TUNING.CALORIES_SMALL, sanity = 0,                    foodtype = FOODTYPE.VEGGIE }
local EDIBLE_VALUES_MEDIUM_VEGGIE  = { health = TUNING.HEALING_SMALL,    hunger = TUNING.CALORIES_MED,   sanity = 0,                    foodtype = FOODTYPE.VEGGIE }
local EDIBLE_VALUES_PLANTMEAT      = { health = 0,                       hunger = TUNING.CALORIES_SMALL, sanity = -TUNING.SANITY_SMALL, foodtype = FOODTYPE.MEAT   }

local SET_HOOK_TIME_SHORT          = { base = 1, var = 0.5 }
local SET_HOOK_TIME_MEDIUM         = { base = 2, var = 0.5 }

local BREACH_FX_SMALL              = { "ocean_splash_small1", "ocean_splash_small2" }
local BREACH_FX_MEDIUM             = { "ocean_splash_med1", "ocean_splash_med2"     }

local SHADOW_SMALL                 = { 1,   0.75 }
local SHADOW_MEDIUM                = { 1.5, 0.75 }
local SHADOW_LARGE                 = { 2.5, 0.75 }

local ALL_PHASES                   = { "day", "dusk", "night" }
local ALL_MOONPHASES               = { "new", "quarter", "half", "threequarter", "full" }
local ALL_SEASONS                  = { "autumn", "winter", "spring", "summer" }
local ALL_WORLDS                   = { "forest", "cave" }

-- New Ocean Fishes,
local OCEANFISHES                  =
{
	oceanfish_pufferfish           = 
	{
		prefab                     = "oceanfish_pufferfish",
		bank                       = "kyno_oceanfish_pufferfish",
		build                      = "kyno_oceanfish_pufferfish",
		
		weight_min                 = TUNING.KYNO_OCEANFISH_PUFFERFISH_MIN_WEIGHT,
		weight_max                 = TUNING.KYNO_OCEANFISH_PUFFERFISH_MAX_WEIGHT,

		walkspeed                  = TUNING.KYNO_OCEANFISH_PUFFERFISH_WALKSPEED,
		runspeed                   = TUNING.KYNO_OCEANFISH_PUFFERFISH_RUNSPEED,
		
		stamina =
		{
			drain_rate             = 0.1,
			recover_rate           = 0.5,
			struggle_times	       = { low = 1, r_low = 2, high = 3, r_high = 2 },
			tired_times		       = { low = 1, r_low = 2, high = 1, r_high = 1 },
			tiredout_angles        = { has_tention = 80, low_tention = 120},
		},

		schoolmin                  = SCHOOL_SIZE.LARGE.min,
		schoolmax                  = SCHOOL_SIZE.LARGE.max,
		schoolrange                = SCHOOL_AREA.LARGE,
		schoollifetimemin          = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax          = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin              = WANDER_DIST.LONG.min,
		herdwandermax              = WANDER_DIST.LONG.max,
		herdarrivedist             = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin         = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax         = WANDER_DELAY.SHORT.max,

		set_hook_time              = SET_HOOK_TIME_MEDIUM,
		breach_fx                  = BREACH_FX_SMALL,
		
		loot                       = LOOT.PUFFERFISH,
		heavy_loot                 = HEAVY_LOOT.PUFFERFISH,
		
		cooking_product            = COOKING_PRODUCT.SMALL,
		perish_product             = PERISH.SMALL,
		fishtype                   = "meat",

		lures                      = TUNING.OCEANFISH_LURE_PREFERENCE.SMALL_OMNI,
		diet                       = DIET.OMNI,
		cooker_ingredient_value    = COOKER_INGREDIENT_SMALL,
		edible_values              = EDIBLE_VALUES_SMALL_MEAT,

		dynamic_shadow             = SHADOW_SMALL,
		
		roe_prefab                 = "kyno_roe_oceanfish_pufferfish",
		baby_prefab                = "oceanfish_pufferfish_inv",
		
		roe_time                   = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time                  = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases                     = { "day" },
		moonphases                 = ALL_MOONPHASES,
		seasons                    = { "summer" },
		worlds                     = ALL_WORLDS,
	},

	oceanfish_sturgeon             = 
	{
		prefab                     = "oceanfish_sturgeon",
		bank                       = "kyno_oceanfish_sturgeon",
		build                      = "kyno_oceanfish_sturgeon",
		
		weight_min                 = TUNING.KYNO_OCEANFISH_STURGEON_MIN_WEIGHT,
		weight_max                 = TUNING.KYNO_OCEANFISH_STURGEON_MAX_WEIGHT,

		walkspeed                  = TUNING.KYNO_OCEANFISH_STURGEON_WALKSPEED,
		runspeed                   = TUNING.KYNO_OCEANFISH_STURGEON_RUNSPEED,
		
		stamina                    =
		{
			drain_rate             = 0.1,
			recover_rate           = 0.25,
			struggle_times	       = { low = 4, r_low = 2, high = 6, r_high = 2 },
			tired_times		       = { low = 1, r_low = 1, high = 1, r_high = 0 },
			tiredout_angles        = { has_tention = 45, low_tention = 90 },
		},

		schoolmin                  = SCHOOL_SIZE.MEDIUM.min,
		schoolmax                  = SCHOOL_SIZE.MEDIUM.max,
		schoolrange                = SCHOOL_AREA.SMALL,
		schoollifetimemin          = SCHOOL_WORLD_TIME.MEDIUM.min,
		schoollifetimemax          = SCHOOL_WORLD_TIME.MEDIUM.max,

		herdwandermin              = WANDER_DIST.MEDIUM.min,
		herdwandermax              = WANDER_DIST.MEDIUM.max,
		herdarrivedist             = ARRIVE_DIST.MEDIUM,
		herdwanderdelaymin         = WANDER_DELAY.SHORT.min,
		herdwanderdelaymax         = WANDER_DELAY.SHORT.max,

		set_hook_time              = SET_HOOK_TIME_SHORT,
		breach_fx                  = BREACH_FX_MEDIUM,
		
		loot                       = LOOT.LARGE, 
		heavy_loot                 = HEAVY_LOOT.LARGE, -- Sturgeons are very big.
		
		cooking_product            = COOKING_PRODUCT.MEDIUM,
		perish_product             = PERISH.MEDIUM,
		fishtype                   = "meat",

		lures                      = TUNING.OCEANFISH_LURE_PREFERENCE.MEAT,
		diet                       = DIET.MEAT,
		cooker_ingredient_value    = COOKER_INGREDIENT_MEDIUM,
		edible_values              = EDIBLE_VALUES_MEDIUM_MEAT,

		dynamic_shadow             = SHADOW_LARGE,
		
		roe_prefab                 = "kyno_roe_oceanfish_sturgeon",
		baby_prefab                = "oceanfish_sturgeon_inv",
		
		roe_time                   = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time                  = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases                     = ALL_PHASES,
		moonphases                 = ALL_MOONPHASES,
		seasons                    = { "summer", "winter" },
		worlds                     = ALL_WORLDS,
	},
}

for k, v in pairs(OCEANFISHES) do
	FISH_DEFS[k]                   = v
end

-- Pufferfish school locations.
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_HAZARDOUS].oceanfish_pufferfish = SCHOOL_VERY_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_ROUGH].oceanfish_pufferfish     = SCHOOL_UNCOMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_SWELL].oceanfish_pufferfish     = SCHOOL_RARE

-- Sturgeon school locations.
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_BRINEPOOL].oceanfish_sturgeon   = SCHOOL_COMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_ROUGH].oceanfish_sturgeon       = SCHOOL_UNCOMMON
SCHOOL_WEIGHTS[SEASONS.AUTUMN][WORLD_TILES.OCEAN_SWELL].oceanfish_sturgeon       = SCHOOL_RARE