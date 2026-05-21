require("map/room_functions")

AddRoom("SunkenForestEntrance",
{
	colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
	value  = WORLD_TILES.DECIDUOUS,

	tags   = { "Hutch_Fishbowl", "SunkenForestArea" },
	type   = NODE_TYPE.Room,

	contents =
	{
		distributepercent = .15,
		distributeprefabs =
		{

		},
	}
})

AddRoom("SunkenForestRivers",
{
	colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
	value  = WORLD_TILES.DECIDUOUS,

	tags   = { "Hutch_Fishbowl", "SunkenForestArea" },
	type   = NODE_TYPE.Room,

	contents =
	{
		distributepercent = .15,
		distributeprefabs =
		{

		},
	}
})

AddRoom("SunkenForestPlains",
{
	colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
	value  = WORLD_TILES.DECIDUOUS,

	tags   = { "Hutch_Fishbowl", "SunkenForestArea" },
	type   = NODE_TYPE.Room,

	contents =
	{
		distributepercent = .15,
		distributeprefabs =
		{

		},
	}
})

AddRoom("SunkenForestMandrakes",
{
	colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
	value  = WORLD_TILES.DECIDUOUS,

	tags   = { "Hutch_Fishbowl", "SunkenForestArea" },
	type   = NODE_TYPE.Room,

	contents =
	{
		distributepercent = .15,
		distributeprefabs =
		{

		},
	}
})

local BGSunkenForest =
{
	colour = { r = 0.7, g = 0.7, b = 0.7, a = 0.9 },
	value  = WORLD_TILES.DECIDUOUS,

	tags   = { "Hutch_Fishbowl", "SunkenForestArea" },
	type   = NODE_TYPE.Room,

	contents =
	{
		distributepercent = .10,
		distributeprefabs =
		{

		},
	}
}

AddRoom("BGSunkenForest", BGSunkenForest)
AddRoom("BGSunkenForestRoom", Roomify(BGSunkenForest))