-- These are permanent upgrade foods. Cooked at the Ancient Kiln, you can only eat them once.
-- They do not appear in the regular Cookbook because I want people to see them differently from regular food,
-- no Cooking Recipe Cards for them, that way you can't get to know they exist by just exploring the world.
-- Despite some of them looking like veggie or meat, they can still be eaten by all characters.

local kyno_foods_ancient =
{
	foodupgrade_health =
	{
		-- replace minotaurhorn with ancient seasoning.
		test = function(cooker, names, tags) return names.minotaurhorn and names.royal_jelly and tags.fruit
		and names.nightmarefuel end,
		priority = 100,
		foodtype = FOODTYPE.FOODUPGRADE,
		perishtime = nil,
		health = 60,
		hunger = 75,
		sanity = 50,
		cooktime = 2,
		potlevel = "low",
		overridebuild = "kyno_foodrecipes_ancient",
		floater = TUNING.HOF_FLOATER,
		card_def = {ingredients = {{"minotaurhorn", 1}, {"royal_jelly", 1}, {"cave_banana", 1}, {"nightmarefuel", 1}}},
	},
}

for k, recipe in pairs(kyno_foods_ancient) do
	recipe.name = k
	recipe.weight = 1
	recipe.overridebuild = recipe.overridebuild or k
	-- recipe.cookbook_ancient_atlas = "images/cookbookimages/hof_cookbookancientimages.xml"
	-- recipe.cookbook_ancient_tex = k..".tex"
end

return kyno_foods_ancient