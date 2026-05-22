local _G          = GLOBAL
local require     = _G.require
local WORLD_TILES = _G.WORLD_TILES

require("map/hof_lockandkey")

local INIT_WORLDGEN =
{
	"worldtiledefs",
	"worldtilenoise",
	"static_layouts", -- Needs to load after hof_worldtiledefs.
	"storygen",
	"worldgen",
	"worldsettings",
}

for _, v in pairs(INIT_WORLDGEN) do
	modimport("main/map/hof_"..v)
end

require("map/hof_terrain") -- Terrain filter needs to load after hof_worldtiledefs.