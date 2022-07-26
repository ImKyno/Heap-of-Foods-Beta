-- Informations about these foods:
-- Cooktimes: 24 = 1 Day. | 48 = 2 Days. | 72 = 3 Days. | 120 = 5 Days. | 168 = 7 Days. | 240 = 10 Days. | 360 = 15 Days. | 480 = 20 Days.
-- These recipes don't appear in the Cookbook since they're "special" and not from the Crcok Pot.
-- They took several days to produce, just like the real life / Stardew Valley mechanics.

local kyno_foods_keg =
{
	-- Keg Recipes.
	beer =
	{
		test = function(brewer, names, tags) return names.kyno_wheat and (names.kyno_wheat == 2) end,
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
	},
	
	paleale = 
	{
		test = function(brewer, names, tags) return names.kyno_spotspice_leaf and (names.kyno_spotspice_leaf == 2) end,
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
	},
	
	greentea = 
	{
		test = function(brewer, names, tags) return names.green_cap and names.succulent_picked end,
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
		prefabs = { "kyno_sanityregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_sanityregenbuff", "kyno_sanityregenbuff")
            end
        end,
	},
	
	redtea = 
	{
		test = function(brewer, names, tags) return names.red_cap and names.foliage end,
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
		prefabs = { "healthregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("healthregenbuff", "healthregenbuff")
            end
        end,
	},
	
	mead =
	{
		test = function(brewer, names, tags) return (names.honey or (names.kyno_syrup and names.kyno_syrup == 2)) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = -10,
		hunger = 70,
		sanity = 40,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DAMAGEREDUCTION,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food", "alcoholic_drink"},
	},
	
	juice_carrot =
	{
		test = function(brewer, names, tags) return names.carrot and (names.carrot == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 5,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_corn =
	{
		test = function(brewer, names, tags) return names.corn and (names.corn == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 5,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_eggplant =
	{
		test = function(brewer, names, tags) return names.eggplant and (names.eggplant == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 45,
		hunger = 5,
		sanity = 10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_pumpkin =
	{
		test = function(brewer, names, tags) return names.pumpkin and (names.pumpkin == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 5,
		sanity = 30,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_lichen =
	{
		test = function(brewer, names, tags) return names.cutlichen and (names.cutlichen == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 20,
		sanity = -10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_cactus =
	{
		test = function(brewer, names, tags) return (names.cactus_meat or (names.cactus_flower and names.cactus_flower == 2)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 40,
		hunger = 5,
		sanity = 40,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_garlic =
	{
		test = function(brewer, names, tags) return names.garlic and (names.garlic == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 5,
		sanity = -5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_asparagus =
	{
		test = function(brewer, names, tags) return names.asparagus and (names.asparagus == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 45,
		hunger = 5,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_onion =
	{
		test = function(brewer, names, tags) return names.onion and (names.onion == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 45,
		hunger = 5,
		sanity = -20,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_tomato =
	{
		test = function(brewer, names, tags) return names.tomato and (names.tomato == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 50,
		hunger = 15,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_potato =
	{
		test = function(brewer, names, tags) return names.potato and (names.potato == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 65,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_pepper =
	{
		test = function(brewer, names, tags) return names.pepper and (names.pepper == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 30,
		hunger = 25,
		sanity = 10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_redcap =
	{
		test = function(brewer, names, tags) return names.red_cap and (names.red_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = -10,
		hunger = 75,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_greencap =
	{
		test = function(brewer, names, tags) return names.green_cap and (names.green_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = -10,
		hunger = 0,
		sanity = 75,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_bluecap =
	{
		test = function(brewer, names, tags) return names.blue_cap and (names.blue_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 75,
		hunger = -10,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_mooncap =
	{
		test = function(brewer, names, tags) return names.moon_cap and (names.moon_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 30,
		sanity = 30,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SLEEP_RESISTANCE,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
		prefabs = { "buff_sleepresistance" },
        oneatenfn = function(inst, eater)
            if eater.components.grogginess ~= nil and
				(eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled()) and
					not (eater.components.health ~= nil and eater.components.health:IsDead()) and
					not eater:HasTag("playerghost") then
                if eater.components.grogginess ~= nil then
                    eater.components.grogginess:ResetGrogginess()
                end
                if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() then
                    eater.components.debuffable:AddDebuff("shroomsleepresist", "buff_sleepresistance")
                end
            end
        end,
	},
	
	juice_kelp =
	{
		test = function(brewer, names, tags) return names.kelp and (names.kelp == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 65,
		sanity = -20,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_avocado =
	{
		test = function(brewer, names, tags) return names.rock_avocado_fruit_ripe and (names.rock_avocado_fruit_ripe == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 45,
		sanity = 10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_whitecap =
	{
		test = function(brewer, names, tags) return names.kyno_white_cap and (names.kyno_white_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 62.5,
		sanity = -10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_aloe =
	{
		test = function(brewer, names, tags) return names.kyno_aloe and (names.kyno_aloe == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 50,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_radish =
	{
		test = function(brewer, names, tags) return names.kyno_radish and (names.kyno_radish == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 5,
		sanity = 15,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_sweetpotato =
	{
		test = function(brewer, names, tags) return names.kyno_sweetpotato and (names.kyno_sweetpotato == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 5,
		sanity = 60,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_lotus =
	{
		test = function(brewer, names, tags) return names.kyno_lotus_flower and (names.kyno_lotus_flower == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 20,
		hunger = 0,
		sanity = 60,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_seaweeds =
	{
		test = function(brewer, names, tags) return names.kyno_seaweeds and (names.kyno_seaweeds == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 0,
		hunger = 62.5,
		sanity = -10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_taroroot =
	{
		test = function(brewer, names, tags) return names.kyno_taroroot and (names.kyno_taroroot == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 0,
		hunger = 62.5,
		sanity = 33,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_waterycress =
	{
		test = function(brewer, names, tags) return names.kyno_waterycress and (names.kyno_waterycress == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 15,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_cucumber =
	{
		test = function(brewer, names, tags) return names.kyno_cucumber and (names.kyno_cucumber == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 15,
		sanity = 15,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_parznip =
	{
		test = function(brewer, names, tags) return (names.kyno_parznip or (names.kyno_parznip_eaten and names.kyno_parznip_eaten == 2)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 0,
		hunger = 20,
		sanity = 20,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_turnip =
	{
		test = function(brewer, names, tags) return names.kyno_turnip and (names.kyno_turnip == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 30,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
	},
	
	juice_fennel =
	{
		test = function(brewer, names, tags) return names.kyno_fennel and (names.kyno_fennel == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_SLOW,
		health = 35,
		hunger = 40,
		sanity = -20,
		cooktime = 72,
		floater = {"med", nil, 0.65},
		tags = {"drinkable_food"},
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
		no_brewbook = true,
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