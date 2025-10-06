local _G      = GLOBAL
local require = _G.require

require("strings/hof_strings_customizations")

modimport("hof_init/misc/hof_tuning")
modimport("scripts/strings/hof_strings_worldsettings")

local localization = GetModConfigData("LANGUAGE")
if localization then
	require("strings/localization_"..localization.."/hof_strings_customizations")
end

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

require("hof_util")
_G.ChangeFoodConfigs("MODRETROFIT", 0)