require("map/rooms/hof_serenityisland_rooms")

AddTask("Serenity Archipelago", {
	locks = {},
	keys_given = { KEYS.ISLAND_TIER3, KEYS.SERENITY_ISLAND },
	region_id = "serenityisland",
	room_tags = {"RoadPoison", "not_mainland", "nohasslers", "nohunt"},
	type = NODE_TYPE.SeparatedRoom,
	room_choices =
	{
		["SerenityIsland"] = 1,
	},
	room_bg = GROUND.QUAGMIRE_PARKFIELD,
	background_room = "Empty_Cove",
	cove_room_name = "Empty_Cove",
	make_loop = true,
	crosslink_factor = 2,
	cove_room_chance = 1,
	cove_room_max_edges = 2,
	colour = {r=0,g=0,b=0,a=0},
})