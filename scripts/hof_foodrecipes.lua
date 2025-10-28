local kyno_foods =
{
	-- Shipwrecked Foods.
	coffee =
	{
		test = function(cooker, names, tags) return names.kyno_coffeebeans_cooked and (names.kyno_coffeebeans_cooked == 4 or 
		(names.kyno_coffeebeans_cooked == 3 and (tags.dairy or tags.sweetener or tags.sugar))) and not names.kyno_coffeebeans end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_BRIEF,
		health = 5,
		hunger = 9.375,
		sanity = -10,
		cooktime = 0.5,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SPEED,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "drinkable_food", "nospice"},
		card_def = {ingredients = {{"kyno_coffeebeans_cooked", 3}, {"honey", 1}}},
	},
	
	bisque =
	{
		test = function(cooker, names, tags) return (tags.limpet and tags.limpet >= 3) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 18.75,
		sanity = 5,
		cooktime = 1,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_limpets", 3}, {"ice", 1}}},
	},
	
	jellyopop = 
	{
		test = function(cooker, names, tags) return tags.jellyfish and tags.frozen and names.twigs end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERFAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 20,
		hunger = 18.75,
		sanity = 10,
		cooktime = 0.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_jellyfish", 1}, {"ice", 1}, {"twigs", 1}}},
	},
	
	sharkfinsoup = 
	{
		test = function(cooker, names, tags) return names.kyno_shark_fin end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 12.5,
		sanity = -10,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NAUGHTINESS,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_shark_fin", 1}, {"twigs", 3}}},
		oneatenfn = function(inst, eater)
			OnFoodNaughtiness(inst, eater)
		end,
	},
	
	tropicalbouillabaisse =
	{
		test = function(cooker, names, tags) return tags.fish and (names.eel or names.eel_cooked or names.pondeel) and (tags.wobster) 
		and (names.barnacle or names.barnacle_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 60,
		hunger = 37.5,
		sanity = 15,
		cooktime = 2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SPEED,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pondfish", 1}, {"pondeel", 1}, {"wobster_sheller_land", 1}, {"barnacle", 1}}},
	},
	
	-- Hamlet Foods.
	feijoada =
	{
		test = function(cooker, names, tags) return (tags.beanbug and tags.beanbug >= 3) and tags.meat end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 20,
		hunger = 75,
		sanity = 15,
		cooktime = 3.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_beanbugs", 3}, {"monstermeat", 1}}},
	},
	
	gummy_cake =
	{
		test = function(cooker, names, tags) return tags.gummybug and tags.sweetener end,
		priority = 1,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_PRESERVED,
		health = -3,
		hunger = 150,
		sanity = -5,
		cooktime = 2,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"kyno_gummybug", 1}, {"honey", 3}}},
	},
	
	hardshell_tacos =
	{
		test = function(cooker, names, tags) return (names.slurtle_shellpieces and names.slurtle_shellpieces >= 2) and tags.veggie end,
		priority = 1,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 37.5,
		sanity = 5,
		cooktime = 2,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"slurtle_shellpieces", 2}, {"tomato", 2}}},
	},
	
	icedtea = 
	{
		test = function(cooker, names, tags) return (names.kyno_tealeaf and names.kyno_tealeaf >= 2) and tags.sweetener and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 25,
		hunger = 12.5,
		sanity = 33,
		cooktime = 0.5,
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "drinkable_food"},
		card_def = {ingredients = {{"kyno_tealeaf", 2}, {"honey", 1}, {"ice", 1}}},
	},
	
	tea = 
	{
		test = function(cooker, names, tags) return (names.kyno_tealeaf and names.kyno_tealeaf >= 2) and tags.sweetener and not tags.frozen end,
		priority = 25,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		perishproduct = "icedtea",
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 25,
		hunger = 12.5,
		sanity = 33,
		cooktime = 1,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "drinkable_food"},
		card_def = {ingredients = {{"kyno_tealeaf", 2}, {"honey", 2}}},
	},
	
	nettlelosange = 
	{
		test = function(cooker, names, tags) return names.firenettles and not tags.meat end,
		priority = 1,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 20,
		hunger = 25,
		sanity = -10,
		cooktime = .5,
		potlevel = "med",
		nochill = true,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"firenettles", 1}, {"twigs", 3}}},
	},
	
	nettlemeated =
	{
		test = function(cooker, names, tags) return (names.firenettles and names.firenettles >= 2) and (tags.meat and tags.meat >= 1) 
		and (not tags.monster or tags.monster <= 1) and not tags.inedible end,
		priority = 1,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 20,
		hunger = 37.5,
		sanity = -5,
		cooktime = 1,
		potlevel = "high",
		nochill = true,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"firenettles", 2}, {"smallmeat", 2}}},
	},
	
	snakebonesoup = 
	{
		test = function(cooker, names, tags) return (names.kyno_worm_bone and names.kyno_worm_bone >= 2) and (tags.meat and tags.meat >= 2) 
		and not (names.kyno_humanmeat or names.kyno_humanmeat_cooked or names.kyno_humanmeat_dried) end,
		priority = 20,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 80,
		sanity = 20,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_BONESOUP,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_worm_bone", 2}, {"meat", 2}}},
		prefabs = { "kyno_wormbuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_wormbuff", "kyno_wormbuff")
		end,
	},
	
	steamedhamsandwich = 
	{
		test = function(cooker, names, tags) return ((names.meat or 0) + (names.meat_cooked or 0) >= 2) and tags.foliage and (tags.veggie and tags.veggie >= 1) end,
		priority = 15,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		health = 30,
		hunger = 62.5,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 2}, {"foliage", 1}, {"garlic", 1}}},
	},
	
	-- The Gorge Foods.
	gorge_bread = 
	{
		test = function(cooker, names, tags) return (tags.flour and tags.flour == 3 or (tags.flour and tags.flour == 4)) 
		and not tags.spotspice end,
		priority = 1,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 3,
		hunger = 12.5,
		sanity = 0,
		cooktime = 1,
		stacksize = 3,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 4}}},
	},
	
	gorge_sweet_chips = 
	{
		test = function(cooker, names, tags) return ((names.kyno_sweetpotato or 0) + (names.kyno_sweetpotato_cooked or 0) >= 2) 
		and tags.oil and tags.spotspice end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 25,
		hunger = 75,
		sanity = 15,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_sweetpotato", 2}, {"kyno_oil", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_vegetable_soup =
	{
		test = function(cooker, names, tags) return (names.carrot or names.carrot_cooked) and (names.onion or names.onion_cooked) and
		(names.corn or names.corn_cooked) and tags.foliage and not (names.potato or names.potato_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 8,
		hunger = 25,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"carrot", 1}, {"onion", 1}, {"corn", 1}, {"foliage", 1}}},
	},
	
	gorge_jelly_sandwich = 
	{
		test = function(cooker, names, tags) return tags.bread and tags.berries 
		and not tags.inedible and not tags.veggie and not tags.meat and not tags.fish end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 3,
		hunger = 37.5,
		sanity = 15,
		cooktime = .5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 1}, {"berries", 3}}},
	},
	
	gorge_fish_stew =
	{
		test = function(cooker, names, tags) return (tags.salmon and tags.salmon >= 2) and (names.asparagus or names.asparagus_cooked) 
		and tags.spotspice and not names.twigs and not tags.bread end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 20,
		hunger = 100,
		sanity = 5,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_salmonfish", 2}, {"asparagus", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_onion_cake =
	{
		test = function(cooker, names, tags) return ((names.kyno_turnip or 0) + (names.kyno_turnip_cooked or 0) >= 2) and tags.egg
		and tags.flour and not tags.dairy end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 37.5,
		sanity = 10,
		cooktime = .75,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_turnip", 2}, {"bird_egg", 1}, {"kyno_flour", 1}}},
	},
	
	gorge_potato_pancakes = 
	{
		test = function(cooker, names, tags) return ((names.potato or 0) + (names.potato_cooked or 0) >= 3) and tags.flour and not tags.egg and not tags.fish end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 40,
		sanity = 40,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"potato", 3}, {"kyno_flour", 1}}},
	},
	
	gorge_potato_soup = 
	{
		test = function(cooker, names, tags) return ((names.potato or 0) + (names.potato_cooked or 0) >= 3) and names.succulent_picked end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 75,
		sanity = 15,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"potato", 3}, {"succulent_picked", 1}}},
	},
	
	gorge_fishball_skewers = 
	{
		test = function(cooker, names, tags) return tags.fish and names.twigs and tags.spotspice end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		health = 25,
		hunger = 37.5,
		sanity = 20,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pondfish", 2}, {"twigs", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_meat_skewers =
	{
		test = function(cooker, names, tags) return (tags.bacon and tags.bacon >= 2) and names.twigs and tags.spotspice end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 20,
		hunger = 37.5,
		sanity = 5,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_bacon", 2}, {"twigs", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_stone_soup = 
	{
		test = function(cooker, names, tags) return names.rocks and tags.veggie end,
		priority = 1,
		foodtype = FOODTYPE.VEGGIE,
		secondaryfoodtype = FOODTYPE.ELEMENTAL,
		perishtime = TUNING.PERISH_SLOW,
		health = -10,
		hunger = 25,
		sanity = 5,
		cooktime = .60,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"rocks", 1}, {"carrot", 3}}},
	},
	
	gorge_croquette = 
	{
		test = function(cooker, names, tags) return (names.potato and names.potato >= 2) and tags.egg and tags.flour and not names.potato_cooked end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 50,
		sanity = 10,
		cooktime = .75,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"potato", 2}, {"bird_egg", 1}, {"kyno_flour", 1}}},
	},
	
	gorge_roast_vegetables = 
	{
		test = function(cooker, names, tags) return names.onion_cooked and names.asparagus_cooked and names.garlic_cooked and names.carrot_cooked end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 25,
		hunger = 40,
		sanity = 20,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"onion_cooked", 1}, {"asparagus_cooked", 1}, {"garlic_cooked", 1}, {"carrot_cooked", 1}}},
	},
	
	gorge_meatloaf =
	{
		test = function(cooker, names, tags) return (tags.bacon and tags.bacon >= 2) and tags.flour and tags.veggie and not tags.foliage end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 25,
		sanity = 5,
		cooktime = 1.5,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_bacon", 2}, {"kyno_flour", 1}, {"onion", 1}}},
	},
	
	gorge_carrot_soup =
	{
		test = function(cooker, names, tags) return ((names.carrot or 0) + (names.carrot_cooked or 0) >= 3) and tags.spotspice end,
		priority = 15,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 37.5,
		sanity = 10,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"sammyfood"},
		card_def = {ingredients = {{"carrot", 3}, {"kyno_spotspice", 1}}},
	},
	
	gorge_fishpie =
	{
		test = function(cooker, names, tags) return tags.salmon and tags.flour and tags.veggie 
		and not tags.bread end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 62.5,
		sanity = 5,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_salmonfish", 1}, {"kyno_flour", 1}, {"kyno_radish", 2}}},
	},

	gorge_fishchips =
	{
		test = function(cooker, names, tags) return tags.fish and tags.flour and ((names.potato or 0) + (names.potato_cooked or 0) >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 50,
		hunger = 85,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pondfish", 1}, {"kyno_flour", 1}, {"potato", 2}}},
	},
	
	gorge_meatpie = 
	{
		test = function(cooker, names, tags) return tags.meat and (tags.flour and tags.flour >= 2) and tags.veggie and not (names.potato or names.potato_cooked) 
		and not (names.onion or names.onion_cooked) and not tags.bacon end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 3,
		hunger = 50,
		sanity = 25,
		cooktime = 2,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"kyno_flour", 2}, {"tomato", 1}}},
	},
	
	gorge_sliders = 
	{
		test = function(cooker, names, tags) return (tags.bacon and tags.bacon >= 2) and names.littlebread and tags.foliage end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 12.5,
		sanity = 25,
		cooktime = 0.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_bacon", 2}, {"littlebread", 1}, {"foliage", 1}}},
	},
	
	gorge_jelly_roll = 
	{
		test = function(cooker, names, tags) return (tags.berries and tags.berries >= 3) and tags.flour 
		and not tags.syrup and not tags.sweetener and not tags.dairy and not tags.meat end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 8,
		hunger = 25,
		sanity = 15,
		cooktime = .5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"berries", 3}, {"kyno_flour", 1}}},
	},
	
	gorge_carrot_cake =
	{
		test = function(cooker, names, tags) return (names.carrot and names.carrot >= 2) and tags.egg and tags.flour 
		and not tags.spotspice and not names.carrot_cooked end,
		priority = 20,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 15,
		hunger = 37.5,
		sanity = 5,
		cooktime = .75,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_CAKE,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"sammyfood"},
		card_def = {ingredients = {{"carrot", 2}, {"bird_egg", 1}, {"kyno_flour", 1}}},
	},
	
	gorge_garlicmashed =
	{
		test = function(cooker, names, tags) return ((names.garlic or 0) + (names.garlic_cooked or 0) >= 2) and 
		(names.potato or names.potato_cooked) and tags.spotspice and not tags.bread and not tags.meat and not tags.fish end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 37.5,
		sanity = 15,
		cooktime = .60,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"garlic", 2}, {"potato", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_garlicbread = 
	{
		test = function(cooker, names, tags) return tags.bread and ((names.garlic or 0) + (names.garlic_cooked or 0) >= 2) 
		and not tags.meat and not tags.fish end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 37.5,
		sanity = 5,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 1}, {"garlic", 3}}},
	},
	
	gorge_tomato_soup = 
	{
		test = function(cooker, names, tags) return ((names.tomato or 0) + (names.tomato_cooked or 0) >= 3) and tags.spotspice 
		and not tags.bread and not tags.meat and not tags.dairy end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 25,
		hunger = 50,
		sanity = 15,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"tomato", 3}, {"kyno_spotspice", 1}}},
	},
	
	gorge_sausage =
	{
		test = function(cooker, names, tags) return (tags.bacon and tags.bacon >= 3) 
		and tags.spotspice and not tags.inedible end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 37.5,
		sanity = 10,
		cooktime = 0.8,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_bacon", 3}, {"kyno_spotspice", 1}}},
	},
	
	gorge_candiedfish =
	{
		test = function(cooker, names, tags) return tags.salmon and tags.syrup end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 25,
		sanity = 60,
		cooktime = 1.5,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"kyno_salmonfish", 2}, {"kyno_syrup", 2}}},
	},
	
	gorge_stuffedmushroom =
	{
		test = function(cooker, names, tags) return ((names.kyno_white_cap or 0) + (names.kyno_white_cap_cooked or 0) >= 3) 
		and not tags.foliage and not names.succulent_picked and not tags.dairy and not names.royal_jelly end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 20,
		sanity = 10,
		cooktime = 0.8,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_white_cap", 3}, {"carrot", 1}}},
	},
	
	gorge_bruschetta = 
	{
		test = function(cooker, names, tags) return tags.bread and tags.spotspice and ((names.tomato or 0) + (names.tomato_cooked or 0) >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 50,
		hunger = 62.5,
		sanity = 10,
		cooktime = 1.7,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 1}, {"kyno_spotspice", 1}, {"tomato", 2}}},
	},
	
	gorge_hamburger =
	{
		test = function(cooker, names, tags) return tags.bread and tags.meat and tags.bacon and 
		tags.foliage and not tags.fish and not tags.dairy and not (tags.bacon and tags.bacon > 1) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 5,
		hunger = 80,
		sanity = 5,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 1}, {"meat", 1}, {"kyno_bacon", 1}, {"foliage", 1}}},
	},
	
	gorge_fishburger =
	{
		test = function(cooker, names, tags) return tags.bread and tags.salmon and tags.foliage end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 20,
		hunger = 80,
		sanity = 5,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 1}, {"kyno_salmonfish", 1}, {"foliage", 2}}},
	},
	
	gorge_mushroomburger =
	{
		test = function(cooker, names, tags) return tags.bread and 
		((names.kyno_white_cap or 0) + (names.kyno_white_cap_cooked or 0) >= 2) and tags.foliage end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 80,
		sanity = 30,
		cooktime = .70,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 1}, {"foliage", 1}, {"kyno_white_cap", 2}}},
	},
	
	gorge_fish_steak =
	{
		test = function(cooker, names, tags) return names.kyno_salmonfish_cooked and tags.foliage and tags.spotspice and not names.kyno_salmonfish end,
		priority = 40,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 150,
		sanity = 15,
		cooktime = 1.2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_salmonfish_cooked", 1}, {"foliage", 1}, {"kyno_spotspice", 2}}},
	},
	
	gorge_curry = 
	{
		test = function(cooker, names, tags) return tags.meat and tags.veggie and (tags.spotspice and tags.spotspice >= 2) end,
		priority = 15,
		foodtype = FOODTYPE.MEAT,
		secondaryfoodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 10,
		hunger = 75,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"carrot", 1}, {"kyno_spotspice", 2}}},
	},
	
	gorge_spaghetti =
	{
		test = function(cooker, names, tags) return tags.meat and tags.flour and tags.spotspice and (names.tomato or names.tomato_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 8,
		hunger = 80,
		sanity = 25,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"kyno_flour", 1}, {"kyno_spotspice", 1}, {"tomato", 1}}},
	},
	
	gorge_poachedfish =
	{
		test = function(cooker, names, tags) return tags.salmon and (tags.foliage and tags.foliage >= 2) and tags.spotspice and not names.twigs end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		health = 40,
		hunger = 25,
		sanity = 25,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_salmonfish", 1}, {"foliage", 2}, {"kyno_spotspice", 1}}},
	},
	
	gorge_shepherd_pie =
	{
		test = function(cooker, names, tags) return tags.meat and (names.onion or names.onion_cooked) 
		and (names.garlic or names.garlic_cooked) and tags.spotspice end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 150,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"onion", 1}, {"garlic", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_candy =
	{
		test = function(cooker, names, tags) return tags.syrup and (tags.sweetener and tags.sweetener >= 4) end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 0,
		hunger = 20,
		sanity = 33,
		cooktime = .75,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HANDS,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"kyno_syrup", 1}, {"honey", 3}}},
		prefabs = { "kyno_hastebuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_hastebuff", "kyno_hastebuff")
        end,
	},
	
	gorge_bread_pudding = 
	{
		test = function(cooker, names, tags) return tags.berries and (tags.flour and tags.flour >= 2)
		and tags.syrup end,
		priority = 20,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 40,
		sanity = 40,
		cooktime = 1.2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"berries", 1}, {"kyno_syrup", 1}, {"kyno_flour", 2}}},
	},
	
	gorge_berry_tart =
	{
		test = function(cooker, names, tags) return (tags.berries and tags.berries >= 2) and tags.flour
		and tags.sweetener and not tags.syrup end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 20,
		sanity = 15,
		cooktime = 1.2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"berries", 2}, {"kyno_flour", 1}, {"honey", 1}}},
	},
	
	gorge_macaroni =
	{
		test = function(cooker, names, tags) return (tags.flour and tags.flour >= 2) and tags.milk and not tags.fish and not tags.meat 
		and not tags.bread and not tags.fruit and not tags.syrup end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 20,
		hunger = 37.5,
		sanity = 50,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 2}, {"goatmilk", 2}}},
	},
	
	gorge_bagel_and_fish = 
	{
		test = function(cooker, names, tags) return tags.bread and tags.milk and tags.salmon and tags.spotspice end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 50,
		hunger = 75,
		sanity = 50,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 1}, {"goatmilk", 1}, {"kyno_salmonfish", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_grilled_cheese =
	{
		test = function(cooker, names, tags) return tags.bread and (tags.dairy or tags.cheese) and not tags.fish and not tags.meat 
		and not tags.spotspice and not (tags.inedible and tags.inedible > 1) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 60,
		hunger = 50,
		sanity = 40,
		cooktime = 0.5,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"gorge_bread", 2}, {"cheese_yellow", 1}, {"twigs", 1}}},
	},
	
	gorge_creammushroom = 
	{
		test = function(cooker, names, tags) return tags.milk and ((names.kyno_white_cap or 0) + (names.kyno_white_cap_cooked or 0) >= 2) 
		and names.succulent_picked and not tags.meat and not tags.fish end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 50,
		sanity = 25,
		cooktime = .75,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"goatmilk", 1}, {"succulent_picked", 1}, {"kyno_white_cap", 2}}},
	},
	
	gorge_manicotti =
	{
		test = function(cooker, names, tags) return tags.flour and tags.milk and tags.spotspice and (names.tomato or names.tomato_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 8,
		hunger = 50,
		sanity = 50,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 1}, {"goatmilk", 1}, {"kyno_spotspice", 1}, {"tomato", 1}}},
	},
	
	gorge_fettuccine = 
	{
		test = function(cooker, names, tags) return tags.flour and (names.garlic or names.garlic_cooked) and names.succulent_picked and tags.dairy end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 50,
		sanity = 40,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 1}, {"garlic", 1}, {"succulent_picked", 1}, {"goatmilk", 1}}},
	},
	
	gorge_onion_soup =
	{
		test = function(cooker, names, tags) return tags.flour and tags.dairy and ((names.onion or 0) + (names.onion_cooked or 0) >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 25,
		hunger = 75,
		sanity = -5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 1}, {"goatmilk", 1}, {"onion", 2}}},
	},
	
	gorge_breaded_cutlet =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 2) and (tags.flour and tags.flour >= 2) 
		and not (tags.monster and tags.monster > 1) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 75,
		sanity = 15,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 2}, {"kyno_flour", 2}}},
	},
	
	gorge_creamy_fish =
	{
		test = function(cooker, names, tags) return tags.milk and tags.veggie and tags.salmon and tags.spotspice and not tags.bread end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 40,
		hunger = 75,
		sanity = 30,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_salmonfish", 1}, {"goatmilk", 1}, {"carrot", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_pot_roast =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 2) and tags.veggie and tags.spotspice and not tags.fish 
		and not tags.monster end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 150,
		sanity = 5,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 2}, {"kyno_aloe", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_crab_cake = 
	{
		test = function(cooker, names, tags) return tags.crab and names.succulent_picked and tags.flour 
		and tags.spotspice end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 62.5,
		sanity = 20,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_crabmeat", 2}, {"succulent_picked", 1}, {"kyno_flour", 1}}},
	},
	
	gorge_steak_frites =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 2) and ((names.potato or 0) + (names.potato_cooked or 0) >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 100,
		sanity = 5,
		cooktime = 2.25,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 2}, {"potato", 2}}},
	},
	
	gorge_shooter_sandwich =
	{
		test = function(cooker, names, tags) return tags.meat and tags.bread and tags.spotspice and not tags.fish 
		and not (names.tomato or names.tomato_cooked) end, 
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 5,
		hunger = 100,
		sanity = 15,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 2}, {"gorge_bread", 1}, {"kyno_spotspice", 1}}},
	},
	
	gorge_bacon_wrapped =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat > 1) and (tags.bacon and tags.bacon >= 2) 
		and not tags.inedible and not tags.bread and not tags.spotspice end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 50,
		sanity = 0,
		cooktime = .75,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 2}, {"kyno_bacon", 2}}},
	},
	
	gorge_crab_roll =
	{
		test = function(cooker, names, tags) return tags.crab and tags.foliage and (names.kyno_white_cap or names.kyno_white_cap_cooked) and tags.flour end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 75,
		sanity = 25,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_crabmeat", 1}, {"foliage", 1}, {"kyno_white_cap", 1}, {"kyno_flour", 1}}},
	},
	
	gorge_crab_ravioli =
	{
		test = function(cooker, names, tags) return tags.crab and tags.flour and tags.dairy and tags.veggie end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		health = 60,
		hunger = 40,
		sanity = 50,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_crabmeat", 1}, {"kyno_flour", 1}, {"goatmilk", 1}, {"asparagus", 1}}},
	},
	
	gorge_caramel_cube =
	{
		test = function(cooker, names, tags) return (tags.syrup and tags.syrup >= 2) and (tags.dairy and tags.dairy >= 2) end,
		priority = 20,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -10,
		hunger = 20,
		sanity = 100,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_KYNO,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"kyno_syrup", 2}, {"goatmilk", 2}}},
	},
	
	gorge_waffles =
	{
		test = function(cooker, names, tags) return tags.butter and tags.egg and tags.syrup end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 37.5,
		sanity = 60,
		cooktime = .5,
		nameoverride = "WAFFLES",
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"butter", 1}, {"bird_egg", 1}, {"kyno_syrup", 2}}},
	},
	
	gorge_scone =
	{
		test = function(cooker, names, tags) return tags.fruit and (tags.flour and tags.flour >= 2) and tags.dairy end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FASTISH,
		health = 5,
		hunger = 37.5,
		sanity = 40,
		cooktime = 0.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"berries", 1}, {"kyno_flour", 2}, {"goatmilk", 1}}},
	},
	
	gorge_cheesecake =
	{
		test = function(cooker, names, tags) return (tags.berries and tags.berries >= 2) and tags.flour and tags.dairy end,
		priority = 20,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 20,
		hunger = 75,
		sanity = 60,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"berries", 2}, {"kyno_flour", 1}, {"goatmilk", 1}}},
	},
	
	kyno_syrup =
	{
		test = function(cooker, names, tags) return names.kyno_sap and (names.kyno_sap == 4 or 
		(names.kyno_sap == 3 and (tags.dairy or tags.sweetener))) and not tags.monster end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 3,
		hunger = 9.375,
		sanity = 0,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "drinkable_food"},
		card_def = {ingredients = {{"kyno_sap", 4}}},
	},
	
	-- Unimplemented Foods. 
	slaw = 
	{
		test = function(cooker, names, tags) return ((names.kyno_fennel or 0) + (names.kyno_fennel_cooked or 0) >= 2) 
		and (names.kyno_radish or names.kyno_radish_cooked) end,
		priority = 20,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 25,
		sanity = 10,
		cooktime = 1.5,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_fennel", 2}, {"kyno_radish", 2}}},
	},
	
	lotusbowl = 
	{
		test = function(cooker, names, tags) return ((names.kyno_lotus_flower or 0) + (names.kyno_lotus_flower_cooked or 0) >= 3) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FASTISH,
		health = 8,
		hunger = 12.5,
		sanity = 50,
		cooktime = 0.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_lotus_flower", 3}, {"twigs", 1}}},
	},
	
	poi = 
	{
		test = function(cooker, names, tags) return ((names.kyno_taroroot or 0) + (names.kyno_taroroot_cooked or 0) >= 3) and not tags.inedible end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 62.5,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_taroroot", 3}, {"carrot", 1}}},
	},
	
	cucumbersalad =
	{
		test = function(cooker, names, tags) return ((names.kyno_cucumber or 0) + (names.kyno_cucumber_cooked or 0) >= 3)
		and not (names.kyno_taroroot or names.kyno_taroroot_cooked) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 15,
		cooktime = 1.2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DRY,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_cucumber", 3}, {"kelp", 1}}},
		prefabs = { "buff_moistureimmunity" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("buff_moistureimmunity", "buff_moistureimmunity")
       	end,
	},
	
	waterycressbowl =
	{
		test = function(cooker, names, tags) return (names.kyno_waterycress and names.kyno_waterycress >= 2) and names.succulent_picked and
		(tags.veggie and tags.veggie >= 3) and not tags.inedible and not tags.egg and not tags.sweetener and not tags.fruit and not tags.meat end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 20,
		hunger = 37.5,
		sanity = 5,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_waterycress", 2}, {"succulent_picked", 1}, {"kelp", 1}}},
	},
	
	-- Secret / Custom Foods. Why are you here by the way?	
	bowlofgears = 
	{
		test = function(cooker, names, tags) return (names.gears and names.gears >= 2) and (names.wagpunk_bits and names.wagpunk_bits >= 2) end,
		priority = 1,
		foodtype = FOODTYPE.GEARS,
		perishtime = nil,
		fireproof = true,
		health = 150,
		hunger = 200,
		sanity = 150,
		cooktime = 2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_GEARS,
		potlevel = "med",
		pickupsound = "metal",
		floater = TUNING.HOF_FLOATER,
		tags = {"preparedgears"},
		card_def = {ingredients = {{"gears", 2}, {"wagpunk_bits", 2}}},
	},
	
	longpigmeal = 
	{
		test = function(cooker, names, tags) return ((names.kyno_humanmeat or 0) + (names.kyno_humanmeat_cooked or 0) + (names.kyno_humanmeat_dried or 0) >= 3)
		and names.boneshard end,
		priority = 1,
		foodtype = FOODTYPE.MEAT,
		secondaryfoodtype = FOODTYPE.MONSTER,
		perishtime = TUNING.PERISH_MED,
		health = -100,
		hunger = 150,
		sanity = -300,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HURT,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_humanmeat", 3}, {"boneshard", 1}}},
	},
	
	duckyouglermz = -- Keep this recipe updated in the postinit in case of changes!!
	{
		test = function(cooker, names, tags) return names.poop and names.guano and names.glommerfuel and names.kyno_salt end,
		priority = 100,
		foodtype = FOODTYPE.PREPAREDPOOP,
		perishtime = nil,
		health = 60,
		hunger = 12.5,
		sanity = 33,
		cooktime = 5,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_GLERMZ,
		potlevel = "med",
		scale = .95,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"poop", 1}, {"guano", 1}, {"glommerfuel", 1}, {"kyno_salt", 1}}},
		tags = {"preparedpoop"},
		oneatenfn = function(inst, eater)
            if eater.components.bloomness ~= nil and eater:HasTag("plantkin")
			and not (eater.components.health ~= nil and eater.components.health:IsDead()) and not eater:HasTag("playerghost") then
                if eater.components.bloomness ~= nil then
					eater.components.health:DoDelta(60) -- Since Wormwood can't heal from foods.
                    eater.components.bloomness:Fertilize(3)
                end
            end
        end,
	},
	
	catfood =
	{
		test = function(cooker, names, tags) return tags.fish and tags.flour and (tags.spotspice and tags.spotspice >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 20,
		hunger = 25,
		sanity = 15,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_CAT,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pondfish", 1}, {"kyno_flour", 1}, {"kyno_spotspice", 2}}},
	},
	
	katfood =
	{
		test = function(cooker, names, tags) return tags.dairy and tags.syrup and (tags.flour and tags.flour >= 2) and not tags.fish end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 15,
		sanity = 30,
		cooktime = 1.5,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_KAT,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"goatmilk", 1}, {"kyno_syrup", 1}, {"kyno_syrup", 2}}},
	},
	
	bowlofpopcorn =
	{
		test = function(cooker, names, tags) return (names.corn and names.corn == 3) and names.kyno_salt and not names.corn_cooked end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 5,
		hunger = 75,
		sanity = 33,
		cooktime = 1.2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"popcorn"},
		card_def = {ingredients = {{"corn", 3}, {"kyno_salt", 1}}},
	},
	
	figjuice =
	{
		test = function(cooker, names, tags) return (names.fig or names.fig_cooked) and (tags.frozen and tags.frozen >= 2) and not tags.meat 
		and not tags.fish and not tags.inedible end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 0,
		hunger = 15,
		sanity = 50,
		cooktime = .5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"fig", 2}, {"ice", 2}}},
	},
	
	coconutwater =
	{
		test = function(cooker, names, tags) return (names.kyno_kokonut_halved and names.kyno_kokonut_halved == 1) and (tags.frozen and tags.frozen >= 2) 
		and names.twigs and not names.kyno_kokonut_cooked and not tags.meat and not tags.fish end,
		priority = 20,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 20,
		hunger = 0,
		sanity = 0,
		cooktime = .5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"kyno_kokonut_halved", 1}, {"ice", 2}, {"twigs", 1}}},
	},
	
	eyeballspaghetti =
	{
		test = function(cooker, names, tags) return names.deerclops_eyeball and (names.tomato or names.tomato_cooked) and tags.flour end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = nil,
		health = 150,
		hunger = 150,
		sanity = -150,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_BOSS,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"deerclops_eyeball", 1}, {"kyno_flour", 1}, {"tomato", 2}}},
	},
	
	soulstew = 
	{
		test = function(cooker, names, tags) return names.kyno_bottle_soul and (names.boneshard and names.boneshard >= 2) end,
		priority = 1,
		foodtype = FOODTYPE.PREPAREDSOUL,
		perishtime = nil,
		health = 10,
		hunger = 62.5,
		sanity = -10,
		cooktime = 1.2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SOUL,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"soulstew"},
		card_def = {ingredients = {{"kyno_bottle_soul", 2}, {"boneshard", 2}}},
		oneatenfn = function(inst, eater)
			if eater:HasTag("soulstealer") then
				eater.components.health:DoDelta(TUNING.SOULSTEW_HEALTH)
				eater.components.hunger:DoDelta(TUNING.SOULSTEW_HUNGER)	
				eater.components.sanity:DoDelta(TUNING.SOULSTEW_SANITY)
			end
		end,
	},
	
	fortunecookie =
	{
		test = function(cooker, names, tags) return tags.flour and tags.sweetener and names.papyrus end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 3, 
		hunger = 20,
		sanity = 5,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_FORTUNE,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"papyrus", 1}, {"honey", 2}}},
		oneatenfn = function(inst, eater)
			if math.random() < 0.01 then
				if math.random() < 0.50 then
					eater.components.health:DoDelta(999)
					eater.components.hunger:DoDelta(999)
					eater.components.sanity:DoDelta(999)
					if eater.components.talker and eater:HasTag("player") then
						eater.components.talker:Say(STRINGS.FORTUNE_COOKIE_BAD[math.random(#STRINGS.FORTUNE_COOKIE_GOOD)])
					end
				else
					eater.components.health:SetPercent(.2)
					eater.components.hunger:DoDelta(-999)
					eater.components.sanity:DoDelta(-999)
					if eater.components.talker and eater:HasTag("player") then
						eater.components.talker:Say(STRINGS.FORTUNE_COOKIE_BAD[math.random(#STRINGS.FORTUNE_COOKIE_BAD)])
					end
				end
			else
				if eater.components.talker and eater:HasTag("player") then
					eater.components.talker:Say(STRINGS.FORTUNE_COOKIE_QUOTES[math.random(#STRINGS.FORTUNE_COOKIE_QUOTES)])
				end
			end
		end,
	},
	
	hornocupia =
	{
		test = function(cooker, names, tags) return tags.meat and tags.veggie and tags.fruit and names.horn end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 12,
		hunger = 75,
		sanity = 25,
		cooktime = 1.6,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"carrot", 1}, {"berries", 1}, {"horn", 1}}},
		prefabs = { "boneshard" },
		oneatenfn = function(inst, eater)
			local bones = SpawnPrefab("boneshard")
			bones.components.stackable.stacksize = 2
			if eater.components.inventory ~= nil and eater:HasTag("player") and not eater.components.health:IsDead() and not eater:HasTag("playerghost") 
			and not eater.components.inventory:IsFull() then 
				eater.components.inventory:GiveItem(bones)
			end
		end,
	},
	
	cheese_yellow = 
	{
		test = function(cooker, names, tags) return (tags.milk and tags.milk == 2) and tags.spotspice and not tags.meat 
		and not (names.garlic or names.garlic_cooked) and not names.kyno_milk_koalefant and not tags.cheese end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 10,
		hunger = 25,
		sanity = 5,
		cooktime = 2.3,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"goatmilk", 2}, {"kyno_spotspice", 2}}},
	},
	
	cheese_white = 
	{
		test = function(cooker, names, tags) return (tags.milk and tags.milk == 2) and tags.spotspice and (names.garlic or names.garlic_cooked)
		and not tags.meat and not tags.cheese end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 15,
		hunger = 25,
		sanity = 20,
		cooktime = 2.3,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"goatmilk", 2}, {"kyno_spotspice", 1}, {"garlic", 1}}},
	},
	
	cheese_koalefant =
	{
		test = function(cooker, names, tags) return (names.kyno_milk_koalefant and names.kyno_milk_koalefant == 2) and tags.spotspice
		and not (names.garlic or names.garlic_cooked) and not names.kyno_milk_beefalo and not names.goatmilk and not tags.meat and not tags.cheese end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 20,
		hunger = 25,
		sanity = 5,
		cooktime = 2.3,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_milk_koalefant", 2}, {"kyno_spotspice", 2}}},
	},

	milk_box = 
	{
		test = function(cooker, names, tags) return (tags.frozen and tags.frozen >= 2) and (tags.milk and tags.milk >= 2) and not names.milk_box end,
		priority = 1,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 25,
		hunger = 0,
		sanity = 20,
		cooktime = 1.1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"ice", 2}, {"goatmilk", 2}}},
	},
	
	honeyjar =
	{
		test = function(cooker, names, tags) return names.honeycomb and (names.honey and names.honey == 3) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 30,
		hunger = 45,
		sanity = 5,
		cooktime = 1.6,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"honeycomb", 1}, {"honey", 3}}},
	},
	
	watercup =
	{
		test = function(cooker, names, tags) return (tags.frozen and tags.frozen >= 2) and not tags.meat and not tags.fish and not tags.veggie 
		and not tags.fruit and not tags.milk and not tags.sweetener end,
		priority = -5,
		foodtype = FOODTYPE.GOODIES,
		perishtime = 9000000,
		fireproof = true,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 1,
		hunger = 1,
		sanity = 1,
		cooktime = .1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_CLEAR,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		tags = {"drinkable_food", "nospice"},
		card_def = {ingredients = {{"ice", 4}}},
		oneatenfn = function(inst, eater)
			if eater.components.debuffable ~= nil then 
				eater.components.debuffable:RemoveAllDebuffs()	
			end
		end
	},
	
	crab_artichoke =
	{
		test = function(cooker, names, tags) return (tags.crab and tags.crab >= 2) and (tags.algae and tags.algae >= 1) and tags.spotspice end,
		priority = 25,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		health = 40,
		hunger = 12.5,
		sanity = 60,
		cooktime = 2.2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_crabmeat", 2}, {"kyno_seaweeds", 1}, {"kyno_spotspice", 1}}},
	},
	
	poisonfrogglebunwich =
	{
		test = function(cooker, names, tags) return (names.kyno_poison_froglegs or names.kyno_poison_froglegs_cooked) and tags.veggie and tags.veggie >= 0.5 
		and not (names.froglegs or names.froglegs_cooked) end,
		priority = 1,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = -20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_FROG,
        potlevel = "low",
        floater = {"med", nil, 0.55},
		card_def = {ingredients = {{"kyno_poison_froglegs", 1}, {"kelp", 1}, {"twigs", 2}}},
		prefabs = { "kyno_frogbuff" },
        oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_frogbuff", "kyno_frogbuff")
       	end,
	},
	
	pepperrolls = 
	{
		test = function(cooker, names, tags) return tags.flour and tags.spotspice and ((names.pepper or 0) + (names.pepper_cooked or 0) >= 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_LONG,
		health = 40,
		hunger = 32.5,
		sanity = -15,
		cooktime = 1.6,
		potlevel = "med",
		floater = {"med", nil, 0.55},
		card_def = {ingredients = {{"kyno_flour", 1}, {"kyno_spotspice", 1}, {"pepper", 2}}},
	},
	
	chocolate_black =
	{
		test = function(cooker, names, tags) return tags.milk and tags.sugar and (names.kyno_twiggynuts and names.kyno_twiggynuts >= 2)
		and not tags.meat and not tags.fish and not tags.veggie and not tags.frozen and not names.kyno_milk_beefalo end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = -5,
		hunger = 12.5,
		sanity = 33,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"goatmilk", 1}, {"kyno_sugar", 1}, {"kyno_twiggynuts", 2}}},
	},
	
	chocolate_white =
	{
		test = function(cooker, names, tags) return names.kyno_milk_beefalo and tags.sugar and (names.kyno_twiggynuts and names.kyno_twiggynuts >= 2)
		and not tags.meat and not tags.fish and not tags.veggie and not tags.frozen and not names.goatmilk end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = -5,
		hunger = 33,
		sanity = 12.5,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_milk_beefalo", 1}, {"kyno_sugar", 1}, {"kyno_twiggynuts", 2}}},
	},
	
	tricolordango =
	{
		test = function(cooker, names, tags) return tags.milk and tags.sugar and tags.flour and names.twigs end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 30,
		hunger = 12.5,
		sanity = 5,
		cooktime = 1,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"goatmilk", 1}, {"kyno_flour", 1}, {"kyno_sugar", 1}, {"twigs", 1}}},
	},
	
	friesfrench =
	{
		test = function(cooker, names, tags) return ((names.potato or 0) + (names.potato_cooked or 0) >= 2) and tags.oil and names.kyno_salt end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 30,
		hunger = 32.5,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"potato", 2}, {"kyno_oil", 1}, {"kyno_salt", 1}}},
	},
	
	onionrings =
	{
		test = function(cooker, names, tags) return ((names.onion or 0) + (names.onion_cooked or 0) >= 2) and tags.oil and tags.flour 
		and not names.twigs and not tags.frozen and not tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 25,
		sanity = 20,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"onion", 2}, {"kyno_flour", 1}, {"kyno_oil", 1}}},
	},
	
	donuts =
	{
		test = function(cooker, names, tags) return (tags.flour and tags.flour >= 2) and names.kyno_sugar and tags.oil end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = -3,
		hunger = 50,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 2}, {"kyno_sugar", 1}, {"kyno_oil", 1}}},
	},
	
	donuts_chocolate_black =
	{
		test = function(cooker, names, tags) return tags.flour and names.kyno_sugar and tags.oil and names.chocolate_black end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = -5,
		hunger = 55,
		sanity = 40,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"chocolate_black", 1}, {"kyno_flour", 1}, {"kyno_sugar", 1}, {"kyno_oil", 1}}},
	},
	
	donuts_chocolate_white =
	{
		test = function(cooker, names, tags) return tags.flour and names.kyno_sugar and tags.oil and names.chocolate_white end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = -5,
		hunger = 75,
		sanity = 15,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"chocolate_white", 1}, {"kyno_flour", 1}, {"kyno_sugar", 1}, {"kyno_oil", 1}}},
	},
	
	gummybeargers =
	{
		test = function(cooker, names, tags) return names.bearger_fur and tags.gummybug and (tags.sweetener and tags.sweetener >= 2) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 5,
		hunger = 30,
		sanity = -5,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_BOSS,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"bearger_fur", 1}, {"kyno_gummybug", 1}, {"honey", 2}}},
	},
	
	pretzel =
	{
		test = function(cooker, names, tags) return tags.butter and names.kyno_salt and (tags.flour and tags.flour >= 2) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 60,
		sanity = 15,
		cooktime = 2.5,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"butter", 1}, {"kyno_salt", 1}, {"kyno_flour", 2}}},
	},
	
	cornincup =
	{
		test = function(cooker, names, tags) return names.kyno_salt and (tags.butter or tags.cheese) and (names.pepper or names.pepper_cooked) and
		(names.corn or names.corn_cooked) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 50,
		hunger = 50,
		sanity = 50,
		cooktime = 0.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"corn", 1}, {"pepper", 1}, {"kyno_salt", 1}, {"butter", 1}}},
	},
	
	cottoncandy =
	{
		test = function(cooker, names, tags) return (tags.sugar and tags.sugar >= 3) and names.twigs end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = -5,
		hunger = 12.5,
		sanity = 33,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_sugar", 3}, {"twigs", 1}}},
	},
	
	roastedhazelnuts =
	{
		test = function(cooker, names, tags) return (names.kyno_twiggynuts and names.kyno_twiggynuts >= 2) 
		and (names.acorn_cooked and names.acorn_cooked >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 10,
		hunger = 25,
		sanity = 10,
		cooktime = 1.2,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_twiggynuts", 2}, {"acorn_cooked", 2}}},
	},
	
	monstermuffin =
	{
		test = function(cooker, names, tags) return tags.flour and names.nightmarefuel and (tags.sweetener and tags.sweetener >= 2) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -10,
		hunger = 50, -- 67 Wurt.
		sanity = -15,
		cooktime = 2,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "monstermeat"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"nightmarefuel", 1}, {"honey", 2}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") or eater:HasTag("playermerm") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(10)
				eater.components.sanity:DoDelta(15)
			end
		end,
	},
	
	pinkcake =
	{
		test = function(cooker, names, tags) return (tags.sugar and tags.sugar >= 2) and tags.flour and tags.egg end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 5,
		hunger = 62.5,
		sanity = 20,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_sugar", 2}, {"bird_egg", 1}, {"kyno_flour", 1}}},
	},
	
	chipsbag =
	{
		test = function(cooker, names, tags) return ((names.potato or 0) + (names.potato_cooked or 0) >= 2) and tags.oil and tags.spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 62.5,
		sanity = 5,
		cooktime = 2,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"potato", 2}, {"kyno_oil", 1}, {"kyno_spotspice", 1}}},
	},
	
	littlebread =
	{
		test = function(cooker, names, tags) return (tags.flour and tags.flour == 3) and tags.spotspice end,
		priority = 1,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 0,
		hunger = 12.5,
		sanity = 5,
		cooktime = 1,
		stacksize = 3,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 3}, {"kyno_spotspice", 1}}},
	},
	
	hothound =
	{
		test = function(cooker, names, tags) return names.littlebread and tags.meat and (names.tomato or names.tomato_cooked) and 
		tags.spotspice and not tags.fish end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 32.5,
		sanity = 10,
		cooktime = 2,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"littlebread", 1}, {"meat", 1}, {"tomato", 1}, {"kyno_spotspice", 1}}},
	},
	
	milkshake =
	{
		test = function(cooker, names, tags) return tags.milk and tags.berries and (tags.sweetener and tags.sweetener >= 2) and not tags.syrup end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 30,
		hunger = 12.5,
		sanity = 30,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"goatmilk", 1}, {"berries", 1}, {"honey", 2}}},
	},
	
	banana_pudding =
	{
		test = function(cooker, names, tags) return (tags.banana and tags.banana >= 2) and tags.milk and tags.sweetener end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 20,
		hunger = 12.5,
		sanity = 50,
		cooktime = .8,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "monkeyqueenbribe"},
		card_def = {ingredients = {{"cave_banana", 2}, {"goatmilk", 1}, {"honey", 1}}},
	},
	
	sea_pudding =
	{
		test = function(cooker, names, tags) return (names.eel or names.eel_cooked or names.pondeel) and tags.mussel
		and names.kyno_grouper and tags.algae end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERFAST,
		health = 60,
		hunger = 150,
		sanity = 5,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_FISHING,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pondeel", 1}, {"kyno_mussel", 1}, {"kyno_grouper", 1}, {"kelp", 1}}},
		prefabs = { "kyno_fishingbuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_fishingbuff", "kyno_fishingbuff")
		end,
	},
	
	minertreat =
	{
		test = function(cooker, names, tags) return tags.fruit and (tags.sweetener and tags.sweetener >= 2) and names.twigs end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = -3,
		hunger = 12.5,
		sanity = 15,
		cooktime = 0.8,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"honey", 2}, {"pomegranate", 1}, {"twigs", 1}}},
	},
	
	radishsalad =
	{
		test = function(cooker, names, tags) return ((names.kyno_radish or 0) + (names.kyno_radish_cooked or 0) >= 3) and tags.spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 62.5,
		sanity = 5,
		cooktime = 1.2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_radish", 3}, {"kyno_spotspice", 1}}},
	},
	
	pumpkin_soup =
	{
		test = function(cooker, names, tags) return ((names.pumpkin or 0) + (names.pumpkin_cooked or 0) >= 2) and tags.butter and tags.spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 100,
		sanity = 33,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pumpkin", 2}, {"butter", 1}, {"kyno_spotspice", 1}}},
	},
	
	algae_soup =
	{
		test = function(cooker, names, tags) return (tags.algae and tags.algae >= 3) and not tags.meat and not tags.fish end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 75,
		sanity = 25,
		cooktime = 1.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kelp", 2}, {"kyno_waterycress", 1}, {"kyno_seaweeds", 1}}},
	},
	
	parznip_soup =
	{
		test = function(cooker, names, tags) return ((names.kyno_parznip or 0) + (names.kyno_parznip_cooked or 0) + (names.kyno_parznip_eaten or 0) >= 3) and
		names.succulent_picked end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 32.5,
		sanity = 5,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_EATER,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_parznip", 3}, {"succulent_picked", 1}}},
		oneatenfn = function(inst, eater)
		prefabs = { "kyno_eaterbuff" },
            eater:AddDebuff("kyno_eaterbuff", "kyno_eaterbuff")
        end,
	},
	
	livingsandwich =
	{
		test = function(cooker, names, tags) return (names.livinglog and names.livinglog >= 2) and 
		((names.monstermeat or 0) + (names.monstermeat_cooked or 0) >= 2) end,
		priority = 1,
		isfuel = true,
		foodtype = FOODTYPE.MEAT,
		secondaryfoodtype = FOODTYPE.MONSTER,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 10,
		hunger = 40,
		sanity = -5,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_CURSE,
		potlevel = "low",
		pickupsound = "wood",
		floater = TUNING.HOF_FLOATER,
		tags = {"wereitem"},
		card_def = {ingredients = {{"livinglog", 2}, {"monstermeat", 2}}},
		oneatenfn = function(inst, eater)
			local WEREMODE_NAMES =
			{
				"beaver",
				"moose",
				"goose",
			}
			
			if eater ~= nil and eater.components.wereeater ~= nil 
			and not (eater.components.health ~= nil and eater.components.health:IsDead()) and not eater:HasTag("playerghost") then
				eater.components.wereeater:ForceTransformToWere(math.random(#WEREMODE_NAMES))
			end
				
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
			else
				inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
			end
		end,
	},
	
	lunarsoup =
	{
		test = function(cooker, names, tags) return (names.carrot or names.carrot_cooked) and (names.moon_cap or names.moon_cap_cooked) 
		and ((names.rock_avocado_fruit_ripe or 0) + (names.rock_avocado_fruit_ripe_cooked or 0) >= 2) and not tags.meat end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 18.75,
		sanity = 0,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_FEARSLEEP,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"moon_cap", 1}, {"carrot", 1}, {"rock_avocado_fruit_ripe", 2}}},
		prefabs = { "buff_sleepresistance", "kyno_fearbuff" },
		oneatenfn = function(inst, eater)
            if eater.components.grogginess ~= nil and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.grogginess:ResetGrogginess()
            end

			eater:AddDebuff("shroomsleepresist", "buff_sleepresistance")
			eater:AddDebuff("kyno_fearbuff", "kyno_fearbuff")
        end,
	},
	
	purplewobstersoup =
	{
		test = function(cooker, names, tags) return tags.wobster and names.kyno_grouper and (names.kyno_turnip or names.kyno_turnip_cooked) end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = -60,
		hunger = 62.5,
		sanity = -5,
		cooktime = 2,
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat"},
		card_def = {ingredients = {{"wobster_sheller_land", 1}, {"kyno_grouper", 1}, {"kyno_turnip", 2}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(60)
				eater.components.sanity:DoDelta(5)
			end
		end,
	},
	
	wobstermonster =
	{
		test = function(cooker, names, tags) return tags.wobster and (names.monstermeat or names.monstermeat_cooked) and
		(tags.veggie and tags.veggie >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = -60,
		hunger = 37.5,
		sanity = -20,
		cooktime = 2,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat"},
		card_def = {ingredients = {{"wobster_sheller_land", 1}, {"monstermeat", 1}, {"carrot", 2}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(60)
				eater.components.sanity:DoDelta(20)
			end
		end,
	},
	
	duriansplit =
	{
		test = function(cooker, names, tags) return (names.durian or names.durian_cooked) and tags.banana and tags.frozen and tags.fruit end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = -5,
		hunger = 32.5, -- 65 Wurt.
		sanity = -15,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat"},
		card_def = {ingredients = {{"durian", 1}, {"ice", 1}, {"banana", 2}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") or eater:HasTag("playermerm") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(5)
				eater.components.sanity:DoDelta(15)
			end
		end,
	},
	
	duriansoup =
	{
		test = function(cooker, names, tags) return (names.durian or names.durian_cooked) and (tags.veggie and tags.veggie >= 3) and not tags.inedible end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = -15,
		hunger = 37.5, -- 75 Wurt.
		sanity = 0,
		cooktime = 1.5,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat"},
		card_def = {ingredients = {{"durian", 1}, {"carrot", 3}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") or eater:HasTag("playermerm") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(15)
			end
		end,
	},
	
	durianmeated =
	{
		test = function(cooker, names, tags) return ((names.monstermeat or 0) + (names.monstermeat_cooked or 0) >= 2) and 
		((names.durian or 0) + (names.durian_cooked or 0) >= 2) and not tags.meat end,
		priority = 40,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = -20,
		hunger = 37.5,
		sanity = -5,
		cooktime = 1.2,
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat"},
		card_def = {ingredients = {{"monstermeat", 2}, {"durian", 2}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(20)
				eater.components.sanity:DoDelta(5)
			end
		end,
	},
	
	durianchicken =
	{
		test = function(cooker, names, tags) return names.durian and (names.cactus_meat and names.cactus_meat >= 2) 
		and names.cactus_flower and not names.durian_cooked and not names.cactus_meat_cooked end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FASTISH,
		health = -10,
		hunger = 45, -- 90 Wurt.
		sanity = -30,
		cooktime = 1,
		scale = 1.8,
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat"},
		card_def = {ingredients = {{"durian", 1}, {"cactus_meat", 2}, {"cactus_flower", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") or eater:HasTag("playermerm") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(10)
				eater.components.sanity:DoDelta(30)
			end
		end,
	},
	
	spidercake =
	{
		test = function(cooker, names, tags) return names.spider and (names.monstermeat or names.monstermeat_cooked) and tags.egg and tags.flour end,
		priority = 1,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -20,
		hunger = 37.5,
		sanity = -20,
		cooktime = 2,
		-- oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SPIDER,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat"},
		card_def = {ingredients = {{"spider", 1}, {"monstermeat", 1}, {"bird_egg", 1}, {"kyno_flour", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(20)
				eater.components.sanity:DoDelta(20)
			end
			
			-- eater:AddDebuff("kyno_spiderbuff", "kyno_spiderbuff") -- Do we really want this?
		end,
	},
	
	sugarbombs =
	{
		test = function(cooker, names, tags) return (tags.sugar and tags.sugar >= 2) and ((names.kyno_wheat or 0) + (names.kyno_wheat_cooked or 0) >= 2) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = 9000000, -- Fallout reference?!
		health = 5,
		hunger = 20,
		sanity = 15,
		cooktime = 1.5,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SUGARBOMBS,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_sugar", 2}, {"kyno_wheat", 2}}},
	},
	
	berrybombs =
	{
		test = function(cooker, names, tags) return (tags.berries and tags.berries >= 2) and names.twigs end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 12,
		hunger = 18.25,
		sanity = 5,
		cooktime = 1,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"berries", 3}, {"twigs", 1}}},
	},
	
	onigiris =
	{
		test = function(cooker, names, tags) return ((names.kyno_rice or 0) + (names.kyno_rice_cooked or 0) >= 2) and tags.spotspice and tags.algae end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 8,
		hunger = 20,
		sanity = 8,
		cooktime = 1.1,
		stacksize = 2,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_rice", 2}, {"kyno_seaweeds", 1}, {"kyno_spotspice", 1}}},
	},
	
	omurice =
	{
		test = function(cooker, names, tags) return tags.egg and ((names.kyno_rice or 0) + (names.kyno_rice_cooked or 0) >= 2) 
		and (names.tomato or names.tomato_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 32.5,
		sanity = 10,
		cooktime = 1.5,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_rice", 2}, {"egg", 1}, {"tomato", 1}}},
	},
	
	paella =
	{
		test = function(cooker, names, tags) return (names.kyno_rice or names.kyno_rice_cooked) and (names.kyno_mussel or names.kyno_mussel_cooked)
		and tags.spotspice and tags.fish end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_BRIEF,
		health = 20,
		hunger = 50,
		sanity = 10,
		cooktime = 2.0,
		stacksize = 2,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_rice", 1}, {"kyno_mussel", 1}, {"pondfish", 1}, {"kyno_spotspice", 1}}},
	},
	
	pizza_tropical =
	{
		test = function(cooker, names, tags) return tags.fish and tags.flour and tags.dairy and 
		(names.kyno_pineapple_halved or names.kyno_pineapple_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 75,
		sanity = 15,
		cooktime = 2.5,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pondfish", 1}, {"kyno_flour", 1}, {"goatmilk", 1}, {"kyno_pineapple_halved", 1}}},
	},
	
	pinacolada = 
	{
		test = function(cooker, names, tags) return names.kyno_pineapple_halved and names.kyno_kokonut_halved and tags.sweetener and tags.frozen
		and not names.kyno_pineapple_cooked and not names.kyno_kokonut_cooked end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 25,
		hunger = 25,
		sanity = 10,
		cooktime = 0.5,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "drinkable_food"},
		card_def = {ingredients = {{"kyno_pineapple_halved", 1}, {"kyno_kokonut_halved", 1}, {"honey", 1}, {"ice", 1}}},
	},
	
	chimas =
	{
		test = function(cooker, names, tags) return ((names.tillweed or 0) + (names.tillweed or 0) >= 2) and tags.frozen end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 5,
		hunger = 12.5,
		sanity = 33,
		cooktime = 1.2,
		floater = TUNING.HOF_FLOATER,
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"tillweed", 2}, {"ice", 2}}},
	},
	
	gummyworms =
	{
		test = function(cooker, names, tags) return names.kyno_gummybug and names.kyno_sugar and names.ancientfruit_nightvision end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 10,
		hunger = 25,
		sanity = -5,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NIGHTVISION,
		nightvision = true,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"ancientfruit_nightvision", 1}, {"kyno_gummybug", 1}, {"kyno_sugar", 2}}},
		prefabs = { "kyno_nightvisionbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_nightvisionbuff", "kyno_nightvisionbuff")

			if eater.components.grogginess ~= nil then
				eater.components.grogginess:MakeGrogginessAtLeast(1.5)
			end
        end,
	},
	
	smores =
	{
		test = function(cooker, names, tags) return (names.kyno_sugar and names.kyno_sugar  >= 2) and tags.flour and tags.chocolate end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 65,
		sanity = 65,
		cooktime = 2,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 1}, {"kyno_sugar", 2}, {"chocolate_black", 1}}},
	},
	
	antslog =
	{
		test = function(cooker, names, tags) return names.livinglog and (names.kyno_twiggynuts and names.kyno_twiggynuts >= 2) and
		(names.fig or names.fig_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 15,
		hunger = 25,
		sanity = 15,
		cooktime = 1.1,
		potlevel = "low",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"livinglog", 1}, {"fig", 1}, {"kyno_twiggynuts", 2}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
			else
				inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
			end
		end,
	},
	
	moonbutterflymuffin =
	{
		test = function(cooker, names, tags) return names.moonbutterflywings and not tags.meat and (tags.veggie and tags.veggie >= 0.5) end,
		priority = 1,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 37.5,
		sanity = 20,
		cooktime = 2,
		nameoverride = "BUTTERFLYMUFFIN",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"moonbutterflywings", 1}, {"carrot", 1}, {"twigs", 2}}},
	},
	
	sugarflymuffin =
	{
		test = function(cooker, names, tags) return names.kyno_sugarflywings and not tags.meat and (tags.veggie and tags.veggie >= 0.5) end,
		priority = 1,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 18.75,
		sanity = 20,
		cooktime = 2,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_sugarflywings", 1}, {"carrot", 1}, {"twigs", 2}}},
	},
	
	eeltacos =
	{
		test = function(cooker, names, tags) return (names.eel or names.pondeel or names.eel_cooked) and 
		(names.corn or names.corn_cooked or names.oceanfish_small_5_inv or names.oceanfish_medium_5_inv) and names.cutlichen end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		health = 5,
		hunger = 37.5,
		sanity = 20,
		cooktime = .5,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"pondeel", 1}, {"corn", 1}, {"cutlichen", 2}}},
	},
	
	meatwaltz =
	{
		test = function(cooker, names, tags) return tags.meat and tags.bread and 
		(names.tomato or names.tomato_cooked) and (names.onion or names.onion_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 37.5,
		sanity = 5,
		cooktime = .7,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_INSPIRATION,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"gorge_bread", 1}, {"tomato", 1}, {"onion", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater.components.singinginspiration ~= nil then
				eater.components.singinginspiration:DoDelta(TUNING.KYNO_INSPIRATIONBUFF)
			end
		end,
	},
	
	completebreakfast = 
	{
		test = function(cooker, names, tags) return names.baconeggs and tags.flour and tags.butter and tags.syrup end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		secondaryfoodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 60,
		hunger = 150,
		sanity = 5,
		cooktime = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_MIGHTINESS,
		potlevel = "high",
		scale = 1.3,
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"baconeggs", 1}, {"kyno_flour", 1}, {"butter", 1}, {"kyno_syrup", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater.components.mightiness ~= nil then
				eater.components.mightiness:DoDelta(TUNING.KYNO_MIGHTINESSBUFF)
			end
		end,
	},
	
	dumplings = -- Wow... they're just perogies with hamlet skin.
	{
		test = function(cooker, names, tags) return tags.flour and (tags.veggie and tags.veggie >= 1)
		and (tags.meat and tags.meat < 1) and tags.oil end,
		priority = 25,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 25,
		sanity = 10,
		cooktime = 1.3,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_flour", 1}, {"smallmeat", 1}, {"carrot", 1}, {"kyno_oil", 1}}},
	},
	
	coxinha =
	{
		test = function(cooker, names, tags) return (names.drumstick or names.drumstick_cooked) and tags.flour and tags.oil
		and tags.spotspice end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 32.5,
		sanity = 0,
		cooktime = 1.5,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"drumstick", 1}, {"kyno_flour", 1}, {"kyno_oil", 1}, {"kyno_spotspice", 1}}},
	},
	
	crabkingfeast =
	{
		test = function(cooker, names, tags) return (names.kyno_crabkingmeat or names.kyno_crabkingmeat_cooked or names.kyno_crabkingmeat_dried)
		and tags.spotspice and names.corn and (names.onion or names.onion_cooked) and not names.corn_cooked end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 40,
		hunger = 62.5,
		sanity = 33,
		cooktime = 2,
		scale = 1.4,
		anim = "oversized",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_CRAB,
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_crabkingmeat", 1}, {"kyno_spotspice", 1}, {"corn", 1}, {"onion", 1}}},
		prefabs = { "kyno_crabbuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_crabbuff", "kyno_crabbuff")
		end,
	},
	
	pienapple =
	{
		test = function(cooker, names, tags) return (names.kyno_pineapple_halved or names.kyno_pineapple_cooked) and not tags.meat end,
		priority = 15,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 25,
		sanity = 5,
		cooktime = 2,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_pineapple_halved", 1}, {"twigs", 3}}},
	},
	
	avocadotoast =
	{
		test = function(cooker, names, tags) return ((names.rock_avocado_fruit_ripe or 0) + (names.rock_avocado_fruit_ripe_cooked or 0) >= 2)
		and tags.bread end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 5,
		hunger = 37.5,
		sanity = 5,
		cooktime = 1.3,
		scale = .9,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"rock_avocado_fruit_ripe", 2}, {"gorge_bread", 1}, {"twigs", 1}}},
	},
	
	ricepudding =
	{
		test = function(cooker, names, tags) return ((names.kyno_rice or 0) + (names.kyno_rice_cooked or 0) >= 2) 
		and tags.dairy and tags.spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FASTISH,
		health = 5,
		hunger = 15, 
		sanity = 33,
		cooktime = 0.8,
		scale = .9,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_rice", 2}, {"goatmilk", 1}, {"kyno_spotspice", 1}}},
	},
	
	sharksushi =
	{
		test = function(cooker, names, tags) return names.kyno_shark_fin and ((names.kyno_rice or 0) + (names.kyno_rice_cooked or 0) >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 40,
		sanity = -10,
		cooktime = 0.5,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NAUGHTINESS,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_shark_fin", 1}, {"kyno_rice", 3}}},
		oneatenfn = function(inst, eater)
			OnFoodNaughtiness(inst, eater)
		end,
	},
	
	wobsterbreaded =
	{
		test = function(cooker, names, tags) return tags.wobster and tags.spotspice and tags.flour and tags.oil end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 60,
		hunger = 50,
		sanity = 10,
		cooktime = 0.7,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"wobster_sheller_land", 1}, {"kyno_spotspice", 1}, {"kyno_flour", 1}, {"kyno_oil", 1}}},
	},
	
	lazypurrito =
	{
		test = function(cooker, names, tags) return tags.beanbug and (names.kyno_rice or names.kyno_rice_cooked) and tags.flour end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 62.5,
		sanity = -15,
		cooktime = 1.3,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_beanbugs", 1}, {"kyno_flour", 1}, {"kyno_rice", 2}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/death", "lazypurrit", 0.5)
			else
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/death", "lazypurrit", 0.5)
			end
		end,
	},
	
	horchata = 
	{
		test = function(cooker, names, tags) return (names.kyno_rice or names.kyno_rice_cooked) and tags.dairy and tags.sweetener
		and tags.frozen end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 40,
		hunger = 20,
		sanity = 5,
		cooktime = 1,
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "drinkable_food"},
		card_def = {ingredients = {{"kyno_rice", 1}, {"goatmilk", 1}, {"honey", 1}, {"ice", 1}}},
	},
	
	wobstercocktail =
	{
		test = function(cooker, names, tags) return tags.wobster and (names.tomato or names.tomato_cooked) and
		(names.pepper or names.pepper_cooked) and not tags.inedible end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 20,
		hunger = 32.5,
		sanity = 60,
		cooktime = 1.1,
		floater = TUNING.HOF_FLOATER,
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"wobster_sheller_land", 1}, {"tomato", 1}, {"pepper", 2}}},
	},
	
	pomegranatetea =
	{
		test = function(cooker, names, tags) return (names.pomegranate or names.pomegranate_cooked) and tags.frozen and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 25,
		hunger = 12.5,
		sanity = 10,
		cooktime = 0.5,
		scale = .8,
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed", "drinkable_food"},
		card_def = {ingredients = {{"pomegranate", 1}, {"ice", 1}, {"honey", 2}}},
	},
	
	pomegranatepie =
	{
		test = function(cooker, names, tags) return (names.pomegranate or names.pomegranate_cooked) and tags.sweetener and tags.flour end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 40,
		hunger = 32.5,
		sanity = 20,
		cooktime = 1.6,
		potlevel = "high",
		scale = 1,
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"pomegranate", 2}, {"kyno_flour", 1}, {"honey", 1}}},
	},
	
	pineapplecake =
	{
		test = function(cooker, names, tags) return (names.kyno_pineapple_halved or names.kyno_pineapple_cooked) and tags.egg
		and tags.flour and tags.sweetener end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 20,
		hunger = 25,
		sanity = 40,
		cooktime = 1.8,
		scale = 1,
		floater = TUNING.HOF_FLOATER,
		tags = {"honeyed"},
		card_def = {ingredients = {{"kyno_pineapple_halved", 1}, {"bird_egg", 1}, {"kyno_flour", 1}, {"honey", 1}}},
	},
	
	pasty_meat =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 1) and tags.flour 
		and tags.veggie and tags.oil and not tags.wobster end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = 5,
		cooktime = .7,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"kyno_flour", 1}, {"carrot", 1}, {"kyno_oil", 1}}},
	},
	
	pasty_cheese =
	{
		test = function(cooker, names, tags) return tags.cheese and tags.flour and tags.spotspice and tags.oil end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 37.5,
		sanity = 33,
		cooktime = .7,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"cheese_yellow", 1}, {"kyno_flour", 1}, {"kyno_spotspice", 1}, {"kyno_oil", 1}}},
	},
	
	brigadeiro =
	{
		test = function(cooker, names, tags) return names.chocolate_black and tags.sugar and names.kyno_twiggynuts end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FASTISH,
		health = 25,
		hunger = 32.5,
		sanity = 50,
		cooktime = 1,
		scale = .9,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"chocolate_black", 1}, {"kyno_sugar", 1}, {"kyno_twiggynuts", 2}}},
	},
	
	regularlasagna =
	{
		test = function(cooker, names, tags) return tags.meat and (names.tomato or names.tomato_cooked) and tags.flour
		and not tags.monster and not tags.spotspice and not tags.wobster end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FAST,
		health = 30,
		hunger = 37.5,
		sanity = 30,
		cooktime = .5,
		scale = .9,
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"meat", 1}, {"tomato", 2}, {"kyno_flour", 1}}},
	},
	
	fltsandwich =
	{
		test = function(cooker, names, tags) return (names.kyno_moon_froglegs or names.kyno_moon_froglegs_cooked) and 
		(names.tomato or names.tomato_cooked) and tags.algae and tags.foliage end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 32.5, 
		sanity = 33,
		cooktime = 1.3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_PLANARDEFENSE,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_moon_froglegs", 1}, {"tomato", 1}, {"foliage", 1}, {"kyno_waterycress", 1}}},
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_planardefensebuff", "kyno_planardefensebuff")
		end,
	},
	
	riceandbeans =
	{
		test = function(cooker, names, tags) return (names.kyno_rice or names.kyno_rice_cooked) and (tags.beanbug and tags.beanbug >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_PRESERVED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 5,
		hunger = 62.5,
		sanity = 20,
		cooktime = 1,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"kyno_rice", 1}, {"kyno_beanbugs", 2}, {"twigs", 1}}},
	},
	
	-- RIP STRAWBERRYGRINDER
	trufflesgrinder =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 1) and (names.kyno_truffles or names.kyno_truffles_cooked)
		and tags.flour end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 30,
		hunger = 62.5,
		sanity = 0,
		cooktime = 1.5,
		goldvalue = 5,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_TRUFFLES,
		potlevel = "high",
		floater = TUNING.HOF_FLOATER,
		tags = {"truffles"},
		card_def = {ingredients = {{"kyno_truffles", 2}, {"kyno_flour", 1}, {"meat", 1}}},
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_trufflesbuff", "kyno_trufflesbuff")
		end,
	},
	
	sporecappie =
	{
		test = function(cooker, names, tags) return ((names.kyno_sporecap or 0) + (names.kyno_sporecap_cooked or 0) >= 2) and
		tags.flour and tags.sweetener end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_PRESERVED,
		health = -20,
		hunger = 37.5,
		sanity = -10,
		cooktime = 2,
		potlevel = "high",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SPORECAP,
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat", "acidrainimmune"},
		card_def = {ingredients = {{"kyno_sporecap", 2}, {"kyno_flour", 1}, {"honey", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(20)
				eater.components.sanity:DoDelta(10)
			end
			
			eater:AddDebuff("kyno_poisonimmunitybuff", "kyno_poisonimmunitybuff")
		end,
	},
	
	sporecap_skewers =
	{
		test = function(cooker, names, tags) return ((names.kyno_sporecap_dark or 0) + (names.kyno_sporecap_dark_cooked or 0) >= 2) and
		tags.veggie and names.twigs end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = -30,
		hunger = 45,
		sanity = -20,
		cooktime = 1,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SPORECAP_DARK,
		floater = TUNING.HOF_FLOATER,
		tags = {"monstermeat", "acidrainimmune"},
		card_def = {ingredients = {{"kyno_sporecap_dark", 2}, {"carrot", 1}, {"twigs", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(30)
				eater.components.sanity:DoDelta(20)
			end
			
			eater:AddDebuff("kyno_acidimmunitybuff", "kyno_acidimmunitybuff")
		end,
	},
}

for k, recipe in pairs(kyno_foods) do
	recipe.name = k
	recipe.weight = 1
	recipe.overridebuild = k
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods