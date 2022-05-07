require("map/rooms/hof_serenityisland_rooms")

AddTask("SerenityIsland_Shards", {
	locks = {},
	keys_given = {KEYS.ISLAND_TIER2},
	region_id = "serenityisland",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "nohunt", "nohasslers", "serenityisland", "not_mainland"},
    room_choices =
    {
        ["SerenityIsland_Crab"] = 2,
		["SerenityIsland_Chicken"] = 2,
        ["SerenityIsland_Cove"] = 2,
    },
    room_bg = GROUND.QUAGMIRE_CITYSTONE,
    background_room = "SerenityIsland_Cove",
	cove_room_name = "SerenityIsland_Blank",
    make_loop = true,
	crosslink_factor = 2,
	cove_room_chance = 1,
	cove_room_max_edges = 2,
    colour = {r=0.6,g=0.6,b=0.0,a=1},
})

AddTask("SerenityIsland_Salt", {
	locks = {LOCKS.ISLAND_TIER2},
	keys_given = {KEYS.ISLAND_TIER3},
	region_id = "serenityisland",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "nohunt", "nohasslers", "serenityisland", "not_mainland"},
    entrance_room = "SerenityIsland_Blank",
    room_choices =
    {
        ["SerenityIsland_Salt"] = 2,
    },
    room_bg = GROUND.QUAGMIRE_CITYSTONE,
    background_room = "SerenityIsland_Cove",
	cove_room_name = "SerenityIsland_Cove",
	cove_room_chance = 1,
    make_loop = true,
	cove_room_max_edges = 2,
    colour = {r=0.6,g=0.6,b=0.0,a=1},
})

AddTask("SerenityIsland_Forest1", {
	locks = {LOCKS.ISLAND_TIER4},
	keys_given = {},
	region_id = "serenityisland",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "nohunt", "nohasslers", "serenityisland", "not_mainland"},
    room_choices =
    {
        ["SerenityIsland_Forest1"] = 1,
    },
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    background_room = "SerenityIsland_Cove",
	cove_room_name = "SerenityIsland_Cove",
	crosslink_factor = 1,
	cove_room_chance = 1,
	cove_room_max_edges = 2,
    colour = {r=0.6,g=0.6,b=0.0,a=1},
})

AddTask("SerenityIsland_Forest2", {
	locks = {LOCKS.ISLAND_TIER4},
	keys_given = {},
	region_id = "serenityisland",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "nohunt", "nohasslers", "serenityisland", "not_mainland"},
	room_choices =
	{
		["SerenityIsland_Forest2"] = 3,
	},
	room_bg=GROUND.QUAGMIRE_PARKFIELD,
	background_room = "SerenityIsland_Cove",
	cove_room_name = "SerenityIsland_Cove",
	cove_room_chance = 1,
	cove_room_max_edges = 2,
	colour = {r=.05,g=.5,b=.05,a=1},
})

AddTask("SerenityIsland_Forest3", {
	locks = {LOCKS.ISLAND_TIER3},
	keys_given = {KEYS.ISLAND_TIER4},
	region_id = "serenityisland",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "nohunt", "nohasslers", "serenityisland", "not_mainland"},
    room_choices =
    {
        ["SerenityIsland_Extra"] = 1,
		["SerenityIsland_Meadows"] = 2,
    },
    room_bg = GROUND.QUAGMIRE_PARKFIELD,
    background_room = "SerenityIsland_Blank",
	cove_room_name = "SerenityIsland_Cove",
	cove_room_chance = 1,
	cove_room_max_edges = 2,
    colour = {r=0.6,g=0.6,b=0.0,a=1},
})