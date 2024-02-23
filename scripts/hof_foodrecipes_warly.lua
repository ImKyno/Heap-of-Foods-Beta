local kyno_warly_foods =
{
	musselbouillabaise =
	{
		test = function(cooker, names, tags) return (names.kyno_mussel and names.kyno_mussel >= 3) and tags.veggie and not tags.inedible 
		and not tags.sweetener and not names.kyno_mussel_cooked end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 37.5,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_mussel", 3}, {"carrot", 1}}},
	},
	
	sweetpotatosouffle =
	{
		test = function(cooker, names, tags) return (names.kyno_sweetpotato and names.kyno_sweetpotato >= 2) and tags.egg and tags.egg >= 2
		and not names.kyno_sweetpotato_cooked and not (names.potato or names.potato_cooked) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		secondaryfoodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 20,
		hunger = 50,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_sweetpotato", 2}, {"bird_egg", 2}}},
	},
	
	gorge_meat_stew =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 3) and names.kyno_spotspice and not (tags.monster and tags.monster > 1) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 200,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"meat", 3}, {"kyno_spotspice", 1}}},
	},
	
	gorge_cheeseburger =
	{
		test = function(cooker, names, tags) return tags.bread and tags.meat and tags.foliage and (tags.cheese or tags.dairy)
		and not names.kyno_bacon and not names.kyno_bacon_cooked end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 50,
		hunger = 100,
		sanity = 30,
		cooktime = 1.2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"gorge_bread", 1}, {"meat", 1}, {"foliage", 1}, {"goatmilk", 1}}},
	},
	
	gorge_pizza =
	{
		test = function(cooker, names, tags) return tags.meat and names.kyno_flour and tags.dairy and (names.tomato or names.tomato_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 40,
		hunger = 150,
		sanity = 20,
		cooktime = 2.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"meat", 1}, {"kyno_flour", 1}, {"goatmilk", 1}, {"tomato", 1}}},
	},
	
	gorge_meat_wellington =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 2) and tags.bread and tags.veggie and not (tags.monster and tags.monster > 1) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 20,
		hunger = 150,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"meat", 2}, {"gorge_bread", 1}, {"carrot", 1}}},
	},
	
	gorge_trifle =
	{
		test = function(cooker, names, tags) return tags.fruit and names.kyno_flour and (tags.dairy and tags.dairy >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 37.5,
		sanity = 60,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"berries", 1}, {"kyno_flour", 1}, {"goatmilk", 2}}},
	},
	
	bubbletea = 
	{
		test = function(cooker, names, tags) return names.kyno_piko and (tags.sweetener and tags.sweetener >= 2) and 
		tags.frozen and not tags.meat and not tags.egg and not tags.fish end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		health = 20,
		hunger = 12.5,
		sanity = 33,
		cooktime = 0.5,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood", "honeyed", "drinkable_food"},
		card_def = {ingredients = {{"kyno_piko", 1}, {"honey", 2}, {"ice", 1}}},
		prefabs = { "buff_sleepresistance" },
        oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SLEEP_RESISTANCE,
        oneatenfn = function(inst, eater)
            if eater.components.grogginess ~= nil and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.grogginess:ResetGrogginess()
            end

			eater:AddDebuff("shroomsleepresist", "buff_sleepresistance")
        end,
	},
	
	frenchonionsoup = 
	{
		test = function(cooker, names, tags) return ((names.onion or 0) + (names.onion_cooked or 0) >= 2) and (tags.veggie and tags.veggie >= 3) and tags.foliage end,
		priority = 5,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 37.5,
		sanity = 5,
		cooktime = 1,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"onion", 2}, {"kyno_waterycress", 1}, {"foliage", 1}}},
	},
	
	jellybean_sanity =
	{
		test = function(cooker, names, tags) return names.royal_jelly and ((names.green_cap or 0) + (names.green_cap_cooked or 0) >= 3) 
		and not tags.inedible and not tags.monster end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 2,
		hunger = 0, 
		sanity = 5,
		cooktime = 2.5,
		stacksize = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_RESANITY,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"royal_jelly", 1}, {"green_cap", 3}}},
        prefabs = { "kyno_sanityregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_sanityregenbuff", "kyno_sanityregenbuff")
        end,
	},
	
	jellybean_hunger =
	{
		test = function(cooker, names, tags) return names.royal_jelly and names.butter and tags.sweetener and not tags.inedible and not tags.monster end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 2,
		hunger = 5, 
		sanity = 0,
		cooktime = 2.5,
		stacksize = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"royal_jelly", 1}, {"butter", 1}, {"honey", 2}}},
        prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
        end,
	},
	
	jellybean_super =
	{
		test = function(cooker, names, tags) return (names.royal_jelly and names.royal_jelly  >= 2) and (names.dragonfruit or names.dragonfruit_cooked)
		and (names.pomegranate or names.pomegranate_cooked) and not tags.inedible and not tags.monster end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = nil,
		health = 2,
		hunger = 2, 
		sanity = 2,
		cooktime = 2.5,
		stacksize = 3,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REALL,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"royal_jelly", 2}, {"dragonfruit", 1}, {"pomegranate", 1}}},
        prefabs = { "kyno_superregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_superregenbuff", "kyno_superregenbuff")
        end,
	},
	
	berrysundae =
	{
		test = function(cooker, names, tags) return tags.berries and tags.dairy and tags.frozen and names.kyno_syrup
		and not tags.meat and not tags.veggie and not tags.inedible and not tags.egg end,
		priority = 10,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 20,
		hunger = 8,
		sanity = 60,
		cooktime = .10,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"berries", 1}, {"goatmilk", 1}, {"kyno_syrup", 1}, {"ice", 1}}},
	},
	
	cinnamonroll =
	{
		test = function(cooker, names, tags) return names.kyno_flour and names.kyno_syrup and names.kyno_spotspice and names.butter end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		health = 80,
		hunger = 50,
		sanity = 20,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"kyno_syrup", 1}, {"kyno_spotspice", 1}, {"butter", 1}}},
	},
	
	milkshake_prismatic =
	{
		test = function(cooker, names, tags) return tags.milk and tags.berries and (names.kyno_syrup and names.kyno_syrup >= 2) end,
		priority = 10,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 60,
		hunger = 12.5,
		sanity = 60,
		cooktime = .10,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"goatmilk", 1}, {"berries", 1}, {"kyno_syrup", 2}}},
	},
	
	nachos =
	{
		test = function(cooker, names, tags) return names.kyno_oil and names.kyno_spotspice and tags.cheese and names.corn and not names.corn_cooked end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 32.5,
		sanity = 10,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_oil", 1}, {"kyno_spotspice", 1}, {"cheese_yellow", 1}, {"corn", 1}}},
	},
	
	tom_kha_soup =
	{
		test = function(cooker, names, tags) return names.kyno_kokonut_halved and tags.mushrooms and names.succulent_picked and
		(names.pepper or names.pepper_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 5,
		hunger = 40,
		sanity = 33,
		cooktime = 2,
		potlevel = "med",
		floater = {"med", nil, 0.65},
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_kokonut_halved", 1}, {"green_cap", 1}, {"succulent_picked", 1}, {"pepper", 1}}},
	},
}

for k, recipe in pairs(kyno_warly_foods) do
	recipe.name = k
	recipe.weight = 1
	-- recipe.cookbook_category = "portablecookpot"
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_warly_foods