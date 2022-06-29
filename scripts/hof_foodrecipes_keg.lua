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
		tags = {"drinkable_food"},
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
		tags = {"drinkable_food"},
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
		cooktime = 48,
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
		cooktime = 48,
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