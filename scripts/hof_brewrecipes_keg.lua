-- Informations about these foods:
-- Cooktimes: 24 = 1 Day. | 48 = 2 Days. | 72 = 3 Days. | 120 = 5 Days. | 168 = 7 Days. | 240 = 10 Days. | 360 = 15 Days. | 480 = 20 Days.
-- These recipes don't appear in the Cookbook since they're "special" and not from the Crcok Pot.
-- They took several days to produce, just like the real life / Stardew Valley mechanics.

local kyno_foods_keg =
{
	--[[
	-- This recipe is just for testing the brewing mechanics. Remember to turn this off when switching the builds.
	brewertest =
	{
		test = function(brewer, names, tags) return names.red_cap and names.blue_cap end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = 480,
		health = -10,
		hunger = 0,
		sanity = 10,
		cooktime = 0.5,
		oneat_desc = "Testing brewing",
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
	},
	]]--
	
	-- Keg Recipes.
	wine_berries = 
	{
		test = function(brewer, names, tags) return names.berries and (names.berries == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"berries", 2}, {"ice", 1}}},
	},
	
	wine_berries_juicy = 
	{
		test = function(brewer, names, tags) return names.berries_juicy and (names.berries_juicy == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"berries_juicy", 2}, {"ice", 1}}},
	},
	
	wine_pomegranate = 
	{
		test = function(brewer, names, tags) return names.pomegranate and (names.pomegranate == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"pomegranate", 2}, {"ice", 1}}},
	},
	
	wine_dragonfruit = 
	{
		test = function(brewer, names, tags) return names.dragonfruit and (names.dragonfruit == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 20,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"dragonfruit", 2}, {"ice", 1}}},
	},
	
	wine_cave_banana = 
	{
		test = function(brewer, names, tags) return names.cave_banana and (names.cave_banana == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"cave_banana", 2}, {"ice", 1}}},
	},
	
	wine_durian = 
	{
		test = function(brewer, names, tags) return names.durian and (names.durian == 2) and tags.frozen and not names.kyno_sugar  end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = -5,
		hunger = 35, -- 70 Wurt.
		sanity = -40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink", "monstermeat"},
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
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"watermelon", 2}, {"ice", 1}}},
	},
	
	wine_fig = 
	{
		test = function(brewer, names, tags) return names.fig and (names.fig == 2) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"fig", 2}, {"ice", 1}}},
	},
	
	wine_glowberry = 
	{
		test = function(brewer, names, tags) return (names.wormlight or (names.wormlight_lesser and names.wormlight_lesser == 2)) and tags.frozen 
		and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 40,
		sanity = -10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
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
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_banana", 2}, {"ice", 1}}},
	},
	
	wine_kokonut = 
	{
		test = function(brewer, names, tags) return (names.kyno_kokonut_halved or 
		(names.kyno_kokonut_cooked and names.kyno_kokonut_cooked == 2)) and tags.frozen and not names.kyno_sugar end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_kokonut_halved", 2}, {"ice", 1}}},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SLEEP_RESISTANCE,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"kyno_fennel", 2}, {"ice", 1}}},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
		card_def = {ingredients = {{"kyno_spotspice_leaf", 2}, {"ice", 1}}},
		prefabs = { "kyno_strengthbuff_med" },
		oneatenfn = function (inst, eater)
			eater:AddDebuff("kyno_strengthbuff_med", "kyno_strengthbuff_med")
		end,
	},
	
	mead =
	{
		test = function(brewer, names, tags) return ((names.honey or 0) + (names.kyno_syrup or 0) == 2) 
		and tags.frozen and not tags.veggie and not tags.fruit end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -10,
		hunger = 70,
		sanity = 40,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DAMAGEREDUCTION,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink", "honeyed"},
		card_def = {ingredients = {{"kyno_honey", 2}, {"ice", 1}}},
		prefabs = { "kyno_dmgreductionbuff" },
		oneatenfn = function (inst, eater)
			eater:AddDebuff("kyno_dmgreductionbuff", "kyno_dmgreductionbuff")
		end,
	},
	
	teagreen = 
	{
		test = function(brewer, names, tags) return names.kyno_piko_orange and names.green_cap and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 12,
		hunger = 32,
		sanity = 1,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_RESANITY,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"kyno_piko_orange", 1}, {"green_cap", 1}, {"ice", 1}}},
		prefabs = { "kyno_sanityregenbuff" },
        oneatenfn = function(inst, eater)
			eater:AddDebuff("kyno_sanityregenbuff", "kyno_sanityregenbuff")
        end,
	},
	
	teared = 
	{
		test = function(brewer, names, tags) return names.kyno_piko and names.red_cap and tags.frozen end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 1,
		hunger = 32,
		sanity = 12,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HEALTH_REGEN,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"kyno_piko", 1}, {"red_cap", 1}, {"ice", 1}}},
		prefabs = { "healthregenbuff" },
        oneatenfn = function(inst, eater)
			eater:AddDebuff("healthregenbuff", "healthregenbuff")
        end,
	},
	
	piraterum =
	{
		test = function(brewer, names, tags) return names.durian and names.kyno_syrup and tags.frozen end,
		priority = 1,
		foodtype = FOODTYPE.GOODIES,
		perishtime = 9000000,
		health = -5,
		hunger = 60,
		sanity = -33,
		cooktime = 48,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_RUM,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink", "honeyed"},
		card_def = {ingredients = {{"durian", 1}, {"kyno_syrup", 1}, {"ice", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("hof_sounds/common/piraterum/laugh")
			else	
				inst.SoundEmitter:PlaySound("hof_sounds/common/piraterum/laugh")
			end
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
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_aloe", 1}, {"kyno_spotspice_leaf", 1}, {"ice", 1}}},
		tags = {"drinkable_food", "alcoholic_drink"},
		oneatenfn = function(inst, eater)
			local function GetRandomPosition(caster, teleportee, target_in_ocean)
				if target_in_ocean then
					local pt = TheWorld.Map:FindRandomPointInOcean(20)
					if pt ~= nil then
						return pt
					end
					
				local from_pt = teleportee:GetPosition()
				local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16)
				or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16)
				or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16)
				or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
				if offset ~= nil then
					return from_pt + offset
				end
				return teleportee:GetPosition()
			else
				local centers = {}
				for i, node in ipairs(TheWorld.topology.nodes) do
					if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
						table.insert(centers, {x = node.x, z = node.y})
					end
				end
					if #centers > 0 then
						local pos = centers[math.random(#centers)]
						return Point(pos.x, 0, pos.z)
					else
						return eater:GetPosition()
					end
				end
			end
			
			local function TeleportEnd(teleportee, locpos, loctarget, eater)
				if loctarget ~= nil and loctarget:IsValid() and loctarget.onteleto ~= nil then
					loctarget:onteleto()
				end
				
				local teleportfx = SpawnPrefab("explode_reskin")
				teleportfx.Transform:SetPosition(teleportee.Transform:GetWorldPosition())
				
				if teleportee.components.talker ~= nil then 
					teleportee.components.talker:Say(GetString(teleportee, "ANNOUNCE_TOWNPORTALTELEPORT"))
				end

				if teleportee:HasTag("player") then
					teleportee.sg.statemem.teleport_task = nil
					teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
				else
					teleportee:Show()
					if teleportee.DynamicShadow ~= nil then
						teleportee.DynamicShadow:Enable(true)
					end
					if teleportee.components.health ~= nil then
						teleportee.components.health:SetInvincible(false)
					end
					teleportee:PushEvent("teleported")
				end
			end
			
			local function TeleportContinue(teleportee, locpos, loctarget, eater)
				if teleportee.Physics ~= nil then
					teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
				else
					teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
				end

				if teleportee:HasTag("player") then
					teleportee:SnapCamera()
					teleportee:ScreenFade(true, 1)
					teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(1, TeleportEnd, locpos, loctarget)
				else
					TeleportEnd(teleportee, locpos, loctarget)
				end
			end
			
			local function TeleportStart(teleportee, eater, caster, loctarget, target_in_ocean)
				local ground = TheWorld

				local locpos = teleportee.components.teleportedoverride ~= nil and teleportee.components.teleportedoverride:GetDestPosition()
				or loctarget == nil and GetRandomPosition(eater, teleportee, target_in_ocean)
				or loctarget.teletopos ~= nil and loctarget:teletopos()
				or loctarget:GetPosition()

				if teleportee.components.locomotor ~= nil then
					teleportee.components.locomotor:StopMoving()
				end

				local teleportfx = SpawnPrefab("explode_reskin")
				teleportfx.Transform:SetPosition(teleportee.Transform:GetWorldPosition())

				local isplayer = teleportee:HasTag("player")
				if isplayer then
					teleportee.sg:GoToState("forcetele")
				else
					if teleportee.components.health ~= nil then
						teleportee.components.health:SetInvincible(true)
					end
					if teleportee.DynamicShadow ~= nil then
						teleportee.DynamicShadow:Enable(false)
					end
					teleportee:Hide()
				end

				if isplayer then
					teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(3, TeleportContinue, locpos, loctarget)
				else
					TeleportContinue(teleportee, locpos, loctarget)
				end
			end
			
			local TELEPORT_MUST_TAGS = { "locomotor" }
			local TELEPORT_CANT_TAGS = { "playerghost", "INLIMBO" }
			local function TeleportPlayer(inst, eater)
				local caster = inst.components.inventoryitem.owner or eater
				if eater == nil then
					eater = caster
				end

				local x, y, z = eater.Transform:GetWorldPosition()
				local target_in_ocean = eater.components.locomotor ~= nil and eater.components.locomotor:IsAquatic()

				local loctarget = eater.components.minigame_participator ~= nil and eater.components.minigame_participator:GetMinigame()
				or eater.components.teleportedoverride ~= nil and eater.components.teleportedoverride:GetDestTarget()
                or eater.components.hitchable ~= nil and eater:HasTag("hitched") and eater.components.hitchable.hitched or nil
				
				if eater:HasTag("player") then 
					TeleportStart(eater, inst, caster, loctarget, target_in_ocean)
				end
			end
			
			TeleportPlayer(inst, eater)
		end,
	},
	
	nukacola =
	{
		test = function(cooker, names, tags) return names.kyno_sugar and names.kyno_syrup and tags.frozen 
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"kyno_sugar", 1}, {"kyno_syrup", 1}, {"ice", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			else
				inst.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			end
			
			if math.random() < 0.05 then 
				local cap = SpawnPrefab("kyno_bottlecap")
				if eater.components.inventory ~= nil and eater:HasTag("player") and not eater.components.health:IsDead() and not eater:HasTag("playerghost") 
				and not eater.components.inventory:IsFull() then 
					eater.components.inventory:GiveItem(cap)
				end
			end
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
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
		card_def = {ingredients = {{"kyno_sugar", 1}, {"wormlight_lesser", 1}, {"ice", 1}}},
		prefabs = { "wormlight_light_greater" },
        oneatenfn = function(inst, eater)
			if eater ~= nil and eater.SoundEmitter ~= nil then
				eater.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			else
				inst.SoundEmitter:PlaySound("hof_sounds/common/nukacola/drink1")
			end
			
			if math.random() < 0.05 then 
				local cap = SpawnPrefab("kyno_bottlecap")
				if eater.components.inventory ~= nil and eater:HasTag("player") and not eater.components.health:IsDead() and not eater:HasTag("playerghost") 
				and not eater.components.inventory:IsFull() then 
					eater.components.inventory:GiveItem(cap)
				end
			end
		
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
	
	-- This recipe is for when brewing a invalid product, we need this to prevent a crash.
	wetgoop2 =
	{
		test = function(brewer, names, tags) return true end,
		priority = -2,
		perishtime = TUNING.PERISH_FAST,
		health = 0,
		hunger = 0,
		sanity = 0,
		cooktime = 1,
		-- no_brewbook = true,
        floater = {"small", nil, nil},
	},
}

for k, recipe in pairs(kyno_foods_keg) do
	recipe.name = k
	recipe.weight = 1
	recipe.brewbook_category = "keg"
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods_keg