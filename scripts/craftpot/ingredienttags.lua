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

AddFoodTag("meat",           {name = "Meats",           atlas = "images/food_tags.xml"})
AddFoodTag("veggie",         {name = "Vegetables",      atlas = "images/food_tags.xml"})
AddFoodTag("fish",           {name = "Fish",            atlas = "images/food_tags.xml"})
AddFoodTag("sweetener",      {name = "Sweets",          atlas = "images/food_tags.xml"})
AddFoodTag("monster",        {name = "Monster Foods",   atlas = "images/food_tags.xml"})
AddFoodTag("fruit",          {name = "Fruits",          atlas = "images/food_tags.xml"})
AddFoodTag("egg",            {name = "Eggs",            atlas = "images/food_tags.xml"})
AddFoodTag("inedible",       {name = "Inedibles",       atlas = "images/food_tags.xml"})
AddFoodTag("frozen",         {name = "Ice",             atlas = "images/food_tags.xml"})
AddFoodTag("magic",          {name = "Magic",           atlas = "images/food_tags.xml"})
AddFoodTag("decoration",     {name = "Decoration",      atlas = "images/food_tags.xml"})
AddFoodTag("seed",           {name = "Seeds",           atlas = "images/food_tags.xml"})
AddFoodTag("dairy",          {name = "Dairies",         atlas = "images/food_tags.xml"})
AddFoodTag("fat",            {name = "Fat",             atlas = "images/food_tags.xml"})
AddFoodTag("alkaline",       {name = "Alkaline",        atlas = "images/food_tags.xml"})
AddFoodTag("flora",          {name = "Flora",           atlas = "images/food_tags.xml"})
AddFoodTag("fungus",         {name = "Fungi",           atlas = "images/food_tags.xml"})
AddFoodTag("leek",           {name = "Leek",            atlas = "images/food_tags.xml"})
AddFoodTag("citrus",         {name = "Citrus",          atlas = "images/food_tags.xml"})
AddFoodTag("dairy_alt",      {name = "Dairy",           atlas = "images/food_tags.xml"})
AddFoodTag("fat_alt",        {name = "Fat",             atlas = "images/food_tags.xml"})
AddFoodTag("mushrooms",      {name = "Mushrooms",       atlas = "images/food_tags.xml"})
AddFoodTag("nut",            {name = "Nuts",            atlas = "images/food_tags.xml"})
AddFoodTag("poultry",        {name = "Poultries",       atlas = "images/food_tags.xml"})
AddFoodTag("pungent",        {name = "Pungents",        atlas = "images/food_tags.xml"})
AddFoodTag("grapes",         {name = "Grapes",          atlas = "images/food_tags.xml"})
AddFoodTag("decoration_alt", {name = "Decoration",      atlas = "images/food_tags.xml"})
AddFoodTag("seed_alt",       {name = "Seeds",           atlas = "images/food_tags.xml"})
AddFoodTag("root",           {name = "Roots",           atlas = "images/food_tags.xml"})
AddFoodTag("seafood",        {name = "Seafood",         atlas = "images/food_tags.xml"})
AddFoodTag("shellfish",      {name = "Shellfish",       atlas = "images/food_tags.xml"})
AddFoodTag("spices",         {name = "Spices",          atlas = "images/food_tags.xml"})
AddFoodTag("wings",          {name = "Wings",           atlas = "images/food_tags.xml"})
AddFoodTag("monster_alt",    {name = "Monster Foods",   atlas = "images/food_tags.xml"})
AddFoodTag("sweetener_alt",  {name = "Sweets",          atlas = "images/food_tags.xml"})
AddFoodTag("squash",         {name = "Squash",          atlas = "images/food_tags.xml"})
AddFoodTag("starch",         {name = "Starch",          atlas = "images/food_tags.xml"})
AddFoodTag("tuber",          {name = "Tuber",           atlas = "images/food_tags.xml"})
AddFoodTag("precook",        {name = "Precooked",       atlas = "images/food_tags.xml"})
AddFoodTag("cactus",         {name = "Cactus",          atlas = "images/food_tags.xml"})

-- Heap of Foods Ingredients Tags.
AddFoodTag("algae",         {name = STRINGS_INGREDIENTS_ALGAE,      atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("cheese",        {name = STRINGS_INGREDIENTS_CHEESE,     atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("crab",          {name = STRINGS_INGREDIENTS_CRAB,       atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("foliage",       {name = STRINGS_INGREDIENTS_FOLIAGE,    atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("milk",          {name = STRINGS_INGREDIENTS_MILK,       atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("mussel",        {name = STRINGS_INGREDIENTS_MUSSEL,     atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("roe",           {name = STRINGS_INGREDIENTS_ROE,        atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("salmon",        {name = STRINGS_INGREDIENTS_SALMON,     atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("beanbug",       {name = STRINGS_INGREDIENTS_BEANBUG,    atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("gummybug",      {name = STRINGS_INGREDIENTS_GUMMYBUG,   atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("berries",       {name = STRINGS_INGREDIENTS_BERRIES,    atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("bacon",         {name = STRINGS_INGREDIENTS_BACON,      atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("limpet",        {name = STRINGS_INGREDIENTS_LIMPET,     atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("chocolate",     {name = STRINGS_INGREDIENTS_CHOCOLATE,  atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("banana",        {name = STRINGS_INGREDIENTS_BANANA,     atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("bread",         {name = STRINGS_INGREDIENTS_BREAD,      atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("sugar",         {name = STRINGS_INGREDIENTS_SUGAR,      atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("piko",          {name = STRINGS_INGREDIENTS_PIKO,       atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("spotspice",     {name = STRINGS_INGREDIENTS_SPOTSPICE,  atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("mayonnaise",    {name = STRINGS_INGREDIENTS_MAYONNAISE, atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("butter",        {name = STRINGS_INGREDIENTS_BUTTER,     atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("flour",         {name = STRINGS_INGREDIENTS_FLOUR,      atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("syrup",         {name = STRINGS_INGREDIENTS_SYRUP,      atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("wobster",       {name = STRINGS_INGREDIENTS_WOBSTER,    altas = "images/ingredientimages/hof_ingredientimages.xml"})