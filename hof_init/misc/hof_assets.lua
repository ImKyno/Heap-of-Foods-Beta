-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require

-- Preload Assets. (Before the game load).
PreloadAssets =
{
	Asset("IMAGE", "images/tipsimages/hof_loadingtips_icon.tex"),
	Asset("ATLAS", "images/tipsimages/hof_loadingtips_icon.xml"),
}

ReloadPreloadAssets() -- Reload it, so our loading assets can work properly.

-- Assets.
Assets =
{	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),

	Asset("ANIM", "anim/kyno_mushroomstump.zip"),
	Asset("ANIM", "anim/kyno_spotbush.zip"),
	Asset("ANIM", "anim/kyno_wheat.zip"),
	Asset("ANIM", "anim/kyno_aloe.zip"),
	Asset("ANIM", "anim/kyno_radish.zip"),
	Asset("ANIM", "anim/kyno_fennel.zip"),
	Asset("ANIM", "anim/kyno_sweetpotato.zip"),
	Asset("ANIM", "anim/kyno_cucumber.zip"),
	Asset("ANIM", "anim/kyno_waterycress.zip"),
	Asset("ANIM", "anim/kyno_turnip.zip"),
	Asset("ANIM", "anim/kyno_veggies.zip"),
	Asset("ANIM", "anim/kyno_banana.zip"),
	Asset("ANIM", "anim/kyno_bananatree_sapling.zip"),
	Asset("ANIM", "anim/kyno_kokonut.zip"),
	Asset("ANIM", "anim/kyno_weed_seeds.zip"),
	Asset("ANIM", "anim/kyno_turfs_events.zip"),
	
	Asset("ANIM", "anim/parsnip.zip"),
	Asset("ANIM", "anim/grotto_parsnip_giant.zip"),
	
	Asset("ANIM", "anim/farm_plant_kyno_radish.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_sweetpotato.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_fennel.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_aloe.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_cucumber.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_parznip.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_turnip.zip"),
	
	Asset("IMAGE", "images/colourcubesimages/quagmire_cc.tex"),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
	Asset("IMAGE", "images/minimapimages/hof_parsnipminimap.tex"),
	Asset("ATLAS", "images/minimapimages/hof_parsnipminimap.xml"),
	
	Asset("IMAGE", "images/tabimages/hof_tabimages.tex"),
	Asset("ATLAS", "images/tabimages/hof_tabimages.xml"),
	
	Asset("IMAGE", "images/cookbookimages/hof_cookbookimages.tex"),
	Asset("ATLAS", "images/cookbookimages/hof_cookbookimages.xml"),
	Asset("ATLAS_BUILD", "images/cookbookimages/hof_cookbookimages.xml", 256),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

-- Minimap Icons.
AddMinimapAtlas("images/minimapimages/hof_minimapicons.xml")
AddMinimapAtlas("images/minimapimages/hof_parsnipminimap.xml") -- The other icon was very small, so I'm just using this from TAP...
