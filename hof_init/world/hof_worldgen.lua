-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

require("map/hof_terrain")
require("map/rooms/hof_rooms")
require("map/tasks/hof_tasks")

modimport("hof_init/misc/hof_tuning")

local TERRAIN_FILTERS = 
{
	_G.WORLD_TILES.ROAD, 
	_G.WORLD_TILES.WOODFLOOR, 
	_G.WORLD_TILES.CARPET, 
	_G.WORLD_TILES.CHECKER,
}

-- Add Plants to World Rooms.
local RoomPrefabs = 
{
	kyno_aloe_ground = 
	{
		"BGGrass",
		"BGGrassBurnt", 
		"FlowerPatch", 
		"GrassyMoleColony",
    },
	
	kyno_wildwheat = 
	{
		"BGSavanna", 
		"BeefalowPlain", 
		"WalrusHut_Plains", 
		"Plain", 
		"BarePlain",
	},
	
	kyno_radish_ground = 
	{
		"BGDeciduous", 
		"DeepDeciduous", 
		"MagicalDeciduous", 
		"DeciduousMole", 
		"PondyGrass",
	},
	
	kyno_fennel_ground = 
	{
		"SinkholeForest", 
		"SinkholeCopses", 
		"SparseSinkholes", 
		"SinkholeOasis", 
		"GrasslandSinkhole", 
		"BGSinkhole", 
		"BGSinkholeRoom",
	},
	
	kyno_sweetpotato_ground = 
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
	},
	
	kyno_parznip_ground = 
	{
		"LightPlantField", 
		"WormPlantField", 
		"FernGully", 
		"MudWithRabbit", 
		"SlurtlePlains",
	},
	
	kyno_turnip_ground = 
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
		"BGSinkholeSwamp", 
		"BGSinkholeSwampRoom",
	},
	
	kyno_aspargos_ground = 
	{
		"BGForest", 
		"BGDeepForest", 
		"DeepForest", 
		"Forest", 
		"BGGrass", 
		"BGGrassBurnt", 
		"FlowerPatch",
		"GrassyMoleColony", 
		"SinkholeForest", 
		"SinkholeCopses", 
		"SparseSinkholes", 
		"SinkholeOasis",
		"GrasslandSinkhole", 
		"BGSinkhole", 
		"BGSinkholeRoom",
    },

	kyno_mushstump_natural = 
	{
		"BGForest", 
		"DeepForest", 
		"Forest", 
		"BGCrappyForest", 
		"CrappyDeepForest", 
		"CrappyForest",
		"SpiderForest", 
		"MoonbaseOne", 
		"GreenMushForest", 
		"GreenMushPonds", 
		"GreenMushSinkhole",
		"GreenMushMeadow", 
		"GreenMushRabbits", 
		"GreenMushNoise", 
		"BGGreenMush", 
		"BGGreenMushRoom",
	},
	
	kyno_cucumber_ground = 
	{
		"OceanCoastal", 
		"OceanRough", 
		"OceanHazardous",
	},
	
	kyno_seaweeds_ocean = 
	{
		"OceanCoastal", 
		"OceanRough", 
		"OceanHazardous",
	},
	
	kyno_taroroot_ocean = 
	{
		"OceanCoastal", 
		"OceanRough", 
		"OceanHazardous",
	},
	
	kyno_waterycress_ocean = 
	{
		"OceanSwell", 
		"OceanRough", 
		"OceanHazardous",
	},
	
		
	kyno_watery_crate = 
	{
		"OceanCoastalShore", 
		"OceanCoastal", 
		"OceanSwell", 
		"OceanRough", 
		"OceanHazardous",
	},
	
	kyno_parznip_big = 
	{
		"WetWilds", 
		"LichenMeadow", 
		"CaveJungle", 
		"MonkeyMeadow", 
		"LichenLand",
		"RuinedCityEntrance", 
		"RuinedCity", 
		"LightHut",
	},
	
	kyno_rockflippable = 
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
	},
}

for prefab, rooms in pairs(RoomPrefabs) do
	for _, roomname in ipairs(rooms) do
		AddRoomPreInit(roomname, function(room)
			room.contents.distributeprefabs[prefab] = TUNING.HOF_RESOURCES
		end)
	end
end

-- This mod suffers from low Beefalo amount due to crowded prefabs.
AddRoomPreInit("BeefalowPlain", function(room)
	room.contents.distributepercent = .10
	room.contents.distributeprefabs["beefalo"] = .10
end)

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
		tasksetdata.ocean_prefill_setpieces[layout]       = { count = math.random(TUNING.HOF_MIN_OCEANSETPIECES, TUNING.HOF_MAX_OCEANSETPIECES) }
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