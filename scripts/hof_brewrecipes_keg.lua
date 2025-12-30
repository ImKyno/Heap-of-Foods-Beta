-- Informations about these foods:
-- Cooktimes: 24 = 1 Day. | 48 = 2 Days. | 72 = 3 Days. | 120 = 5 Days. | 168 = 7 Days. | 240 = 10 Days. | 360 = 15 Days. | 480 = 20 Days.
-- These recipes don't appear in the Cookbook since they're "special" and not from the Crcok Pot.
-- They took several days to produce, just like the real life / Stardew Valley mechanics.

local kyno_foods_keg =
{
	-- Keg Recipes.
	wine_berries =
	{
		test = function(brewer, names, tags) return names.berries and (names.berries == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"berries", 2}, {"ice", 1}}},
	},

	wine_berries_juicy =
	{
		test = function(brewer, names, tags) return names.berries_juicy and (names.berries_juicy == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"berries_juicy", 2}, {"ice", 1}}},
	},

	wine_pomegranate =
	{
		test = function(brewer, names, tags) return names.pomegranate and (names.pomegranate == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"pomegranate", 2}, {"ice", 1}}},
	},

	wine_dragonfruit =
	{
		test = function(brewer, names, tags) return names.dragonfruit and (names.dragonfruit == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 20,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"dragonfruit", 2}, {"ice", 1}}},
	},

	wine_cave_banana =
	{
		test = function(brewer, names, tags) return names.cave_banana and (names.cave_banana == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink", "monkeyqueenbribe"},
		card_def = {ingredients = {{"cave_banana", 2}, {"ice", 1}}},
	},

	wine_durian =
	{
		test = function(brewer, names, tags) return names.durian and (names.durian == 2) and tags.frozen and not names.kyno_sugar  end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = -5,
		hunger = 35, -- 70 Wurt.
		sanity = -40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink", "monstermeat"},
		card_def = {ingredients = {{"durian", 2}, {"ice", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") or eater:HasTag("playermerm") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(5)
				eater.components.sanity:DoDelta(40)
			end
		end,
	},

	wine_watermelon =
	{
		test = function(brewer, names, tags) return names.watermelon and (names.watermelon == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"watermelon", 2}, {"ice", 1}}},
	},

	wine_fig =
	{
		test = function(brewer, names, tags) return names.fig and (names.fig == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"fig", 2}, {"ice", 1}}},
	},

	wine_glowberry =
	{
		test = function(brewer, names, tags) return (names.wormlight or (names.wormlight_lesser and names.wormlight_lesser == 2)) and tags.frozen
		and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 40,
		sanity = -10,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_GLOW,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"berries", 2}, {"ice", 1}}},
		prefabs = { "wormlight_light_greater" },
        oneatenfn = function(inst, eater)
            if eater.wormlight ~= nil then
                if eater.wormlight.prefab == "wormlight_light_greater" then
                    eater.wormlight.components.spell.lifetime = 0
                    eater.wormlight.components.spell:ResumeSpell()
                    return
                else
                    eater.wormlight.components.spell:OnFinish()
                end
            end

            local light = SpawnPrefab("wormlight_light_greater")
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

	wine_banana =
	{
		test = function(brewer, names, tags) return names.kyno_banana and (names.kyno_banana == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink", "monkeyqueenbribe"},
		card_def = {ingredients = {{"kyno_banana", 2}, {"ice", 1}}},
	},

	wine_kokonut =
	{
		test = function(brewer, names, tags) return names.kyno_kokonut_halved and (names.kyno_kokonut_halved == 2)
		and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_kokonut_halved", 2}, {"ice", 1}}},
	},

	wine_pineapple =
	{
		test = function(brewer, names, tags) return names.kyno_pineapple_halved and (names.kyno_pineapple_halved == 2)
		and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 25,
		sanity = 20,
		cooktime = 72,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_pineapple", 2}, {"ice", 1}}},
	},

	wine_nightberry =
	{
		test = function(brewer, names, tags) return names.ancientfruit_nightvision and (names.ancientfruit_nightvision == 2)
		and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 35,
		sanity = 15,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NIGHTVISION,
		nightvision = true,
		nameoverride = "KYNO_WINE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"ancientfruit_nightvision", 2}, {"ice", 1}}},
		prefabs = { "kyno_nightvisionbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_nightvisionbuff", "kyno_nightvisionbuff")

			if eater.components.grogginess ~= nil then
				eater.components.grogginess:MakeGrogginessAtLeast(1.5)
			end
        end,
	},

	juice_carrot =
	{
		test = function(brewer, names, tags) return names.carrot and (names.carrot == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"carrot", 2}, {"ice", 1}}},
	},

	juice_corn =
	{
		test = function(brewer, names, tags) return names.corn and (names.corn == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"corn", 2}, {"ice", 1}}},
	},

	juice_eggplant =
	{
		test = function(brewer, names, tags) return names.eggplant and (names.eggplant == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 25,
		hunger = 35,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"eggplant", 2}, {"ice", 1}}},
	},

	juice_pumpkin =
	{
		test = function(brewer, names, tags) return names.pumpkin and (names.pumpkin == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 30,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"pumpkin", 2}, {"ice", 1}}},
	},

	juice_lichen =
	{
		test = function(brewer, names, tags) return names.cutlichen and (names.cutlichen == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 20,
		sanity = -15,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"cutlichen", 2}, {"ice", 1}}},
	},

	juice_cactus =
	{
		test = function(brewer, names, tags) return (names.cactus_meat or (names.cactus_flower and names.cactus_flower == 2)) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 40,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"cactus_meat", 2}, {"ice", 1}}},
	},

	juice_garlic =
	{
		test = function(brewer, names, tags) return names.garlic and (names.garlic == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 25,
		sanity = -5,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"garlic", 2}, {"ice", 1}}},
	},

	juice_asparagus =
	{
		test = function(brewer, names, tags) return names.asparagus and (names.asparagus == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 45,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"asparagus", 2}, {"ice", 1}}},
	},

	juice_onion =
	{
		test = function(brewer, names, tags) return names.onion and (names.onion == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 25,
		sanity = -20,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"onion", 2}, {"ice", 1}}},
	},

	juice_tomato =
	{
		test = function(brewer, names, tags) return names.tomato and (names.tomato == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 50,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"tomato", 2}, {"ice", 1}}},
	},

	juice_potato =
	{
		test = function(brewer, names, tags) return names.potato and (names.potato == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"potato", 2}, {"ice", 1}}},
	},

	juice_pepper =
	{
		test = function(brewer, names, tags) return names.pepper and (names.pepper == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 30,
		hunger = 45,
		sanity = -20,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"pepper", 2}, {"ice", 1}}},
	},

	juice_redcap =
	{
		test = function(brewer, names, tags) return names.red_cap and (names.red_cap == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 40,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"red_cap", 2}, {"ice", 1}}},
	},

	juice_greencap =
	{
		test = function(brewer, names, tags) return names.green_cap and (names.green_cap == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"green_cap", 2}, {"ice", 1}}},
	},

	juice_bluecap =
	{
		test = function(brewer, names, tags) return names.blue_cap and (names.blue_cap == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"blue_cap", 2}, {"ice", 1}}},
	},

	juice_mooncap =
	{
		test = function(brewer, names, tags) return names.moon_cap and (names.moon_cap == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 30,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SLEEP_RESISTANCE,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"moon_cap", 2}, {"ice", 1}}},
		prefabs = { "buff_sleepresistance" },
        oneatenfn = function(inst, eater)
            if eater.components.grogginess ~= nil and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.grogginess:ResetGrogginess()
            end

			eater:AddDebuff("shroomsleepresist", "buff_sleepresistance")
        end,
	},

	juice_kelp =
	{
		test = function(brewer, names, tags) return names.kelp and (names.kelp == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 65,
		sanity = -20,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kelp", 2}, {"ice", 1}}},
	},

	juice_avocado =
	{
		test = function(brewer, names, tags) return names.rock_avocado_fruit_ripe and (names.rock_avocado_fruit_ripe == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 45,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"rock_avocado_fruit_ripe", 2}, {"ice", 1}}},
	},

	juice_whitecap =
	{
		test = function(brewer, names, tags) return names.kyno_white_cap and (names.kyno_white_cap == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 25,
		hunger = 62.5,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_white_cap", 2}, {"ice", 1}}},
	},

	juice_aloe =
	{
		test = function(brewer, names, tags) return names.kyno_aloe and (names.kyno_aloe == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 25,
		hunger = 50,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_aloe", 2}, {"ice", 1}}},
	},

	juice_radish =
	{
		test = function(brewer, names, tags) return names.kyno_radish and (names.kyno_radish == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 25,
		hunger = 35,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_radish", 2}, {"ice", 1}}},
	},

	juice_sweetpotato =
	{
		test = function(brewer, names, tags) return names.kyno_sweetpotato and (names.kyno_sweetpotato == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_sweetpotato", 2}, {"ice", 1}}},
	},

	juice_lotus =
	{
		test = function(brewer, names, tags) return names.kyno_lotus_flower and (names.kyno_lotus_flower == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 60,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_lotus_flower", 2}, {"ice", 1}}},
	},

	juice_seaweeds =
	{
		test = function(brewer, names, tags) return names.kyno_seaweeds and (names.kyno_seaweeds == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 62.5,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_seaweeds", 2}, {"ice", 1}}},
	},

	juice_taroroot =
	{
		test = function(brewer, names, tags) return names.kyno_taroroot and (names.kyno_taroroot == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_taroroot", 2}, {"ice", 1}}},
	},

	juice_waterycress =
	{
		test = function(brewer, names, tags) return names.kyno_waterycress and (names.kyno_waterycress == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_waterycress", 2}, {"ice", 1}}},
	},

	juice_cucumber =
	{
		test = function(brewer, names, tags) return names.kyno_cucumber and (names.kyno_cucumber == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 30,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_cucumber", 2}, {"ice", 1}}},
	},

	juice_parznip =
	{
		test = function(brewer, names, tags) return (names.kyno_parznip or (names.kyno_parznip_eaten and names.kyno_parznip_eaten == 2)) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_parznip", 2}, {"ice", 1}}},
	},

	juice_turnip =
	{
		test = function(brewer, names, tags) return names.kyno_turnip and (names.kyno_turnip == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 70,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_turnip", 2}, {"ice", 1}}},
	},

	juice_fennel =
	{
		test = function(brewer, names, tags) return names.kyno_fennel and (names.kyno_fennel == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 70,
		sanity = -20,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_fennel", 2}, {"ice", 1}}},
	},
	
	juice_truffles =
	{
		test = function(brewer, names, tags) return names.kyno_truffles and (names.kyno_truffles == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 5,
		hunger = 50,
		sanity = 5,
		cooktime = 72,
		goldvalue = 10,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "truffles"},
		card_def = {ingredients = {{"kyno_truffles", 2}, {"ice", 1}}},
	},
	
	juice_sporecap =
	{
		test = function(brewer, names, tags) return names.kyno_sporecap and (names.kyno_sporecap == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = -10,
		hunger = 62.5,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "monstermeat"},
		card_def = {ingredients = {{"kyno_sporecap", 2}, {"ice", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(10)
				eater.components.sanity:DoDelta(10)
			end
		end,
	},
	
	juice_sporecap_dark =
	{
		test = function(brewer, names, tags) return names.kyno_sporecap_dark and (names.kyno_sporecap_dark == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = -20,
		hunger = 62.5,
		sanity = -20,
		cooktime = 72,
		nameoverride = "KYNO_JUICE",
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "monstermeat"},
		card_def = {ingredients = {{"kyno_sporecap_dark", 2}, {"ice", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(20)
				eater.components.sanity:DoDelta(20)
			end
		end,
	},

	beer =
	{
		test = function(brewer, names, tags) return names.kyno_wheat and (names.kyno_wheat == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 12.5,
		sanity = -10,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_ALCOHOL,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_wheat", 2}, {"ice", 1}}},
		prefabs = { "kyno_strengthbuff" },
		oneatenfn = function (inst, eater)
			eater:AddDebuff("kyno_strengthbuff", "kyno_strengthbuff")
		end,
	},

	paleale =
	{
		test = function(brewer, names, tags) return names.kyno_spotspice_leaf and (names.kyno_spotspice_leaf == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 25,
		sanity = -10,
		cooktime = 48,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_ALCOHOL,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_spotspice_leaf", 2}, {"ice", 1}}},
		prefabs = { "kyno_strengthbuff_med" },
		oneatenfn = function (inst, eater)
			eater:AddDebuff("kyno_strengthbuff_med", "kyno_strengthbuff_med")
		end,
	},

	mead =
	{
		test = function(brewer, names, tags) return ((names.honey or 0) + (tags.syrup or 0) == 2)
		and tags.frozen and not tags.veggie and not tags.fruit end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -10,
		hunger = 70,
		sanity = 40,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DAMAGEREDUCTION,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink", "honeyed"},
		card_def = {ingredients = {{"honey", 2}, {"ice", 1}}},
		prefabs = { "kyno_dmgreductionbuff" },
		oneatenfn = function (inst, eater)
			eater:AddDebuff("kyno_dmgreductionbuff", "kyno_dmgreductionbuff")
		end,
	},

	teagreen =
	{
		test = function(brewer, names, tags) return names.kyno_piko_orange and names.green_cap and names.kyno_tealeaf end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 12,
		hunger = 32,
		sanity = 1,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_RESANITY,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_piko_orange", 1}, {"green_cap", 1}, {"kyno_tealeaf", 1}}},
		prefabs = { "kyno_sanityregenbuff" },
        oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_sanityregenbuff", "kyno_sanityregenbuff")
        end,
	},

	teared =
	{
		test = function(brewer, names, tags) return names.kyno_piko and names.red_cap and names.kyno_tealeaf end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 1,
		hunger = 32,
		sanity = 12,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HEALTH_REGEN,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_piko", 1}, {"red_cap", 1}, {"kyno_tealeaf", 1}}},
		prefabs = { "healthregenbuff" },
        oneatenfn = function(inst, eater)
			eater:AddDebuff("healthregenbuff", "healthregenbuff")
        end,
	},

	piraterum =
	{
		test = function(brewer, names, tags) return names.durian and tags.syrup and tags.frozen end,
		priority = 1,
		foodtype = FOODTYPE.GOODIES,
		perishtime = 9000000,
		health = -5,
		hunger = 60,
		sanity = -33,
		cooktime = 48,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_RUM,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink", "honeyed", "monkeyqueenbribe"},
		card_def = {ingredients = {{"durian", 1}, {"kyno_syrup", 1}, {"ice", 1}}},
		prefabs = { "kyno_piratebuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_piratebuff", "kyno_piratebuff")
			eater:PushEvent("piraterum")
			
			--[[
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("hof_sounds/common/piraterum/laugh", "piraterum", 0.5)
			else
				inst.SoundEmitter:PlaySound("hof_sounds/common/piraterum/laugh", "piraterum", 0.5)
			end
			]]--
		end,
	},

	twistedtequila =
	{
		test = function(cooker, names, tags) return (names.kyno_aloe or names.kyno_aloe_cooked) and names.kyno_spotspice_leaf and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 15,
		hunger = 32.5,
		sanity = -30,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_TEQUILA,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_aloe", 1}, {"kyno_spotspice_leaf", 1}, {"ice", 1}}},
		oneatenfn = function(inst, eater)
			OnFoodTeleport(inst, eater)
			
			if eater.components.grogginess ~= nil then
				eater.components.grogginess:MakeGrogginessAtLeast(1.5)
			end
		end,
	},

	nukacola =
	{
		test = function(cooker, names, tags) return names.kyno_sugar and tags.syrup and tags.frozen
		and not (names.wormlight or names.wormlight_lesser) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = -5,
		hunger = 12.5,
		sanity = 60,
		cooktime = 48,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_sugar", 1}, {"kyno_syrup", 1}, {"ice", 1}}},
		oneatenfn = function(inst, eater)
			eater:PushEvent("bottlecap")

			if math.random() < 0.05 then
				local cap = SpawnPrefab("kyno_bottlecap")
				if eater.components.inventory ~= nil and eater:HasTag("player") and not eater.components.health:IsDead() and not eater:HasTag("playerghost")
				and not eater.components.inventory:IsFull() then
					eater.components.inventory:GiveItem(cap)
				end
			end
			
			--[[
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			else
				inst.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			end
			]]--
		end,
	},

	nukacola_quantum =
	{
		test = function(cooker, names, tags) return names.kyno_sugar and (names.wormlight or names.wormlight_lesser) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = -10,
		hunger = 20,
		sanity = 60,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_GLOW,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_sugar", 1}, {"wormlight_lesser", 1}, {"ice", 1}}},
		prefabs = { "wormlight_light_greater" },
        oneatenfn = function(inst, eater)
			eater:PushEvent("bottlecap")

			if math.random() < 0.05 then
				local cap = SpawnPrefab("kyno_bottlecap")
				if eater.components.inventory ~= nil and eater:HasTag("player") and not eater.components.health:IsDead() and not eater:HasTag("playerghost")
				and not eater.components.inventory:IsFull() then
					eater.components.inventory:GiveItem(cap)
				end
			end
			
			--[[
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			else
				inst.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			end
			]]--

            if eater.wormlight ~= nil then
                if eater.wormlight.prefab == "wormlight_light_greater" then
                    eater.wormlight.components.spell.lifetime = 0
                    eater.wormlight.components.spell:ResumeSpell()
                    return
                else
                    eater.wormlight.components.spell:OnFinish()
                end
            end

            local light = SpawnPrefab("wormlight_light_greater")
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
	
	nukashine =
	{
		test = function(brewer, names, tags) return names.ancientfruit_nightvision and names.kyno_sugar and names.nukacola_quantum end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 100,
		hunger = 150,
		sanity = -100,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NUKASHINE,
		nightvision = true,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"ancientfruit_nightvision", 1}, {"kyno_sugar", 1}, {"nukacola_quantum", 1}}},
		prefabs = { "kyno_nukashinebuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_nukashinebuff", "kyno_nukashinebuff")
			
			--[[
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("hof_sounds/common/nukashine/open")
				eater.SoundEmitter:PlaySound("hof_sounds/common/nukashine/drink")
			else
				inst.SoundEmitter:PlaySound("hof_sounds/common/nukashine/open")
				inst.SoundEmitter:PlaySound("hof_sounds/common/nukashine/drink")
			end
			]]--
		end,
	},

	ricesake =
	{
		test = function(brewer, names, tags) return names.kyno_rice and (names.kyno_rice == 2) and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -10,
		hunger = 32.5,
		sanity = 20,
		cooktime = 48,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DAMAGEREDUCTION,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_rice", 2}, {"ice", 1}}},
		prefabs = { "kyno_dmgreductionbuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_dmgreductionbuff", "kyno_dmgreductionbuff")
		end,
	},
	
	coffee_mocha =
	{
		test = function(brewer, names, tags) return names.kyno_coffeebeans_cooked and (names.kyno_coffeebeans_cooked == 2) and tags.chocolate end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_BRIEF,
		health = -10,
		hunger = 33,
		sanity = 33, 
		cooktime = 72,
		scale = 1,
		nameoverride = "COFFEE",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HUNGERRATE,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_coffeebeans_cooked", 2}, {"chocolate_black", 1}}},
	},
	
	toadstoolcola = -- Oh well, good luck having to farm Toadstool for this. OR just buy his legs from Sammy!
	{
		test = function(brewer, names, tags) return names.kyno_poison_froglegs and tags.sugar and tags.frozen end,
		priority = 100,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -30,
		hunger = 12.5,
		sanity = 80,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_AMPHIBIAN,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_poison_froglegs", 1}, {"kyno_sugar", 1}, {"ice", 1}}},
		prefab = { "kyno_amphibianbuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_amphibianbuff", "kyno_amphibianbuff")
		end,
	},
	
	tepache =
	{
		test = function(brewer, names, tags) return names.kyno_pineapple_halved and tags.sugar and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION,
		health = 20,
		hunger = 12.5,
		sanity = 33,
		cooktime = 24,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		tags = {"fooddrink"},
		card_def = {ingredients = {{"kyno_pineapple_halved", 1}, {"kyno_sugar", 1}, {"ice", 1}}},
	},
	
	lunartequila =
	{
		test = function(brewer, names, tags) return names.moon_tree_blossom and names.purebrilliance and tags.frozen end,
		priority = 100,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		loopanim = true,
		health = 5,
		hunger = 12.5,
		sanity = 100,
		cooktime = 72,
		scale = 1.2,
		bank = "lunartequila",
		anim = "idle",
		floater = TUNING.HOF_FLOATER,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_ENLIGHTENMENT,
		tags = {"fooddrink", "alcoholic_drink", "lunar_aligned"},
		card_def = {ingredients = {{"moon_tree_blossom", 1}, {"purebrilliance", 1}, {"ice", 1}}},
		prefabs = { "kyno_enlightenmentbuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_enlightenmentbuff", "kyno_enlightenmentbuff")
		end,
	},
	
	mimicmosa =
	{
		test = function(brewer, names, tags) return names.kyno_pineapple_halved and names.horrorfuel and tags.frozen end,
		priority = 100,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		horrorfx = true,
		health = 5,
		hunger = 12.5,
		sanity = -100,
		cooktime = 72,
		scale = 1.2,
		overridebuild = "kyno_foodrecipes_keg",
		floater = TUNING.HOF_FLOATER,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_STEALTH,
		tags = {"fooddrink", "alcoholic_drink", "shadow_aligned", "shadow_fooditem"},
		card_def = {ingredients = {{"kyno_pineapple_halved", 1}, {"horrorfuel", 1}, {"ice", 1}}},
		prefabs = { "kyno_stealthbuff" },
		oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_stealthbuff", "kyno_stealthbuff")
		end,
	},

	-- This recipe is for when brewing an invalid product, we need this to prevent a crash.
	wetgoop2 =
	{
		test = function(brewer, names, tags) return true end,
		priority = -2,
		perishtime = TUNING.PERISH_FAST,
		health = 0,
		hunger = 0,
		sanity = 0,
		cooktime = 1,
		isfertilizer = true,
		nutrients = {32, 8, 8},
		-- no_brewbook = true,
        floater = {"small", nil, nil},
	},
}

for k, recipe in pairs(kyno_foods_keg) do
	recipe.name = k
	recipe.weight = 1
	recipe.overridebuild = recipe.overridebuild or k
	recipe.brewbook_category = "keg"
	recipe.cookbook_atlas = "images/cookbookimages/hof_brewbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods_keg