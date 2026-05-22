local _G                 = GLOBAL
local require            = _G.require
local WORLD_TILES        = _G.WORLD_TILES
local NoiseTileFunctions = require("noisetilefunctions")

local function GetTileForSunkenForestNoise(noise)
	if noise < 0.25 then
		return WORLD_TILES.HOF_SUNKENFOREST_ROCKY
	elseif noise < 0.26 then
		return WORLD_TILES.HOF_SUNKENFOREST_ROCKY
	elseif noise < 0.35 then
		return WORLD_TILES.SAVANNA
	elseif noise < 0.40 then
		return WORLD_TILES.HOF_SUNKENFOREST_SINKHOLE
	elseif noise < 0.50 then
		return WORLD_TILES.HOF_SUNKENFOREST_SAVANNA
	elseif noise < 0.70 then
		return WORLD_TILES.HOF_SUNKENFOREST_GRASS
	end

	return WORLD_TILES.HOF_SUNKENFOREST_OCEAN
end

local function GetTileForSunkenForestRiverNoise(noise)
	if noise < 0.25 then
		return WORLD_TILES.HOF_SUNKENFOREST_OCEAN
	elseif noise < 0.26 then
		return WORLD_TILES.HOF_SUNKENFOREST_OCEAN
	elseif noise < 0.35 then
		return WORLD_TILES.HOF_SUNKENFOREST_ROCKY
	elseif noise < 0.40 then
		return WORLD_TILES.HOF_SUNKENFOREST_SINKHOLE
	elseif noise < 0.50 then
		return WORLD_TILES.HOF_SUNKENFOREST_SAVANNA
	elseif noise < 0.70 then
		return WORLD_TILES.HOF_SUNKENFOREST_GRASS
	end

	return WORLD_TILES.HOF_SUNKENFOREST_OCEAN
end

NoiseTileFunctions[WORLD_TILES.HOF_SUNKENFOREST_NOISE]       = GetTileForSunkenForestNoise
NoiseTileFunctions[WORLD_TILES.HOF_SUNKENFOREST_RIVER_NOISE] = GetTileForSunkenForestRiverNoise