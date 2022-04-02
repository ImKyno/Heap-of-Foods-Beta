-- Salt Ponds, Boulders, Flintless Boulders and Salt Crystals.
AddRoom("SerenityIslandSalt", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.QUAGMIRE_CITYSTONE,
	tags = {"ExitPiece", "nohasslers", "nohunt"},
	contents =  {
		distributepercent = .2 ,
		distributeprefabs = {
			kyno_pond_salt = .1,
			kyno_serenityisland_rock1 = .2,
			kyno_serenityisland_rock3 = .1,
			saltrock = .06,
		},
	}
})

-- Pebble Crabs, Limpet Rocks and Rocks.
AddRoom("SerenityIslandCrab", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.QUAGMIRE_CITYSTONE,
	type = NODE_TYPE.SeparatedRoom,
	tags = {"ForceDisconnected", "nohasslers", "nohunt"},
	contents =  {
		distributepercent = .2,
		distributeprefabs = {
			kyno_pebblecrab_spawner = .10,
			kyno_limpetrock = .2,
			kyno_serenityisland_rock3 = .1,
			rocks = .06,
		},
	}
})

-- Wild Wheats, Grass and Chickens.
AddRoom("SerenityIslandChicken", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.SAVANNA,
	type = NODE_TYPE.SeparatedRoom,
	tags = {"ForceDisconnected", "nohasslers", "nohunt"},
	contents =  {
		distributepercent = .2,
		distributeprefabs = {
			-- kyno_chicken2_spawner = .15,
			kyno_wildwheat = .1,
			grass = .1,
		},
	}
})

-- More Sugarwood Trees and Sweet Flowers, Less Ferns and Spotty Shrubs.
AddRoom("SerenityIsland", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.QUAGMIRE_PARKFIELD,
	tags = {"ExitPiece", "nohasslers", "nohunt"},
	contents =  {
		distributepercent = .2,
		distributeprefabs = {
			kyno_sugartree = .3,
			kyno_sugartree_flower = .2,
			kyno_spotbush = .1,
			cave_fern = .1,
		},
	}
})

AddRoom("SerenityIslandEntrance", {
	colour = {r=.010,g=.010,b=.10,a=.50},
	value = GROUND.QUAGMIRE_PARKFIELD,
	tags = {"ExitPiece", "nohasslers", "nohunt"},
	contents = {
		countstaticlayouts = {
			["SerenityIslandShop"] = 1,
		},
		distributepercent = .2,
		distributeprefabs = {
			kyno_spotbush = .1,
			kyno_sugartree = .2,
			kyno_sugartree_flower = .2,
			cave_fern = .2,
		},
	}
})

-- More Spotty Shrubs and Ferns, Less Sugarwood Trees and Sweet Flowers.
AddRoom("BGSerenityIsland", {
	colour={r=0,g=0,b=0,a=0},
	value = GROUND.QUAGMIRE_PARKFIELD,
	type = NODE_TYPE.SeparatedRoom,
	tags = {"ForceDisconnected", "nohasslers", "nohunt"},
	contents = { 
		distributepercent = .2,
		distributeprefabs = {
			kyno_spotbush = .2,
			kyno_sugartree = .1,
			kyno_sugartree_flower = .1,
			cave_fern = .2,
		},
	}
})