-- Informations about these foods:
-- Cooktimes: 24 = 1 Day. | 48 = 2 Days. | 72 = 3 Days. | 120 = 5 Days. | 168 = 7 Days. | 240 = 10 Days. | 360 = 15 Days. | 480 = 20 Days.
-- These recipes don't appear in the Cookbook since they're "special" and not from the Crcok Pot.
-- They took several days to produce, just like the real life / Stardew Valley mechanics.

local kyno_brews =
{
	-- Keg Recipes.
	beer =
	{
		test = function(cooker, names, tags) return names.kyno_wheat and (names.kyno_wheat == 2) end,
		priority = 30,
		foodtype = FOODTYPE.GOODIES,
		perishtime = TUNING.PERISH_MED,
		health = 5,
		hunger = 12.5,
		sanity = -10,
		cooktime = 24,
		no_cookbook = true,
		floater = {"med", nil, 0.65},
	},
	
	-- This recipe is for when brewing a invalid product, we need this to prevent a crash.
	wetgoop2 =
	{
		test = function(cooker, names, tags) return true end,
		priority = -2,
		perishtime = TUNING.PERISH_FAST,
		health = 0,
		hunger = 0,
		sanity = 0,
		cooktime = 2,
		no_cookbook = true,
        floater = {"small", nil, nil},
	},
}

for k, recipe in pairs(kyno_brews) do
	recipe.name = k
	recipe.weight = 1
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_brews