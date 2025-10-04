local _G      = GLOBAL
local require = _G.require

require("hof_mainfunctions")
require("strings/hof_strings_customizations")

modimport("hof_init/misc/hof_tuning")
modimport("hof_init/world/hof_worldsettings")

local localization = GetModConfigData("LANGUAGE")
if localization then
	require("strings/localization_"..localization.."/hof_strings_customizations")
end

FrontEndAssets =
{
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

_G.ChangeFoodConfigs("RETROFIT", 0)
_G.ChangeFoodConfigs("RETROFIT_FORCE", false)