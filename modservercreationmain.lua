local _G      = GLOBAL
local require = _G.require

require("hof_util")

modimport("scripts/strings/hof_strings_worldsettings")
modimport("hof_init/misc/hof_tuning")

FrontEndAssets =
{
	Asset("IMAGE", "images/hof_loadingtips_icon.tex"),
	Asset("ATLAS", "images/hof_loadingtips_icon.xml"),

	Asset("IMAGE", "images/customizationimages/hof_customizationimages_worldgen.tex"),
	Asset("ATLAS", "images/customizationimages/hof_customizationimages_worldgen.xml"),
	
	Asset("IMAGE", "images/customizationimages/hof_customizationimages_worldsettings.tex"),
	Asset("ATLAS", "images/customizationimages/hof_customizationimages_worldsettings.xml"),

    -- Accomplishments Mod.
    -- Asset("IMAGE", "images/achievementsimages/hof_achievements_images.tex"),
    -- Asset("ATLAS", "images/achievementsimages/hof_achievements_images.xml"),

    -- Asset("IMAGE", "images/achievementsimages/hof_achievements_buttons.tex"),
    -- Asset("ATLAS", "images/achievementsimages/hof_achievements_buttons.xml"),
}

ReloadFrontEndAssets()

--_G.HOF_ChangeConfiguration("MODRETROFIT", 0)