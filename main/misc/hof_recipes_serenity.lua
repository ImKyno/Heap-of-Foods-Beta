local _G               = GLOBAL
local TECH             = _G.TECH
local Ingredient       = _G.Ingredient
local AllRecipes       = _G.AllRecipes
local Recipe2          = _G.Recipe2
local TechTree         = require("techtree")
local RecipeFilter     = require("recipes_filter")

-- Atlases for Recipes.
local DefaultAtlas     = "images/inventoryimages.xml"
local DefaultAtlas1    = "images/inventoryimages1.xml"

-- Pig Elder Shop.
AddRecipe2("kyno_saltrack_installer_p", {Ingredient("kyno_salmonfish", 2)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_saltrack_installer_p",
		sg_state    		= "give",
		product				= "kyno_saltrack_installer",
		numtogive 			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_crabtrap_installer_p", {Ingredient("quagmire_pigeon", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_crabtrap_installer_p",
		sg_state			= "give",
		product				= "kyno_crabtrap_installer",
		numtogive			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sapbucket_installer_p", {Ingredient("kyno_salt", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_sapbucket_installer_p",
		sg_state    		= "give",
		product				= "kyno_sapbucket_installer",
		numtogive 			= 3,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_slaughtertool_p", {Ingredient("kyno_crabmeat", 2)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_slaughtertool_p",
		sg_state			= "give",
		product				= "kyno_slaughtertool",
		numtogive			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_hanger_p", {Ingredient("bonestew", 1), Ingredient("gorge_garlicmashed", 1), Ingredient("feijoada", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_cookware_kit_hanger_p",
		sg_state			= "give",
		product				= "kyno_cookware_kit_hanger",
		numtogive			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_syrup_p", {Ingredient("taffy", 1), Ingredient("gorge_berry_tart", 1), Ingredient("gummy_cake", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_cookware_kit_syrup_p",
		sg_state			= "give",
		product				= "kyno_cookware_kit_syrup",
		numtogive			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_oven_p", {Ingredient("dragonpie", 1), Ingredient("gorge_bread", 1), Ingredient("gorge_carrot_cake", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_cookware_kit_oven_p",
		sg_state			= "give",
		product				= "kyno_cookware_kit_oven",
		numtogive			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_small_grill_p", {Ingredient("kabobs", 1), Ingredient("gorge_sliders", 1), Ingredient("steamedhamsandwich", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_cookware_kit_small_grill_p",
		sg_state			= "give",
		product				= "kyno_cookware_kit_small_grill",
		numtogive			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_grill_p", {Ingredient("frogglebunwich", 1), Ingredient("gorge_hamburger", 1), Ingredient("hardshell_tacos", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_cookware_kit_grill_p",
		sg_state			= "give",
		product				= "kyno_cookware_kit_grill",
		numtogive			= 1,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sweetpotato_seeds_p", {Ingredient("potato_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_seeds_kit_sweetpotato_p",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_sweetpotato",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_turnip_seeds_p", {Ingredient("garlic_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_seeds_kit_turnip_p",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_turnip",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_radish_seeds_p", {Ingredient("carrot_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_seeds_kit_radish_p",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_radish",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_parznip_seeds_p", {Ingredient("pumpkin_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_seeds_kit_parznip_p",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_parznip",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_fennel_seeds_p", {Ingredient("durian_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_seeds_kit_fennel_p",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_fennel",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_cucumber_seeds_p", {Ingredient("watermelon_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_seeds_kit_cucumber_p",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_cucumber",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_aloe_seeds_p", {Ingredient("asparagus_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_seeds_kit_aloe_p",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_aloe",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_saphealer_p", {Ingredient("kyno_sap_spoiled", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_saphealer_p",
		sg_state    		= "give",
		product				= "kyno_saphealer",
		numtogive 			= 2,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sugartree_petals_p", {Ingredient("kyno_sugarfly", 1)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_sugartree_petals_p",
		sg_state    		= "give",
		product				= "kyno_sugartree_petals",
		numtogive 			= 3,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sugartree_bud_p", {Ingredient("kyno_syrup", 3)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "kyno_sugartree_bud_p",
		sg_state    		= "give",
		product				= "kyno_sugartree_bud",
		numtogive 			= 2,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("dug_kyno_spotbush_p", {Ingredient("kyno_spotspice_leaf", 3)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "dug_kyno_spotbush_p",
		sg_state    		= "give",
		product				= "dug_kyno_spotbush",
		numtogive 			= 2,
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("dug_kyno_wildwheat_p", {Ingredient("kyno_wheat", 3)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSSERENITYSHOP",
		actionstr 			= "SERENITYSHOP",
		description         = "dug_kyno_wildwheat_p",
		sg_state    		= "give",
		product				= "dug_kyno_wildwheat",
		numtogive 			= 2,
	},
	{"CRAFTING_STATION"}
)