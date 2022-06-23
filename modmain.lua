------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require

require("hof_constants")
require("hof_brewing")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Languages.
-- I need to make this one better if new translations are added...
local HOF_LANGUAGE = GetModConfigData("HOF_LANGUAGE")
modimport("hof_init/language/"..HOF_LANGUAGE)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Dependencies.
local hofmodimports = 
{	
	"hof_assets",
	"hof_prefabs",
	"hof_recipes",
	"hof_postinits",
	"hof_actions",
	"hof_meatrackfix",
	"hof_farming",
	"hof_cooking",
	"hof_bruwing",
	"hof_brewbook",
	"hof_stategraphs",
	"hof_retrofit",
	"hof_regrowth",
	"hof_containers",
	"hof_loadingtips",
	"hof_icons",
}

for _, v in pairs(hofmodimports) do
	modimport("hof_init/"..v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fix For Inventory Icons.
local atlas = (src and src.components.inventoryitem and src.components.inventoryitem.atlasname and resolvefilepath(src.components.inventoryitem.atlasname) ) or "images/inventoryimages.xml"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------