-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local LAYOUT          = _G.LAYOUT
local LAYOUT_POSITION = _G.LAYOUT_POSITION
local LAYOUT_ROTATION = _G.LAYOUT_ROTATION
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

_G.DECIDUOUSFOREST_SHOP_GROUNDS          =
{
	WORLD_TILES.DECIDUOUS,               -- 1
	WORLD_TILES.ROAD,                    -- 2
	WORLD_TILES.FOREST,                  -- 3
	WORLD_TILES.GRASS,                   -- 4
}

Layouts["SerenityIsland"]                = StaticLayout.Get("map/static_layouts/hof_serenityisland2",
{
	start_mask                           = PLACE_MASK.IGNORE_IMPASSABLE,
	fill_mask                            = PLACE_MASK.IGNORE_IMPASSABLE,
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
	start_mask                           = PLACE_MASK.IGNORE_IMPASSABLE,
	fill_mask                            = PLACE_MASK.IGNORE_IMPASSABLE,
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
		start_mask                       = PLACE_MASK.IGNORE_IMPASSABLE,
		fill_mask                        = PLACE_MASK.IGNORE_IMPASSABLE,
		add_topology                     = 
		{
			room_id                      = "StaticLayoutIsland:WreckSetPieces",
			tags                         = tags,
		},
		min_dist_from_land               = 10,
	})

	Layouts[layout].ground_types         = { WORLD_TILES.OCEAN_HAZARDOUS }
end

Layouts["FruitTreeShop"]                 = StaticLayout.Get("map/static_layouts/hof_deciduousforest_shop",
{
	start_mask                           = PLACE_MASK.IGNORE_IMPASSABLE,
	fill_mask                            = PLACE_MASK.IGNORE_IMPASSABLE,
	force_rotation                       = LAYOUT_ROTATION.NORTH,
	add_topology                         =
	{
		room_id                          = "StaticLayout:DeciduousForestShop",
		tags                             = {"FruitTreeArea"},
	},
})
Layouts["FruitTreeShop"].ground_types    = _G.DECIDUOUSFOREST_SHOP_GROUNDS

Layouts["DinaMemorial"]                  = StaticLayout.Get("map/static_layouts/hof_dinamemorial",
{
	start_mask                           = PLACE_MASK.IGNORE_IMPASSABLE,
	fill_mask                            = PLACE_MASK.IGNORE_IMPASSABLE,
	force_rotation                       = LAYOUT_ROTATION.NORTH,
	add_topology                         =
	{
		room_id                          = "StaticLayout:DinaMemorial",
		tags                             = {"MemorialArea"},
	},
})

local function monkeyisland_prefabs_area(area, data)
	local prefabs = _G.PickSomeWithDups(math.floor(area / 5 + 0.5),
		{   
			"bananabush",
			"monkeytail",
			"palmconetree_short",
			"palmconetree_normal",
			"palmconetree_tall",
			"pirate_flag_pole",
		}
	)

	table.insert(prefabs, "bananabush")
	table.insert(prefabs, "palmconetree_normal")
	table.insert(prefabs, "monkeytail")
	table.insert(prefabs, "lightcrab")
	
	if math.random() > 0.5 then
		table.insert(prefabs, "lightcrab")
	end

	return prefabs
end

local function monkeyhut_area()
	return {"monkeyhut", "monkeyhut"}
end

local monkey_island_add_data             =
{
	add_topology                         = 
	{
		room_id                          = "StaticLayoutIsland:MonkeyIsland", 
		tags                             = {"RoadPoison", "nohunt", "nohasslers", "not_mainland"}
	},
	
	areas =
	{
		monkeyisland_prefabs             = monkeyisland_prefabs_area,
		monkeyhut_area                   = monkeyhut_area,

		monkeyisland_docksafearea        = function(area, data)
			return 
			{
				{
					prefab               = "monkeyisland_dockgen_safeareacenter",
					x                    = data.x,
					y                    = data.y,
					properties           = 
					{
						data             = 
						{
							width        = data.width,
							height       = data.height,
						},
					},
				}
			}
		end,
	},
}

Layouts["MonkeyIsland"]                  = StaticLayout.Get("map/static_layouts/hof_monkeyisland_01", monkey_island_add_data)
Layouts["MonkeyIslandSmall"]             = StaticLayout.Get("map/static_layouts/hof_monkeyisland_01_small", monkey_island_add_data)

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

local MapData =
{
 -- ["SerenityIsland_Spawner"] = true,
 -- ["MeadowIsland_Spawner"]   = true,
	["DinaMemorial_Spawner"]   = true,
	["FruitTreeShop_Spawner"]  = true,
}

local MapTags = 
{ 
	["SerenityArea"] = function(tagdata)
		return "TAG", "SerenityArea"
	end,
	
	["MeadowArea"] = function(tagdata)
		return "TAG", "MeadowArea"
	end,
	
	["WreckArea"] = function(tagdata)
		return "TAG", "WreckArea"
	end,
	
	["LowMist"] = function(tagdata)
		return "TAG", "LowMist"
	end,
	
	["FruitTreeArea"] = function(tagdata)
		return "TAG", "FruitTreeArea"
	end,
	
	["MemorialArea"] = function(tagdata)
		return "TAG", "MemorialArea"
	end,
	
	--[[
	["SerenityIsland_Spawner"] = function(tagdata, level)
		if tagdata["SerenityIsland_Spawner"] == false then
			return
		end
		
		tagdata["SerenityIsland_Spawner"] = false

        return "STATIC", "SerenityIsland"
    end,
	
	["MeadowIsland_Spawner"] = function(tagdata, level)
		if tagdata["MeadowIsland_Spawner"] == false then
			return
		end
		
		tagdata["MeadowIsland_Spawner"] = false

        return "STATIC", "MeadowIsland"
    end,
	]]--

	["DinaMemorial_Spawner"] = function(tagdata, level)
		if tagdata["DinaMemorial_Spawner"] == false then
			return
		end
		
		tagdata["DinaMemorial_Spawner"] = false

        return "STATIC", "DinaMemorial"
    end,
	
	["FruitTreeShop_Spawner"] = function(tagdata, level)
		if tagdata["FruitTreeShop_Spawner"] == false then
			return
		end
		
		tagdata["FruitTreeShop_Spawner"] = false

        return "STATIC", "FruitTreeShop"
    end,
}

AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
	for tag, v in pairs(MapData) do
		self.map_tags.TagData[tag] = v
	end
	
	for tag, v in pairs(MapTags) do
		self.map_tags.Tag[tag] = v
	end
end)

modimport("hof_init/world/hof_worldgen")
modimport("hof_init/world/hof_worldsettings")