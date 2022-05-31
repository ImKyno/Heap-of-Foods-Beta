------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require

require("cooking")
require("hof_constants")
AddPopup("BREWBOOK")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Dependencies.
local modimports = 
{
	"hof_prefabs",
	"hof_recipes",
	"hof_strings",
	"hof_postinits",
	"hof_actions",
	"hof_meatrackfix",
	"hof_farming",
	"hof_cooking",
	"hof_retrofit",
	"hof_regrowth",
	"hof_containers",
	"hof_loadingtips",
	"hof_icons",
}

for _, v in pairs(modimports) do
	modimport("hof_init/"..v)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fix For Inventory Icons.
local atlas = (src and src.components.inventoryitem and src.components.inventoryitem.atlasname and resolvefilepath(src.components.inventoryitem.atlasname) ) or "images/inventoryimages.xml"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Preload Assets. (Before the game load).
PreloadAssets =
{
	Asset("IMAGE", "images/tipsimages/hof_loadingtips_icon.tex"),
	Asset("ATLAS", "images/tipsimages/hof_loadingtips_icon.xml"),
}

ReloadPreloadAssets() -- Reload it, so our loading assets can work properly.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Assets.
Assets =
{	
	Asset("ANIM", "anim/kyno_humanmeat.zip"),
	Asset("ANIM", "anim/kyno_mushroomstump.zip"),
	Asset("ANIM", "anim/kyno_spotbush.zip"),
	Asset("ANIM", "anim/kyno_wheat.zip"),
	Asset("ANIM", "anim/kyno_aloe.zip"),
	Asset("ANIM", "anim/kyno_radish.zip"),
	Asset("ANIM", "anim/kyno_fennel.zip"),
	Asset("ANIM", "anim/kyno_sweetpotato.zip"),
	Asset("ANIM", "anim/kyno_seaweeds.zip"),
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

	Asset("IMAGE", "images/inventoryimages/hof_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_buildingimages.xml"),

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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Minimap Icons.
AddMinimapAtlas("images/minimapimages/hof_minimapicons.xml")
AddMinimapAtlas("images/minimapimages/hof_parsnipminimap.xml") -- The other icon was very small, so I'm just using this from TAP...
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Support for the Craft Pot Mod.
--[[
if _G.KnownModIndex:IsModEnabled("workshop-727774324") then	
	require("cookingpots")
	local COOKINGPOTS = _G.COOKINGPOTS

	local modcookpots = 
	{ 
		"kyno_cookware_syrup", 
		"kyno_cookware_small", 
		"kyno_cookware_big",
		"kyno_cookware_elder",
		"kyno_cookware_small_grill",
		"kyno_cookware_grill",
		"kyno_cookware_oven_small_casserole",
		"kyno_cookware_oven_casserole",
	}

	for k,v in pairs(modcookpots) do
		if _G.AddCookingPot then
			_G.AddCookingPot(v)
		end
	end
end
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
AddSimPostInit(function()
    _G.TheInput:AddKeyHandler(
    function(key, down)
        -- Only trigger on key down
        if not down then return end
        -- Push our screen
        if key == _G.KEY_N then
            local screen = TheFrontEnd:GetActiveScreen()
            -- End if we can't find the screen name (e.g. asleep)
            if not screen or not screen.name then return true end
            -- If the hud exists, open the UI
            if screen.name:find("HUD") then
                -- We want to pass in the (clientside) player entity
                TheFrontEnd:PushScreen(require("screens/brewbookpopupscreen")(_G.ThePlayer))
                return true
            else
                -- If the screen is already open, close it
                if screen.name == "brewbookpopupscreen" then
                    screen:OnClose()
                end
            end
        end
        -- Require CTRL for any debug keybinds
        if _G.TheInput:IsKeyDown(_G.KEY_CTRL) then
             -- Load latest save and run latest scripts
            if key == _G.KEY_R then
                if _G.TheWorld.ismastersim then
                    _G.c_reset()
                else
                    _G.TheNet:SendRemoteExecute("c_reset()")
                end
            end
        end
    end)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------