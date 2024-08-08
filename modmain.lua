-- Common Dependencies.
local _G            = GLOBAL
local require       = _G.require

require("hof_constants")
require("hof_debugcommands")
require("hof_brewing")

-- Mod Languages. I need to make this one better if new translations are added...
local HOF_LANGUAGE = GetModConfigData("HOF_LANGUAGE")
modimport("hof_init/strings/"..HOF_LANGUAGE)
modimport("hof_init/strings/hof_strings_loadingtips")

-- Mod Dependencies.
local hof_init_misc =
{
	"hof_assets",
	"hof_prefabs",
	"hof_recipes",
	"hof_brewbook",
	"hof_actions",
	"hof_stategraphs",
	"hof_meatrackfix",
	"hof_containers",
	"hof_tuning",
	"hof_postinits_misc",
	"hof_icons",
}

local hof_init_world =
{
	"hof_regrowth",
	"hof_retrofit",
	"hof_retrofit_component",
	"hof_worldgen",
	"hof_messagebottletreasures",
	"hof_postinits_world",
	"hof_postinits_mobs",
}

local hof_init_foods =
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
_G.CONFIGS_HOF  =
{
	ENABLEDMODS = {}
}

_G.CONFIGS_HOF.SEASONALFOOD = GetModConfigData("HOF_SEASONALFOOD")
_G.CONFIGS_HOF.SCRAPBOOK    = GetModConfigData("HOF_SCRAPBOOK")

if _G.CONFIGS_HOF.SCRAPBOOK then
	modimport("hof_init/misc/hof_scrapbook")
	modimport("hof_init/strings/hof_strings_scrapbook")
end

-- This belongs to the Accomplishments Mod.
-- modimport("achievementsmain")