------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local cooking      = require("cooking")
local brewing      = require("hof_brewing")
local JarRecipes   = require("hof_foodrecipes_jar")
local KegRecipes   = require("hof_foodrecipes_keg")
local ClusterPanel = require("screens/redux/panels/brewbookpanel")

local HOF_LANGUAGE = GetModConfigData("HOF_LANGUAGE")
modimport("hof_init/language/"..HOF_LANGUAGE)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Assets.
Assets =
{
	Asset("ANIM", "anim/kyno_turfs_events.zip"),
	
	Asset("ANIM", "anim/farm_plant_kyno_radish.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_sweetpotato.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_fennel.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_aloe.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_cucumber.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_parznip.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_turnip.zip"),
	
    Asset("IMAGE", "images/cookbookimages/hof_cookbookimages.tex"),
	Asset("ATLAS", "images/cookbookimages/hof_cookbookimages.xml"),
	Asset("ATLAS_BUILD", "images/cookbookimages/hof_cookbookimages.xml", 256),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Adds the Brewbook to the Compendium.
AddClassPostConstruct("screens/redux/compendiumscreen", function(self)
    local brewbook_button = self.subscreener:MenuButton("SEXO", "brewbookpanel", "SEXO SEXO SEXOOO", self.tooltip)

    local panel = ClusterPanel()
    panel:Hide()

    self.subscreener.sub_screens["brewbookpanel"] = self.panel_root:AddChild(panel)
    self.subscreener.menu:AddCustomItem(brewbook_button)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------