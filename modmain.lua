-- Common Dependencies.
local _G               = GLOBAL
local require          = _G.require

-- Mod Strings and Localizations.
-- If you want to contribute with your localization please head to "scripts/strings/hof_localization.lua" for more information.
modimport("scripts/strings/hof_strings_loadingtips")

local hof_init_strings = 
{
	"hof_strings",
	"hof_strings_scrapbook",
	"hof_strings_skinprefabs",
}

for _, v in pairs(hof_init_strings) do
	require("strings/"..v)
end

local localization = GetModConfigData("LANGUAGE")
if localization then
	modimport("scripts/strings/localization_"..localization.."/hof_strings_loadingtips")

	for _, v in pairs(hof_init_strings) do
		require("strings/localization_"..localization.."/"..v)
	end
end

require("hof_main") -- Fish Registry needs to load after STRINGS.

-- Mod Dependencies.
local hof_init_misc    =
{
	"hof_tuning",
	"hof_assets",
	"hof_prefabs",
	"hof_skins",
	"hof_recipes",
	"hof_recipes_hofbirthday",
	"hof_recipes_serenity",
	"hof_recipes_meadow",
	"hof_popups",
	"hof_actions",
	"hof_stategraphs",
	"hof_containers",
	"hof_postinits_misc",
	"hof_postinits_brains",
	"hof_postinits_playervision",
	"hof_postinits_wisecracker",
}

local hof_init_world   =
{
	"hof_tiledefs",
	"hof_regrowth",
	"hof_worldgen",
	"hof_worldsettings",
	"hof_messagebottletreasures",
	"hof_postinits_world",
	"hof_postinits_mobs",
	"hof_slaughterable_animals",
	"hof_ancienttree_data",
	"hof_tree_rock_data",
	"hof_oceanfish_data",
	"hof_octopusking_data",
}

local hof_init_foods   =
{
	"hof_farming",
	"hof_cooking",
	"hof_bruwing",
	"hof_fishfarm_foods",
	"hof_meatrack_foods",
	"hof_mushroom_foods",
	"hof_postinits_foods",
	"hof_postinits_buffs",
}

for _, v in pairs(hof_init_misc) do
	modimport("hof_init/misc/"..v)
end

for _, v in pairs(hof_init_world) do
	modimport("hof_init/world/"..v)
end

for _, v in pairs(hof_init_foods) do
	modimport("hof_init/foods/"..v)
end

-- Mod Options.
_G.CONFIGS_HOF                =
{
	ENABLEDMODS               = {}
}

_G.CONFIGS_HOF.SEASONALFOOD   = GetModConfigData("SEASONALFOOD")
_G.CONFIGS_HOF.SCRAPBOOK      = GetModConfigData("SCRAPBOOK")
_G.CONFIGS_HOF.AUTORETROFIT   = GetModConfigData("AUTORETROFIT")

if _G.CONFIGS_HOF.SCRAPBOOK then
	modimport("hof_init/misc/hof_scrapbook")
	modimport("hof_init/misc/hof_shinyloots") -- Requires Scrapbook to be enabled...
end

if _G.CONFIGS_HOF.AUTORETROFIT then
	modimport("hof_init/world/hof_retrofit")
end

-- This belongs to the Accomplishments Mod.
-- modimport("achievementsmain")

-- Testing Mod Options.
--[[
local mod_options = 
{
	{ name = "LANGUAGE",         default = false },

	{ name = "SEASONALFOOD",     default = false },
	{ name = "HUMANMEAT",        default = true  },
	{ name = "GIANTSPAWNING",    default = true  },
	{ name = "ALCOHOLICDRINKS",  default = true  },
	{ name = "ICEBOXSTACKSIZE",  default = false },
	{ name = "COFFEESPEED",      default = true  },
	{ name = "COFFEEDURATION",   default = 480   },
	{ name = "COFFEEDROPRATE",   default = 4     },

	{ name = "SCRAPBOOK",        default = true  },
	{ name = "WARLYRECIPES",     default = true  },
	{ name = "KEEPFOOD",         default = false },
	{ name = "WARLYMEALGRINDER", default = false },
	{ name = "FERTILIZERTWEAK",  default = false },

	{ name = "SERENITY_CC",      default = false },
	{ name = "MEADOW_CC",        default = false },
	{ name = "FULLMOONTRANS",    default = false },

	{ name = "RETROCOMPAT",      default = false },
 -- { name = "MODRETROFITFORCE", default = false },
 -- { name = "MODRETROFIT",      default = 0     },
	{ name = "MODTRADES",        default = false },
}

for _, option in ipairs(mod_options) do
	local value = GetModConfigData(option.name)
	print(string.format("HOF CONFIG - %s = %s", option.name, tostring(value)))
end
]]--