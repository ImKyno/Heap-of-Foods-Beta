-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require

-- Preload Assets. (Before the game load).
PreloadAssets =
{
	Asset("IMAGE", "images/hof_loadingtips_icon.tex"),
	Asset("ATLAS", "images/hof_loadingtips_icon.xml"),
}

ReloadPreloadAssets()

-- Assets.
Assets =
{
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
	
	Asset("ANIM", "anim/ui_brewer_1x3.zip"),
	Asset("ANIM", "anim/kyno_turfs_hof.zip"),
	
	Asset("ANIM", "anim/farm_plant_kyno_aloe.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_cucumber.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_fennel.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_parznip.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_radish.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_rice.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_sweetpotato.zip"),
	Asset("ANIM", "anim/farm_plant_kyno_turnip.zip"),
	
	Asset("IMAGE", "images/hof_loadingtips_icon.tex"), 
	Asset("ATLAS", "images/hof_loadingtips_icon.xml"),
	
	Asset("IMAGE", "images/customizationimages/hof_customizationimages_worldgen.tex"),
	Asset("ATLAS", "images/customizationimages/hof_customizationimages_worldgen.xml"),
	
	Asset("IMAGE", "images/customizationimages/hof_customizationimages_worldsettings.tex"),
	Asset("ATLAS", "images/customizationimages/hof_customizationimages_worldsettings.xml"),
	
	Asset("IMAGE", "images/tabimages/hof_tabimages.tex"),
	Asset("ATLAS", "images/tabimages/hof_tabimages.xml"),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

	Asset("IMAGE", "images/ingredientimages/hof_ingredientimages.tex"),
	Asset("ATLAS", "images/ingredientimages/hof_ingredientimages.xml"),
	Asset("ATLAS_BUILD", "images/ingredientimages/hof_ingredientimages.xml", 256),
	
	Asset("IMAGE", "images/cookbookimages/hof_cookbookimages.tex"),
	Asset("ATLAS", "images/cookbookimages/hof_cookbookimages.xml"),
	Asset("ATLAS_BUILD", "images/cookbookimages/hof_cookbookimages.xml", 256),
	
	Asset("IMAGE", "images/cookbookimages/hof_brewbookimages.tex"),
	Asset("ATLAS", "images/cookbookimages/hof_brewbookimages.xml"),
	Asset("ATLAS_BUILD", "images/cookbookimages/hof_brewbookimages.xml", 256),
	
	Asset("IMAGE", "images/cookbookimages/hof_cookbookimages_warly.tex"),
	Asset("ATLAS", "images/cookbookimages/hof_cookbookimages_warly.xml"),
	Asset("ATLAS_BUILD", "images/cookbookimages/hof_cookbookimages_warly.xml", 256),
	
	Asset("IMAGE", "images/cookbookimages/hof_cookbookimages_seasonal.tex"),
	Asset("ATLAS", "images/cookbookimages/hof_cookbookimages_seasonal.xml"),
	Asset("ATLAS_BUILD", "images/cookbookimages/hof_cookbookimages_seasonal.xml", 256),
	
	Asset("IMAGE", "images/scrapbookimages/hof_scrapbookimages.tex"),
	Asset("ATLAS", "images/scrapbookimages/hof_scrapbookimages.xml"),
	Asset("ATLAS_BUILD", "images/scrapbookimages/hof_scrapbookimages.xml", 256),
	
	-- Accomplishments Mod.
    -- Asset("IMAGE", "images/achievementsimages/hof_achievements_images.tex"),
    -- Asset("ATLAS", "images/achievementsimages/hof_achievements_images.xml"),

    -- Asset("IMAGE", "images/achievementsimages/hof_achievements_buttons.tex"),
    -- Asset("ATLAS", "images/achievementsimages/hof_achievements_buttons.xml"),
}

-- Minimap Icons.
AddMinimapAtlas("images/minimapimages/hof_minimapicons.xml")

-- Mod Icons.
local HOF_ICONS =
{
	"algae_soup",
	"antslog",
	"avocadotoast",
	"banana_pudding",
	"beer",
	"berrybombs",
	"berrysundae",
	"bisque",
	"bowlofgears",
	"bowlofpopcorn",
	"bubbletea",
	"butter_beefalo",
	"butter_goat",
	"butter_koalefant",
	"catfood",
	"caviar",
	"cheese_koalefant",
	"cheese_white",
	"cheese_yellow",
	"chimas",
	"chipsbag",
	"chocolate_black",
	"chocolate_white",
	"cinnamonroll",
	"coconutwater",
	"coffee",
	"coffee_mocha",
	"completebreakfast",
	"cornincup",
	"cottoncandy",
	"coxinha",
	"crab_artichoke",
	"cucumbersalad",
	"donuts",
	"donuts_chocolate_black",
	"donuts_chocolate_white",
	"duckyouglermz",
	"dug_kyno_coffeebush",
	"dug_kyno_pineapplebush",
	"dug_kyno_spotbush",
	"dug_kyno_wildwheat",
	"dumplings",
	"durianchicken",
	"durianmeated",
	"duriansoup",
	"duriansplit",
	"eeltacos",
	"eyeballspaghetti",
	"feijoada",
	"festive_berrysauce",
	"festive_bibingka",
	"festive_cabbagerolls",
	"festive_fishdish",
	"festive_goodgravy",
	"festive_latkes",
	"festive_lutefisk",
	"festive_mulledpunch",
	"festive_panettone",
	"festive_pavlova",
	"festive_pickledherring",
	"festive_polishcookies",
	"festive_pumpkinpie",
	"festive_roastedturkey",
	"festive_stuffing",
	"festive_sweetpotato",
	"festive_tamales",
	"festive_tourtiere",
	"figjuice",
	"firenettles_seeds",
	"fltsandwich",
	"forgetmelots_seeds",
	"fortunecookie",
	"frenchonionsoup",
	"friesfrench",
	"gorge_bacon_wrapped",
	"gorge_bagel_and_fish",
	"gorge_berry_tart",
	"gorge_bread",
	"gorge_bread_pudding",
	"gorge_breaded_cutlet",
	"gorge_bruschetta",
	"gorge_candiedfish",
	"gorge_candy",
	"gorge_caramel_cube",
	"gorge_carrot_cake",
	"gorge_carrot_soup",
	"gorge_cheeseburger",
	"gorge_cheesecake",
	"gorge_crab_cake",
	"gorge_crab_ravioli",
	"gorge_crab_roll",
	"gorge_creammushroom",
	"gorge_creamy_fish",
	"gorge_croquette",
	"gorge_curry",
	"gorge_fettuccine",
	"gorge_fish_steak",
	"gorge_fish_stew",
	"gorge_fishball_skewers",
	"gorge_fishburger",
	"gorge_fishchips",
	"gorge_fishpie",
	"gorge_garlicbread",
	"gorge_garlicmashed",
	"gorge_grilled_cheese",
	"gorge_hamburger",
	"gorge_jelly_roll",
	"gorge_jelly_sandwich",
	"gorge_macaroni",
	"gorge_manicotti",
	"gorge_meat_skewers",
	"gorge_meat_stew",
	"gorge_meat_wellington",
	"gorge_meatloaf",
	"gorge_meatpie",
	"gorge_mushroomburger",
	"gorge_onion_cake",
	"gorge_onion_soup",
	"gorge_pizza",
	"gorge_poachedfish",
	"gorge_pot_roast",
	"gorge_potato_pancakes",
	"gorge_potato_soup",
	"gorge_roast_vegetables",
	"gorge_sausage",
	"gorge_scone",
	"gorge_shepherd_pie",
	"gorge_shooter_sandwich",
	"gorge_sliders",
	"gorge_spaghetti",
	"gorge_steak_frites",
	"gorge_stone_soup",
	"gorge_stuffedmushroom",
	"gorge_sweet_chips",
	"gorge_tomato_soup",
	"gorge_trifle",
	"gorge_vegetable_soup",
	"gummy_cake",
	"gummybeargers",
	"gummyworms",
	"hardshell_tacos",
	"honeyjar",
	"horchata",
	"horn",
	"hornocupia",
	"hothound",
	"icedtea",
	"jelly_banana",
	"jelly_berries",
	"jelly_berries_juicy",
	"jelly_cave_banana",
	"jelly_dragonfruit",
	"jelly_durian",
	"jelly_fig",
	"jelly_glowberry",
	"jelly_kokonut",
	"jelly_nightberry",
	"jelly_pineapple",
	"jelly_pomegranate",
	"jelly_watermelon",
	"jellybean_hunger",
	"jellybean_sanity",
	"jellybean_super",
	"jellyopop",
	"juice_aloe",
	"juice_asparagus",
	"juice_avocado",
	"juice_bluecap",
	"juice_cactus",
	"juice_carrot",
	"juice_corn",
	"juice_cucumber",
	"juice_eggplant",
	"juice_fennel",
	"juice_garlic",
	"juice_greencap",
	"juice_kelp",
	"juice_lichen",
	"juice_lotus",
	"juice_mooncap",
	"juice_onion",
	"juice_parznip",
	"juice_pepper",
	"juice_potato",
	"juice_pumpkin",
	"juice_radish",
	"juice_redcap",
	"juice_seaweeds",
	"juice_sweetpotato",
	"juice_taroroot",
	"juice_tomato",
	"juice_turnip",
	"juice_waterycress",
	"juice_whitecap",
	"katfood",
	"kingfisher",
	"kyno_aloe",
	"kyno_aloe_cooked",
	"kyno_aloe_oversized",
	"kyno_aloe_oversized_rotten",
	"kyno_aloe_oversized_waxed",
	"kyno_aloe_seeds",
	"kyno_bacon",
	"kyno_bacon_cooked",
	"kyno_banana",
	"kyno_banana_cooked",
	"kyno_beanbugs",
	"kyno_beanbugs_cooked",
	"kyno_beancan",
	"kyno_beancan_open",
	"kyno_blue_cap_dried",
	"kyno_bottle_soul",
	"kyno_bottlecap",
	"kyno_brewbook",
	"kyno_brewingrecipecard",
	"kyno_bucket_empty",
	"kyno_bucket_metal",
	"kyno_chicken2",
	"kyno_chicken_egg",
	"kyno_chicken_egg_cooked",
	"kyno_coffeebeans",
	"kyno_coffeebeans_cooked",
	"kyno_cokecan",
	"kyno_cookware_big_pot",
	"kyno_cookware_casserole",
	"kyno_cookware_grill_item",
	"kyno_cookware_hanger_item",
	"kyno_cookware_kit_grill",
	"kyno_cookware_kit_hanger",
	"kyno_cookware_kit_oven",
	"kyno_cookware_kit_small_grill",
	"kyno_cookware_kit_syrup",
	"kyno_cookware_oven_item",
	"kyno_cookware_small_casserole",
	"kyno_cookware_small_grill_item",
	"kyno_cookware_small_pot",
	"kyno_cookware_syrup_pot",
	"kyno_crabkingmeat",
	"kyno_crabkingmeat_cooked",
	"kyno_crabkingmeat_dried",
	"kyno_crabmeat",
	"kyno_crabmeat_cooked",
	"kyno_crabmeat_dried",
	"kyno_crabtrap_installer",
	"kyno_cucumber",
	"kyno_cucumber_cooked",
	"kyno_cucumber_oversized",
	"kyno_cucumber_oversized_rotten",
	"kyno_cucumber_oversized_waxed",
	"kyno_cucumber_seeds",
	"kyno_energycan",
	"kyno_fennel",
	"kyno_fennel_cooked",
	"kyno_fennel_oversized",
	"kyno_fennel_oversized_rotten",
	"kyno_fennel_oversized_waxed",
	"kyno_fennel_seeds",
	"kyno_floatilizer",
	"kyno_flour",
	"kyno_foliage",
	"kyno_foliage_cooked",
	"kyno_foodsack",
	"kyno_green_cap_dried",
	"kyno_grouper",
	"kyno_grouper_cooked",
	"kyno_gummybug",
	"kyno_gummybug_cooked",
	"kyno_humanmeat",
	"kyno_humanmeat_cooked",
	"kyno_humanmeat_dried",
	"kyno_itemslicer",
	"kyno_itemslicer_gold",
	"kyno_koi",
	"kyno_koi_cooked",
	"kyno_kokonut",
	"kyno_kokonut_cooked",
	"kyno_kokonut_halved",
	"kyno_limpets",
	"kyno_limpets_cooked",
	"kyno_lotus_flower",
	"kyno_lotus_flower_cooked",
	"kyno_meatcan",
	"kyno_meatcan_open",
	"kyno_milk_beefalo",
	"kyno_milk_deer",
	"kyno_milk_koalefant",
	"kyno_moon_cap_dried",
	"kyno_moon_froglegs",
	"kyno_moon_froglegs_cooked",
	"kyno_mussel",
	"kyno_mussel_cooked",
	"kyno_musselstick_item",
	"kyno_mysterymeat",
	"kyno_nectar_pod",
	"kyno_neonfish",
	"kyno_neonfish_cooked",
	"kyno_oaktree_pod",
	"kyno_oaktree_pod_cooked",
	"kyno_oil",
	"kyno_parznip",
	"kyno_parznip_cooked",
	"kyno_parznip_eaten",
	"kyno_parznip_oversized",
	"kyno_parznip_oversized_rotten",
	"kyno_parznip_oversized_waxed",
	"kyno_parznip_seeds",
	"kyno_pebblecrab",
	"kyno_pierrotfish",
	"kyno_pierrotfish_cooked",
	"kyno_piko",
	"kyno_piko_orange",
	"kyno_pineapple",
	"kyno_pineapple_cooked",
	"kyno_pineapple_halved",
	"kyno_plantmeat_dried",
	"kyno_poison_froglegs",
	"kyno_poison_froglegs_cooked",
	"kyno_radish",
	"kyno_radish_cooked",
	"kyno_radish_oversized",
	"kyno_radish_oversized_rotten",
	"kyno_radish_oversized_waxed",
	"kyno_radish_seeds",
	"kyno_red_cap_dried",
	"kyno_repairtool",
	"kyno_rice",
	"kyno_rice_cooked",
	"kyno_rice_oversized",
	"kyno_rice_oversized_rotten",
	"kyno_rice_oversized_waxed",
	"kyno_rice_seeds",
	"kyno_roe",
	"kyno_roe_cooked",
	"kyno_salmonfish",
	"kyno_salmonfish_cooked",
	"kyno_salt",
	"kyno_saltrack_installer",
	"kyno_sap",
	"kyno_sap_spoiled",
	"kyno_sapbucket_installer",
	"kyno_saphealer",
	"kyno_seaweeds",
	"kyno_seaweeds_cooked",
	"kyno_seaweeds_dried",
	"kyno_seaweeds_root",
	"kyno_seeds_kit_aloe",
	"kyno_seeds_kit_cucumber",
	"kyno_seeds_kit_fennel",
	"kyno_seeds_kit_parznip",
	"kyno_seeds_kit_radish",
	"kyno_seeds_kit_rice",
	"kyno_seeds_kit_sweetpotato",
	"kyno_seeds_kit_turnip",
	"kyno_shark_fin",
	"kyno_sodacan",
	"kyno_spotspice",
	"kyno_spotspice_leaf",
	"kyno_sugar",
	"kyno_sugarfly",
	"kyno_sugarflywings",
	"kyno_sugartree_bud",
	"kyno_sugartree_petals",
	"kyno_sweetpotato",
	"kyno_sweetpotato_cooked",
	"kyno_sweetpotato_oversized",
	"kyno_sweetpotato_oversized_rotten",
	"kyno_sweetpotato_oversized_waxed",
	"kyno_sweetpotato_seeds",
	"kyno_syrup",
	"kyno_taroroot",
	"kyno_taroroot_cooked",
	"kyno_tealeaf",
	"kyno_tomatocan",
	"kyno_tomatocan_open",
	"kyno_tropicalfish",
	"kyno_tropicalfish_cooked",
	"kyno_tunacan",
	"kyno_tunacan_open",
	"kyno_turnip",
	"kyno_turnip_cooked",
	"kyno_turnip_oversized",
	"kyno_turnip_oversized_rotten",
	"kyno_turnip_oversized_waxed",
	"kyno_turnip_seeds",
	"kyno_waterycress",
	"kyno_wheat",
	"kyno_wheat_cooked",
	"kyno_white_cap",
	"kyno_white_cap_cooked",
	"kyno_worm_bone",
	"lavaeeggboiled",
	"lazypurrito",
	"littlebread",
	"livingsandwich",
	"longpigmeal",
	"lotusbowl",
	"lunarsoup",
	"lunartequila",
	"mayonnaise",
	"mayonnaise_chicken",
	"mayonnaise_nightmare",
	"mayonnaise_tallbird",
	"mead",
	"meatskillet",
	"meatwaltz",
	"milk_box",
	"milkshake",
	"milkshake_prismatic",
	"mimicmosa",
	"minertreat",
	"monstermuffin",
	"moonbutterflymuffin",
	"musselbouillabaise",
	"nachos",
	"nettlelosange",
	"nukacola",
	"nukacola_quantum",
	"nukashine",
	"nukashine_sugarfree",
	"omurice",
	"onigiris",
	"onionrings",
	"paella",
	"paleale",
	"parznip_soup",
	"pepperrolls",
	"pickles_aloe",
	"pickles_asparagus",
	"pickles_avocado",
	"pickles_bluecap",
	"pickles_cactus",
	"pickles_carrot",
	"pickles_corn",
	"pickles_cucumber",
	"pickles_eggplant",
	"pickles_fennel",
	"pickles_garlic",
	"pickles_greencap",
	"pickles_kelp",
	"pickles_lichen",
	"pickles_lotus",
	"pickles_mooncap",
	"pickles_onion",
	"pickles_parznip",
	"pickles_pepper",
	"pickles_potato",
	"pickles_pumpkin",
	"pickles_radish",
	"pickles_redcap",
	"pickles_rice",
	"pickles_seaweeds",
	"pickles_sweetpotato",
	"pickles_taroroot",
	"pickles_tomato",
	"pickles_turnip",
	"pickles_waterycress",
	"pickles_whitecap",
	"pinacolada",
	"pineapplemousse",
	"pinkcake",
	"piraterum",
	"pizza_tropical",
	"poi",
	"poisonfrogglebunwich",
	"pomegranatetea",
	"pretzel",
	"pretzel_heart",
	"pumpkin_soup",
	"purplewobstersoup",
	"radishsalad",
	"ricepudding",
	"ricesake",
	"risotto",
	"roastedhazelnuts",
	"sea_pudding",
	"sharkfinsoup",
	"sharksushi",
	"slaw",
	"smores",
	"snakebonesoup",
	"soulstew",
	"spice_cold",
	"spice_cold_over",
	"spice_cure",
	"spice_cure_over",
	"spice_fed",
	"spice_fed_over",
	"spice_fire",
	"spice_fire_over",
	"spice_mind",
	"spice_mind_over",
	"spidercake",
	"spooky_brain_noodles",
	"spooky_burgerzilla",
	"spooky_deadbread",
	"spooky_jellybeans",
	"spooky_popsicle",
	"spooky_pumpkincream",
	"spooky_skullcandy",
	"spooky_tacodile",
	"steamedhamsandwich",
	"succulent_picked",
	"sugarbombs",
	"sugarbombs_explosive",
	"sugarflymuffin",
	"sweetpotatosouffle",
	"tartarsauce",
	"tea",
	"teagreen",
	"teared",
	"tepache",
	"tillweed_seeds",
	"tiramisu",
	"toadstoolcola",
	"tom_kha_soup",
	"toucan",
	"tricolordango",
	"tropicalbouillabaisse",
	"turf_fields",
	"turf_pinkpark",
	"turf_stonecity",
	"turf_tidalmarsh",
	"twistedtequila",
	"warlyicedtea",
	"warlytea",
	"watercup",
	"waterycressbowl",
	"wine_banana",
	"wine_berries",
	"wine_berries_juicy",
	"wine_cave_banana",
	"wine_dragonfruit",
	"wine_durian",
	"wine_fig",
	"wine_glowberry",
	"wine_kokonut",
	"wine_nightberry",
	"wine_pineapple",
	"wine_pomegranate",
	"wine_watermelon",
	"wobsterbreaded",
	"wobstercocktail",
	"wobstermonster",
	-- "beard_monster",
	-- "bearger_fur",
	-- "deerclops_eyeball",
	-- "foliage",
	-- "gears",
	-- "glommerfuel",
	-- "guano",
	-- "livinglog",
	-- "papyrus",
	-- "petals",
	-- "poop",
	-- "rabbit",
	-- "rabbit_winter",
	-- "robin_winter",
	-- "rocks",
	-- "saltrock",
	-- "strawberrygrinder",
}

-- Dirty fix for icons not appearing on Mini Signs.
for k, v in pairs(HOF_ICONS) do
	if _G.TheNet:GetIsMasterSimulation() then
		local icon_atlas = MODROOT.."images/inventoryimages/hof_inventoryimages.xml"
		
		for _, icon in pairs({v}) do 
			local icon_name = icon 
		
			AddPrefabPostInit(icon_name, function(inst)
				inst.components.inventoryitem.imagename = icon_name
				inst.components.inventoryitem.atlasname = icon_atlas
			end)
		end
	end
	
	RegisterInventoryItemAtlas("images/inventoryimages/hof_inventoryimages.xml", v..".tex")
end

-- Icons for the Scrapbook.
local HOF_SCRAPBOOK_ICONS =
{
	"farm_plant_kyno_aloe",
	"farm_plant_kyno_cucumber",
	"farm_plant_kyno_fennel",
	"farm_plant_kyno_parznip",
	"farm_plant_kyno_radish",
	"farm_plant_kyno_rice",
	"farm_plant_kyno_sweetpotato",
	"farm_plant_kyno_turnip",
	"kingfisher",
	"kyno_aloe_ground",
	"kyno_antchest",
	"kyno_aspargos_ground",
	"kyno_chicken2",
	"kyno_coffeebush",
	"kyno_cookware_big",
	"kyno_cookware_grill",
	"kyno_cookware_hanger",
	"kyno_cookware_oven",
	"kyno_cookware_oven_casserole",
	"kyno_cookware_oven_small_casserole",
	"kyno_cookware_small",
	"kyno_cookware_small_grill",
	"kyno_cookware_syrup",
	"kyno_cucumber_ground",
	"kyno_fennel_ground",
	"kyno_fishermermhut_wurt",
	"kyno_garden_sprinkler",
	"kyno_kokonuttree",
	"kyno_kokonuttree_sapling",
	"kyno_limpetrock",
	"kyno_lotus_ocean",
	"kyno_meadowisland_crate",
	"kyno_meadowisland_fishermermhut",
	"kyno_meadowisland_mermcart",
	"kyno_meadowisland_mermfisher",
	"kyno_meadowisland_mermhut",
	"kyno_meadowisland_pikotree",
	"kyno_meadowisland_pond",
	"kyno_meadowisland_sandhill",
	"kyno_meadowisland_shop",
	"kyno_meadowisland_trader",
	"kyno_meadowisland_tree",
	"kyno_meadowisland_tree_sapling",
	"kyno_mealgrinder",
	"kyno_mushstump",
	"kyno_musselstick",
	"kyno_ocean_wreck",
	"kyno_parznip_big",
	"kyno_parznip_ground",
	"kyno_pebblecrab",
	"kyno_piko",
	"kyno_piko_orange",
	"kyno_pineapplebush",
	"kyno_pond_salt",
	"kyno_preservesjar",
	"kyno_radish_ground",
	"kyno_rockflippable",
	"kyno_seaweeds_ocean",
	"kyno_serenityisland_crate",
	"kyno_serenityisland_decor2",
	"kyno_serenityisland_shop",
	"kyno_spotbush",
	"kyno_spotbush",
	"kyno_sugarfly",
	"kyno_sugartree",
	"kyno_sugartree_flower",
	"kyno_sugartree_ruined",
	"kyno_sugartree_ruined2",
	"kyno_sugartree_sapling",
	"kyno_sugartree_sapped",
	"kyno_sweetpotato_ground",
	"kyno_taroroot_ocean",
	"kyno_turnip_ground",
	"kyno_waterycress_ocean",
	"kyno_wildwheat",
	"kyno_woodenkeg",
	"quagmire_pigeon",
	"toucan",
}

for i, v in ipairs(HOF_SCRAPBOOK_ICONS) do
	RegisterScrapbookIconAtlas("images/scrapbookimages/hof_scrapbookimages.xml", v..".tex")
end