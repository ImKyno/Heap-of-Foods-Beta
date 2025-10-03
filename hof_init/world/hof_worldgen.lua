-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require
local min     = 1
local max     = 3

require("map/terrain")
--require("tilemanager")

require("map/rooms/hof_rooms")
require("map/tasks/hof_tasks")

modimport("hof_init/misc/hof_tuning")

local TERRAIN_FILTERS = 
{
	WORLD_TILES.ROAD, 
	WORLD_TILES.WOODFLOOR, 
	WORLD_TILES.CARPET, 
	WORLD_TILES.CHECKER,
}

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

for k, v in pairs(RadishRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_radish_ground      = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(FennelRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_fennel_ground      = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(SweetPotatoRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_sweetpotato_ground = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(ParznipRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_parznip_ground     = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(TurnipRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_turnip_ground      = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_cucumber_ground    = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_seaweeds_ocean     = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_taroroot_ocean     = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(WaterycressRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_waterycress_ocean  = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(WheatRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_wildwheat          = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(ParznipBigRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_parznip_big        = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(StoneSlabRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_rockflippable      = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(MushroomStumpRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_mushstump_natural  = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(WateryCrateRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_watery_crate       = TUNING.HOF_RESOURCES
	end)
end

for k, v in pairs(AspargosRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_aspargos_ground    = TUNING.HOF_RESOURCES
	end)
end

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

local OCEAN_SETPIECES =
{
	"hof_oceansetpiece_crates",
	"hof_oceansetpiece_crates2",
	"hof_oceansetpiece_seaweeds",
	"hof_oceansetpiece_taroroot",
	"hof_oceansetpiece_waterycress",
	"hof_oceansetpiece_graveyard1",
	"hof_oceansetpiece_graveyard2",
}

AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end
	
	if not tasksetdata.ocean_prefill_setpieces then 
		tasksetdata.ocean_prefill_setpieces = {}
	end

	tasksetdata.ocean_prefill_setpieces["SerenityIsland"] = { count = 1 }
	tasksetdata.ocean_prefill_setpieces["MeadowIsland"]   = { count = 1 }
	
	for k, layout in pairs(OCEAN_SETPIECES) do
		tasksetdata.ocean_prefill_setpieces[layout]       = { count = math.random(min, max) }
	end
end)

-- Make our setpieces a must for when generating the world.
AddLevelPreInit("forest", function(level)
    level.required_setpieces = level.required_setpieces or {}
	
	table.insert(level.required_setpieces, "SerenityIsland")
	table.insert(level.required_setpieces, "MeadowIsland")
	
	for k, layout in pairs(OCEAN_SETPIECES) do
		table.insert(level.required_setpieces, layout)
	end
end)

-- Main Menu world customization.
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof",            "Heap of Foods - Resources",                     nil, nil, 11)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_ocean",      "Heap of Foods - Ocean Resources",               nil, nil, 12)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_serenity",   "Heap of Foods - Serenity Archipelago",          nil, nil, 13)
AddCustomizeGroup(_G.LEVELCATEGORY.WORLDGEN, "hof_meadow",     "Heap of Foods - Seaside Island",                nil, nil, 14)

AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_r",          "Heap of Foods - Resources Regrowth",            nil, nil, 11)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_ocean_r",    "Heap of Foods - Ocean Resources Regrowth",      nil, nil, 12)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_serenity_r", "Heap of Foods - Serenity Archipelago Regrowth", nil, nil, 13)
AddCustomizeGroup(_G.LEVELCATEGORY.SETTINGS, "hof_meadow_r",   "Heap of Foods - Seaside Island Regrowth",       nil, nil, 14)

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