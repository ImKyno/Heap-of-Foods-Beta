------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G             = GLOBAL
local require        = _G.require
local LAYOUT         = _G.LAYOUT
local GROUND         = _G.GROUND
local LOCKS          = _G.LOCKS
local KEYS           = _G.KEYS
local LOCKS_KEYS     = _G.LOCKS_KEYS
local LAYOUT         = _G.LAYOUT
local Layouts        = require("map/layouts").Layouts
local StaticLayout   = require("map/static_layout")

require("map/terrain")
require("tilemanager")

modimport("hof_init/world/hof_customize")
modimport("hof_init/world/hof_worldgen")

local TheArchitectPack = _G.KnownModIndex:IsModEnabled("workshop-2428854303")
local NotEnoughTurfs   = _G.KnownModIndex:IsModEnabled("workshop-2528541304")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Since we already have the turfs and they can be dug, we are going to use them for make a custom prefab.
-- Basically you're getting the original turfs from ground with a custom prefab i.e: the turf item.
local GROUND_TURFS = 
{
	[WORLD_TILES.QUAGMIRE_PARKFIELD] = "turf_pinkpark",
	[WORLD_TILES.QUAGMIRE_CITYSTONE] = "turf_stonecity",
}

require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_PARKFIELD] = { name = "pinkpark",  bank_build = "kyno_turfs_events", anim = "pinkpark"  }
require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_CITYSTONE] = { name = "stonecity", bank_build = "kyno_turfs_events", anim = "stonecity" }

ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_PARKFIELD,  WORLD_TILES.DECIDUOUS, true)
ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_CITYSTONE,  WORLD_TILES.ROCKY,     true)

-- To match The Architect Pack and Not Enough Turfs.
if TheArchitectPack or NotEnoughTurfs then
	ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_PARKFIELD, WORLD_TILES.SWIRLGRASSMONO, true)
	ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_CITYSTONE, WORLD_TILES.PINKSTONE,      true)
end

-- This does nothing. Mostly used for the Tiled only.
-- QUAGMIRE_PARKFIELD_ID = 32
-- QUAGMIRE_CITYSTONE_ID = 40
-- ROCKY_ID				 = 3
-- SAVANNA_ID			 = 5
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Keys and Locks.
local keycount                    = 1
for k, v in pairs(KEYS) do
	keycount                      = keycount + 1
end

KEYS["SERENITY_ISLAND"]           = keycount

local lockcount                   = 1
for k, v in pairs(LOCKS) do
	lockcount                     = lockcount + 1
end

LOCKS["SERENITY_ISLAND"]          = lockcount
LOCKS_KEYS[LOCKS.SERENITY_ISLAND] = {KEYS.SERENITY_ISLAND}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Our Custom Layouts.
Layouts["Oasis"]              = StaticLayout.Get("map/static_layouts/hof_oasis")
Layouts["SerenityIslandShop"] = StaticLayout.Get("map/static_layouts/hof_serenityisland_shop")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrofit the Serenity Archipelago in the world.
-- The numbers below each turf represents them on the setpiece file.
_G.SERENITYISLAND_GROUNDS        = 
{
	WORLD_TILES.OCEAN_BRINEPOOL, WORLD_TILES.ROCKY, WORLD_TILES.SAVANNA, WORLD_TILES.QUAGMIRE_CITYSTONE, WORLD_TILES.QUAGMIRE_PARKFIELD
	-- 1              			 -- 2               -- 3                 -- 4                            -- 5
}

local hof_ocean_islands          = 
{
	"hof_serenityisland1", 
	"hof_serenityisland2"
}

for i, layout in ipairs(hof_ocean_islands) do
	Layouts[layout] = StaticLayout.Get("map/static_layouts/"..layout,
	{
		start_mask 			     = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		fill_mask                = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		add_topology             = {room_id = "StaticLayoutIsland:Serenity Archipelago", tags = {"RoadPoison", "serenityisland", "not_mainland", "nohunt", "nohasslers"}},
		areas =
		{
		},
		min_dist_from_land       = 5,
	})
	Layouts[layout].ground_types = _G.SERENITYISLAND_GROUNDS
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ocean Wrecks Setpieces.
_G.OCEANSETPIECE_GROUNDS         = 
{
	WORLD_TILES.OCEAN_BRINEPOOL,
	-- 1
}

local hof_ocean_setpieces 		 = 
{
	"hof_oceansetpiece_crates",
	"hof_oceansetpiece_crates2",
	"hof_oceansetpiece_seaweeds",
	"hof_oceansetpiece_taroroot",
	"hof_oceansetpiece_waterycress",
}

for i, layout in ipairs(hof_ocean_setpieces) do
	Layouts[layout] = StaticLayout.Get("map/static_layouts/"..layout,
	{
		start_mask 			     = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		fill_mask                = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		add_topology             = {room_id = "StaticLayoutIsland:OceanSetpiece HoF", tags = {"RoadPoison", "not_mainland"}},
		areas =
		{
		},
		min_dist_from_land       = 5,
	})
	Layouts[layout].ground_types = _G.OCEANSETPIECE_GROUNDS
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------