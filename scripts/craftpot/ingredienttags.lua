global("FOODTAGDEFINITIONS")
FOODTAGDEFINITIONS = FOODTAGDEFINITIONS or {}

global("AddFoodTag")
AddFoodTag = function(tag, data)
	local mergedData = FOODTAGDEFINITIONS[tag] or {}

	for k, v in pairs(data) do
		mergedData[k] = v
	end

	FOODTAGDEFINITIONS[tag] = mergedData
end

-- Heap of Foods Ingredients Tags.
AddFoodTag("algae",             { name = STRINGS_INGREDIENTS_ALGAE,      atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("cheese",            { name = STRINGS_INGREDIENTS_CHEESE,     atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("crab",              { name = STRINGS_INGREDIENTS_CRAB,       atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("foliage",           { name = STRINGS_INGREDIENTS_FOLIAGE,    atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("milk",              { name = STRINGS_INGREDIENTS_MILK,       atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("mussel",            { name = STRINGS_INGREDIENTS_MUSSEL,     atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("roe",               { name = STRINGS_INGREDIENTS_ROE,        atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("salmon",            { name = STRINGS_INGREDIENTS_SALMON,     atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("beanbug",           { name = STRINGS_INGREDIENTS_BEANBUG,    atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("gummybug",          { name = STRINGS_INGREDIENTS_GUMMYBUG,   atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("berries",           { name = STRINGS_INGREDIENTS_BERRIES,    atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("bacon",             { name = STRINGS_INGREDIENTS_BACON,      atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("limpet",            { name = STRINGS_INGREDIENTS_LIMPET,     atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("chocolate",         { name = STRINGS_INGREDIENTS_CHOCOLATE,  atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("banana",            { name = STRINGS_INGREDIENTS_BANANA,     atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("bread",             { name = STRINGS_INGREDIENTS_BREAD,      atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("sugar",             { name = STRINGS_INGREDIENTS_SUGAR,      atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("piko",              { name = STRINGS_INGREDIENTS_PIKO,       atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("spotspice",         { name = STRINGS_INGREDIENTS_SPOTSPICE,  atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("mayonnaise",        { name = STRINGS_INGREDIENTS_MAYONNAISE, atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("butter",            { name = STRINGS_INGREDIENTS_BUTTER,     atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("flour",             { name = STRINGS_INGREDIENTS_FLOUR,      atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("syrup",             { name = STRINGS_INGREDIENTS_SYRUP,      atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("wobster",           { name = STRINGS_INGREDIENTS_WOBSTER,    atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("oil",               { name = STRINGS_INGREDIENTS_OIL,        atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("jellyfish",         { name = STRINGS_INGREDIENTS_JELLYFISH,  atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("jellyfish_rainbow", { name = STRINGS_INGREDIENTS_JELLYFISH2, atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("swordfish",         { name = STRINGS_INGREDIENTS_SWORDFISH,  atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("succulent",         { name = STRINGS_INGREDIENTS_SUCCULENT,  atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("fireweed",          { name = STRINGS_INGREDIENTS_FIREWEED,   atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("forgetweed",        { name = STRINGS_INGREDIENTS_FORGETWEED, atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("tillweed",          { name = STRINGS_INGREDIENTS_TILLWEED,   atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("chicken",           { name = STRINGS_INGREDIENTS_CHICKEN,    atlas = "images/ingredientimages/hof_ingredientimages.xml" })
AddFoodTag("chickenegg",        { name = STRINGS_INGREDIENTS_CHICKENEGG, atlas = "images/ingredientimages/hof_ingredientimages.xml" })