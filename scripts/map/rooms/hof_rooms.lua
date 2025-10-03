AddRoom("SerenityRoom", 
{
	colour = {r = 0.3, g = 0.2, b = 0.1, a = 0.3},
	value = WORLD_TILES.OCEAN_SWELL,
	tags = {"SerenityArea"},
	
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
	value = WORLD_TILES.OCEAN_SWELL,
	tags = {"MeadowArea"},
	
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