require("map/rooms/hof_terrain_sunkenforest")

AddTask("SunkenForest",
{
	locks           = { LOCKS.SUNKENFOREST },
	keys_given      = { },
	room_choices    = 
	{
		["SunkenForestEntrance"]  = 1,
		["SunkenForestPlains"]    = function() return 1 + math.random(2) end,
		["SunkenForestRivers"]    = function() return 2 + math.random(1) end,
		["SunkenForestMandrakes"] = 1,
	},
	room_bg         = WORLD_TILES.ROCKY,
	background_room = "BGSunkenForestRoom",
	colour          = { r = 0, g = 0, b = 0, a = 0 }
})