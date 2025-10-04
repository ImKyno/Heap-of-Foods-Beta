-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local LAYOUT          = _G.LAYOUT
local LAYOUT_POSITION = _G.LAYOUT_POSITION
local PLACE_MASK      = _G.PLACE_MASK
local WORLD_TILES     = _G.WORLD_TILES
local Layouts         = require("map/layouts").Layouts
local StaticLayout    = require("map/static_layout")

modimport("hof_init/world/hof_tiledefs")
require("map/hof_terrain")

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

Layouts["SerenityIsland"]                = StaticLayout.Get("map/static_layouts/hof_serenityisland2",
{
	add_topology                         =
	{
		room_id                          = "StaticLayoutIsland:SerenityIsland",
		tags                             = {"RoadPoison", "not_mainland", "nohasslers", "nohunt", "SerenityArea"},
	},
	min_dist_from_land                   = 10,
})
Layouts["SerenityIsland"].ground_types   = _G.SERENITYISLAND_GROUNDS

Layouts["MeadowIsland"]                  = StaticLayout.Get("map/static_layouts/hof_meadowisland2",
{
	add_topology                         =
	{
		room_id                          = "StaticLayoutIsland:MeadowIsland",
		tags                             = {"RoadPoison", "not_mainland", "nohunt", "MeadowArea"},
	},
	min_dist_from_land                   = 10,
})
Layouts["MeadowIsland"].ground_types     = _G.MEADOWISLAND_GROUNDS

Layouts["Oasis"]                         = StaticLayout.Get("map/static_layouts/hof_oasis_beach")
Layouts["Oasis"].ground_types            = { WORLD_TILES.MONKEY_GROUND }
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
	"hof_oceansetpiece_graveyard1",
	"hof_oceansetpiece_graveyard2",
}

local mist_layouts                       = 
{
	["hof_oceansetpiece_crates"]         = true,
	["hof_oceansetpiece_crates2"]        = true,
	["hof_oceansetpiece_graveyard1"]     = true,
	["hof_oceansetpiece_graveyard2"]     = true,
}

for i, layout in ipairs(hof_ocean_setpieces) do
	local tags = {"WreckArea"}

	if mist_layouts[layout] then
		table.insert(tags, "LowMist")
	end

	Layouts[layout]                      = StaticLayout.Get("map/static_layouts/"..layout,
	{
		add_topology                     = 
		{
			room_id                      = "StaticLayoutIsland:WreckSetPieces",
			tags                         = tags,
		},
		min_dist_from_land               = 10,
	})

	Layouts[layout].ground_types         = { WORLD_TILES.OCEAN_HAZARDOUS }
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

local MapTags = { "SerenityArea", "MeadowArea", "WreckArea", "LowMist" }
AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
	for k, v in pairs(MapTags) do
		self.map_tags.Tag[v] = function(tagdata) return "TAG", v end
	end
end)

modimport("hof_init/world/hof_worldgen")
modimport("hof_init/world/hof_worldsettings")