-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require
local GROUND 		= _G.GROUND

require("map/terrain")

TUNING.HOF_RESOURCES = .08
local TERRAIN_FILTERS = {_G.GROUND.ROAD, _G.GROUND.WOODFLOOR, _G.GROUND.CARPET, _G.GROUND.CHECKER}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Prefab Rooms.
local AloeRooms = {
	"BGGrass",
	"BGGrassBurnt",
	"FlowerPatch",
	"GrassyMoleColony",
}

local WheatRooms = {
	"BGSavanna",
	"BeefalowPlain",
	"WalrusHut_Plains",
	"Plain",
	"BarePlain",
}

local RadishRooms = {
	"BGDeciduous",
	"DeepDeciduous",
	"MagicalDeciduous",
	"DeciduousMole",
	"PondyGrass",
}

local FennelRooms = {
	"SinkholeForest",
	"SinkholeCopses",
	"SparseSinkholes",
	"SinkholeOasis",
	"GrasslandSinkhole",
	"BGSinkhole",
	"BGSinkholeRoom",
}

local SweetPotatoRooms = {
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

local ParznipRooms = {
	"LightPlantField",
	"WormPlantField",
	"FernGully",
	"MudWithRabbit",
	"SlurtlePlains",
}

local TurnipRooms = {
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

local OceanRooms = {
	"OceanCoastal",
	"OceanRough",
	"OceanHazardous",
}

local WaterycressRooms = {
	"OceanSwell",
	"OceanRough",
	"OceanHazardous",
}

local ParznipBigRooms = {
	"WetWilds",
	"LichenMeadow",
	"CaveJungle",
	"MonkeyMeadow",
	"LichenLand",
	"RuinedCityEntrance",
	"RuinedCity",
	"LightHut",
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_cucumber_ground  	= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_cucumber_ground							= TERRAIN_FILTERS

for k, v in pairs(OceanRooms) do
	AddRoomPreInit(v, function(room)
		room.contents.distributeprefabs.kyno_lotus_ocean  		= TUNING.HOF_RESOURCES
	end)
end
_G.terrain.filter.kyno_lotus_ocean 								= TERRAIN_FILTERS

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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- List of Rooms (Biomes).
--[[
"BGBadlands","Badlands","Lightning","HoundyBadlands","BuzzardyBadlands","Moundfield",
"BGDeciduous","DeepDeciduous","DeciduousMole","DeciduousClearing","PondyGrass","MolesvilleDeciduous","MagicalDeciduous",
"BGGrassBurnt","BGGrass","MandrakeHome","GrassyMoleColony","FlowerPatch","EvilFlowerPatch","Waspnests","WalrusHut_Grassy","Walrusfield","PigTown","PigVillage","PigKingdom","PigCamp",
"BGDirt","BGNoise",
"BGCrappyForest","BGForest","BGDeepForest","BurntForest","CrappyDeepForest","DeepForest","Forest","ForestMole","CrappyForest","BurntClearing","Clearing","SpiderForest","SpiderCity","Graveyard",  
"BGMarsh","Marsh","SpiderMarsh","SlightlyMermySwamp","SpiderVillageSwamp","Mermfield","Tentacleland",
"BGRocky","Rocky","GenericRockyNoThreat","MolesvilleRocky","BGChessRocky","RockyBuzzards","SpiderVillage","WalrusHut_Rocky","Tallbirdfield","TallbirdNests","PigCity",
"BGSavanna","Plain","BarePlain","WalrusHut_Plains","BeefalowPlain",
-- Common rooms for each mobs.
Spiders = {"SpiderMarsh","SpiderForest","SpiderCity","SpiderVillage","SpiderVillageSwamp","SpiderfieldEasy","Spiderfield",},
Wasps = {"BeeClearing","FlowerPatch","EvilFlowerPatch","Waspnests",}, -- everywhere were bees are
Merms = {"SlightlyMermySwamp","MermTown","Mermfield",},
Tentacles = {"BGMarsh","Marsh","Tentacleland",},
Walrus = {"WalrusHut_Plains","WalrusHut_Grassy","WalrusHut_Rocky","Walrusfield",},
Hounds = {"HoundyBadlands","Moundfield",},
Clockworks = {"ChessArea","MarbleForest","ChessMarsh","ChessForest","ChessBarrens","BGChessRocky","Chessfield",},
GuardPigs = {}, -- They don't have a room.
Bees = {"BeeClearing","FlowerPatch","EvilFlowerPatch","Waspnests",},
Tallbirds = {"TallbirdNests","Tallbirdfield",},
Beefalos = {"BeefalowPlain",},
Pigs = {"PigTown","PigVillage","PigKingdom","PigCity","PigCamp",},
Rabbits = {"BGSavanna","Plain","BarePlain",},
Moles = {"GrassyMoleColony","DeciduousMole","MolesvilleDeciduous","ForestMole","MolesvilleRocky",},
Voaltgoats = {"Lightning",},
Catcoons = {"BGDeciduous","DeepDeciduous","MagicalDeciduous","DeciduousMole","PondyGrass",}
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------