local _G      = GLOBAL
local require = _G.require

require("hof_mainfunctions")
require("strings/hof_strings")
modimport("hof_init/misc/hof_tuning")

FrontEndAssets =
{
	Asset("IMAGE", "images/customizationimages/hof_customizationimages.tex"),
	Asset("ATLAS", "images/customizationimages/hof_customizationimages.xml"),

    -- Accomplishments Mod.
    -- Asset("IMAGE", "images/achievementsimages/hof_achievements_images.tex"),
    -- Asset("ATLAS", "images/achievementsimages/hof_achievements_images.xml"),

    -- Asset("IMAGE", "images/achievementsimages/hof_achievements_buttons.tex"),
    -- Asset("ATLAS", "images/achievementsimages/hof_achievements_buttons.xml"),
}

ReloadFrontEndAssets()

local localization = GetModConfigData("LANGUAGE")
if localization then
	for _, v in pairs(hof_init_strings) do
		require("strings/localization_"..localization.."/hof_strings")
	end
end

_G.ChangeFoodConfigs("RETROFIT", 0)