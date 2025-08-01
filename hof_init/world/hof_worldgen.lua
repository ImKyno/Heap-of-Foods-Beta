-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require
local GROUND  = _G.GROUND
local min     = 1
local max     = 3

require("map/terrain")
modimport("hof_init/misc/hof_tuning")

local TERRAIN_FILTERS     = {_G.WORLD_TILES.ROAD, _G.WORLD_TILES.WOODFLOOR, _G.WORLD_TILES.CARPET, _G.WORLD_TILES.CHECKER}
local OCEANSETPIECE_COUNT = GetModConfigData("OCEANSETPIECE_COUNT")

-- Prefab Rooms.
local AloeRooms = 
{
	"BGGrass",
	"BGGrassBurnt",
	"FlowerPatch",
	"GrassyMoleColony",
}

local WheatRooms = 
{
	"BGSavanna",
	"BeefalowPlain",
	"WalrusHut_Plains",
	"Plain",
	"BarePlain",
}

local RadishRooms = 
{
	"BGDeciduous",
	"DeepDeciduous",
	"MagicalDeciduous",
	"DeciduousMole",
	"PondyGrass",
}

local FennelRooms = 
{
	"SinkholeForest",
	"SinkholeCopses",
	"SparseSinkholes",
	"SinkholeOasis",
	"GrasslandSinkhole",
	"BGSinkhole",
	"BGSinkholeRoom",
}

local SweetPotatoRooms = 
{
	"BGForest",
	"BGDeepForest",
	"DeepForest",
	"Forest",
	"BGCrappyForest",
	"BurntForest",
	"CrappyDeepForest",
	"CrappyForest",
	"SpiderForest",
	"BurntClearing",
	"Clearing",
	"MoonbaseOne",
	"MandrakeHome",
}

local ParznipRooms = 
{
	"LightPlantField",
	"WormPlantField",
	"FernGully",
	"MudWithRabbit",
	"SlurtlePlains",
}

local TurnipRooms = 
{
	"BGMarsh",
	"Marsh",
	"SpiderMarsh",
	"SlightlyMermySwamp",
	"DarkSwamp",
	"TentaclesAndTrees",
	"TentacleMud",
	"SpiderSinkholeMarsh",
	"SinkholeSwamp",
	
	-- Caves
	"SinkholeSwamp",
	"DarkSwamp",
	"TentacleMud",
	"TentaclesAndTrees",
	"SpiderSinkholeMarsh",
	"BGSinkholeSwamp",
	"BGSinkholeSwampRoom",
}

local OceanRooms = 
{
	"OceanCoastal",
	"OceanRough",
	"OceanHazardous",
}

local WaterycressRooms = 
{
	"OceanSwell",
	"OceanRough",
	"OceanHazardous",
}

local ParznipBigRooms = 
{
	"WetWilds",
	"LichenMeadow",
	"CaveJungle",
	"MonkeyMeadow",
	"LichenLand",
	"RuinedCityEntrance",
	"RuinedCity",
	"LightHut",
}

local StoneSlabRooms = 
{
	"BGChessRocky",
	"BGRocky",
	"Rocky",
	"RockyBuzzards",
	"GenericRockyNoThreat",
	"MolesvilleRocky",
	"BGSavanna",
	"CritterDen",
	"BGDeciduous",
	"DeepDeciduous",
	"MagicalDeciduous",
	"DeciduousMole",
	"PondyGrass",
	
	-- Caves
	"SlurtleCanyon",
	"BatsAndSlurtles",
	"RockyPlains",
	"RockyHatchingGrounds",
	"BatsAndRocky",
	"BGRockyCave",
	"BGRockyCaveRoom",
	"SpillagmiteForest",
	"DropperCanyon",
	"StalagmitesAndLights",
	"SpidersAndBats",
	"ThuleciteDebris",
	"BGSpillagmite",
	"BGSpillagmiteRoom",
}

local MushroomStumpRooms = 
{
	"BGForest",
	"DeepForest",
	"Forest",
	"BGCrappyForest",
	"CrappyDeepForest",
	"CrappyForest",
	"SpiderForest",
	"MoonbaseOne",
	
	-- Caves
	"GreenMushForest",
	"GreenMushPonds",
	"GreenMushSinkhole",
	"GreenMushMeadow",
	"GreenMushRabbits",
	"GreenMushNoise",
	"BGGreenMush",
	"BGGreenMushRoom",
}

local WateryCrateRooms = 
{
	"OceanCoastalShore",
	"OceanCoastal",
	"OceanSwell",
	"OceanRough",
	"OceanHazardous",
}

local AspargosRooms = 
{
	"BGForest",
	"BGDeepForest",
	"DeepForest",
	"Forest",
	"BGGrass",
	"BGGrassBurnt",
	"FlowerPatch",
	"GrassyMoleColony",
	
	-- Caves
	"SinkholeForest",
	"SinkholeCopses",
	"SparseSinkholes",
	"SinkholeOasis",
	"GrasslandSinkhole",
	"BGSinkhole",
	"BGSinkholeRoom",
}

-- Add the Prefabs to the world.
for k, v in pairs(AloeRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_aloe_ground        = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_aloe_ground                              = TERRAIN_FILTERS

for k, v in pairs(RadishRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_radish_ground      = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_radish_ground                            = TERRAIN_FILTERS

for k, v in pairs(FennelRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_fennel_ground      = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_fennel_ground                            = TERRAIN_FILTERS

for k, v in pairs(SweetPotatoRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_sweetpotato_ground = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_sweetpotato_ground                       = TERRAIN_FILTERS

for k, v in pairs(ParznipRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_parznip_ground     = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_parznip_ground                           = TERRAIN_FILTERS

for k, v in pairs(TurnipRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_turnip_ground      = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_turnip_ground                            = TERRAIN_FILTERS

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_cucumber_ground    = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_cucumber_ground                          = TERRAIN_FILTERS

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_seaweeds_ocean     = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_seaweeds_ocean                           = TERRAIN_FILTERS

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_taroroot_ocean     = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_taroroot_ocean                           = TERRAIN_FILTERS

for k, v in pairs(WaterycressRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_waterycress_ocean  = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_waterycress_ocean                        = TERRAIN_FILTERS

for k, v in pairs(WheatRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_wildwheat          = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_wildwheat                                = TERRAIN_FILTERS

for k, v in pairs(ParznipBigRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_parznip_big        = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_parznip_big                              = TERRAIN_FILTERS

for k, v in pairs(StoneSlabRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_rockflippable      = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_rockflippable                            = TERRAIN_FILTERS

for k, v in pairs(MushroomStumpRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_mushstump_natural  = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_mushstump_natural                        = TERRAIN_FILTERS

for k, v in pairs(WateryCrateRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_watery_crate       = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_watery_crate                             = TERRAIN_FILTERS

for k, v in pairs(AspargosRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_aspargos_ground    = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_aspargos_ground                          = TERRAIN_FILTERS

-- This mod suffers from low Beefalo amount due to crowded prefabs.
local BeefaloRooms =
{
	"BeefalowPlain",
	-- "BarePlain",
}

for k, v in pairs(BeefaloRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributepercent = .10
		room.contents.distributeprefabs["beefalo"] = .08
	end)
end

--[[
AddRoomPreInit("OceanRough", function(room)
	if not room.tags then
		room.tags = { "SerenitySpawner" }
	elseif room.tags then
		table.insert(room.tags, "SerenitySpawner")
	end
end)

AddRoomPreInit("OceanSwell", function(room)
	if not room.tags then
		room.tags = { "MeadowSpawner" }
	elseif room.tags then
		table.insert(room.tags, "MeadowSpawner")
	end
end)
]]--

AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end
	
	if not tasksetdata.ocean_prefill_setpieces then 
		tasksetdata.ocean_prefill_setpieces = {}
	end
    
	tasksetdata.ocean_prefill_setpieces["hof_serenityisland1"]           = { count = 1 }
	tasksetdata.ocean_prefill_setpieces["hof_meadowisland2"]             = { count = 1 } -- hof_meadowisland1
	
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_crates"]      = { count = math.random(min, max) } -- OCEANSETPIECE_COUNT
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_crates2"]     = { count = math.random(min, max) }
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_waterycress"] = { count = math.random(min, max) }
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_taroroot"]    = { count = math.random(min, max) }
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_seaweeds"]    = { count = math.random(min, max) }
end)

-- Make our setpieces a must for when generating the world.
AddLevelPreInit("forest", function(level)
    level.required_setpieces = level.required_setpieces or {}
	
	table.insert(level.required_setpieces, "hof_serenityisland1")
	table.insert(level.required_setpieces, "hof_meadowisland2") -- hof_meadowisland1
	
	table.insert(level.required_setpieces, "hof_oceansetpiece_crates")
	table.insert(level.required_setpieces, "hof_oceansetpiece_crates2")
	table.insert(level.required_setpieces, "hof_oceansetpiece_waterycress")
	table.insert(level.required_setpieces, "hof_oceansetpiece_taroroot")
	table.insert(level.required_setpieces, "hof_oceansetpiece_seaweeds")
end)

-- Main Menu world customization.
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof",            "Heap of Foods - Resources",                     nil, nil, 6)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_ocean",      "Heap of Foods - Ocean Resources",               nil, nil, 7)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_serenity",   "Heap of Foods - Serenity Archipelago",          nil, nil, 8)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_meadow",     "Heap of Foods - Seaside Island",                nil, nil, 9)

AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_r",          "Heap of Foods - Resources Regrowth",            nil, nil, 8)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_ocean_r",    "Heap of Foods - Ocean Resources Regrowth",      nil, nil, 9)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_serenity_r", "Heap of Foods - Serenity Archipelago Regrowth", nil, nil, 10)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_meadow_r",   "Heap of Foods - Seaside Island Regrowth",       nil, nil, 11)

local customization_worldgen      = require("map/hof_customizations_worldgen")
local customization_worldsettings = require("map/hof_customizations_worldsettings")

for k, v in pairs(customization_worldgen) do
	v.image = "worldgen_"..v.name
	
	AddCustomizeItem(v.category, v.group, v.name, 
	{
		order = v.order,
		value = v.value,
		desc  = GetCustomizeDescription(v.desc),
		world = v.world or {"forest"},		
		image = v.image..".tex",
		atlas = "images/customizationimages/hof_customizationimages_worldgen.xml",
	})
end

for k, v in pairs(customization_worldsettings) do
	v.image = v.name
	
	AddCustomizeItem(v.category, v.group, v.name, 
	{
		order = v.order,
		value = v.value,
		desc  = GetCustomizeDescription(v.desc),
		world = v.world or {"forest"},		
		image = v.image..".tex",
		atlas = "images/customizationimages/hof_customizationimages_worldsettings.xml",
	})
end