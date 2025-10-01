-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local LAYOUT          = _G.LAYOUT
local LAYOUT_POSITION = _G.LAYOUT_POSITION
local PLACE_MASK      = _G.PLACE_MASK
local GROUND          = _G.GROUND
local Layouts         = require("map/layouts").Layouts
local StaticLayout    = require("map/static_layout")

require("map/terrain")
require("tilemanager")

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

local GROUND_TURFS =
{
	[WORLD_TILES.QUAGMIRE_PARKFIELD] = "turf_pinkpark",
	[WORLD_TILES.QUAGMIRE_CITYSTONE] = "turf_stonecity",
}

require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_PARKFIELD] = 
{ 
	name        = "pinkpark",  
	bank_build  = "kyno_turfs_hof", 
	anim        = "pinkpark",  
	pickupsound = "rock", 
}

require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_CITYSTONE] = 
{ 
	name        = "stonecity", 
	bank_build  = "kyno_turfs_hof", 
	anim        = "stonecity", 
	pickupsound = "rock",
	hard        = true,
	roadways    = true,
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

-- The numbers below represents each turf in the setpiece file.
_G.SERENITYISLAND_GROUNDS                =
{
	WORLD_TILES.OCEAN_BRINEPOOL,         -- 1
	WORLD_TILES.ROCKY,                   -- 2
	WORLD_TILES.SAVANNA,                 -- 3
	WORLD_TILES.QUAGMIRE_CITYSTONE,      -- 4
	WORLD_TILES.QUAGMIRE_PARKFIELD,      -- 5
}

_G.MEADOWISLAND_GROUNDS                  =
{
	WORLD_TILES.OCEAN_BRINEPOOL,         -- 1
	WORLD_TILES.MONKEY_GROUND,           -- 2
	WORLD_TILES.HOF_FIELDS,              -- 3
	WORLD_TILES.HOF_TIDALMARSH,          -- 4
	WORLD_TILES.ROAD,                    -- 5
	WORLD_TILES.FARMING_SOIL,            -- 6
	WORLD_TILES.FOREST,                  -- 7
}

_G.MEADOWISLAND_SHOP_GROUNDS             =
{
	WORLD_TILES.ROAD,                    -- 1
	WORLD_TILES.FOREST,                  -- 2
	WORLD_TILES.FARMING_SOIL,            -- 3
}

Layouts["SerenityIsland"]                = StaticLayout.Get("map/static_layouts/hof_serenityisland1",
{
	add_topology                         =
	{
		room_id                          = "StaticLayoutIsland:SerenityIsland",
		tags                             = {"RoadPoison", "not_mainland", "nohasslers", "nohunt", "SerenityArea"},
	},
	min_dist_from_land                   = 0,
})
Layouts["SerenityIsland"].ground_types   = _G.SERENITYISLAND_GROUNDS

Layouts["MeadowIsland"]                  = StaticLayout.Get("map/static_layouts/hof_meadowisland2",
{
	add_topology                         =
	{
		room_id                          = "StaticLayoutIsland:MeadowIsland",
		tags                             = {"RoadPoison", "not_mainland", "nohunt", "MeadowArea"},
	},
	min_dist_from_land                   = 0,
})
Layouts["MeadowIsland"].ground_types     = _G.MEADOWISLAND_GROUNDS

Layouts["Oasis"]                         = StaticLayout.Get("map/static_layouts/hof_oasis")
Layouts["SerenityIslandShop"]            = StaticLayout.Get("map/static_layouts/hof_serenityisland_shop")
Layouts["MeadowIslandShop"]              = StaticLayout.Get("map/static_layouts/hof_meadowisland_shop")
Layouts["MeadowIslandShop"].ground_types = _G.MEADOWISLAND_SHOP_GROUNDS

local hof_ocean_setpieces                =
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
		add_topology                     = 
		{
			room_id                      = "StaticLayoutIsland:WreckSetPieces",
			tags                         = {"RoadPoison", "not_mainland", "Mist", "WreckArea"},
		},
		min_dist_from_land               = 0,
	})
	Layouts[layout].ground_types         = { WORLD_TILES.OCEAN_BRINEPOOL }
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

local waterlogged_layouts = 
{
	"Waterlogged1",
	"Waterlogged2",
	"Waterlogged3",
	"Waterlogged4",
}

for _, name in ipairs(waterlogged_layouts) do
	Layouts[name] = StaticLayout.Get("map/static_layouts/hof_" .. string.lower(name), 
	{
		areas = 
		{
			treearea = HofWaterloggedArea,
		},
	})
end

AddClassPostConstruct("map/storygen", function(self)
	if self.map_tags ~= nil then
		self.map_tags.Tag["SerenityArea"] = function(tagdata) return "TAG", "SerenityArea" end
		self.map_tags.Tag["MeadowArea"]   = function(tagdata) return "TAG", "MeadowArea" end
		self.map_tags.Tag["WreckArea"]    = function(tagdata) return "TAG", "WreckArea" end
	end
end)

modimport("hof_init/world/hof_worldgen")