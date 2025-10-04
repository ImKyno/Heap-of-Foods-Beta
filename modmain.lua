-- Common Dependencies.
local _G               = GLOBAL
local require          = _G.require

require("hof_constants")
require("hof_debugcommands")
require("hof_brewing")
require("hof_behaviours")

-- Mod Strings and Localizations.
-- If you want to contribute with your localization please head to "scripts/strings/hof_localization.lua" for more information.
modimport("scripts/strings/hof_strings_loadingtips")

local hof_init_strings = 
{
	"hof_strings",
	"hof_strings_customizations",
	"hof_strings_scrapbook",
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

-- Mod Dependencies.
local hof_init_misc    =
{
	"hof_tuning",
	"hof_assets",
	"hof_prefabs",
	"hof_recipes",
	"hof_recipes_serenity",
	"hof_recipes_meadow",
	"hof_brewbook",
	"hof_actions",
	"hof_stategraphs",
	"hof_containers",
	"hof_meatrack_foods",
	"hof_postinits_misc",
	"hof_postinits_brains",
	"hof_postinits_playervision",
}

local hof_init_world   =
{
	"hof_tiledefs",
	"hof_regrowth",
	"hof_retrofit",
	"hof_pollinator_component",
	"hof_worldgen",
	"hof_messagebottletreasures",
	"hof_postinits_world",
	"hof_postinits_mobs",
	"hof_slaughterable_animals",
	"hof_ancienttree_data",
	"hof_tree_rock_data",
}

local hof_init_foods   =
{
	"hof_farming",
	"hof_cooking",
	"hof_bruwing",
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
_G.CONFIGS_HOF         =
{
	ENABLEDMODS        = {}
}

_G.CONFIGS_HOF.SEASONALFOOD = GetModConfigData("SEASONALFOOD")
_G.CONFIGS_HOF.SCRAPBOOK    = GetModConfigData("SCRAPBOOK")

if _G.CONFIGS_HOF.SCRAPBOOK then
	modimport("hof_init/misc/hof_scrapbook")
	modimport("hof_init/misc/hof_shinyloots") -- Requires Scrapbook to be enabled...
end

-- This belongs to the Accomplishments Mod.
-- modimport("achievementsmain")