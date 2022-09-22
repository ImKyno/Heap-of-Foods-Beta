-- Common Dependencies.
local _G 					= GLOBAL
local require 				= _G.require

require("cooking")
require("hof_constants")
require("craftpot/ingredienttags")

-- New Vanilla Crock Pot Ingredients.
AddIngredientValues({"slurtle_shellpieces"}, 	{inedible   = 1, 	elemental = 1,	 shell    = 1})
AddIngredientValues({"rabbit"}, 				{rabbit     = 1})
AddIngredientValues({"firenettles"}, 			{veggie     = 0.5})
AddIngredientValues({"foliage"}, 				{veggie     = 0.5,  foliage   = 1}, 		  true)
AddIngredientValues({"succulent_picked"}, 		{veggie     = 0.5})
AddIngredientValues({"petals"}, 				{veggie     = 0.5})
AddIngredientValues({"gears"}, 					{gears      = 1,	inedible  = 1})
AddIngredientValues({"rocks"}, 					{rocks      = 1, 	elemental = 1,   inedible = 1})
AddIngredientValues({"poop"}, 					{poop       = 1, 	inedible  = 1})
AddIngredientValues({"guano"}, 					{poop       = 1, 	inedible  = 1})
AddIngredientValues({"glommerfuel"}, 			{poop       = 1, 	inedible  = 1})
AddIngredientValues({"papyrus"},				{paper      = 1})
AddIngredientValues({"deerclops_eyeball"},      {inedible   = 1, 	boss      = 1})
AddIngredientValues({"horn"},					{horn       = 1})
AddIngredientValues({"kelp"},                   {veggie     = 0.5,  algae     = 1},     true, true)
AddIngredientValues({"goatmilk"},               {dairy      = 1,    milk      = 1})
AddIngredientValues({"berries"},                {fruit      = 0.5,  berries   = 1},           true)
AddIngredientValues({"berries_juicy"},          {fruit      = 0.5,  berries   = 1},           true)

-- New Mod Crock Pot Ingredients.
AddIngredientValues({"kyno_coffeebeans"}, 		{seeds      = 1}, 	 		  				  true)
AddIngredientValues({"kyno_shark_fin"}, 		{fish       = 1})
AddIngredientValues({"kyno_roe"}, 				{meat       = 0.5, 	roe       = 1}, 		  true)
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
-- This is a false Foliage. We just need it because Cooked Foliage icon doesn't display without it.
AddIngredientValues({"kyno_foliage"}, 			{veggie     = 0.5,  foliage   = 1}, 		  true)
AddIngredientValues({"kyno_sap"}, 				{inedible   = 1, 	sap       = 1})
AddIngredientValues({"kyno_aloe"}, 				{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_radish"}, 			{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_fennel"}, 			{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_sweetpotato"}, 		{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_lotus_flower"}, 		{veggie     = 1}, 						      true)
AddIngredientValues({"kyno_seaweeds"}, 			{veggie     = 1,   algae      = 1},     true, true)
AddIngredientValues({"kyno_limpets"}, 			{fish       = 0.5, limpets    = 1}, 		  true)
AddIngredientValues({"kyno_taroroot"}, 			{veggie     = 1},                             true)
AddIngredientValues({"kyno_cucumber"}, 			{veggie     = 1})
AddIngredientValues({"kyno_waterycress"}, 		{veggie     = 1,   algae      = 1})
AddIngredientValues({"kyno_salt"}, 				{inedible   = 1})
AddIngredientValues({"kyno_parznip"}, 			{veggie     = 1},                             true)
AddIngredientValues({"kyno_parznip_eaten"}, 	{veggie     = 1},                             true)
AddIngredientValues({"kyno_turnip"}, 			{veggie     = 1},                             true)
AddIngredientValues({"kyno_banana"}, 			{fruit      = 1},                             true)
AddIngredientValues({"kyno_kokonut_halved"}, 	{fruit      = 1})
AddIngredientValues({"kyno_kokonut_cooked"}, 	{fruit      = 1})
AddIngredientValues({"kyno_twiggynuts"}, 		{seeds      = 1,   fruit      = 0.5})
AddIngredientValues({"kyno_grouper"},			{fish       = 1,   meat       = 1},			  true)
AddIngredientValues({"kyno_neonfish"},			{fish       = 1,   meat       = 1},			  true)
AddIngredientValues({"kyno_koi"},			    {fish       = 1,   meat       = 1},			  true)
AddIngredientValues({"kyno_tropicalfish"},		{fish       = 0.5, meat       = 0.5},		  true)
AddIngredientValues({"kyno_pierrotfish"},		{fish       = 0.5, meat       = 0.5},		  true)
AddIngredientValues({"kyno_salmonfish"},		{fish       = 1,   salmon     = 1},		      true)
AddIngredientValues({"kyno_sugartree_petals"},	{sweetener  = 1})
AddIngredientValues({"kyno_crabmeat"},			{meat       = 0.5, crab       = 1},           true)
AddIngredientValues({"kyno_chicken_egg"},		{egg        = 1},                             true)
AddIngredientValues({"kyno_bottle_soul"},		{soul       = 1})
AddIngredientValues({"kyno_milk_beefalo"},		{dairy      = 0.5, milk       = 1})
AddIngredientValues({"kyno_milk_koalefant"},	{dairy      = 0.5, milk       = 1})
AddIngredientValues({"kyno_milk_deer"},			{dairy      = 0.5, milk       = 1})
AddIngredientValues({"kyno_milk_spat"},			{dairy      = 0.5, milk       = 1})
AddIngredientValues({"kyno_sugarflywings"},     {decoration = 2})
AddIngredientValues({"cheese_yellow"},			{dairy      = 1,   cheese     = 1})
AddIngredientValues({"cheese_white"},			{dairy      = 1,   cheese     = 1})
AddIngredientValues({"cheese_koalefant"},		{dairy      = 1,   cheese     = 1})
AddIngredientValues({"milk_box"},				{dairy      = 1,   milk       = 2})
AddIngredientValues({"kyno_red_cap_dried"}, 	{veggie     = 0.5, mushrooms  = 1})
AddIngredientValues({"kyno_green_cap_dried"}, 	{veggie     = 0.5, mushrooms  = 1})
AddIngredientValues({"kyno_blue_cap_dried"}, 	{veggie     = 0.5, mushrooms  = 1})
AddIngredientValues({"kyno_moon_cap_dried"}, 	{veggie     = 0.5, mushrooms  = 1})
AddIngredientValues({"kyno_plantmeat_dried"},   {meat       = 1})
AddIngredientValues({"kyno_piko"},              {piko       = 1})
AddIngredientValues({"kyno_piko_orange"},       {piko       = 1})
AddIngredientValues({"kyno_poison_froglegs"},   {meat       = 0.5},                    true, true) 

-- Icons For Cookbook.
local cookbook_icons = 
{
	"kyno_coffeebeans_cooked.tex",
	"kyno_coffeebeans.tex",
	"kyno_shark_fin.tex",
	"ecp_shark_fin.tex",
	"kyno_roe_cooked.tex",
	"kyno_roe.tex",
	"kyno_mussel_cooked.tex",
	"kyno_mussel.tex",
	"kyno_beanbugs_cooked.tex",
	"kyno_beanbugs.tex",
	"kyno_gummybug_cooked.tex",
	"kyno_gummybug.tex",
	"kyno_humanmeat_cooked.tex",
	"kyno_humanmeat.tex",
	"kyno_humanmeat_dried.tex",
	"kyno_syrup.tex",
	"kyno_flour.tex",
	"kyno_spotspice.tex",
	"kyno_bacon_cooked.tex",
	"kyno_bacon.tex",
	"gorge_bread.tex",
	"kyno_white_cap_cooked.tex",
	"kyno_white_cap.tex",
	"kyno_foliage_cooked.tex",
	"kyno_foliage.tex",
	"kyno_sap.tex",
	"kyno_aloe_cooked.tex",
	"kyno_aloe.tex",
	"kyno_radish_cooked.tex",
	"kyno_radish.tex",
	"kyno_fennel_cooked.tex",
	"kyno_fennel.tex",
	"kyno_sweetpotato_cooked.tex",
	"kyno_sweetpotato.tex",
	"kyno_lotus_flower_cooked.tex",
	"kyno_lotus_flower.tex",
	"kyno_seaweeds_cooked.tex",
	"kyno_seaweeds.tex",
	"kyno_seaweeds_dried.tex",
	"kyno_limpets_cooked.tex",
	"kyno_limpets.tex",
	"kyno_taroroot_cooked.tex",
	"kyno_taroroot.tex",
	"kyno_cucumber.tex",
	"kyno_waterycress.tex",
	"kyno_salt.tex",
	"kyno_parznip_cooked.tex",
	"kyno_parznip.tex",
	"kyno_parznip_eaten.tex",
	"kyno_turnip_cooked.tex",
	"kyno_turnip.tex",
	"kyno_banana_cooked.tex",
	"kyno_banana.tex",
	"kyno_kokonut_cooked.tex",
	"kyno_kokonut_halved.tex",
	"kyno_twiggynuts.tex",
	"kyno_neonfish_cooked.tex",
	"kyno_neonfish.tex",
	"kyno_grouper_cooked.tex",
	"kyno_grouper.tex",
	"kyno_pierrotfish_cooked.tex",
	"kyno_pierrotfish.tex",
	"kyno_koi_cooked.tex",
	"kyno_koi.tex",
	"kyno_salmonfish_cooked.tex",
	"kyno_salmonfish.tex",
	"kyno_tropicalfish.tex",
	"kyno_sugartree_petals.tex",
	"kyno_crabmeat_cooked.tex",
	"kyno_crabmeat.tex",
	"kyno_chicken_egg_cooked.tex",
	"kyno_chicken_egg.tex",
	"kyno_bottle_soul.tex",
	"kyno_milk_beefalo.tex",
	"kyno_milk_koalefant.tex",
	"kyno_milk_deer.tex",
	"kyno_milk_spat.tex",
	"cheese_yellow.tex",
	"cheese_white.tex",
	"cheese_koalefant.tex",
	"milk_box.tex",
	"kyno_red_cap_dried.tex",
	"kyno_green_cap_dried.tex",
	"kyno_blue_cap_dried.tex",
	"kyno_moon_cap_dried.tex",
	"kyno_piko.tex",
	"kyno_piko_orange.tex",
	"kyno_poison_froglegs.tex",
	"kyno_poison_froglegs_cooked.tex",
}

for k,v in pairs(cookbook_icons) do
	RegisterInventoryItemAtlas("images/inventoryimages/hof_inventoryimages.xml", v)
end

-- Import The Foods.
for k, v in pairs(require("hof_foodrecipes")) do
	AddCookerRecipe("cookpot",             					v)
	AddCookerRecipe("archive_cookpot",     					v)
	AddCookerRecipe("portablecookpot",     					v)
	AddCookerRecipe("kyno_cookware_syrup", 					v)
	AddCookerRecipe("kyno_cookware_small", 					v)
	AddCookerRecipe("kyno_cookware_big",   					v)
	AddCookerRecipe("kyno_cookware_elder",          		v)
	AddCookerRecipe("kyno_cookware_small_grill", 			v)
	AddCookerRecipe("kyno_cookware_grill", 		 			v)
	AddCookerRecipe("kyno_cookware_oven_small_casserole", 	v)
	AddCookerRecipe("kyno_cookware_oven_casserole", 		v)
end

-- This file is only for Warly foods.
for k, v in pairs(require("hof_foodrecipes_warly")) do
	AddCookerRecipe("portablecookpot",         				v)
end 

for k, v in pairs(require("hof_foodspicer")) do
	AddCookerRecipe("portablespicer",          				v)
end

-- Fix For Spiced Foods and Potlevel.
local spices  = 
{ 
	"chili", 
	"garlic", 
	"sugar", 
	"salt" 
}

local cookers = 
{ 
	"cookpot", 
	"portablecookpot", 
	"portablespicer", 
	"archive_cookpot",
	"kyno_cookware_syrup", 
	"kyno_cookware_small", 
	"kyno_cookware_big",
	"kyno_cookware_elder",
	"kyno_cookware_small_grill",
	"kyno_cookware_grill",
	"kyno_cookware_oven_small_casserole",
	"kyno_cookware_oven_casserole",
}

for i, cooker in ipairs(cookers) do 
	if not cookerrecipes[cooker] then
		cookerrecipes[cooker] = {}
	end
end

-- Fix For Food On Stations.
local cookerstations = 
{
	"cookpot",
	"portablecookpot",
	"archive_cookpot",
	"kyno_cookware_syrup",
	"kyno_cookware_small",
	"kyno_cookware_big",
	"kyno_cookware_elder",
	"kyno_cookware_small_grill",
	"kyno_cookware_grill",
	"kyno_cookware_oven_small_casserole",
	"kyno_cookware_oven_casserole",
} 

local kynofoods =
{
	-- Shipwrecked.
	coffee 					= require("hof_foodrecipes").coffee,
	bisque 					= require("hof_foodrecipes").bisque,
	jellyopop 				= require("hof_foodrecipes").jellyopop,
	sharkfinsoup 			= require("hof_foodrecipes").sharkfinsoup,
	caviar 					= require("hof_foodrecipes").caviar,
	tropicalbouillabaisse 	= require("hof_foodrecipes").tropicalbouillabaisse,
	
	-- Hamlet.
	feijoada 				= require("hof_foodrecipes").feijoada,
	gummy_cake 				= require("hof_foodrecipes").gummy_cake,
	hardshell_tacos 		= require("hof_foodrecipes").hardshell_tacos,
	icedtea 				= require("hof_foodrecipes").icedtea,
	tea 					= require("hof_foodrecipes").tea,
	nettlelosange 			= require("hof_foodrecipes").nettlelosange,
	snakebonesoup 			= require("hof_foodrecipes").snakebonesoup,
	steamedhamsandwich 		= require("hof_foodrecipes").steamedhamsandwich,
	
	-- The Gorge.
	gorge_bread 			= require("hof_foodrecipes").gorge_bread,
	gorge_potato_chips 		= require("hof_foodrecipes").gorge_potato_chips,
	gorge_vegetable_soup 	= require("hof_foodrecipes").gorge_vegetable_soup,
	gorge_jelly_sandwich 	= require("hof_foodrecipes").gorge_jelly_sandwich,
	gorge_fish_stew 		= require("hof_foodrecipes").gorge_fish_stew,
	gorge_onion_cake 		= require("hof_foodrecipes").gorge_onion_cake,
	gorge_potato_pancakes 	= require("hof_foodrecipes").gorge_potato_pancakes,
	gorge_potato_soup 		= require("hof_foodrecipes").gorge_potato_soup,
	gorge_fishball_skewers 	= require("hof_foodrecipes").gorge_fishball_skewers,
	gorge_meat_skewers 		= require("hof_foodrecipes").gorge_meat_skewers,
	gorge_stone_soup 		= require("hof_foodrecipes").gorge_stone_soup,
	gorge_croquette 		= require("hof_foodrecipes").gorge_croquette,
	gorge_roast_vegetables 	= require("hof_foodrecipes").gorge_roast_vegetables,
	gorge_meatloaf 			= require("hof_foodrecipes").gorge_meatloaf,
	gorge_carrot_soup 		= require("hof_foodrecipes").gorge_carrot_soup,
	gorge_fishpie 			= require("hof_foodrecipes").gorge_fishpie,
	gorge_fishchips 		= require("hof_foodrecipes").gorge_fishchips,
	gorge_meatpie 			= require("hof_foodrecipes").gorge_meatpie,
	gorge_sliders 			= require("hof_foodrecipes").gorge_sliders,
	gorge_jelly_roll 		= require("hof_foodrecipes").gorge_jelly_roll,
	gorge_carrot_cake 		= require("hof_foodrecipes").gorge_carrot_cake,
	gorge_garlicmashed 		= require("hof_foodrecipes").gorge_garlicmashed,
	gorge_garlicbread 		= require("hof_foodrecipes").gorge_garlicbread,
	gorge_tomato_soup 		= require("hof_foodrecipes").gorge_tomato_soup,
	gorge_sausage 			= require("hof_foodrecipes").gorge_sausage,
	gorge_candiedfish 		= require("hof_foodrecipes").gorge_candiedfish,
	gorge_stuffedmushroom 	= require("hof_foodrecipes").gorge_stuffedmushroom,
	gorge_bruschetta 		= require("hof_foodrecipes").gorge_bruschetta,
	gorge_hamburger 		= require("hof_foodrecipes").gorge_hamburger,
	gorge_fishburger 		= require("hof_foodrecipes").gorge_fishburger,
	gorge_mushroomburger 	= require("hof_foodrecipes").gorge_mushroomburger,
	gorge_fish_steak 		= require("hof_foodrecipes").gorge_fish_steak,
	gorge_curry 			= require("hof_foodrecipes").gorge_curry,
	gorge_spaghetti 		= require("hof_foodrecipes").gorge_spaghetti,
	gorge_poachedfish 		= require("hof_foodrecipes").gorge_poachedfish,
	gorge_shepherd_pie 		= require("hof_foodrecipes").gorge_shepherd_pie,
	gorge_candy 			= require("hof_foodrecipes").gorge_candy,
	gorge_bread_pudding 	= require("hof_foodrecipes").gorge_bread_pudding,
	gorge_berry_tart 		= require("hof_foodrecipes").gorge_berry_tart,
	gorge_macaroni 			= require("hof_foodrecipes").gorge_macaroni,
	gorge_bagel_and_fish 	= require("hof_foodrecipes").gorge_bagel_and_fish,
	gorge_grilled_cheese 	= require("hof_foodrecipes").gorge_grilled_cheese,
	gorge_creammushroom 	= require("hof_foodrecipes").gorge_creammushroom,
	gorge_manicotti 		= require("hof_foodrecipes").gorge_manicotti,
	gorge_fettuccine 		= require("hof_foodrecipes").gorge_fettuccine,
	gorge_onion_soup 		= require("hof_foodrecipes").gorge_onion_soup,
	gorge_breaded_cutlet 	= require("hof_foodrecipes").gorge_breaded_cutlet,
	gorge_creamy_fish 		= require("hof_foodrecipes").gorge_creamy_fish,
	gorge_pot_roast 		= require("hof_foodrecipes").gorge_pot_roast,
	gorge_crab_cake 		= require("hof_foodrecipes").gorge_crab_cake,
	gorge_steak_frites 		= require("hof_foodrecipes").gorge_steak_frites,
	gorge_shooter_sandwich 	= require("hof_foodrecipes").gorge_shooter_sandwich,
	gorge_bacon_wrapped 	= require("hof_foodrecipes").gorge_bacon_wrapped,
	gorge_crab_roll 		= require("hof_foodrecipes").gorge_crab_roll,
	gorge_crab_ravioli 		= require("hof_foodrecipes").gorge_crab_ravioli,
	gorge_caramel_cube 		= require("hof_foodrecipes").gorge_caramel_cube,
	gorge_scone 			= require("hof_foodrecipes").gorge_scone,
	gorge_cheesecake 		= require("hof_foodrecipes").gorge_cheesecake,
	kyno_syrup 				= require("hof_foodrecipes").kyno_syrup,
	
	-- Winter's Feast. 
	festive_berrysauce 		= require("hof_foodrecipes").festive_berrysauce,
	festive_bibingka 		= require("hof_foodrecipes").festive_bibingka,
	festive_cabbagerolls 	= require("hof_foodrecipes").festive_cabbagerolls,
	festive_fishdish 		= require("hof_foodrecipes").festive_fishdish,
	festive_goodgravy 		= require("hof_foodrecipes").festive_goodgravy,
	festive_latkes 			= require("hof_foodrecipes").festive_latkes,
	festive_lutefisk 		= require("hof_foodrecipes").festive_lutefisk,
	festive_mulledpunch 	= require("hof_foodrecipes").festive_mulledpunch,
	festive_panettone 		= require("hof_foodrecipes").festive_panettone,
	festive_pavlova 		= require("hof_foodrecipes").festive_pavlova,
	festive_pickledherring 	= require("hof_foodrecipes").festive_pickledherring,
	festive_polishcookies 	= require("hof_foodrecipes").festive_polishcookies,
	festive_pumpkinpie 		= require("hof_foodrecipes").festive_pumpkinpie,
	festive_roastedturkey 	= require("hof_foodrecipes").festive_roastedturkey,
	festive_stuffing 		= require("hof_foodrecipes").festive_stuffing,
	festive_sweetpotato 	= require("hof_foodrecipes").festive_sweetpotato,
	festive_tamales 		= require("hof_foodrecipes").festive_tamales,
	festive_tourtiere 		= require("hof_foodrecipes").festive_tourtiere,
	
	-- Unimplemented.
	slaw 					= require("hof_foodrecipes").slaw,
	lotusbowl 				= require("hof_foodrecipes").lotusbowl,
	poi 					= require("hof_foodrecipes").poi,
	cucumbersalad 			= require("hof_foodrecipes").cucumbersalad,
	waterycressbowl 		= require("hof_foodrecipes").waterycressbowl,
	
	-- Secret / Custom.
	bowlofgears 			= require("hof_foodrecipes").bowlofgears,
	longpigmeal 			= require("hof_foodrecipes").longpigmeal,
	duckyouglermz 			= require("hof_foodrecipes").duckyouglermz,
	catfood 				= require("hof_foodrecipes").catfood,
	katfood 				= require("hof_foodrecipes").katfood,
	bowlofpopcorn			= require("hof_foodrecipes").bowlofpopcorn,
	figjuice                = require("hof_foodrecipes").figjuice,
	coconutwater            = require("hof_foodrecipes").coconutwater,
	eyeballsoup             = require("hof_foodrecipes").eyeballsoup,
	soulstew             	= require("hof_foodrecipes").soulstew,
	fortunecookie			= require("hof_foodrecipes").fortunecookie,
	hornocupia				= require("hof_foodrecipes").hornocupia,
	cheese_yellow		    = require("hof_foodrecipes").cheese_yellow,
	cheese_white 		    = require("hof_foodrecipes").cheese_white,
	cheese_koalefant		= require("hof_foodrecipes").cheese_koalefant,
	milk_box				= require("hof_foodrecipes").milk_box,
	watercup				= require("hof_foodrecipes").watercup,
	crab_artichoke          = require("hof_foodrecipes").crab_artichoke,
	poisonfrogglebunwich    = require("hof_foodrecipes").poisonfrogglebunwich,
	
	-- Warly Exclusives.
	musselbouillabaise 		= require("hof_foodrecipes_warly").musselbouillabaise,
	sweetpotatosouffle 		= require("hof_foodrecipes_warly").sweetpotatosouffle,
	gorge_meat_stew			= require("hof_foodrecipes_warly").gorge_meat_stew,
	gorge_cheeseburger 		= require("hof_foodrecipes_warly").gorge_cheeseburger,
	gorge_pizza 			= require("hof_foodrecipes_warly").gorge_pizza,
	gorge_meat_wellington 	= require("hof_foodrecipes_warly").gorge_meat_wellington,
	gorge_trifle 			= require("hof_foodrecipes_warly").gorge_trifle,
	bubbletea 				= require("hof_foodrecipes_warly").bubbletea,
	frenchonionsoup 		= require("hof_foodrecipes_warly").frenchonionsoup,
	jellybean_sanity 		= require("hof_foodrecipes_warly").jellybean_sanity,
	jellybean_hunger 		= require("hof_foodrecipes_warly").jellybean_hunger,
	jellybean_super 		= require("hof_foodrecipes_warly").jellybean_super,
}

for name, recipe in pairs(kynofoods) do
	for i, station in ipairs(cookerstations) do 
		table.insert(cookerrecipes[station], 				   name)
	end
	
	AddPrefabPostInit(name, function(inst)
		inst.AnimState:OverrideSymbol("swap_food", name, 	   name)
	end)
	
	for _, spicename in ipairs(spices) do
		local spiced_name = name.."_spice_"..spicename
		table.insert(cookerrecipes["portablespicer"], 	spiced_name)
		
		AddPrefabPostInit(spiced_name, function(inst)
			inst.AnimState:OverrideSymbol("swap_food",   name, name)
		end)
	end
end