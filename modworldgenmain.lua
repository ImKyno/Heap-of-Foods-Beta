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

modimport("hof_init/hof_customize")
modimport("hof_init/hof_worldgen")

TUNING.HOF_RESOURCES = .08
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Custom Turfs.
if not _G.KnownModIndex:IsModEnabled("workshop-2428854303") or _G.KnownModIndex:IsModEnabled("workshop-2528541304") then
	AddTile("STONECITY", "LAND",
		{
			ground_name        = "City Stone",
			old_static_id      = GROUND.QUAGMIRE_CITYSTONE,
		},
		{
			name               = "cave",
			noise_texture      = "levels/textures/events/quagmire_citystone_noise.tex",
			runsound           = "dontstarve/movement/run_dirt",
			walksound          = "dontstarve/movement/walk_dirt",
			snowsound          = "dontstarve/movement/run_snow",
			hard               = true,
		},
		{
			name               = "map_edge",
			noise_texture      = "levels/textures/events/quagmire_citystone_mini.tex",
		},
		{
			name               = "stonecity",
			anim               = "stonecity",
			bank_build         = "kyno_turfs_events",
		}
	)

	AddTile("PINKPARK", "LAND",
		{
			ground_name        = "Pink Park",
			old_static_id      = GROUND.QUAGMIRE_PARKFIELD,
		},
		{
			name               = "deciduous",
			noise_texture      = "levels/textures/events/quagmire_parkfield_noise.tex",
			runsound           = "dontstarve/movement/run_grass",
			walksound          = "dontstarve/movement/walk_grass",
			snowsound          = "dontstarve/movement/run_snow",
			hard               = false,
		},
		{
			name               = "map_edge",
			noise_texture      = "levels/textures/events/quagmire_parkfield_mini.tex",
		},
		{
			name               = "pinkpark",
			anim               = "pinkpark",
			bank_build         = "kyno_turfs_events",
		}
	)
end

-- To match The Architect Pack and Not Enough Turfs.
if not _G.KnownModIndex:IsModEnabled("workshop-2428854303") or _G.KnownModIndex:IsModEnabled("workshop-2528541304") then
		ChangeTileRenderOrder(WORLD_TILES.PINKPARK, 	WORLD_TILES.DECIDUOUS, 			true)
		ChangeTileRenderOrder(WORLD_TILES.STONECITY, 	WORLD_TILES.ROCKY, 				true)
else
		ChangeTileRenderOrder(WORLD_TILES.PINKPARK, 	WORLD_TILES.SWIRLGRASSMONO, 	true)
		ChangeTileRenderOrder(WORLD_TILES.STONECITY, 	WORLD_TILES.PINKSTONE, 			true)
end

-- This does nothing. Mostly used for the Tiled only.
-- QUAGMIRE_PARKFIELD_ID = 32
-- QUAGMIRE_CITYSTONE_ID = 40
-- ROCKY_ID				       = 3
-- SAVANNA_ID			       = 5
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
	WORLD_TILES.OCEAN_BRINEPOOL, WORLD_TILES.ROCKY, WORLD_TILES.SAVANNA, WORLD_TILES.STONECITY, WORLD_TILES.PINKPARK
	-- 1              			 -- 2               -- 3                 -- 4                   -- 5
}

_G.OCEANSETPIECE_GROUNDS         = 
{
	WORLD_TILES.OCEAN_BRINEPOOL,
	-- 1
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
		min_dist_from_land       = 2,
	})
	Layouts[layout].ground_types = _G.SERENITYISLAND_GROUNDS
end

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
		min_dist_from_land       = 2,
	})
	Layouts[layout].ground_types = _G.OCEANSETPIECE_GROUNDS
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------