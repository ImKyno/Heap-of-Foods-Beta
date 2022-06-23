-- Informations about these foods:
-- Cooktimes: 24 = 1 Day. | 48 = 2 Days. | 72 = 3 Days. | 120 = 5 Days. | 168 = 7 Days. | 240 = 10 Days. | 360 = 15 Days. | 480 = 20 Days.
-- These recipes don't appear in the Cookbook since they're "special" and not from the Crcok Pot.
-- They took several days to produce, just like the real life / Stardew Valley mechanics.

local kyno_foods_jar =
{
	-- Preserves Jar Recipes.
	jelly_berries = 
	{
		test = function(brewer, names, tags) return names.berries and (names.berries == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 12,
		hunger = 20,
		sanity = 0,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_berries_juicy = 
	{
		test = function(brewer, names, tags) return names.berries_juicy and (names.berries_juicy == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 20,
		sanity = 12,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_pomegranate = 
	{
		test = function(brewer, names, tags) return names.pomegranate and (names.pomegranate == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 20,
		sanity = 5,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_dragonfruit = 
	{
		test = function(brewer, names, tags) return names.dragonfruit and (names.dragonfruit == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 20,
		sanity = 15,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_cave_banana = 
	{
		test = function(brewer, names, tags) return names.cave_banana and (names.cave_banana == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 20,
		sanity = 5,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_durian = 
	{
		test = function(brewer, names, tags) return names.durian and (names.durian == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = -3,
		hunger = 35,
		sanity = -5,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_watermelon = 
	{
		test = function(brewer, names, tags) return names.watermelon and (names.watermelon == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 15,
		sanity = 20,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_fig = 
	{
		test = function(brewer, names, tags) return names.fig and (names.fig == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 25,
		sanity = 15,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_banana = 
	{
		test = function(brewer, names, tags) return names.kyno_banana and (names.kyno_banana == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 15,
		sanity = 10,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_kokonut = 
	{
		test = function(brewer, names, tags) return (names.kyno_kokonut_halved or (names.kyno_kokonut_cooked and names.kyno_kokonut_cooked == 2)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 20,
		sanity = 33,
		cooktime = 48,
		floater = {"med", nil, 0.65},
	},
	
	jelly_glowberry = 
	{
		test = function(brewer, names, tags) return (names.wormlight or (names.wormlight_lesser and names.wormlight_lesser == 2)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = -10,
		cooktime = 48,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_GLOW,
		floater = {"med", nil, 0.65},
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
	
	mayonnaise = 
	{
		test = function(brewer, names, tags) return tags.egg and tags.veggie end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 10,
		hunger = 12.5,
		sanity = 15,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		floater = {"med", nil, 0.65},
		prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
            end
        end,
	},
	
	mayonnaise_chicken = 
	{
		test = function(brewer, names, tags) return names.kyno_chicken_egg and tags.veggie end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 0,
		hunger = 25,
		sanity = 25,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		floater = {"med", nil, 0.65},
		prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
            end
        end,
	},
	
	mayonnaise_tallbird = 
	{
		test = function(brewer, names, tags) return names.tallbirdegg and tags.veggie end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SLOW,
		health = 30,
		hunger = 12.5,
		sanity = 5,
		cooktime = 24,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_REHUNGER,
		floater = {"med", nil, 0.65},
		prefabs = { "kyno_hungerregenbuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_hungerregenbuff", "kyno_hungerregenbuff")
            end
        end,
	},
	
	mayonnaise_nightmare =
	{
		test = function(brewer, names, tags) return names.nightmarefuel and tags.egg end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_SUPERSLOW,
		health = 30,
		hunger = 62.5,
		sanity = -5,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_DESANITY,
		floater = {"med", nil, 0.65},
		prefabs = { "kyno_insanitybuff" },
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("kyno_insanitybuff", "kyno_insanitybuff")
            end
        end,
	},
	
	tartarsauce = 
	{
		test = function(brewer, names, tags) return names.mayonnaise and names.kyno_spotspice end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 62.5,
		sanity = 5,
		cooktime = 50,
		floater = {"med", nil, 0.65},
	},
	
	pickles_carrot = 
	{
		test = function(brewer, names, tags) return names.carrot and (names.carrot == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 30,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_corn = 
	{
		test = function(brewer, names, tags) return names.corn and (names.corn == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 35,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_eggplant = 
	{
		test = function(brewer, names, tags) return names.eggplant and (names.eggplant == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 25,
		sanity = 1,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_pumpkin = 
	{
		test = function(brewer, names, tags) return names.pumpkin and (names.pumpkin == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 0,
		sanity = 50,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_lichen = 
	{
		test = function(brewer, names, tags) return names.cutlichen and (names.cutlichen == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 15,
		sanity = -15,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_cactus = 
	{
		test = function(brewer, names, tags) return (names.cactus_meat or (names.cactus_flower and names.cactus_flower == 2)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = -10,
		hunger = 15,
		sanity = 50,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_garlic = 
	{
		test = function(brewer, names, tags) return names.garlic and (names.garlic == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 15,
		hunger = 32,
		sanity = -20,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_asparagus = 
	{
		test = function(brewer, names, tags) return names.asparagus and (names.asparagus == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 12,
		hunger = 62.5,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_onion = 
	{
		test = function(brewer, names, tags) return names.onion and (names.onion == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = -20,
		hunger = 62.5,
		sanity = 50,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_tomato = 
	{
		test = function(brewer, names, tags) return names.tomato and (names.tomato == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 35,
		hunger = 62.5,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_potato = 
	{
		test = function(brewer, names, tags) return names.potato and (names.potato == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 70,
		sanity = -10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_pepper = 
	{
		test = function(brewer, names, tags) return names.pepper and (names.pepper == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		temperature = TUNING.HOT_FOOD_BONUS_TEMP,
		temperatureduration = TUNING.FOOD_TEMP_AVERAGE,
		health = 25,
		hunger = 25,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_redcap = 
	{
		test = function(brewer, names, tags) return names.red_cap and (names.red_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = -5,
		hunger = 50,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_greencap = 
	{
		test = function(brewer, names, tags) return names.green_cap and (names.green_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 5,
		sanity = 50,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_bluecap = 
	{
		test = function(brewer, names, tags) return names.blue_cap and (names.blue_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 50,
		hunger = 5,
		sanity = -5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_mooncap = 
	{
		test = function(brewer, names, tags) return names.moon_cap and (names.moon_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 25,
		sanity = 15,
		cooktime = 72,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_SLEEP_RESISTANCE,
		floater = {"med", nil, 0.65},
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
	
	pickles_kelp = 
	{
		test = function(brewer, names, tags) return names.kelp and (names.kelp == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 20,
		sanity = -5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_avocado = 
	{
		test = function(brewer, names, tags) return names.rock_avocado_fruit_ripe and (names.rock_avocado_fruit_ripe == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 12,
		hunger = 33,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_whitecap = 
	{
		test = function(brewer, names, tags) return names.kyno_white_cap and (names.kyno_white_cap == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 25,
		sanity = 25,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_aloe = 
	{
		test = function(brewer, names, tags) return names.kyno_aloe and (names.kyno_aloe == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 33,
		hunger = 15,
		sanity = 15,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_radish = 
	{
		test = function(brewer, names, tags) return names.kyno_radish and (names.kyno_radish == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 62.5,
		sanity = 20,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_sweetpotato = 
	{
		test = function(brewer, names, tags) return names.kyno_sweetpotato and (names.kyno_sweetpotato == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 25,
		hunger = 62.5,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_lotus = 
	{
		test = function(brewer, names, tags) return names.kyno_lotus_flower and (names.kyno_lotus_flower == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 33,
		sanity = 33,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_seaweeds = 
	{
		test = function(brewer, names, tags) return names.kyno_seaweeds and (names.kyno_seaweeds == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 62.5,
		sanity = -15,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_taroroot = 
	{
		test = function(brewer, names, tags) return names.kyno_taroroot and (names.kyno_taroroot == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 15,
		sanity = 5,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_waterycress = 
	{
		test = function(brewer, names, tags) return names.kyno_waterycress and (names.kyno_waterycress == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 20,
		hunger = 15,
		sanity = 30,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_cucumber = 
	{
		test = function(brewer, names, tags) return names.kyno_cucumber and (names.kyno_cucumber == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 50,
		sanity = 20,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_parznip = 
	{
		test = function(brewer, names, tags) return (names.kyno_parznip or (names.kyno_parznip_eaten and names.kyno_parznip_eaten == 2)) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 0,
		hunger = 75,
		sanity = 10,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_turnip = 
	{
		test = function(brewer, names, tags) return names.kyno_turnip and (names.kyno_turnip == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 10,
		hunger = 75,
		sanity = 0,
		cooktime = 72,
		floater = {"med", nil, 0.65},
	},
	
	pickles_fennel = 
	{
		test = function(brewer, names, tags) return names.kyno_fennel and (names.kyno_fennel == 2) end,
		priority = 30,
		foodtype = FOODTYPE.VEGGIE,
		perishtime = TUNING.PERISH_MED,
		health = 30,
		hunger = 40,
		sanity = -15,
		cooktime = 72,
		floater = {"med", nil, 0.65},
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
		cooktime = 2,
		no_brewbook = true,
        floater = {"small", nil, nil},
	},
}

for k, recipe in pairs(kyno_foods_jar) do
	recipe.name = k
	recipe.weight = 1
	recipe.brewbook_category = "jar"
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods_jar