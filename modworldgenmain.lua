-- Common Dependencies.
local _G             = GLOBAL
local require        = _G.require
local LAYOUT         = _G.LAYOUT
local GROUND         = _G.GROUND
local LOCKS          = _G.LOCKS
local KEYS           = _G.KEYS
local LOCKS_KEYS     = _G.LOCKS_KEYS
local Layouts        = require("map/layouts").Layouts
local StaticLayout   = require("map/static_layout")

require("map/terrain")
require("tilemanager")

-- modimport("hof_init/world/hof_customize")
modimport("hof_init/world/hof_worldgen")

local TheArchitectPack = _G.KnownModIndex:IsModEnabled("workshop-2428854303")
local NotEnoughTurfs   = _G.KnownModIndex:IsModEnabled("workshop-2528541304")

AddTile("HOF_FIELDS", "LAND",
	{
		ground_name 	= "HOF Fields",
		old_static_id   = 65,
	},
	{
		name			= "jungle",
		noise_texture	= "levels/textures/hof/fields_noise.tex",
		runsound		= "dontstarve/movement/run_grass",
		walksound		= "dontstarve/movement/walk_grass",
		snowsound		= "dontstarve/movement/run_snow",
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hof/fields_mini.tex",
	},
	{
		name			= "fields",
		anim			= "fields",
		bank_build		= "kyno_turfs_hof",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("HOF_TIDALMARSH", "LAND",
	{
		ground_name 	= "HOF Tidal Marsh",
		old_static_id 	= 80,
	},
	{
		name			= "tidalmarsh",
		noise_texture	= "levels/textures/hof/tidalmarsh_noise.tex",
		runsound 		= "dontstarve/movement/run_marsh",
        walksound 		= "dontstarve/movement/walk_marsh",
		snowsound		= "dontstarve/movement/run_snow",
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hof/tidalmarsh_mini.tex",
	},
	{
		name			= "tidalmarsh",
		anim			= "tidalmarsh",
		bank_build		= "kyno_turfs_hof",
		pickupsound     = "squidgy",
	}
)

-- Since we already have the turfs and they can be dug, we are going to use them for make a custom prefab.
-- Basically you're getting the original turfs from ground with a custom prefab i.e: the turf item.
local GROUND_TURFS =
{
	[WORLD_TILES.QUAGMIRE_PARKFIELD] = "turf_pinkpark",
	[WORLD_TILES.QUAGMIRE_CITYSTONE] = "turf_stonecity",
}

require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_PARKFIELD] = 
{ 
	name = "pinkpark",  
	bank_build = "kyno_turfs_events", 
	anim = "pinkpark",  
	pickupsound = "rock", 
}

require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_CITYSTONE] = 
{ 
	name = "stonecity", 
	bank_build = "kyno_turfs_events", 
	anim = "stonecity", 
	pickupsound = "rock",
	hard = true,
	roadways = true,
}

ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_PARKFIELD,  WORLD_TILES.DECIDUOUS, true)
ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_CITYSTONE,  WORLD_TILES.ROCKY,     true)
ChangeTileRenderOrder(WORLD_TILES.HOF_TIDALMARSH,      WORLD_TILES.MARSH,     true)
ChangeTileRenderOrder(WORLD_TILES.HOF_FIELDS,          WORLD_TILES.DECIDUOUS, true)

-- To match The Architect Pack and Not Enough Turfs.
if TheArchitectPack or NotEnoughTurfs then
	ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_PARKFIELD, WORLD_TILES.SWIRLGRASSMONO, true)
	ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_CITYSTONE, WORLD_TILES.PINKSTONE,      true)
	ChangeTileRenderOrder(WORLD_TILES.HOF_TIDALMARSH,     WORLD_TILES.TIDALMARSH,     true)
	ChangeTileRenderOrder(WORLD_TILES.HOF_FIELDS,         WORLD_TILES.FIELDS,         true)
end

-- This does nothing. Mostly used for the Tiled only.
-- QUAGMIRE_PARKFIELD_ID = 32
-- QUAGMIRE_CITYSTONE_ID = 40
-- ROCKY_ID				 = 3
-- SAVANNA_ID			 = 5

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

-- Our Custom Layouts.
Layouts["Oasis"]              = StaticLayout.Get("map/static_layouts/hof_oasis")
Layouts["SerenityIslandShop"] = StaticLayout.Get("map/static_layouts/hof_serenityisland_shop")

-- Retrofit the Serenity Archipelago in the world.
-- The numbers below each turf represents them on the setpiece file.
_G.SERENITYISLAND_GROUNDS        =
{
	WORLD_TILES.OCEAN_BRINEPOOL, WORLD_TILES.ROCKY, WORLD_TILES.SAVANNA, WORLD_TILES.QUAGMIRE_CITYSTONE, WORLD_TILES.QUAGMIRE_PARKFIELD
	-- 1              			 -- 2               -- 3                 -- 4                            -- 5
}

local hof_serenity_islands          =
{
	"hof_serenityisland1",
}

for i, layout in ipairs(hof_serenity_islands) do
	Layouts[layout] = StaticLayout.Get("map/static_layouts/"..layout,
	{
		start_mask 			     = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		fill_mask                = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		add_topology             = {room_id = "StaticLayoutIsland:Serenity Archipelago", tags = {"RoadPoison", "serenityarea", "not_mainland", "nohunt", "nohasslers"}},
		areas =
		{
		},
		min_dist_from_land       = 10,
	})
	Layouts[layout].ground_types = _G.SERENITYISLAND_GROUNDS
end

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
		add_topology             = {room_id = "StaticLayoutIsland:OceanSetpiece HoF", tags = {"RoadPoison", "not_mainland", "wreckarea"}},
		areas =
		{
		},
		min_dist_from_land       = 10,
	})
	Layouts[layout].ground_types = _G.OCEANSETPIECE_GROUNDS
end

_G.MEADOWISLAND_GROUNDS          =
{
	WORLD_TILES.OCEAN_BRINEPOOL, WORLD_TILES.MONKEY_GROUND, WORLD_TILES.HOF_FIELDS, WORLD_TILES.HOF_TIDALMARSH,
	-- 1              			 -- 2                       -- 3                    -- 4
}

local hof_meadow_setpieces       =
{
	"hof_meadowisland1",
}

for i, layout in ipairs(hof_meadow_setpieces) do
	Layouts[layout] = StaticLayout.Get("map/static_layouts/"..layout,
	{
		start_mask 			     = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		fill_mask                = _G.PLACE_MASK.IGNORE_IMPASSABLE,
		add_topology             = {room_id = "StaticLayoutIsland:Seaside Island", tags = {"RoadPoison", "meadowarea", "not_mainland"}},
		areas =
		{
		},
		min_dist_from_land       = 10,
	})
	Layouts[layout].ground_types = _G.MEADOWISLAND_GROUNDS
end

-- Custom Layout for Waterlogged biome.
local function HofWaterloggedArea()
	local stuff = {}

	table.insert(stuff, "oceantree")
	for i = 1, 6 do
		if math.random() < 0.1 then
			table.insert(stuff, "oceantree")
		end
	end

	table.insert(stuff, "oceanvine")
	table.insert(stuff, "oceanvine_deco")

	if math.random() < 0.2 then
		table.insert(stuff, "oceanvine")
	end

	for i = 1, 3 do
		if math.random() < 0.3 then
			table.insert(stuff, "watertree_root")
		end
	end

	for i = 1, 3 do
		if math.random() < 0.3 then
			table.insert(stuff, "oceanvine_deco")
		end
	end

	for i = 1, 2 do
		if math.random() < 0.3 then
			table.insert(stuff, "kyno_lotus_ocean")
		end
	end

	for i = 1, 2 do
		if math.random() < 0.3 then
			table.insert(stuff, "oceanvine_cocoon")
		end
	end


	for i = 1, 10 do
		if math.random() < 0.4 then
			table.insert(stuff, "fireflies")
		end
	end

	return stuff
end

Layouts["Waterlogged1"] = StaticLayout.Get("map/static_layouts/hof_waterlogged1",
{
	areas =
	{
		treearea = HofWaterloggedArea,
	}
})

Layouts["Waterlogged2"] = StaticLayout.Get("map/static_layouts/hof_waterlogged2",
{
	areas =
	{
		treearea = HofWaterloggedArea,
	}
})

Layouts["Waterlogged3"] = StaticLayout.Get("map/static_layouts/hof_waterlogged3",
{
	areas =
	{
		treearea = HofWaterloggedArea,
	}
})

Layouts["Waterlogged4"] = StaticLayout.Get("map/static_layouts/hof_waterlogged4",
{
	areas =
	{
		treearea = HofWaterloggedArea,
	}
})