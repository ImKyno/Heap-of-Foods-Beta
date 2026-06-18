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
local ModAtlas             = "images/inventoryimages/hof_inventoryimages.xml"
local CraftingFilterAtlas  = "images/tabimages/hof_tabimages.xml"

-- Partitio The Merchant.
AddRecipe2("deciduoustrader_kyno_plantbooster_growth", {Ingredient("kyno_pigcoin1", 5, ModAtlas)}, TECH.LOST,
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
		atlas               = ModAtlas,
		image               = "kyno_plantbooster_growth.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_plantbooster_vitality", {Ingredient("kyno_pigcoin1", 10, ModAtlas),
Ingredient("kyno_pigcoin2", 5, ModAtlas)}, TECH.LOST,
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
		atlas               = ModAtlas,
		image               = "kyno_plantbooster_vitality.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_plantbooster_yield", {Ingredient("kyno_pigcoin3", 5, ModAtlas)}, TECH.LOST,
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
		atlas               = ModAtlas,
		image               = "kyno_plantbooster_yield.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_plantbooster_supergrowth", {Ingredient("kyno_pigcoin2", 10, ModAtlas),
Ingredient("kyno_pigcoin3", 5, ModAtlas)}, TECH.LOST,
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
		atlas               = ModAtlas,
		image               = "kyno_plantbooster_supergrowth.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_white_cap", {Ingredient("kyno_pigcoin1", 1, ModAtlas)}, TECH.LOST,
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
		atlas               = ModAtlas,
		image               = "kyno_white_cap.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("deciduoustrader_kyno_truffles", {Ingredient("kyno_pigcoin2", 1, ModAtlas)}, TECH.LOST,
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
		atlas               = ModAtlas,
		image               = "kyno_truffles.tex",
	},
	{"CRAFTING_STATION"}
)

AddDeconstructRecipe("kyno_seedsbag", {}) -- Needed for getting alterguardianhatshard back.

CONSTRUCTION_PLANS["kyno_deciduousforest_shop"] =
{
	Ingredient("kyno_truffles",          20, ModAtlas, nil),
	Ingredient("cutstone",               10, nil,      nil),
	Ingredient("boards",                  5, nil,      nil),
	Ingredient("lantern",                 1, nil,      nil),
}