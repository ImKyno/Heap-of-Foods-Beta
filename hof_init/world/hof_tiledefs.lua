-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local WORLD_TILES     = _G.WORLD_TILES

-- I don't know why but there's a bug when "EnableModError()" is enabled that prevents
-- you from even launching a server with the mod enabled. This seems to solve the issue (?)
if WORLD_TILES.HOF_FIELDS ~= nil or WORLD_TILES.HOF_TIDALMARSH ~= nil then
	return
end

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
if TUNING.HOF_IS_TAP_ENABLED or TUNING.HOF_IS_NET_ENABLED then
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