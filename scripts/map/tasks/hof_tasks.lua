require("map/rooms/hof_rooms")

AddTask("SerenityIsland", 
{
	colour = {r = 1, g = 1, b = 1, a = 1},
	locks = LOCKS.NONE,
	keys_given = KEYS.SERENITY_ISLAND,
	
	region_id = "serenityisland",
	room_tags = {"RoadPoison", "not_mainland", "nohasslers", "nohunt"},
	level_set_piece_blocker = true,
	
	room_choices = 
	{
		["Empty_Cove"] = 1,
		["SerenityRoom"] = 1,
	},
	
	room_bg = WORLD_TILES.GRASS,
	background_room = "Empty_Cove",
	cove_room_name = "Empty_Cove",
	cove_room_chance = 1,
	cove_room_max_edges = 3,
})

AddTask("MeadowIsland", 
{
	colour = {r = 1, g = 1, b = 1, a = 1},
	locks = LOCKS.NONE,
	keys_given = KEYS.MEADOW_ISLAND,

	region_id = "meadowisland",
	room_tags = {"RoadPoison", "not_mainland", "nohunt"},
	level_set_piece_blocker = true,
	
	room_choices = 
	{
		["Empty_Cove"] = 1,
		["MeadowRoom"] = 1,
	},

	room_bg = WORLD_TILES.GRASS,
	background_room = "Empty_Cove",
	cove_room_name = "Empty_Cove",
	cove_room_chance = 1,
	cove_room_max_edges = 3,
})