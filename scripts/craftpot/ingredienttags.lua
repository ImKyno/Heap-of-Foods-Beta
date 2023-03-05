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

AddFoodTag("meat",           {name = "Meats",         atlas = "images/food_tags.xml"})
AddFoodTag("veggie",         {name = "Vegetables",    atlas = "images/food_tags.xml"})
AddFoodTag("fish",           {name = "Fish",          atlas = "images/food_tags.xml"})
AddFoodTag("sweetener",      {name = "Sweets",        atlas = "images/food_tags.xml"})

AddFoodTag("monster",        {name = "Monster Foods", atlas = "images/food_tags.xml"})
AddFoodTag("fruit",          {name = "Fruits",        atlas = "images/food_tags.xml"})
AddFoodTag("egg",            {name = "Eggs",          atlas = "images/food_tags.xml"})
AddFoodTag("inedible",       {name = "Inedibles",     atlas = "images/food_tags.xml"})

AddFoodTag("frozen",         {name = "Ice",           atlas = "images/food_tags.xml"})
AddFoodTag("magic",          {name = "Magic",         atlas = "images/food_tags.xml"})
AddFoodTag("decoration",     {name = "Decoration",    atlas = "images/food_tags.xml"})
AddFoodTag("seed",           {name = "Seeds",         atlas = "images/food_tags.xml"})

AddFoodTag("dairy",          {name = "Dairies",       atlas = "images/food_tags.xml"})
AddFoodTag("fat",            {name = "Fat",           atlas = "images/food_tags.xml"})

AddFoodTag("alkaline",       {name = "Alkaline",      atlas = "images/food_tags.xml"})
AddFoodTag("flora",          {name = "Flora",         atlas = "images/food_tags.xml"})
AddFoodTag("fungus",         {name = "Fungi",         atlas = "images/food_tags.xml"})
AddFoodTag("leek",           {name = "Leek",          atlas = "images/food_tags.xml"})
AddFoodTag("citrus",         {name = "Citrus",        atlas = "images/food_tags.xml"})

AddFoodTag("dairy_alt",      {name = "Dairy",         atlas = "images/food_tags.xml"})
AddFoodTag("fat_alt",        {name = "Fat",           atlas = "images/food_tags.xml"})

AddFoodTag("mushrooms",      {name = "Mushrooms",     atlas = "images/food_tags.xml"})
AddFoodTag("nut",            {name = "Nuts",          atlas = "images/food_tags.xml"})
AddFoodTag("poultry",        {name = "Poultries",     atlas = "images/food_tags.xml"})
AddFoodTag("pungent",        {name = "Pungents",      atlas = "images/food_tags.xml"})
AddFoodTag("grapes",         {name = "Grapes",        atlas = "images/food_tags.xml"})

AddFoodTag("decoration_alt", {name = "Decoration",    atlas = "images/food_tags.xml"})
AddFoodTag("seed_alt",       {name = "Seeds",         atlas = "images/food_tags.xml"})

AddFoodTag("root",           {name = "Roots",         atlas = "images/food_tags.xml"})
AddFoodTag("seafood",        {name = "Seafood",       atlas = "images/food_tags.xml"})
AddFoodTag("shellfish",      {name = "Shellfish",     atlas = "images/food_tags.xml"})
AddFoodTag("spices",         {name = "Spices",        atlas = "images/food_tags.xml"})
AddFoodTag("wings",          {name = "Wings",         atlas = "images/food_tags.xml"})

AddFoodTag("monster_alt",    {name = "Monster Foods", atlas = "images/food_tags.xml"})
AddFoodTag("sweetener_alt",  {name = "Sweets",        atlas = "images/food_tags.xml"})

AddFoodTag("squash",         {name = "Squash",        atlas = "images/food_tags.xml"})
AddFoodTag("starch",         {name = "Starch",        atlas = "images/food_tags.xml"})
AddFoodTag("tuber",          {name = "Tuber",         atlas = "images/food_tags.xml"})
AddFoodTag("precook",        {name = "Precooked",     atlas = "images/food_tags.xml"})
AddFoodTag("cactus",         {name = "Cactus",        atlas = "images/food_tags.xml"})

-- Heap of Foods Ingredients Tags.
-- Cookers Tags.
AddFoodTag("algae",         {name = "Algaes",           atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("cheese",        {name = "Cheese",           atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("crab",          {name = "Crab Meat",        atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("foliage",       {name = "Foliage",          atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("milk",          {name = "Milk",             atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("mussel",        {name = "Mussel",           atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("roe",           {name = "Roe",              atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("salmon",        {name = "Salmon",           atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("beanbug",       {name = "Bean Bugs",        atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("gummybug",      {name = "Gummy Slug",       atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("berries",       {name = "Berries",          atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("bacon",         {name = "Bacon",            atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("limpet",        {name = "Limpet",           atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("chocolate",     {name = "Chocolate",        atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("banana",        {name = "Banana",           atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("bread",         {name = "Bread",            atlas = "images/ingredientimages/hof_ingredientimages.xml"})

-- Brewers Tags.
AddFoodTag("piko",          {name = "Piko",             atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("spotspice",     {name = "Spot Spice",       atlas = "images/ingredientimages/hof_ingredientimages.xml"})
AddFoodTag("mayonnaise",    {name = "Mayonnaise",       atlas = "images/ingredientimages/hof_ingredientimages.xml"})