AddRoom("SerenityRoom", 
{
	colour = {r = 0.3, g = 0.2, b = 0.1, a = 0.3},
	value = WORLD_TILES.QUAGMIRE_PARKFIELD,
	tags = {"RoadPoison", "nohasslers", "nohunt"},
	
	required_prefabs =
	{
		"kyno_serenityisland_shop",
	},

	contents =
	{
		countstaticlayouts =
		{
			["SerenityIsland"] = 1,
		},
	}
})

AddRoom("MeadowRoom", 
{
	colour = {r = 0.3, g = 0.2, b = 0.1, a = 0.3},
	value = WORLD_TILES.MONKEY_GROUND,
	tags = {"RoadPoison", "nohunt"},
	
	required_prefabs =
	{
		"kyno_meadowisland_shop",
	},

	contents =
	{
		countstaticlayouts =
		{
			["MeadowIsland"] = 1,
		},
	}
})