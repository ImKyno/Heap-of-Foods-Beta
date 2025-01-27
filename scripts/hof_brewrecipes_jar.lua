-- Informations about these foods:
-- Cooktimes: 24 = 1 Day. | 48 = 2 Days. | 72 = 3 Days. | 120 = 5 Days. | 168 = 7 Days. | 240 = 10 Days. | 360 = 15 Days. | 480 = 20 Days.
-- These recipes don't appear in the Cookbook since they're "special" and not from the Crcok Pot.
-- They took several days to produce, just like the real life / Stardew Valley mechanics.

local kyno_foods_jar =
{
	-- Preserves Jar Recipes.
	jelly_berries = 
	{
		test = function(brewer, names, tags) return names.berries and (names.berries == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 20,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"berries", 2}, {"honey", 1}}},
	},
	
	jelly_berries_juicy = 
	{
		test = function(brewer, names, tags) return names.berries_juicy and (names.berries_juicy == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 20,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"berries_juicy", 2}, {"honey", 1}}},
	},
	
	jelly_pomegranate = 
	{
		test = function(brewer, names, tags) return names.pomegranate and (names.pomegranate == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 30,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"pomegranate", 2}, {"honey", 1}}},
	},
	
	jelly_dragonfruit = 
	{
		test = function(brewer, names, tags) return names.dragonfruit and (names.dragonfruit == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 40,
		sanity = 40,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"dragonfruit", 2}, {"honey", 1}}},
	},
	
	jelly_cave_banana = 
	{
		test = function(brewer, names, tags) return names.cave_banana and (names.cave_banana == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 25,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"cave_banana", 2}, {"honey", 1}}},
	},
	
	jelly_durian = 
	{
		test = function(brewer, names, tags) return names.durian and (names.durian == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = -5,
		hunger = 35,
		sanity = -20,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		tags = {"monstermeat"},
		card_def = {ingredients = {{"durian", 2}, {"honey", 1}}},
		oneatenfn = function(inst, eater)
			if eater ~= nil and eater:HasTag("playermonster") or eater:HasTag("playermerm") and
			not (eater.components.health ~= nil and eater.components.health:IsDead()) and
			not eater:HasTag("playerghost") then
				eater.components.health:DoDelta(5)
				eater.components.sanity:DoDelta(20)
			end
		end,
	},
	
	jelly_watermelon = 
	{
		test = function(brewer, names, tags) return names.watermelon and (names.watermelon == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 35,
		sanity = 20,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"watermelon", 2}, {"honey", 1}}},
	},
	
	jelly_fig = 
	{
		test = function(brewer, names, tags) return names.fig and (names.fig == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 20,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"fig", 2}, {"honey", 1}}},
	},
	
	jelly_glowberry = 
	{
		test = function(brewer, names, tags) return (names.wormlight or (names.wormlight_lesser and names.wormlight_lesser == 2)) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 40,
		sanity = -10,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_GLOW,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"wormlight_lesser", 2}, {"honey", 1}}},
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
	
	jelly_banana = 
	{
		test = function(brewer, names, tags) return names.kyno_banana and (names.kyno_banana == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 33,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_banana", 2}, {"honey", 1}}},
	},
	
	jelly_kokonut = 
	{
		test = function(brewer, names, tags) return names.kyno_kokonut_halved and (names.kyno_kokonut_halved == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 20,
		sanity = 33,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_kokonut_halved", 2}, {"honey", 1}}},
	},
	
	jelly_pineapple =
	{
		test = function(brewer, names, tags) return names.kyno_pineapple_halved and (names.kyno_pineapple_halved == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 33,
		hunger = 25,
		sanity = 15,
		cooktime = 48,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_pineapple_halved", 2}, {"honey", 1}}},
	},
	
	jelly_nightberry =
	{
		test = function(brewer, names, tags) return names.ancientfruit_nightvision and (names.ancientfruit_nightvision == 2) and tags.sweetener end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 25,
		sanity = 10,
		cooktime = 48,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NIGHTVISION,
		nightvision = true,
		nameoverride = "KYNO_JELLY",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"ancientfruit_nightvision", 2}, {"honey", 1}}},
		prefabs = { "kyno_nightvisionbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_nightvisionbuff", "kyno_nightvisionbuff")
			
			if eater.components.grogginess ~= nil then
				eater.components.grogginess:MakeGrogginessAtLeast(1.5)
			end
        end,
	},
	
	pickles_carrot = 
	{
		test = function(brewer, names, tags) return names.carrot and (names.carrot == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 30,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"carrot", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_corn = 
	{
		test = function(brewer, names, tags) return names.corn and (names.corn == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 35,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"corn", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_eggplant = 
	{
		test = function(brewer, names, tags) return names.eggplant and (names.eggplant == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 35,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"eggplant", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_pumpkin = 
	{
		test = function(brewer, names, tags) return names.pumpkin and (names.pumpkin == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 50,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"pumpkin", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_lichen = 
	{
		test = function(brewer, names, tags) return names.cutlichen and (names.cutlichen == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 15,
		sanity = -15,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"cutlichen", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_cactus = 
	{
		test = function(brewer, names, tags) return (names.cactus_meat or (names.cactus_flower and names.cactus_flower == 2)) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 50,
		hunger = 25,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"cactus_meat", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_garlic = 
	{
		test = function(brewer, names, tags) return names.garlic and (names.garlic == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 30,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"garlic", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_asparagus = 
	{
		test = function(brewer, names, tags) return names.asparagus and (names.asparagus == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"asparagus", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_onion = 
	{
		test = function(brewer, names, tags) return names.onion and (names.onion == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"onion", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_tomato = 
	{
		test = function(brewer, names, tags) return names.tomato and (names.tomato == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"tomato", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_potato = 
	{
		test = function(brewer, names, tags) return names.potato and (names.potato == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 70,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"potato", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_pepper = 
	{
		test = function(brewer, names, tags) return names.pepper and (names.pepper == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 25,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"pepper", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_redcap = 
	{
		test = function(brewer, names, tags) return names.red_cap and (names.red_cap == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = -15,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"red_cap", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_greencap = 
	{
		test = function(brewer, names, tags) return names.green_cap and (names.green_cap == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 50,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"green_cap", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_bluecap = 
	{
		test = function(brewer, names, tags) return names.blue_cap and (names.blue_cap == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 20,
		sanity = -5,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"blue_cap", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_mooncap = 
	{
		test = function(brewer, names, tags) return names.moon_cap and (names.moon_cap == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SLEEP_RESISTANCE,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"moon_cap", 2}, {"kyno_spotspice", 1}}},
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
	
	pickles_kelp = 
	{
		test = function(brewer, names, tags) return names.kelp and (names.kelp == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 20,
		sanity = -5,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kelp", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_avocado = 
	{
		test = function(brewer, names, tags) return names.rock_avocado_fruit_ripe and (names.rock_avocado_fruit_ripe == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 35,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"rock_avocado_fruit_ripe", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_whitecap = 
	{
		test = function(brewer, names, tags) return names.kyno_white_cap and (names.kyno_white_cap == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_white_cap", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_aloe = 
	{
		test = function(brewer, names, tags) return names.kyno_aloe and (names.kyno_aloe == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_aloe", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_radish = 
	{
		test = function(brewer, names, tags) return names.kyno_radish and (names.kyno_radish == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_radish", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_sweetpotato = 
	{
		test = function(brewer, names, tags) return names.kyno_sweetpotato and (names.kyno_sweetpotato == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_sweetpotato", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_lotus = 
	{
		test = function(brewer, names, tags) return names.kyno_lotus_flower and (names.kyno_lotus_flower == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 33,
		hunger = 33,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_lotus_flower", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_seaweeds = 
	{
		test = function(brewer, names, tags) return names.kyno_seaweeds and (names.kyno_seaweeds == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = -10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_seaweeds", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_taroroot = 
	{
		test = function(brewer, names, tags) return names.kyno_taroroot and (names.kyno_taroroot == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 20,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_taroroot", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_waterycress = 
	{
		test = function(brewer, names, tags) return names.kyno_waterycress and (names.kyno_waterycress == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 40,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_waterycress", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_cucumber = 
	{
		test = function(brewer, names, tags) return names.kyno_cucumber and (names.kyno_cucumber == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_cucumber", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_parznip = 
	{
		test = function(brewer, names, tags) return (names.kyno_parznip or 
		(names.kyno_parznip_eaten and names.kyno_parznip_eaten == 2)) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 75,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_parznip", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_turnip = 
	{
		test = function(brewer, names, tags) return names.kyno_turnip and (names.kyno_turnip == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 40,
		hunger = 32.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_turnip", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_fennel = 
	{
		test = function(brewer, names, tags) return names.kyno_fennel and (names.kyno_fennel == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 40,
		sanity = -15,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_fennel", 2}, {"kyno_spotspice", 1}}},
	},
	
	pickles_rice =
	{
		test = function(brewer, names, tags) return names.kyno_rice and (names.kyno_rice == 2) and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		nameoverride = "KYNO_PICKLES",
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_rice", 2}, {"kyno_spotspice", 1}}},
	},
	
	mayonnaise = 
	{
		test = function(brewer, names, tags) return tags.egg and names.kyno_oil and names.kyno_salt
		and not names.kyno_chicken_egg and not names.tallbirdegg and not names.nightmarefuel end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 10,
		hunger = 12.5,
		sanity = 15,
		cooktime = 24,
		nameoverride = "KYNO_MAYONNAISE",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"bird_egg", 1}, {"kyno_oil", 1}, {"kyno_salt", 1}}},
		prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
        end,
	},
	
	mayonnaise_chicken = 
	{
		test = function(brewer, names, tags) return names.kyno_chicken_egg and names.kyno_oil and names.kyno_salt and not names.nightmarefuel end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 0,
		hunger = 25,
		sanity = 25,
		cooktime = 24,
		nameoverride = "KYNO_MAYONNAISE",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_chicken_egg", 1}, {"kyno_oil", 1}, {"kyno_salt", 1}}},
		prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
        end,
	},
	
	mayonnaise_tallbird = 
	{
		test = function(brewer, names, tags) return names.tallbirdegg and names.kyno_oil and names.kyno_salt and not names.nightmarefuel end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 12.5,
		sanity = 5,
		cooktime = 24,
		nameoverride = "KYNO_MAYONNAISE",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"tallbirdegg", 1}, {"kyno_oil", 1}, {"kyno_salt", 1}}},
		prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
        end,
	},
	
	mayonnaise_nightmare =
	{
		test = function(brewer, names, tags) return tags.egg and names.nightmarefuel and names.kyno_salt end,
		priority = 35,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 30,
		hunger = 62.5,
		sanity = -5,
		cooktime = 72,
		nameoverride = "KYNO_MAYONNAISE",
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DESANITY,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"bird_egg", 1}, {"nightmarefuel", 1}, {"kyno_salt", 1}}},
		prefabs = { "kyno_insanitybuff" },
        oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_insanitybuff", "kyno_insanitybuff")
        end,
	},
	
	tartarsauce = 
	{
		test = function(brewer, names, tags) return tags.mayonnaise and names.kyno_spotspice and names.kyno_cucumber and not names.mayonnaise_nightmare end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 62.5,
		sanity = 10,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"mayonnaise", 1}, {"kyno_spotspice", 1}, {"kyno_cucumber", 1}}},
		oneatenfn = function(inst, eater)
            eater:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
        end,
	},
	
	butter_beefalo =
	{
		test = function(brewer, names, tags) return names.kyno_milk_beefalo and (names.kyno_milk_beefalo == 2) and names.kyno_salt end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 0,
		hunger = 25,
		sanity = 40,
		cooktime = 96,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_milk_beefalo", 2}, {"kyno_salt", 1}}},
	},
	
	butter_goat =
	{
		test = function(brewer, names, tags) return names.goatmilk and (names.goatmilk == 2) and names.kyno_salt end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 25,
		hunger = 40,
		sanity = 0,
		cooktime = 96,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"goatmilk", 2}, {"kyno_salt", 1}}},
	},
	
	butter_koalefant =
	{
		test = function(brewer, names, tags) return names.kyno_milk_koalefant and (names.kyno_milk_koalefant == 2) and names.kyno_salt end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 25,
		sanity = 20,
		cooktime = 96,
		floater = {"med", nil, 0.65},
		card_def = {ingredients = {{"kyno_milk_koalefant", 2}, {"kyno_salt", 1}}},
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

for k, recipe in pairs(kyno_foods_jar) do
	recipe.name = k
	recipe.weight = 1
	recipe.brewbook_category = "jar"
	recipe.cookbook_atlas = "images/cookbookimages/hof_brewbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods_jar