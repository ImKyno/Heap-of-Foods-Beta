local kyno_warly_foods =
{
	musselbouillabaise =
	{
		test = function(cooker, names, tags) return (tags.mussel and tags.mussel >= 3) and tags.veggie and not tags.inedible 
		and not tags.sweetener and not names.kyno_mussel_cooked end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_MED,
		health = 60,
		hunger = 37.5,
		sanity = 15,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
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
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_sweetpotato", 2}, {"bird_egg", 2}}},
	},
	
	gorge_meat_stew =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 3) and tags.spotspice and not (tags.monster and tags.monster > 1) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 200,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"meat", 3}, {"kyno_spotspice", 1}}},
	},
	
	gorge_cheeseburger =
	{
		test = function(cooker, names, tags) return tags.bread and tags.meat and tags.foliage and (tags.cheese or tags.dairy)
		and not tags.bacon end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_FASTISH,
		health = 50,
		hunger = 100,
		sanity = 30,
		cooktime = 1.2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"gorge_bread", 1}, {"meat", 1}, {"foliage", 1}, {"goatmilk", 1}}},
	},
	
	gorge_pizza =
	{
		test = function(cooker, names, tags) return tags.meat and tags.flour and tags.dairy and (names.tomato or names.tomato_cooked) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 40,
		hunger = 150,
		sanity = 20,
		cooktime = 2.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"meat", 1}, {"kyno_flour", 1}, {"goatmilk", 1}, {"tomato", 1}}},
	},
	
	gorge_meat_wellington =
	{
		test = function(cooker, names, tags) return (tags.meat and tags.meat >= 2) and tags.bread and tags.veggie and not (tags.monster and tags.monster > 1) end,
		priority = 35,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_PRESERVED,
		health = 20,
		hunger = 150,
		sanity = 10,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"meat", 2}, {"gorge_bread", 1}, {"carrot", 1}}},
	},
	
	gorge_trifle =
	{
		test = function(cooker, names, tags) return tags.fruit and tags.flour and (tags.dairy and tags.dairy >= 2) end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 15,
		hunger = 37.5,
		sanity = 60,
		cooktime = 1,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"berries", 1}, {"kyno_flour", 1}, {"goatmilk", 2}}},
	},
	
	bubbletea = 
	{
		test = function(cooker, names, tags) return names.kyno_piko and names.kyno_tealeaf and tags.sweetener and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		health = 20,
		hunger = 12.5,
		sanity = 33,
		cooktime = 0.5,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed", "fooddrink"},
		card_def = {ingredients = {{"kyno_piko", 1}, {"kyno_tealeaf", 1}, {"honey", 1}, {"ice", 1}}},
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
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"onion", 2}, {"kyno_waterycress", 1}, {"foliage", 1}}},
	},
	
	jellybean_sanity =
	{
		test = function(cooker, names, tags) return names.royal_jelly and ((names.green_cap or 0) + (names.green_cap_cooked or 0) >= 3) 
		and not tags.inedible and not tags.monster and not tags.sugar end,
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
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"royal_jelly", 1}, {"green_cap", 3}}},
        prefabs = { "kyno_sanityregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_sanityregenbuff", "kyno_sanityregenbuff")
        end,
	},
	
	jellybean_hunger =
	{
		test = function(cooker, names, tags) return names.royal_jelly and tags.butter and tags.sweetener and not tags.inedible 
		and not tags.monster and not tags.sugar end,
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
		floater = TUNING.HOF_FLOATER,
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
		and (names.pomegranate or names.pomegranate_cooked) and not tags.inedible and not tags.monster and not tags.sugar end,
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
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"royal_jelly", 2}, {"dragonfruit", 1}, {"pomegranate", 1}}},
        prefabs = { "kyno_superregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_superregenbuff", "kyno_superregenbuff")
        end,
	},
	
	berrysundae =
	{
		test = function(cooker, names, tags) return tags.berries and tags.dairy and tags.frozen and tags.syrup
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
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"berries", 1}, {"goatmilk", 1}, {"kyno_syrup", 1}, {"ice", 1}}},
		prefabs = { "kyno_heatbuff" },
		oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_heatbuff", "kyno_heatbuff")
		end,
	},
	
	cinnamonroll =
	{
		test = function(cooker, names, tags) return tags.flour and tags.syrup and tags.spotspice and tags.butter end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		health = 80,
		hunger = 50,
		sanity = 20,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed"},
		card_def = {ingredients = {{"kyno_flour", 1}, {"kyno_syrup", 1}, {"kyno_spotspice", 1}, {"butter", 1}}},
	},
	
	milkshake_prismatic =
	{
		test = function(cooker, names, tags) return names.kyno_jellyfish_rainbow_dead and tags.milk and tags.berries and tags.syrup end,
		priority = 10,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_FAST,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 60,
		hunger = 12.5,
		sanity = 60,
		cooktime = .10,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_GLOW,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed"},
		prefabs = { "kyno_jellyfish_rainbow_light_greater" },
		card_def = {ingredients = {{"kyno_jellyfish_rainbow_dead", 1}, {"goatmilk", 1}, {"berries", 1}, {"kyno_syrup", 1}}},
		oneatenfn = function(inst, eater)
            if eater.wormlight ~= nil then
                if eater.wormlight.prefab == "kyno_jellyfish_rainbow_light_greater" then
                    eater.wormlight.components.spell.lifetime = 0
                    eater.wormlight.components.spell:ResumeSpell()
                    return
                else
                    eater.wormlight.components.spell:OnFinish()
                end
            end

            local light = SpawnPrefab("kyno_jellyfish_rainbow_light_greater")
            light.components.spell:SetTarget(eater)
			
            if light:IsValid() then
                if light.components.spell.target == nil then
                    light:Remove()
                else
                    light.components.spell:StartSpell()
                end
            end
        end,
	},
	
	nachos =
	{
		test = function(cooker, names, tags) return tags.oil and tags.spotspice and tags.cheese and names.corn and not names.corn_cooked end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 32.5,
		sanity = 10,
		cooktime = 2,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_oil", 1}, {"kyno_spotspice", 1}, {"cheese_yellow", 1}, {"corn", 1}}},
	},
	
	tom_kha_soup =
	{
		test = function(cooker, names, tags) return names.kyno_kokonut_halved and tags.mushrooms and tags.succulent and
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
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_kokonut_halved", 1}, {"green_cap", 1}, {"succulent_picked", 1}, {"pepper", 1}}},
		prefabs = { "kyno_coldbuff" },
		oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_coldbuff", "kyno_coldbuff")
		end,
	},
	
	risotto =
	{
		test = function(cooker, names, tags) return ((names.kyno_rice or 0) + (names.kyno_rice_cooked or 0) >= 2) and 
		(names.kyno_white_cap or names.kyno_white_cap_cooked) and tags.dairy end,
		priority = 35,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 33,
		hunger = 75,
		sanity = 25,
		cooktime = 1.7,
		potlevel = "med",
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"kyno_rice", 2}, {"kyno_white_cap", 1}, {"goatmilk", 1}}},
	},
	
	meatskillet =
	{
		test = function(cooker, names, tags) return tags.meat and (names.pepper or names.pepper_cooked) and 
		(names.garlic or names.garlic_cooked) and tags.spotspice end,
		priority = 30,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = -5,
		hunger = 62.5,
		sanity = 15,
		cooktime = 2,
		potlevel = "high",
		nochill = true,
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"meat", 1}, {"pepper", 1}, {"garlic", 1}, {"kyno_spotspice", 1}}},
	},
	
	warlyicedtea = 
	{
		test = function(cooker, names, tags) return names.kyno_piko_orange and names.kyno_tealeaf and tags.sweetener and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 20,
		hunger = 12.5,
		sanity = 5,
		cooktime = 0.5,
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed", "fooddrink"},
		card_def = {ingredients = {{"kyno_piko_orange", 1}, {"kyno_tealeaf", 1}, {"honey", 1}, {"ice", 1}}},
	},
	
	warlytea =
	{
		test = function(cooker, names, tags) return names.kyno_piko_orange and names.kyno_tealeaf and tags.sweetener and not tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		perishproduct = "warlyicedtea",
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 40,
		hunger = 25,
		sanity = 10,
		cooktime = 0.5,
		potlevel = "low",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SANITYRATE,
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed", "fooddrink"},
		card_def = {ingredients = {{"kyno_piko_orange", 1}, {"kyno_tealeaf", 1}, {"honey", 2}}},
		prefabs = { "kyno_sanityratebuff" },
		oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_sanityratebuff", "kyno_sanityratebuff")
		end,
	},
	
	lazydessert =
	{
		test = function(cooker, names, tags) return names.townportaltalisman and names.rocks and tags.sweetener end,
		priority = 1,
		foodtype = FOODTYPE.ELEMENTAL,
		perishtime = nil,
		rocktribute = 18,
		health = -30,
		hunger = 12.5,
		sanity = 0,
		cooktime = 2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_ANTLION,
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "honeyed", "nospice"},
		card_def = {ingredients = {{"townportaltalisman", 1}, {"rocks", 2}, {"honey", 1}}},
	},
	
	lavaeeggboiled =
	{
		test = function(cooker, names, tags) return names.lavae_egg and names.firenettles and (names.pepper or names.pepper_cooked) and not tags.frozen end,
		priority = 100,
		foodtype = FOODTYPE.MEAT,
		perishtime = TUNING.PERISH_SLOW,
		fireproof = true,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 60,
		hunger = 100,
		sanity = 15,
		cooktime = 2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_FIREIMMUNITY,
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood"},
		card_def = {ingredients = {{"lavae_egg", 1}, {"firenettles", 1}, {"pepper", 2}}},
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_fireimmunitybuff", "kyno_fireimmunitybuff")
		end,
	},
	
	tiramisu = -- Dry + Small Speed buffs.
	{
		test = function(cooker, names, tags) return names.kyno_coffeebeans_cooked and tags.chocolate and tags.dairy and not names.kyno_coffeebeans end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 32.5,
		sanity = 15,
		cooktime = 1.5,
		scale = .9,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SPEED, 
		floater = TUNING.HOF_FLOATER,
		tags = {"masterfood", "nospice"},
		card_def = {ingredients = {{"kyno_coffeebeans_cooked", 1}, {"chocolate_black", 1}, {"goatmilk", 1}}},
		prefabs = { "buff_moistureimmunity" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("buff_moistureimmunity", "buff_moistureimmunity")
		end,
	},
}

for k, recipe in pairs(kyno_warly_foods) do
	recipe.name = k
	recipe.weight = 1
	-- recipe.cookbook_category = "portablecookpot" -- check "hof_cooking.lua" for details.
	recipe.overridebuild = k
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages_warly.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_warly_foods