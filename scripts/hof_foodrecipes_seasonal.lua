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
		scale = 1,
		nameoverride = "BERRYSAUCE",
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
		scale = 1,
		nameoverride = "BIBINGKA",
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
		scale = 1,
		nameoverride = "CABBAGEROLLS",
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
		scale = 1,
		nameoverride = "FESTIVEFISH",
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
		scale = 1,
		nameoverride = "GRAVY",
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
		scale = 1,
		nameoverride = "LATKES",
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
		scale = 1,
		nameoverride = "LUTEFISK",
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
		scale = 1,
		nameoverride = "MULLEDDRINK",
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
		scale = 1,
		nameoverride = "PANETTONE",
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
		scale = 1,
		nameoverride = "PAVLOVA",
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
		scale = 1,
		nameoverride = "PICKLEDHERRING",
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
		scale = 1,
		nameoverride = "POLISHCOOKIE",
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
		scale = 1,
		nameoverride = "PUMPKINPIE",
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
		scale = 1,
		nameoverride = "ROASTTURKEY",
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
		scale = 1,
		nameoverride = "STUFFING",
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
		scale = 1,
		nameoverride = "SWEETPOTATO",
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
		scale = 1,
		nameoverride = "TAMALES",
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
		scale = 1,
		nameoverride = "TOURTIERE",
		floater = {"med", nil, 0.65},
		tags = {"xmas"},
		card_def = {ingredients = {{"meat", 1}, {"kyno_flour", 1}, {"kyno_bacon", 1}, {"potato", 1}}},
	},
	
	-- Hallowed Nights Foods.
	spooky_brain_noodles =
	{
		test = function(cooker, names, tags) return names.kyno_flour and names.kyno_spotspice and tags.beanbug and tags.meat 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 10,
		hunger = 32.5,
		sanity = 30,
		cooktime = 1.2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"halloween"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"kyno_spotspice", 1}, {"kyno_beanbugs", 1}, {"meat", 1}}},
	},
	
	spooky_burgerzilla =
	{
		test = function(cooker, names, tags) return tags.bread and (names.monstermeat or names.monstermeat_cooked) and
		(names.onion or names.onion_cooked) and (names.kyno_cucumber or names.kyno_cucumber_cooked) and not tags.foliage and not tags.bacon 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = -20,
		hunger = 80,
		sanity = -20,
		cooktime = 1.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"halloween", "monstermeat"},
		card_def = {ingredients = {{"gorge_bread", 1}, {"monstermeat", 1}, {"onion", 1}, {"kyno_cucumber", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(20)
				eater.components.sanity:DoDelta(20)
			end
		end,
	},
	
	spooky_deadbread =
	{
		test = function(cooker, names, tags) return names.boneshard and names.kyno_sugar and names.kyno_flour and names.butter 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 40,
		hunger = 65,
		sanity = -30,
		cooktime = 2,
		potlevel = "low",
		floater = {"med", nil, 0.65},
		tags = {"halloween"},
		card_def = {ingredients = {{"boneshard", 1}, {"kyno_sugar", 1}, {"kyno_flour", 1}, {"butter", 1}}},
	},
	
	spooky_jellybeans =
	{
		test = function(cooker, names, tags) return names.royal_jelly and tags.sugar and 
		(names.nightmarefuel and names.nightmarefuel >= 2) and not tags.monster 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 15,
		hunger = 15,
		sanity = 0,
		cooktime = 2.5,
		stacksize = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DESANITY,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"halloween", "honeyed"},
		card_def = {ingredients = {{"royal_jelly", 1}, {"kyno_sugar", 1}, {"nightmarefuel", 2}}},
		prefabs = { "kyno_insanitybuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_insanitybuff", "kyno_insanitybuff")
        end,
	},
	
	spooky_popsicle =
	{
		test = function(cooker, names, tags) return names.livinglog and tags.dairy and tags.frozen and tags.sugar 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 40,
		hunger = 12.5,
		sanity = -20,
		cooktime = .10,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"halloween"},
		card_def = {ingredients = {{"livinglog", 1}, {"goatmilk", 1}, {"ice", 1}, {"kyno_sugar", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
			else
				inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
			end
		end,
	},
	
	spooky_pumpkincream =
	{
		test = function(cooker, names, tags) return names.pumpkin and names.kyno_pineapple_halved and (names.pomegranate or names.pomegranate_cooked)
		and tags.dairy and not names.pumpkin_cooked and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 62.5,
		sanity = 25,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"halloween"},
		card_def = {ingredients = {{"pumpkin", 1}, {"kyno_pineapple_halved", 1}, {"pomegranate", 1}, {"goatmilk", 1}}},
	},
	
	spooky_skullcandy =
	{
		test = function(cooker, names, tags) return names.boneshard and (names.kyno_sugar and names.kyno_sugar >= 2) and names.nightmarefuel 
		and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 5,
		hunger = 15,
		sanity = -15,
		cooktime = 1.5,
		stacksize = 2,
		potlevel = "low",
		fireproof = true,
		floater = {"med", nil, 0.65},
		tags = {"halloween"},
		card_def = {ingredients = {{"boneshard", 1}, {"kyno_sugar", 2}, {"nightmarefuel", 1}}},
	},
	
	spooky_tacodile =
	{
		test = function(cooker, names, tags) return names.kyno_flour and (names.pepper or names.pepper_cooked) and
		(names.onion or names.onion_cooked) and names.kyno_spotspice and (CONFIGS_HOF.SEASONALFOOD or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS)) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 15,
		hunger = 50,
		sanity = 10,
		cooktime = 1.7,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"halloween"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"pepper", 1}, {"onion", 1}, {"kyno_spotspice", 1}}},
	},
}

for k, recipe in pairs(kyno_foods_seasonal) do
	recipe.name = k
	recipe.weight = 1
	recipe.overridebuild = k
	recipe.cookbook_atlas = "images/cookbookimages/hof_seasonalfoodsimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods_seasonal