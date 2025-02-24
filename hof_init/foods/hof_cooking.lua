-- Common Dependencies.
local _G           = GLOBAL
local require      = _G.require
local cooking      = require("cooking")
local CookbookData = require("cookbookdata")

require("hof_constants")
require("craftpot/ingredienttags")

-- New Vanilla Crock Pot Ingredients.
AddIngredientValues({"slurtle_shellpieces"}, 	{shell      = 1, 	elemental = 1})
AddIngredientValues({"rabbit"}, 				{rabbit     = 1})
AddIngredientValues({"firenettles"}, 			{veggie     = 0.5})
AddIngredientValues({"foliage"}, 				{veggie     = 0.25, foliage   = 1}, 		  true)
AddIngredientValues({"succulent_picked"}, 		{veggie     = 0.25})
AddIngredientValues({"petals"}, 				{decoration = 1})
AddIngredientValues({"gears"}, 					{gears      = 1})
AddIngredientValues({"rocks"}, 					{rocks      = 1, 	elemental = 1})
AddIngredientValues({"poop"}, 					{poop       = 1})
AddIngredientValues({"guano"}, 					{poop       = 1})
AddIngredientValues({"glommerfuel"}, 			{poop       = 1})
AddIngredientValues({"papyrus"},				{paper      = 1})
AddIngredientValues({"deerclops_eyeball"},      {inedible   = 1, 	boss      = 1})
AddIngredientValues({"bearger_fur"},            {inedible   = 1, 	boss      = 1})
AddIngredientValues({"horn"},					{horn       = 1})
AddIngredientValues({"kelp"},                   {veggie     = 0.5,  algae     = 0.5},   true, true)
AddIngredientValues({"goatmilk"},               {dairy      = 1,    milk      = 1})
AddIngredientValues({"berries"},                {fruit      = 0.5,  berries   = 1},           true)
AddIngredientValues({"berries_juicy"},          {fruit      = 0.5,  berries   = 1},           true)
AddIngredientValues({"cave_banana"},            {fruit      = 1,    banana    = 1},           true)
AddIngredientValues({"red_cap"},                {veggie     = 0.5,  mushrooms = 1},           true)
AddIngredientValues({"green_cap"},              {veggie     = 0.5,  mushrooms = 1},           true)
AddIngredientValues({"blue_cap"},               {veggie     = 0.5,  mushrooms = 1},           true)
AddIngredientValues({"moon_cap"},               {veggie     = 0.5,  mushrooms = 1},           true)
AddIngredientValues({"livinglog"},              {inedible   = 1,    magic     = 1})
AddIngredientValues({"spider"},                 {monster    = 1,    spider    = 1})
AddIngredientValues({"tillweed"},               {veggie     = 0.5,  weed      = 1})
AddIngredientValues({"wagpunk_bits"}, 			{junk       = 1})
AddIngredientValues({"butter"},                 {fat        = 1,    dairy     = 1,   butter   = 1})
AddIngredientValues({"baconeggs"},              {prepfood   = 1}) -- Could use meat tag, but I don't want people using this as "filler" lol.

-- New Mod Crock Pot Ingredients.
AddIngredientValues({"kyno_coffeebeans"}, 		{seeds      = 1}, 	 		  				  true)
AddIngredientValues({"kyno_shark_fin"}, 		{fish       = 1})
AddIngredientValues({"kyno_roe"}, 				{fish       = 0.25, meat = 0.25, roe = 1},    true)
AddIngredientValues({"kyno_mussel"}, 			{fish       = 0.5, 	mussel    = 1}, 		  true)
AddIngredientValues({"kyno_beanbugs"}, 			{beanbug    = 1, 	veggie    = 0.5}, 		  true)
AddIngredientValues({"kyno_gummybug"}, 			{gummybug   = 1, 	veggie    = 0.5}, 		  true)
AddIngredientValues({"kyno_humanmeat"}, 		{meat       = 1, 	monster   = 1}, 	true, true)
AddIngredientValues({"kyno_syrup"}, 			{sweetener  = 1,    syrup     = 1})
AddIngredientValues({"kyno_flour"}, 			{inedible   = 1, 	flour     = 1})
AddIngredientValues({"kyno_spotspice"},			{spotspice  = 1})
AddIngredientValues({"kyno_bacon"}, 			{meat       = 0.5, 	bacon     = 1}, 		  true)
AddIngredientValues({"gorge_bread"}, 			{bread      = 1})
AddIngredientValues({"kyno_white_cap"}, 		{veggie     = 0.5, 	mushrooms = 1},		      true)
AddIngredientValues({"kyno_foliage"}, 			{veggie     = 0.25, foliage   = 1}, 		  true)
AddIngredientValues({"kyno_sap"}, 				{inedible   = 1, 	sap       = 1})
AddIngredientValues({"kyno_aloe"}, 				{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_radish"}, 			{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_fennel"}, 			{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_sweetpotato"}, 		{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_lotus_flower"}, 		{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_seaweeds"}, 			{veggie     = 1,    algae      = 1},    true, true)
AddIngredientValues({"kyno_limpets"}, 			{fish       = 0.5,  limpet     = 1}, 		  true)
AddIngredientValues({"kyno_taroroot"}, 			{veggie     = 1},                             true)
AddIngredientValues({"kyno_cucumber"}, 			{veggie     = 1},                             true)
AddIngredientValues({"kyno_waterycress"}, 		{veggie     = 1,    algae      = 1})
AddIngredientValues({"kyno_salt"}, 				{inedible   = 1})
AddIngredientValues({"kyno_parznip"}, 			{veggie     = 1},                             true)
AddIngredientValues({"kyno_parznip_eaten"}, 	{veggie     = 1},                             true)
AddIngredientValues({"kyno_turnip"}, 			{veggie     = 1},                             true)
AddIngredientValues({"kyno_banana"}, 			{fruit      = 1,    banana     = 1},          true)
AddIngredientValues({"kyno_kokonut_halved"}, 	{fruit      = 1})
AddIngredientValues({"kyno_kokonut_cooked"}, 	{fruit      = 1})
AddIngredientValues({"kyno_twiggynuts"}, 		{seeds      = 1,    fruit      = 0.5})
AddIngredientValues({"kyno_grouper"},			{fish       = 1,    meat       = 1},          true)
AddIngredientValues({"kyno_neonfish"},			{fish       = 1,    meat       = 1},          true)
AddIngredientValues({"kyno_koi"},			    {fish       = 1,    meat       = 1},          true)
AddIngredientValues({"kyno_tropicalfish"},		{fish       = 0.5,  meat       = 0.5},		  true)
AddIngredientValues({"kyno_pierrotfish"},		{fish       = 0.5,  meat       = 0.5},		  true)
AddIngredientValues({"kyno_salmonfish"},		{fish       = 1,    salmon     = 1},          true)
AddIngredientValues({"kyno_crabmeat"},			{meat       = 0.5,  crab       = 1},          true)
AddIngredientValues({"kyno_crabmeat_dried"},	{meat       = 0.5,  crab       = 1})
AddIngredientValues({"kyno_crabkingmeat"},      {meat       = 1,    crab       = 2})
AddIngredientValues({"kyno_chicken_egg"},		{egg        = 1},                             true)
AddIngredientValues({"kyno_bottle_soul"},		{soul       = 1})
AddIngredientValues({"kyno_milk_beefalo"},		{dairy      = 0.5,  milk       = 1})
AddIngredientValues({"kyno_milk_koalefant"},	{dairy      = 0.5,  milk       = 1})
AddIngredientValues({"kyno_sugartree_petals"},	{sweetener  = 0.5,  sugar      = 0.5})
AddIngredientValues({"kyno_sugarflywings"},     {decoration = 2,    sugar      = 0.5})
AddIngredientValues({"cheese_yellow"},			{dairy      = 1,    cheese     = 1})
AddIngredientValues({"cheese_white"},			{dairy      = 1,    cheese     = 1})
AddIngredientValues({"cheese_koalefant"},		{dairy      = 1,    cheese     = 1})
AddIngredientValues({"milk_box"},				{dairy      = 1,    milk       = 2})
AddIngredientValues({"kyno_red_cap_dried"}, 	{veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_green_cap_dried"}, 	{veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_blue_cap_dried"}, 	{veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_moon_cap_dried"}, 	{veggie     = 0.5,  mushrooms  = 1})
AddIngredientValues({"kyno_plantmeat_dried"},   {meat       = 1})
AddIngredientValues({"kyno_piko"},              {piko       = 1})
AddIngredientValues({"kyno_piko_orange"},       {piko       = 1})
AddIngredientValues({"kyno_poison_froglegs"},   {meat       = 0.5},                     true, true)
AddIngredientValues({"kyno_oil"},               {oil        = 1})
AddIngredientValues({"chocolate_black"},        {sweetener  = 2,    chocolate  = 1})
AddIngredientValues({"chocolate_white"},        {sweetener  = 2,    chocolate  = 1})
AddIngredientValues({"littlebread"}, 			{bread      = 1})
AddIngredientValues({"kyno_sugar"},             {sweetener  = 1,    sugar      = 1})
AddIngredientValues({"kyno_wheat"},             {seeds      = 1},                            true)
AddIngredientValues({"kyno_rice"},              {veggie     = 0.5,  seeds      = 0.5},       true)
AddIngredientValues({"kyno_pineapple_halved"},  {fruit      = 1})
AddIngredientValues({"kyno_pineapple_cooked"},  {fruit      = 1})
AddIngredientValues({"kyno_worm_bone"},         {inedible   = 1})
AddIngredientValues({"butter_beefalo"},         {dairy      = 1,    fat       = 1,     butter = 1})
AddIngredientValues({"butter_goat"},            {dairy      = 1,    fat       = 1,     butter = 1})
AddIngredientValues({"butter_koalefant"},       {dairy      = 1,    fat       = 1,     butter = 1})
AddIngredientValues({"kyno_tealeaf"},           {leaf       = 1})

-- Import the Foods.
local cookpots = 
{
	"cookpot", 
	"portablecookpot", 
	"archive_cookpot",
	"kyno_cookware_syrup",
	"kyno_cookware_small",
	"kyno_cookware_big",
	"kyno_cookware_small_grill",
	"kyno_cookware_grill",
	"kyno_cookware_oven_small_casserole",
	"kyno_cookware_oven_casserole",
	"kyno_cookware_elder",
}

local cookpots_master  = {"portablecookpot"}
local cookpots_spicer  = {"portablespicer"}

local common_recipes   = require("hof_foodrecipes")
local seasonal_recipes = require("hof_foodrecipes_seasonal")
local warly_recipes    = require("hof_foodrecipes_warly")
local spiced_recipes   = require("hof_foodspicer")
local recipe_cards     = cooking.recipe_cards

for _, cooker in pairs(cookpots)         do for _, recipe in pairs(common_recipes)   do AddCookerRecipe(cooker, recipe) end end
for _, cooker in pairs(cookpots)         do for _, recipe in pairs(seasonal_recipes) do AddCookerRecipe(cooker, recipe) end end
for _, cooker in pairs(cookpots_master)  do for _, recipe in pairs(warly_recipes)    do AddCookerRecipe(cooker, recipe) end end
for _, cooker in pairs(cookpots_spicer)  do for _, recipe in pairs(spiced_recipes)   do AddCookerRecipe(cooker, recipe) end end

for _, recipe in pairs(common_recipes)   do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "cookpot"}) end end
for _, recipe in pairs(seasonal_recipes) do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "cookpot"}) end end
for _, recipe in pairs(warly_recipes)    do if recipe.card_def then table.insert(recipe_cards, {recipe_name = recipe.name, cooker_name = "portablecookpot"}) end end

-- Previous dirty fix don't work anymore, will be using this one for now...
local testfoods = {}
for k, v in pairs(_G.MergeMaps(require("hof_foodrecipes"), require("hof_foodrecipes_seasonal"), require("hof_foodrecipes_warly"))) do 
	testfoods[k] = true 
end

AddPrefabPostInit("portablespicer", function(inst)
	if _G.TheWorld.ismastersim then	
		local function ShowProduct(inst)
			local product = inst.components.stewer.product
			local recipe = cooking.GetRecipe(inst.prefab, product)
			
			if recipe ~= nil then
				product = recipe.basename or product
			end
			
			if testfoods[product] then
				inst.AnimState:OverrideSymbol("swap_cooked", product, product)
			end
		end
		
		local _continuedonefn = inst.components.stewer.oncontinuedone
		local _donecookfn = inst.components.stewer.ondonecooking
		
		inst.components.stewer.oncontinuedone = function(inst) _continuedonefn(inst) ShowProduct(inst) end
		inst.components.stewer.ondonecooking = function(inst) _donecookfn(inst) ShowProduct(inst) end
	end
end)

-- Inject Warly recipes in Chef's Specials page instead of Mod Recipes page in the Cookbook.
-- I'm not sure if this can lead to problems in the future, will leave it on for now.
local HOF_WARLYRECIPES = GetModConfigData("WARLYRECIPES")
if HOF_WARLYRECIPES then
	for k, recipe in pairs(warly_recipes) do
		cooking.cookbook_recipes["mod"][k] = nil
		cooking.cookbook_recipes["portablecookpot"][k] = recipe
		recipe.cookbook_category = "portablecookpot" -- Need this here so it can properly register the recipes.
	end
end