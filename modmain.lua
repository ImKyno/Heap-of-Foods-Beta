-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require

require("hof_constants")
require("hof_debugcommands")
require("hof_brewing")

-- Mod Languages. I need to make this one better if new translations are added...
local HOF_LANGUAGE = GetModConfigData("HOF_LANGUAGE")
modimport("hof_init/strings/"..HOF_LANGUAGE)
modimport("hof_init/strings/hof_strings_loadingtips")

--[[
if HOF_LANGUAGE == "hof_strings_br" then
	modimport("hof_init/strings/hof_strings_loadingtips_br")
elseif HOF_LANGUAGE == "hof_strings_zht" then
	modimport("hof_init/strings/hof_strings_loadingtips_zht")
else
	modimport("hof_init/strings/hof_strings_loadingtips")
end
]]--

-- Mod Dependencies.
local hof_init_misc =
{
	"hof_assets",
	"hof_prefabs",
	"hof_recipes",
	"hof_actions",
	"hof_meatrackfix",
	"hof_brewbook",
	"hof_stategraphs",
	"hof_containers",
	"hof_tuning",
	"hof_postinits_misc",
	"hof_icons",
}

local hof_init_world =
{
	"hof_customize",
	"hof_regrowth",
	"hof_retrofit",
	"hof_worldgen",
	"hof_postinits_world",
}

local hof_init_foods =
{
	"hof_farming",
	"hof_cooking",
	"hof_bruwing",
	"hof_postinits_foods",
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

-- Fix For Inventory Icons.
local atlas = (src and src.components.inventoryitem and src.components.inventoryitem.atlasname and resolvefilepath(src.components.inventoryitem.atlasname) ) or "images/inventoryimages.xml"