local _G          = GLOBAL
local require     = _G.require
local WORLD_TILES = _G.WORLD_TILES

-- I don't know why but there's a bug when "EnableModError()" is enabled that prevents
-- you from even launching a server with the mod enabled. This seems to solve the issue (?)
if WORLD_TILES.HOF_FIELDS ~= nil or WORLD_TILES.HOF_TIDALMARSH ~= nil then
	return
end

-- Land Tiles.
AddTile("HOF_FIELDS", "LAND",
	{
		ground_name 	= "HOF Fields",
		old_static_id   = 65,
	},
	{
		name            = "jungle",
		noise_texture   = "levels/textures/hof/fields_noise.tex",
		runsound        = "dontstarve/movement/run_grass",
		walksound       = "dontstarve/movement/walk_grass",
		mudsound        = "dontstarve/movement/run_mud",
		snowsound       = "dontstarve/movement/run_snow",
		hard            = false,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/hof/fields_mini.tex",
	},
	{
		name            = "fields",
		anim            = "fields",
		bank_build      = "kyno_turfs_hof",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("HOF_TIDALMARSH", "LAND",
	{
		ground_name     = "HOF Tidal Marsh",
		old_static_id   = 80,
	},
	{
		name            = "tidalmarsh",
		noise_texture   = "levels/textures/hof/tidalmarsh_noise.tex",
		runsound        = "dontstarve/movement/run_marsh",
		walksound       = "dontstarve/movement/walk_marsh",
		mudsound        = "dontstarve/movement/run_mud",
		snowsound       = "dontstarve/movement/run_snow",
		hard            = false,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/hof/tidalmarsh_mini.tex",
	},
	{
		name            = "tidalmarsh",
		anim            = "tidalmarsh",
		bank_build      = "kyno_turfs_hof",
		pickupsound     = "squidgy",
	}
)

AddTile("HOF_SUNKENFOREST_ROCKY", "LAND",
	{
		ground_name     = "HOF Sunken Forest Rocky",
	}
	{
		name            = "desert_dirt",
		noise_texture   = "levels/textures/hof/sunkenforest_rocky_noise.tex",
		runsound        = "dontstarve/movement/run_dirt",
		walksound       = "dontstarve/movement/walk_dirt",
		mudsound        = "dontstarve/movement/run_mud",
		snowsound       = "dontstarve/movement/run_snow",
		hard            = true,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/hof/sunkenforest_rocky_mini.tex",
	},
	{
		name            = "sunkenforest_rocky",
		anim            = "sunkenforest_rocky",
		bank_build      = "kyno_turfs_hof",
		pickupsound     = "rock",
	}
)

AddTile("HOF_SUNKENFOREST_SINKHOLE", "LAND",
	{
		ground_name     = "HOF Sunken Forest Sinkhole",
	},
	{
		name            = "cave",
		noise_texture   = "levels/textures/hof/sunkenforest_sinkhole_noise.tex",
		runsound        = "dontstarve/movement/run_dirt",
		walksound       = "dontstarve/movement/walk_dirt",
		mudsound        = "dontstarve/movement/run_mud",
		snowsound       = "dontstarve/movement/run_snow",
		hard            = false,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/hof/sunkenforest_sinkhole_mini.tex",
	},
	{
		name            = "sunkenforest_sinkhole",
		anim            = "sunkenforest_sinkhole",
		bank_build      = "kyno_turfs_hof",
		pickupsound     = "squidgy",
	}
)

AddTile("HOF_SUNKENFOREST_SAVANNA", "LAND",
	{
		ground_name     = "HOF Sunken Forest Savanna",
	},
	{
		name            = "yellowgrass",
		noise_texture   = "levels/textures/hof/sunkenforest_savanna_noise.tex",
		runsound        = "dontstarve/movement/run_woods",
		walksound       = "dontstarve/movement/walk_woods",
		mudsound        = "dontstarve/movement/run_mud",
		snowsound       = "dontstarve/movement/run_snow",
		hard            = false,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/hof/sunkenforest_savanna_mini.tex",
	},
	{
		name            = "sunkenforest_savanna",
		anim            = "sunkenforest_savanna",
		bank_build      = "kyno_turfs_hof",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("HOF_SUNKENFOREST_GRASS", "LAND",
	{
		ground_name     = "HOF Sunken Forest Grass",
	},
	{
		name            = "yellowgrass",
		noise_texture   = "levels/textures/hof/sunkenforest_grass_noise.tex",
		runsound        = "dontstarve/movement/run_grass",
		walksound       = "dontstarve/movement/walk_grass",
		mudsound        = "dontstarve/movement/run_mud",
		snowsound       = "dontstarve/movement/run_snow",
		hard            = false,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/hof/sunkenforest_grass_mini.tex",
	},
	{
		name            = "sunkenforest_grass",
		anim            = "sunkenforest_grass",
		bank_build      = "kyno_turfs_hof",
		pickupsound     = "vegetation_grassy",
	}
)

local COASTAL_SHORE_OCEAN_COLOR =
{
    primary_color =        {220, 240, 255, 60},
    secondary_color =      {21,  96,  110, 140},
    secondary_color_dusk = {0,   0,   0,   50},
    minimap_color =        {23,  51,  62,  102},
}

local WAVETINTS =
{
    shallow =   {0.8,   0.9,    1},
}

-- Ocean Tiles.
AddTile("HOF_SUNKENFOREST_OCEAN", "IMPASSABLE",
	{
		ground_name     = "HOF Sunken Forest Ocean",
	},
	{
		name            = "sunkenforest_ocean",
		noise_texture   = "levels/textures/hof/sunkenforest_ocean_noise.tex",
		runsound        = "dontstarve/movement/run_marsh",
		walksound       = "dontstarve/movement/walk_marsh",
		mudsound        = "dontstarve/movement/run_mud",
		snowsound       = "dontstarve/movement/run_ice",
		is_shoreline    = true,
		ocean_depth     = "SHALLOW",
		colors          = COASTAL_SHORE_OCEAN_COLOR,
		wavetint        = WAVETINTS.shallow,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/hof/sunkenforest_ocean_mini.tex",
	}
)

-- Used to pick random turfs. Check hof_worldtilenoise.lua for more details.
AddTile("HOF_SUNKENFOREST_NOISE",       "NOISE")
AddTile("HOF_SUNKENFOREST_RIVER_NOISE", "NOISE")

-- PARKFIELD and CITYSTONE already exists, we are just making an inventory item for them.
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
	pickupsound = "vegetation_grassy",
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

ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_PARKFIELD,        WORLD_TILES.DECIDUOUS,      true)
ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_CITYSTONE,        WORLD_TILES.ROCKY,          true)
ChangeTileRenderOrder(WORLD_TILES.HOF_TIDALMARSH,            WORLD_TILES.MARSH,          true)
ChangeTileRenderOrder(WORLD_TILES.HOF_FIELDS,                WORLD_TILES.DECIDUOUS,      true)
ChangeTileRenderOrder(WORLD_TILES.HOF_SUNKENFOREST_ROCKY,    WORLD_TILES.ROCKY,          true)
ChangeTileRenderOrder(WORLD_TILES.HOF_SUNKENFOREST_SINKHOLE, WORLD_TILES.SINKHOLE,       true)

-- To match The Architect Pack and Not Enough Turfs.
if WORLD_TILES.TIDALMARSH ~= nil and WORLD_TILES.FIELDS ~= nil and
WORLD_TILES.SWIRLGRASSMONO ~= nil and WORLD_TILES.PINKSTONE ~= nil then
	ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_PARKFIELD, WORLD_TILES.SWIRLGRASSMONO, true)
	ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_CITYSTONE, WORLD_TILES.PINKSTONE,      true)
	ChangeTileRenderOrder(WORLD_TILES.HOF_TIDALMARSH,     WORLD_TILES.TIDALMARSH,     true)
	ChangeTileRenderOrder(WORLD_TILES.HOF_FIELDS,         WORLD_TILES.FIELDS,         true)
end