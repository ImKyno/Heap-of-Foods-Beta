local _G 		= GLOBAL
local require 	= _G.require

FrontEndAssets = {
	Asset("IMAGE", "images/customizationimages/hof_customizationicons.tex"),
	Asset("ATLAS", "images/customizationimages/hof_customizationicons.xml"),
}

ReloadFrontEndAssets()

require("hof_mainfunctions")
_G.ChangeFoodConfigs("HOF_RETROFIT", 0)