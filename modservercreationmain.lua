local _G 		= GLOBAL
local require 	= _G.require

FrontEndAssets = 
{
	Asset("IMAGE", "images/customizationimages/hof_customizationicons.tex"),
	Asset("ATLAS", "images/customizationimages/hof_customizationicons.xml"),
	
    -- Accomplishments Mod.
    Asset("IMAGE", "images/achievementsimages/hof_achievements_images.tex"),
    Asset("ATLAS", "images/achievementsimages/hof_achievements_images.xml"),

    Asset("IMAGE", "images/achievementsimages/hof_achievements_buttons.tex"),
    Asset("ATLAS", "images/achievementsimages/hof_achievements_buttons.xml"),
}

ReloadFrontEndAssets()

require("hof_mainfunctions")
_G.ChangeFoodConfigs("HOF_RETROFIT", 0)