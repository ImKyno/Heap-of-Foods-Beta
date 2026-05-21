local _G                 = GLOBAL
local require            = _G.require
local WORLD_TILES        = _G.WORLD_TILES
local NoiseTileFunctions = require("noisetilefunctions")

local function GetTileForSunkenForestNoise(noise)
	if noise < 0.25 then
		return WORLD_TILES.HOF_OCEAN_SUNKENFOREST
	elseif noise < 0.35 then
		return WORLD_TILES.HOF_OCEAN_SUNKENFOREST
	elseif noise < 0.40 then
		return WORLD_TILES.HOF_SUNKENFOREST_ROCKY
	elseif noise < 0.45 then
		return WORLD_TILES.HOF_SUNKENFOREST_SINKHOLE
	elseif noise < 0.50 then
		return WORLD_TILES.HOF_SUNKENFOREST_FOREST
	elseif noise < 0.75 then
		return WORLD_TILES.HOF_SUNKENFOREST_GRASS
	end

	return WORLD_TILES.HOF_SUNKENFOREST_GRASS
end

NoiseTileFunctions[WORLD_TILES.HOF_SUNKENFOREST_NOISE] = GetTileForSunkenForestNoise