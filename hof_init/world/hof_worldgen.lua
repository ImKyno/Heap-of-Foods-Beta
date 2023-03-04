-- Common Dependencies.
local _G 			       = GLOBAL
local require 		       = _G.require
local GROUND 		       = _G.GROUND

require("map/terrain")
modimport("hof_init/misc/hof_tuning")

local TERRAIN_FILTERS      = {_G.WORLD_TILES.ROAD, _G.WORLD_TILES.WOODFLOOR, _G.WORLD_TILES.CARPET, _G.WORLD_TILES.CHECKER}
local OCEANSETPIECE_COUNT  = GetModConfigData("HOF_OCEANSETPIECE_COUNT")

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
}

local TurnipCaveRooms = 
{
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
}

local StoneSlabCaveRooms = 
{
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
}

local MushroomStumpCaveRooms = 
{
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
}

local AspargosCaveRooms = 
{
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
		room.contents.distributeprefabs.kyno_aloe_ground 		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_aloe_ground 								= TERRAIN_FILTERS

for k, v in pairs(RadishRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_radish_ground 		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_radish_ground 							= TERRAIN_FILTERS

for k, v in pairs(FennelRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_fennel_ground 		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_fennel_ground 							= TERRAIN_FILTERS

for k, v in pairs(SweetPotatoRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_sweetpotato_ground = TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_sweetpotato_ground 						= TERRAIN_FILTERS

for k, v in pairs(ParznipRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_parznip_ground 	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_parznip_ground 							= TERRAIN_FILTERS

for k, v in pairs(TurnipRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_turnip_ground  	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_turnip_ground 							= TERRAIN_FILTERS

for k, v in pairs(TurnipCaveRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_turnip_cave  		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_turnip_cave 								= TERRAIN_FILTERS

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_cucumber_ground  	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_cucumber_ground							= TERRAIN_FILTERS

--[[ Lotus Flowers were moved to Waterlogged biomes.
for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_lotus_ocean  		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_lotus_ocean 								= TERRAIN_FILTERS
]]--

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_seaweeds_ocean  	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_seaweeds_ocean 							= TERRAIN_FILTERS

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_taroroot_ocean  	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_taroroot_ocean 							= TERRAIN_FILTERS

for k, v in pairs(WaterycressRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_waterycress_ocean 	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_waterycress_ocean 						= TERRAIN_FILTERS

for k, v in pairs(WheatRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_wildwheat 			= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_wildwheat 								= TERRAIN_FILTERS

for k, v in pairs(ParznipBigRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_parznip_big 		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_parznip_big								= TERRAIN_FILTERS

for k, v in pairs(StoneSlabRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_rockflippable		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_rockflippable							= TERRAIN_FILTERS

for k, v in pairs(StoneSlabCaveRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_rockflippable_cave	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_rockflippable_cave						= TERRAIN_FILTERS

for k, v in pairs(MushroomStumpRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_mushstump_natural	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_mushstump_natural						= TERRAIN_FILTERS

for k, v in pairs(MushroomStumpCaveRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_mushstump_cave		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_mushstump_cave							= TERRAIN_FILTERS

for k, v in pairs(WateryCrateRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_watery_crate		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_watery_crate							    = TERRAIN_FILTERS

for k, v in pairs(AspargosRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_aspargos_ground	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_aspargos_ground							= TERRAIN_FILTERS

for k, v in pairs(AspargosCaveRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_aspargos_cave		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_aspargos_cave							= TERRAIN_FILTERS

-- Add the Serenity Archipelago to the world. Not using this, because the CC thingie doesn't work properly!!
AddTaskSetPreInitAny(function(tasksetdata)
    if tasksetdata.location ~= "forest" then
        return
    end
    
	tasksetdata.ocean_prefill_setpieces["hof_serenityisland1"]           = { count = 1 }
	tasksetdata.ocean_prefill_setpieces["hof_meadowisland1"]             = { count = 1 }
	
	-- I will let the players decide how many they want.
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_crates"]      = { count = OCEANSETPIECE_COUNT }
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_crates2"]     = { count = OCEANSETPIECE_COUNT }
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_waterycress"] = { count = OCEANSETPIECE_COUNT }
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_taroroot"]    = { count = OCEANSETPIECE_COUNT }
	tasksetdata.ocean_prefill_setpieces["hof_oceansetpiece_seaweeds"]    = { count = OCEANSETPIECE_COUNT }
end)