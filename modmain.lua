------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Dependencies.
modimport("hof_init/hof_prefabs")
modimport("hof_init/hof_recipes")
modimport("hof_init/hof_strings")
modimport("hof_init/hof_postinits")
modimport("hof_init/hof_meatrackfix")
modimport("hof_init/hof_farming")
modimport("hof_init/hof_cooking")
modimport("hof_init/hof_retrofit")
modimport("hof_init/hof_containers")
modimport("hof_init/hof_loadingtips")
modimport("hof_init/hof_icons")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fix For Inventory Icons.
local atlas = (src and src.components.inventoryitem and src.components.inventoryitem.atlasname and resolvefilepath(src.components.inventoryitem.atlasname) ) or "images/inventoryimages.xml"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Preload Assets. (Before the game load).
PreloadAssets =
{
	Asset("IMAGE", "images/tipsimages/hof_loadingtips_icon.tex"),
	Asset("ATLAS", "images/tipsimages/hof_loadingtips_icon.xml"),
}

ReloadPreloadAssets() -- Reload it, so our loading assets can work properly.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Assets.
Assets =
{	
	Asset("ANIM", "anim/kyno_humanmeat.zip"),
	Asset("ANIM", "anim/kyno_mushroomstump.zip"),
	Asset("ANIM", "anim/kyno_spotbush.zip"),
	Asset("ANIM", "anim/kyno_wheat.zip"),
	Asset("ANIM", "anim/kyno_aloe.zip"),
	Asset("ANIM", "anim/kyno_radish.zip"),
	Asset("ANIM", "anim/kyno_fennel.zip"),
	Asset("ANIM", "anim/kyno_sweetpotato.zip"),
	Asset("ANIM", "anim/kyno_seaweeds.zip"),
	Asset("ANIM", "anim/kyno_cucumber.zip"),
	Asset("ANIM", "anim/kyno_waterycress.zip"),
	Asset("ANIM", "anim/kyno_turnip.zip"),
	Asset("ANIM", "anim/kyno_veggies.zip"),
	Asset("ANIM", "anim/kyno_banana.zip"),
	Asset("ANIM", "anim/kyno_bananatree_sapling.zip"),
	Asset("ANIM", "anim/kyno_kokonut.zip"),
	Asset("ANIM", "anim/kyno_weed_seeds.zip"),
	Asset("ANIM", "anim/kyno_turfs_events.zip"),
	
	Asset("ANIM", "anim/parsnip.zip"),
	Asset("ANIM", "anim/grotto_parsnip_giant.zip"),
	
	Asset("ANIM", "anim/farm_plant_kyno_radish.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_sweetpotato.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_fennel.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_aloe.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_cucumber.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_parznip.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_turnip.zip"),
	
	Asset("IMAGE", "images/colourcubesimages/quagmire_cc.tex"),

	Asset("IMAGE", "images/inventoryimages/hof_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_buildingimages.xml"),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
	Asset("IMAGE", "images/minimapimages/hof_parsnipminimap.tex"),
	Asset("ATLAS", "images/minimapimages/hof_parsnipminimap.xml"),
	
	Asset("IMAGE", "images/tabimages/hof_tabimages.tex"),
	Asset("ATLAS", "images/tabimages/hof_tabimages.xml"),
	
	Asset("IMAGE", "images/cookbookimages/hof_cookbook.tex"),
	Asset("ATLAS", "images/cookbookimages/hof_cookbook.xml"),
	Asset("ATLAS_BUILD", "images/cookbookimages/hof_cookbook.xml", 256),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Minimap Icons.
AddMinimapAtlas("images/minimapimages/hof_minimapicons.xml")
AddMinimapAtlas("images/minimapimages/hof_parsnipminimap.xml") -- The other icon was very small, so I'm just using this from TAP...
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Import The Foods.
local XMAS_FOODS = GetModConfigData("xmas_foods")
if XMAS_FOODS == 1 then
	for k, v in pairs(require("hof_foodrecipes_optional")) do
		if not v.tags then
			AddCookerRecipe("cookpot",             			v)
			AddCookerRecipe("archive_cookpot",     	     	v)
			AddCookerRecipe("kyno_archive_cookpot",      	v) -- Compatibility with T.A.P!
			AddCookerRecipe("kyno_cookware_syrup", 	     	v)
			AddCookerRecipe("kyno_cookware_small", 	     	v)
			AddCookerRecipe("kyno_cookware_big",   		 	v)
			AddCookerRecipe("kyno_cookware_elder",          v)
			AddCookerRecipe("kyno_cookware_small_grill", 	v)
			AddCookerRecipe("kyno_cookware_grill", 		 	v)
		end
		AddCookerRecipe("portablecookpot",         			v)
	end

	for k, v in pairs(require("hof_foodspicer_optional")) do
		AddCookerRecipe("portablespicer",          			v)
	end
	
else -- Do Not Import Winter's Feast Foods.

	for k, v in pairs(require("hof_foodrecipes")) do
		if not v.tags then
			AddCookerRecipe("cookpot",             			v)
			AddCookerRecipe("archive_cookpot",     			v)
			AddCookerRecipe("kyno_archive_cookpot", 		v)
			AddCookerRecipe("kyno_cookware_syrup", 			v)
			AddCookerRecipe("kyno_cookware_small", 			v)
			AddCookerRecipe("kyno_cookware_big",   			v)
			AddCookerRecipe("kyno_cookware_elder",          v)
			AddCookerRecipe("kyno_cookware_small_grill", 	v)
			AddCookerRecipe("kyno_cookware_grill", 		 	v)
		end
		AddCookerRecipe("portablecookpot",         			v)
	end

	for k, v in pairs(require("hof_foodspicer")) do
		AddCookerRecipe("portablespicer",          			v)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	"kyno_archive_cookpot", -- Compatibility with T.A.P!
	"kyno_cookware_syrup", 
	"kyno_cookware_small", 
	"kyno_cookware_big",
	"kyno_cookware_elder",
	"kyno_cookware_small_grill",
	"kyno_cookware_grill",
}

for i, cooker in ipairs(cookers) do 
	if not cookerrecipes[cooker] then
		cookerrecipes[cooker] = {}
	end
end

local kynofoods =
{
	-- Shipwrecked.
	coffee 					= require("hof_foodrecipes").coffee,
	bisque 					= require("hof_foodrecipes").bisque,
	jellyopop 				= require("hof_foodrecipes").jellyopop,
	musselbouillabaise 		= require("hof_foodrecipes").musselbouillabaise,
	sharkfinsoup 			= require("hof_foodrecipes").sharkfinsoup,
	sweetpotatosouffle 		= require("hof_foodrecipes").sweetpotatosouffle,
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
	
	-- Unimplemented.
	bubbletea 				= require("hof_foodrecipes").bubbletea,
	frenchonionsoup 		= require("hof_foodrecipes").frenchonionsoup,
	slaw 					= require("hof_foodrecipes").slaw,
	lotusbowl 				= require("hof_foodrecipes").lotusbowl,
	poi 					= require("hof_foodrecipes").poi,
	jellybean_sanity 		= require("hof_foodrecipes").jellybean_sanity,
	jellybean_hunger 		= require("hof_foodrecipes").jellybean_hunger,
	jellybean_super 		= require("hof_foodrecipes").jellybean_super,
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
	
	-- The Gorge.
	gorge_bread 			= require("hof_foodrecipes").gorge_bread,
	gorge_potato_chips 		= require("hof_foodrecipes").gorge_potato_chips,
	gorge_vegetable_soup 	= require("hof_foodrecipes").gorge_vegetable_soup,
	gorge_jelly_sandwich 	= require("hof_foodrecipes").gorge_jelly_sandwich,
	gorge_fish_stew 		= require("hof_foodrecipes").gorge_fish_stew,
	gorge_meat_stew			= require("hof_foodrecipes").gorge_meat_stew,
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
	gorge_cheeseburger 		= require("hof_foodrecipes").gorge_cheeseburger,
	gorge_fettuccine 		= require("hof_foodrecipes").gorge_fettuccine,
	gorge_onion_soup 		= require("hof_foodrecipes").gorge_onion_soup,
	gorge_breaded_cutlet 	= require("hof_foodrecipes").gorge_breaded_cutlet,
	gorge_creamy_fish 		= require("hof_foodrecipes").gorge_creamy_fish,
	gorge_pizza 			= require("hof_foodrecipes").gorge_pizza,
	gorge_pot_roast 		= require("hof_foodrecipes").gorge_pot_roast,
	gorge_crab_cake 		= require("hof_foodrecipes").gorge_crab_cake,
	gorge_steak_frites 		= require("hof_foodrecipes").gorge_steak_frites,
	gorge_shooter_sandwich 	= require("hof_foodrecipes").gorge_shooter_sandwich,
	gorge_bacon_wrapped 	= require("hof_foodrecipes").gorge_bacon_wrapped,
	gorge_crab_roll 		= require("hof_foodrecipes").gorge_crab_roll,
	gorge_meat_wellington 	= require("hof_foodrecipes").gorge_meat_wellington,
	gorge_crab_ravioli 		= require("hof_foodrecipes").gorge_crab_ravioli,
	gorge_caramel_cube 		= require("hof_foodrecipes").gorge_caramel_cube,
	gorge_scone 			= require("hof_foodrecipes").gorge_scone,
	gorge_trifle 			= require("hof_foodrecipes").gorge_trifle,
	gorge_cheesecake 		= require("hof_foodrecipes").gorge_cheesecake,
	kyno_syrup 				= require("hof_foodrecipes").kyno_syrup,
	
	-- Winter's Feast. 
	festive_berrysauce 		= require("hof_foodrecipes_optional").festive_berrysauce,
	festive_bibingka 		= require("hof_foodrecipes_optional").festive_bibingka,
	festive_cabbagerolls 	= require("hof_foodrecipes_optional").festive_cabbagerolls,
	festive_fishdish 		= require("hof_foodrecipes_optional").festive_fishdish,
	festive_goodgravy 		= require("hof_foodrecipes_optional").festive_goodgravy,
	festive_latkes 			= require("hof_foodrecipes_optional").festive_latkes,
	festive_lutefisk 		= require("hof_foodrecipes_optional").festive_lutefisk,
	festive_mulledpunch 	= require("hof_foodrecipes_optional").festive_mulledpunch,
	festive_panettone 		= require("hof_foodrecipes_optional").festive_panettone,
	festive_pavlova 		= require("hof_foodrecipes_optional").festive_pavlova,
	festive_pickledherring 	= require("hof_foodrecipes_optional").festive_pickledherring,
	festive_polishcookies 	= require("hof_foodrecipes_optional").festive_polishcookies,
	festive_pumpkinpie 		= require("hof_foodrecipes_optional").festive_pumpkinpie,
	festive_roastedturkey 	= require("hof_foodrecipes_optional").festive_roastedturkey,
	festive_stuffing 		= require("hof_foodrecipes_optional").festive_stuffing,
	festive_sweetpotato 	= require("hof_foodrecipes_optional").festive_sweetpotato,
	festive_tamales 		= require("hof_foodrecipes_optional").festive_tamales,
	festive_tourtiere 		= require("hof_foodrecipes_optional").festive_tourtiere,
}

kynofoods.coffee.potlevel 					= "med"
kynofoods.bisque.potlevel 					= "high"
kynofoods.jellyopop.potlevel 				= "med"
kynofoods.musselbouillabaise.potlevel 		= "med"
kynofoods.sharkfinsoup.potlevel 			= "med"
kynofoods.sweetpotatosouffle.potlevel 		= "med"
kynofoods.caviar.potlevel 					= "med"
kynofoods.tropicalbouillabaisse.potlevel 	= "med"
kynofoods.feijoada.potlevel 				= "med"
kynofoods.gummy_cake.potlevel 				= "high"
kynofoods.hardshell_tacos.potlevel 			= "high"
kynofoods.icedtea.potlevel 					= "med"
kynofoods.tea.potlevel 						= "med"
kynofoods.nettlelosange.potlevel 			= "med"
kynofoods.snakebonesoup.potlevel 			= "med"
kynofoods.steamedhamsandwich.potlevel 		= "med"
kynofoods.bubbletea.potlevel 				= "med"
kynofoods.frenchonionsoup.potlevel 			= "med"
kynofoods.slaw.potlevel						= "high"
kynofoods.lotusbowl.potlevel 				= "med"
kynofoods.poi.potlevel 						= "med"
kynofoods.jellybean_sanity.potlevel 		= "med"
kynofoods.jellybean_hunger.potlevel 		= "med"
kynofoods.jellybean_super.potlevel 			= "med"
kynofoods.bowlofgears.potlevel 				= "med"
kynofoods.longpigmeal.potlevel 				= "med"
kynofoods.gorge_bread.potlevel 				= "med"
kynofoods.gorge_potato_chips.potlevel 		= "med"
kynofoods.gorge_vegetable_soup.potlevel 	= "med"
kynofoods.gorge_jelly_sandwich.potlevel 	= "med"
kynofoods.gorge_fish_stew.potlevel 			= "med"
kynofoods.gorge_meat_stew.potlevel 			= "med"
kynofoods.gorge_onion_cake.potlevel 		= "med"
kynofoods.gorge_potato_pancakes.potlevel 	= "med"
kynofoods.gorge_potato_soup.potlevel 		= "med"
kynofoods.gorge_fishball_skewers.potlevel 	= "med"
kynofoods.gorge_meat_skewers.potlevel 		= "med"
kynofoods.gorge_stone_soup.potlevel 		= "med"
kynofoods.gorge_croquette.potlevel 			= "med"
kynofoods.gorge_roast_vegetables.potlevel 	= "med"
kynofoods.gorge_meatloaf.potlevel 			= "low"
kynofoods.gorge_carrot_soup.potlevel 		= "med"
kynofoods.gorge_fishpie.potlevel 			= "med"
kynofoods.gorge_fishchips.potlevel 			= "med"
kynofoods.gorge_meatpie.potlevel 			= "med"
kynofoods.gorge_sliders.potlevel 			= "med"
kynofoods.gorge_jelly_roll.potlevel 		= "med"
kynofoods.gorge_carrot_cake.potlevel 		= "med"
kynofoods.gorge_garlicmashed.potlevel 		= "med"
kynofoods.gorge_garlicbread.potlevel 		= "med"
kynofoods.gorge_tomato_soup.potlevel 		= "med"
kynofoods.gorge_sausage.potlevel 			= "med"
kynofoods.gorge_candiedfish.potlevel 		= "low"
kynofoods.gorge_stuffedmushroom.potlevel 	= "low"
kynofoods.gorge_bruschetta.potlevel 		= "med"
kynofoods.gorge_hamburger.potlevel 			= "med"
kynofoods.gorge_fishburger.potlevel 		= "med"
kynofoods.gorge_mushroomburger.potlevel 	= "med"
kynofoods.gorge_fish_steak.potlevel 		= "med"
kynofoods.gorge_curry.potlevel 				= "med"
kynofoods.gorge_spaghetti.potlevel 			= "med"
kynofoods.gorge_poachedfish.potlevel 		= "med"
kynofoods.gorge_shepherd_pie.potlevel 		= "med"
kynofoods.gorge_candy.potlevel 				= "med"
kynofoods.gorge_bread_pudding.potlevel 		= "med"
kynofoods.gorge_berry_tart.potlevel 		= "med"
kynofoods.gorge_macaroni.potlevel 			= "med"
kynofoods.gorge_bagel_and_fish.potlevel 	= "med"
kynofoods.gorge_grilled_cheese.potlevel 	= "low"
kynofoods.gorge_creammushroom.potlevel 		= "med"
kynofoods.gorge_manicotti.potlevel 			= "med"
kynofoods.gorge_cheeseburger.potlevel 		= "med"
kynofoods.gorge_fettuccine.potlevel 		= "med"
kynofoods.gorge_onion_soup.potlevel 		= "med"
kynofoods.gorge_breaded_cutlet.potlevel 	= "low"
kynofoods.gorge_creamy_fish.potlevel 		= "med"
kynofoods.gorge_pizza.potlevel 				= "med"
kynofoods.gorge_pot_roast.potlevel 			= "med"
kynofoods.gorge_crab_cake.potlevel 			= "med"
kynofoods.gorge_steak_frites.potlevel 		= "med"
kynofoods.gorge_shooter_sandwich.potlevel 	= "med"
kynofoods.gorge_bacon_wrapped.potlevel 		= "med"
kynofoods.gorge_crab_roll.potlevel 			= "med"
kynofoods.gorge_meat_wellington.potlevel 	= "med"
kynofoods.gorge_crab_ravioli.potlevel 		= "med"
kynofoods.gorge_caramel_cube.potlevel 		= "med"
kynofoods.gorge_scone.potlevel 				= "med"
kynofoods.gorge_trifle.potlevel 			= "med"
kynofoods.gorge_cheesecake.potlevel 		= "med"
kynofoods.kyno_syrup.potlevel 				= "med"
kynofoods.duckyouglermz.potlevel 			= "med"
kynofoods.cucumbersalad.potlevel 			= "med"
kynofoods.waterycressbowl.potlevel 			= "med"
kynofoods.catfood.potlevel 					= "low"
kynofoods.katfood.potlevel 					= "med"
kynofoods.bowlofpopcorn.potlevel            = "med"
kynofoods.figjuice.potlevel                 = "med"
kynofoods.coconutwater.potlevel             = "med"
kynofoods.eyeballsoup.potlevel              = "med"
kynofoods.festive_berrysauce.potlevel 		= "med"
kynofoods.festive_bibingka.potlevel 		= "med"
kynofoods.festive_cabbagerolls.potlevel 	= "med"
kynofoods.festive_fishdish.potlevel 		= "med"
kynofoods.festive_goodgravy.potlevel 		= "med"
kynofoods.festive_latkes.potlevel 			= "med"
kynofoods.festive_lutefisk.potlevel 		= "med"
kynofoods.festive_mulledpunch.potlevel 		= "med"
kynofoods.festive_panettone.potlevel 		= "med"
kynofoods.festive_pavlova.potlevel 			= "med"
kynofoods.festive_pickledherring.potlevel 	= "med"
kynofoods.festive_polishcookies.potlevel 	= "med"
kynofoods.festive_pumpkinpie.potlevel 		= "med"
kynofoods.festive_roastedturkey.potlevel 	= "med"
kynofoods.festive_stuffing.potlevel 		= "med"
kynofoods.festive_sweetpotato.potlevel 		= "med"
kynofoods.festive_tamales.potlevel 			= "med"
kynofoods.festive_tourtiere.potlevel 		= "med"
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fix For Food On Stations.
for name, recipe in pairs(kynofoods) do
	table.insert(cookerrecipes["cookpot"], 					 		name)
	table.insert(cookerrecipes["portablecookpot"],			 		name)
	table.insert(cookerrecipes["archive_cookpot"], 					name)
	table.insert(cookerrecipes["kyno_archive_cookpot"], 	 		name) -- Compatibility with T.A.P!
	table.insert(cookerrecipes["kyno_cookware_syrup"], 		 		name)
	table.insert(cookerrecipes["kyno_cookware_small"], 		 		name)
	table.insert(cookerrecipes["kyno_cookware_big"], 		 		name)
	table.insert(cookerrecipes["kyno_cookware_elder"], 		 		name)
	table.insert(cookerrecipes["kyno_cookware_small_grill"], 		name)
	table.insert(cookerrecipes["kyno_cookware_grill"], 				name)
	AddPrefabPostInit(name, function(inst)
		inst.AnimState:OverrideSymbol("swap_food", name, 	 		name)
	end)
	for _, spicename in ipairs(spices) do
		local spiced_name = name.."_spice_"..spicename
		table.insert(cookerrecipes["portablespicer"], 		 spiced_name)
		AddPrefabPostInit(spiced_name, function(inst)
			inst.AnimState:OverrideSymbol("swap_food", 		  name, name)
		end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------