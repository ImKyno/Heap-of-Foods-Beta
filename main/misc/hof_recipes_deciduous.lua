local _G                   = GLOBAL
local TECH                 = _G.TECH
local Ingredient           = _G.Ingredient
local AllRecipes           = _G.AllRecipes
local Recipe2              = _G.Recipe2
local CONSTRUCTION_PLANS   = _G.CONSTRUCTION_PLANS
local TechTree             = require("techtree")
local RecipeFilter         = require("recipes_filter")

-- Atlases for Recipes.
local DefaultAtlas         = "images/inventoryimages.xml"
local DefaultAtlas1        = "images/inventoryimages1.xml"
local DefaultAtlas2        = "images/inventoryimages2.xml"
local CraftingFilterAtlas  = "images/tabimages/hof_tabimages.xml"

-- Partitio The Merchant.
AddRecipe2("deciduoustrader_kyno_plantbooster_growth", {Ingredient("kyno_pigcoin1", 5)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSDECIDUOUSSHOP",
		actionstr           = "DECIDUOUSSHOP",
		numtogive           = 2,
		description         = "kyno_plantbooster_growth_d",
		sg_state            = "give",
		product             = "kyno_plantbooster_growth",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_plantbooster_vitality", {Ingredient("kyno_pigcoin1", 10),
Ingredient("kyno_pigcoin2", 5)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSDECIDUOUSSHOP",
		actionstr           = "DECIDUOUSSHOP",
		numtogive           = 2,
		description         = "kyno_plantbooster_vitality_d",
		sg_state            = "give",
		product             = "kyno_plantbooster_vitality",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_plantbooster_yield", {Ingredient("kyno_pigcoin3", 5)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSDECIDUOUSSHOP",
		actionstr           = "DECIDUOUSSHOP",
		numtogive           = 2,
		description         = "kyno_plantbooster_yield_d",
		sg_state            = "give",
		product             = "kyno_plantbooster_yield",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_plantbooster_supergrowth", {Ingredient("kyno_pigcoin2", 10),
Ingredient("kyno_pigcoin3", 5)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSDECIDUOUSSHOP",
		actionstr           = "DECIDUOUSSHOP",
		numtogive           = 2,
		description         = "kyno_plantbooster_supergrowth_d",
		sg_state            = "give",
		product             = "kyno_plantbooster_supergrowth",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_white_cap", {Ingredient("kyno_pigcoin1", 1)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSDECIDUOUSSHOP",
		actionstr           = "DECIDUOUSSHOP",
		numtogive           = 2,
		description         = "kyno_white_cap_d",
		sg_state            = "give",
		product             = "kyno_white_cap",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_truffles", {Ingredient("kyno_pigcoin2", 1)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSDECIDUOUSSHOP",
		actionstr           = "DECIDUOUSSHOP",
		numtogive           = 2,
		description         = "kyno_truffles_d",
		sg_state            = "give",
		product             = "kyno_truffles",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_seedsbag", {Ingredient("kyno_pigcoin1", 15), Ingredient("kyno_pigcoin2", 10)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSDECIDUOUSSHOP",
		actionstr           = "DECIDUOUSSHOP",
		description         = "kyno_seedsbag_d",
		sg_state            = "give",
		product             = "kyno_seedsbag",
		image               = "kyno_seedsbag_full.tex",
	},
	{"CRAFTING_STATION"}
)

AddDeconstructRecipe("kyno_seedsbag", {}) -- Needed for getting alterguardianhatshard back.

CONSTRUCTION_PLANS["kyno_deciduousforest_shop"] =
{
	Ingredient("kyno_truffles", 20, nil),
	Ingredient("cutstone",      10, nil, nil),
	Ingredient("boards",        5,  nil, nil),
	Ingredient("lantern",       1,  nil, nil),
}