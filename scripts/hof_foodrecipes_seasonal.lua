local kyno_foods_seasonal =
{
	-- Winter's Feast Foods.
	festive_berrysauce =
	{
		test = function(cooker, names, tags) return (tags.berries and tags.berries >= 2) and tags.sweetener == 2 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 10,
		hunger = 25,
		sanity = 15,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"honeyed", "xmas"},
		card_def = {ingredients = {{"berries", 2}, {"honey", 2}}},
	},
	
	festive_bibingka =
	{
		test = function(cooker, names, tags) return (names.succulent_picked and names.succulent_picked >= 2) and tags.foliage and tags.veggie 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 20,
		sanity = 0,
		cooktime = 1.3,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"succulent_picked", 2}, {"foliage", 1}, {"carrot", 1}}},
	},
	
	festive_cabbagerolls =
	{
		test = function(cooker, names, tags) return (names.kyno_waterycress and names.kyno_waterycress >= 2) and names.kyno_syrup and not names.kyno_flour 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 32.5,
		sanity = 15,
		cooktime = 1.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"kyno_waterycress", 2}, {"kyno_syrup", 2}}},
	},
	
	festive_fishdish =
	{
		test = function(cooker, names, tags) return tags.fish and names.succulent_picked and not tags.sweetener and not names.wobster_sheller_land 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 30,
		hunger = 62.5,
		sanity = 1,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"pondfish", 2}, {"succulent_picked", 2}}},
	},
	
	festive_goodgravy =
	{
		test = function(cooker, names, tags) return names.kyno_syrup and names.kyno_flour and tags.meat 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 5,
		hunger = 32.5,
		sanity = 15,
		cooktime = 1.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"honeyed", "xmas"},
		card_def = {ingredients = {{"kyno_syrup", 1}, {"kyno_flour", 1}, {"meat", 1}}},
	},
	
	festive_latkes =
	{
		test = function(cooker, names, tags) return ((names.potato or 0) + (names.potato_cooked or 0) >= 2) and tags.dairy 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_FAST,
		health = 5,
		hunger = 50,
		sanity = 20,
		cooktime = .8,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"potato", 3}, {"goatmilk", 1}}},
	},
	
	festive_lutefisk =
	{
		test = function(cooker, names, tags) return (tags.fish and tags.fish >= 2) and (names.pepper or names.pepper_cooked) and tags.foliage 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 5,
		hunger = 75,
		sanity = 5,
		cooktime = 1.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"pondfish", 2}, {"pepper", 1}, {"foliage", 1}}},
	},
	
	festive_mulledpunch = 
	{
		test = function(cooker, names, tags) return names.kyno_syrup and tags.sweetener and tags.frozen and not names.forgetmelots 
		and not tags.meat and not tags.berries and not tags.fruit and not names.cutlichen and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 12.5,
		sanity = 33,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"honeyed", "xmas"},
		card_def = {ingredients = {{"kyno_syrup", 1}, {"honey", 2}, {"ice", 1}}},
	},
	
	festive_panettone = 
	{
		test = function(cooker, names, tags) return (names.kyno_flour and names.kyno_flour >= 2) and (tags.fruit and tags.fruit >= 2) 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 20,
		hunger = 32.5,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"kyno_flour", 2}, {"pomegranate", 2}}},
	},
	
	festive_pavlova =
	{
		test = function(cooker, names, tags) return names.kyno_flour and (tags.fruit and tags.fruit >= 2) and tags.sweetener 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 25,
		sanity = 5,
		cooktime = 1.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"honeyed", "xmas"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"honey", 1}, {"cave_banana", 2}}},
	},
	
	festive_pickledherring =
	{
		test = function(cooker, names, tags) return tags.fish and (names.kyno_spotspice and names.kyno_spotspice >= 2) and not names.kyno_flour 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 40,
		hunger = 37.5,
		sanity = 0,
		cooktime = 1.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"pondfish", 2}, {"kyno_spotspice", 2}}},
	},
	
	festive_polishcookies = 
	{ 
		test = function(cooker, names, tags) return names.kyno_flour and tags.dairy and (tags.sweetener and tags.sweetener >= 2) 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 12.5,
		sanity = 5,
		cooktime = .8,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"honeyed", "xmas"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"goatmilk", 1}, {"honey", 2}}},
	},
	
	festive_pumpkinpie =
	{
		test = function(cooker, names, tags) return (names.pumpkin or names.pumpkin_cooked) and names.kyno_flour and tags.sweetener 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 1.8,
		potlevel = "med",
		floater = {"med", nil, 0,65},
		tags = {"honeyed", "xmas"},
		card_def = {ingredients = {{"pumpkin", 1}, {"kyno_flour", 1}, {"honey", 1}}},
	},
	
	festive_roastedturkey =
	{
		test = function(cooker, names, tags) return (names.drumstick or names.drumstick_cooked) 
		and (names.kyno_spotspice and names.kyno_spotspice >= 2) and names.succulent_picked and not tags.fruit and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 80,
		sanity = 20,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"drumstick", 1}, {"succulent_picked", 1}, {"kyno_spotspice", 2}}},
	},
	
	festive_stuffing =
	{
		test = function(cooker, names, tags) return names.kyno_flour and (tags.veggie and tags.veggie >= 2) and tags.fruit 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 32.5,
		sanity = 20,
		cooktime = 1.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"carrot", 2}, {"berries", 1}}},
	},
	
	festive_sweetpotato =
	{
		test = function(cooker, names, tags) return names.kyno_flour and ((names.kyno_sweetpotato or 0) + (names.kyno_sweetpotato_cooked or 0) >= 2)
		and not tags.meat and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 37.5,
		sanity = 20,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"kyno_flour", 2}, {"kyno_sweetpotato", 2}}},
	},
	
	festive_tamales =
	{
		test = function(cooker, names, tags) return names.kyno_flour and ((names.corn or 0) + (names.corn_cooked or 0) >= 2) and tags.dairy 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 5,
		hunger = 20,
		sanity = 50,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"goatmilk", 1}, {"corn", 2}}},
	},
	
	festive_tourtiere =
	{
		test = function(cooker, names, tags) return tags.meat and names.kyno_flour and (names.kyno_bacon or names.kyno_bacon_cooked) 
		and (names.potato or names.potato_cooked) and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST)) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 25,
		hunger = 50,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"meat", 1}, {"kyno_flour", 1}, {"kyno_bacon", 1}, {"potato", 1}}},
	},
}

for k, recipe in pairs(kyno_foods_seasonal) do
	recipe.name = k
	recipe.weight = 1
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods_seasonal