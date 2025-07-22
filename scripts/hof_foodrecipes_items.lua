-- Thease are items, prefabs, etc that aren't technically food.
local kyno_foods_items =
{
	jawsbreaker =
	{
		test = function(cooker, names, tags) return names.kyno_shark_fin and (tags.sweetener and tags.sweetener >= 2) end,
		priority = 100,
		foodtype = FOODTYPE.GOODIES,
		secondaryfoodtype = FOODTYPE.MEAT, 
		perishtime = nil,
		health = -30,
		hunger = 12.5,
		sanity = 33,
		cooktime = 1,
		stacksize = 2,
		oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_JAWSBREAKER,
		floater = {"med", nil, 0.65},
		potlevel = "low",
		card_def = {ingredients = {{"kyno_shark_fin", 1}, {"honey", 3}}},
	},
}

for k, recipe in pairs(kyno_foods_items) do
	recipe.name = k
	recipe.weight = 1
	recipe.overridebuild = k
	recipe.cookbook_atlas = "images/cookbookimages/hof_cookbookimages.xml"
	recipe.cookbook_tex = k..".tex"
end

return kyno_foods_items