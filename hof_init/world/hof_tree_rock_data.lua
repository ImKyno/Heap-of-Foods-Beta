-- Common Dependencies.
local _G                                   = GLOBAL
local require                              = _G.require
local TREE_ROCK_DATA                       = require("prefabs/tree_rock_data")
local VINE_LOOT_DATA                       = TREE_ROCK_DATA.VINE_LOOT_DATA
local WEIGHTED_VINE_LOOT                   = TREE_ROCK_DATA.WEIGHTED_VINE_LOOT
local ROOMS_TO_LOOT_KEY                    = TREE_ROCK_DATA.ROOMS_TO_LOOT_KEY
local TASKS_TO_LOOT_KEY                    = TREE_ROCK_DATA.TASKS_TO_LOOT_KEY
local STATIC_LAYOUTS_TO_LOOT_KEY           = TREE_ROCK_DATA.STATIC_LAYOUTS_TO_LOOT_KEY

WEIGHTED_VINE_LOOT["SERENITY_AREA"]        = 
{
	kyno_sugartree_bud                     = 20,
	kyno_sugartree_petals                  = 15,
	saltrock                               = 10,
	foliage                                = 10,
}

WEIGHTED_VINE_LOOT["MEADOW_AREA"]          = 
{
	kyno_pineapple                         = 20,
	kyno_sweetpotato                       = 15,
	kyno_oaktree_pod                       = 8,
	kyno_kokonut                           = 8,
}

local ROOMS                                =
{
	["SerenityRoom"]                       = "SERENITY_AREA",
	["MeadowRoom"]                         = "MEADOW_AREA",
	
	-- Old Worlds.
	["StaticLayoutIsland: SerenityIsland"] = "SERENITY_AREA",
	["StaticLayoutIsland: MeadowIsland"]   = "MEADOW_AREA",
}

local TASKS =
{
	["SerenityIsland"]                     = "SERENITY_AREA",
	["MeadowIsland"]                       = "MEADOW_AREA",
	
	-- Old Worlds.
	["StaticLayoutIsland: SerenityIsland"] = "SERENITY_AREA",
	["StaticLayoutIsland: MeadowIsland"]   = "MEADOW_AREA",
}

local STATIC_LAYOUTS                       = 
{
    ["SerenityIsland"]                     = "SERENITY_AREA",
    ["MeadowIsland"]                       = "MEADOW_AREA",
	
	-- Old Worlds.
	["hof_serenityisland1"]                = "SERENITY_AREA",
	["hof_serenityisland2"]                = "SERENITY_AREA",
	["hof_meadowisland1"]                  = "MEADOW_AREA",
	["hof_meadowisland2"]                  = "MEADOW_AREA",
}

VINE_LOOT_DATA["kyno_sugartree_bud"]       = { build = "kyno_tree_rock_swaps", symbols = { "swap_kyno_sugartree_bud"    } }
VINE_LOOT_DATA["kyno_sugartree_petals"]    = { build = "kyno_tree_rock_swaps", symbols = { "swap_kyno_sugartree_petals" } }
VINE_LOOT_DATA["saltrock"]                 = { build = "kyno_tree_rock_swaps", symbols = { "swap_saltrock"              } }
VINE_LOOT_DATA["foliage"]                  = { build = "kyno_tree_rock_swaps", symbols = { "swap_kyno_sugartree_bud"    } }
VINE_LOOT_DATA["kyno_pineapple"]           = { build = "kyno_tree_rock_swaps", symbols = { "swap_kyno_pineapple"        } }
VINE_LOOT_DATA["kyno_sweetpotato"]         = { build = "kyno_tree_rock_swaps", symbols = { "swap_kyno_sweetpotato"      } }
VINE_LOOT_DATA["kyno_oaktree_pod"]         = { build = "kyno_tree_rock_swaps", symbols = { "swap_kyno_oaktree_pod"      } }
VINE_LOOT_DATA["kyno_kokonut"]             = { build = "kyno_tree_rock_swaps", symbols = { "swap_kyno_kokonut"          } }

for k, v in pairs(ROOMS) do
	ROOMS_TO_LOOT_KEY[k]                   = v
end

for k, v in pairs(TASKS) do
	TASKS_TO_LOOT_KEY[k]                   = v
end

for k, v in pairs(STATIC_LAYOUTS) do
	STATIC_LAYOUTS_TO_LOOT_KEY[k]          = v
end