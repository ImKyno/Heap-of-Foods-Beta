------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 							= GLOBAL
local require 						= _G.require
local LAYOUT 						= _G.LAYOUT
local GROUND 						= _G.GROUND
local LOCKS 						= _G.LOCKS
local KEYS 							= _G.KEYS
local LOCKS_KEYS 					= _G.LOCKS_KEYS
local LAYOUT						= _G.LAYOUT
local Layouts 						= require("map/layouts").Layouts
local StaticLayout  				= require("map/static_layout")

require("map/terrain")

modimport("tile_adder")
modimport("hof_init/hof_customize")
modimport("hof_init/hof_worldgen")

TUNING.HOF_RESOURCES = .08
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Keys and Locks.
local keycount 						= 1
for k, v in pairs(KEYS) do
	keycount 						= keycount + 1
end

KEYS["SERENITY_ISLAND"] 			= keycount

local lockcount 					= 1
for k, v in pairs(LOCKS) do
	lockcount 						= lockcount + 1
end

LOCKS["SERENITY_ISLAND"] 			= lockcount
LOCKS_KEYS[LOCKS.SERENITY_ISLAND]	= {KEYS.SERENITY_ISLAND}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Our Custom Layouts.
Layouts["Oasis"] 					= StaticLayout.Get("map/static_layouts/hof_oasis")
Layouts["SerenityIslandShop"] 		= StaticLayout.Get("map/static_layouts/hof_serenityisland_shop")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrofit the Serenity Archipelago in the world.
_G.SERENITYISLAND_GROUNDS = {
	GROUND.IMPASSABLE, GROUND.ROCKY, GROUND.SAVANNA, GROUND.QUAGMIRE_CITYSTONE, GROUND.QUAGMIRE_PARKFIELD
	-- 1               -- 2          -- 3            -- 4                       -- 5
}

local retrofit_islands = {"hof_serenityisland1", "hof_serenityisland2"}	
for i, layout in ipairs(retrofit_islands) do
	Layouts[layout] = StaticLayout.Get("map/static_layouts/"..layout,
	{
		start_mask 					= _G.PLACE_MASK.IGNORE_IMPASSABLE,
		fill_mask 					= _G.PLACE_MASK.IGNORE_IMPASSABLE,
		add_topology 				= {room_id = "StaticLayoutIsland:Serenity Archipelago", tags = {"RoadPoison", "serenityisland", "not_mainland", "nohunt", "nohasslers"}},
		areas =
		{
		},
		min_dist_from_land 			= 0,
	})
	-- Layouts[layout].ground_types = _G.SERENITYISLAND_GROUNDS
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Since we already have the turfs and they can be dug, we are going to use them for make a custom prefab.
-- Basically you're getting the original turfs from ground with a custom prefab i.e: the turf item.
local GROUND_TURFS = 
{
	[GROUND.QUAGMIRE_PARKFIELD]	= "turf_pinkpark",
	[GROUND.QUAGMIRE_CITYSTONE] = "turf_stonecity",
}

require("worldtiledefs").turf[GROUND.QUAGMIRE_PARKFIELD] 	= { name = "pinkpark", 	bank_build = "kyno_turfs_events", 	anim = "pinkpark" }
require("worldtiledefs").turf[GROUND.QUAGMIRE_CITYSTONE] 	= { name = "stonecity", bank_build = "kyno_turfs_events", 	anim = "stonecity"}

-- To match The Architect Pack and Not Enough Turfs.
if not _G.KnownModIndex:IsModEnabled("workshop-2428854303") or _G.KnownModIndex:IsModEnabled("workshop-2528541304") then
	ChangeTileTypeRenderOrder(GROUND.QUAGMIRE_PARKFIELD, 	GROUND.ROCKY, 				true)
	ChangeTileTypeRenderOrder(GROUND.QUAGMIRE_CITYSTONE, 	GROUND.ROAD, 				true)
else
	ChangeTileTypeRenderOrder(GROUND.QUAGMIRE_PARKFIELD, 	GROUND.SWIRLGRASSMONO, 		true)
	ChangeTileTypeRenderOrder(GROUND.QUAGMIRE_CITYSTONE, 	GROUND.PINKSTONE, 			true)
end

-- This does nothing. Mostly used for the Tiled only.
-- QUAGMIRE_PARKFIELD_ID = 32
-- QUAGMIRE_CITYSTONE_ID = 40
-- ROCKY_ID				 = 3
-- SAVANNA_ID			 = 5
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------