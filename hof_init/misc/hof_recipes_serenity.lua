-- Common Dependencies.
local _G               = GLOBAL
local TECH             = _G.TECH
local Ingredient       = _G.Ingredient
local AllRecipes       = _G.AllRecipes
local Recipe2          = _G.Recipe2
local TechTree         = require("techtree")
local RecipeFilter     = require("recipes_filter")

local TheArchitectPack = _G.KnownModIndex:IsModEnabled("workshop-2428854303")
local NotEnoughTurfs   = _G.KnownModIndex:IsModEnabled("workshop-2528541304")

-- Atlases for Recipes.
local DefaultAtlas     = "images/inventoryimages.xml"
local DefaultAtlas1    = "images/inventoryimages1.xml"
local ModAtlas         = "images/inventoryimages/hof_inventoryimages.xml"

-- For sorting recipe.
-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
local function SortRecipe(a, b, filter_name, offset)
    local filter = _G.CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1
        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end

        table.insert(filter.recipes, target_position, a)
    end
end 
 
local function SortBefore(a, b, filter_name)
    SortRecipe(a, b, filter_name, 0)
end 

local function SortAfter(a, b, filter_name)
    SortRecipe(a, b, filter_name, 1)
end

-- Pig Elder Shop.
AddRecipe2("kyno_saltrack_installer_p", {Ingredient("kyno_salmonfish", 2, ModAtlas)}, TECH.SERENITYSHOP_ONE, 
	{
		nounlock 			= true,
		no_deconstruction   = true,		
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give", 
		product				= "kyno_saltrack_installer",
		numtogive 			= 1, 
		atlas 				= ModAtlas, 
		image 				= "kyno_saltrack_installer.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_crabtrap_installer_p", {Ingredient("quagmire_pigeon", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_crabtrap_installer",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_crabtrap_installer.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sapbucket_installer_p", {Ingredient("kyno_salt", 3, ModAtlas)}, TECH.SERENITYSHOP_ONE, 
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sapbucket_installer",		
		numtogive 			= 3, 
		atlas 				= ModAtlas, 
		image 				= "kyno_sapbucket_installer.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_slaughtertool_p", {Ingredient("kyno_crabmeat", 2, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_slaughtertool",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_slaughtertool.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_hanger_p", {Ingredient("bonestew", 1), Ingredient("gorge_stone_soup", 1, ModAtlas), Ingredient("caviar", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_hanger",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_hanger.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_syrup_p", {Ingredient("taffy", 1), Ingredient("gorge_berry_tart", 1, ModAtlas), Ingredient("gummy_cake", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_syrup",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_hanger.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_oven_p", {Ingredient("dragonpie", 1), Ingredient("gorge_bread", 1), Ingredient("gorge_carrot_cake", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_oven",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_oven.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_small_grill_p", {Ingredient("kabobs", 1), Ingredient("gorge_sliders", 1, ModAtlas), Ingredient("steamedhamsandwich", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_small_grill",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_small_grill.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_kit_grill_p", {Ingredient("frogglebunwich", 1), Ingredient("gorge_hamburger", 1, ModAtlas), Ingredient("hardshell_tacos", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_grill",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_grill.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sweetpotato_seeds_p", {Ingredient("potato_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_sweetpotato",
		atlas 				= ModAtlas, 
		image				= "kyno_seeds_kit_sweetpotato.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_turnip_seeds_p", {Ingredient("garlic_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_turnip",
		atlas 				= ModAtlas, 
		image				= "kyno_seeds_kit_turnip.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_radish_seeds_p", {Ingredient("carrot_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_radish", 
		atlas 				= ModAtlas, 
		image				= "kyno_seeds_kit_radish.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_parznip_seeds_p", {Ingredient("pumpkin_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,		
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_parznip",
		atlas 				= ModAtlas, 
		image				= "kyno_seeds_kit_parznip.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_fennel_seeds_p", {Ingredient("durian_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_fennel",
		atlas 				= ModAtlas, 
		image				= "kyno_seeds_kit_fennel.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_cucumber_seeds_p", {Ingredient("watermelon_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_cucumber",
		atlas 				= ModAtlas, 
		image				= "kyno_seeds_kit_cucumber.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_aloe_seeds_p", {Ingredient("asparagus_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_seeds_kit_aloe",
		atlas 				= ModAtlas, 
		image				= "kyno_seeds_kit_aloe.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_saphealer_p", {Ingredient("kyno_sap_spoiled", 3, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_saphealer",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "kyno_saphealer.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sugartree_petals_p", {Ingredient("kyno_sugarfly", 1, ModAtlas)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sugartree_petals",		
		numtogive 			= 3, 
		atlas 				= ModAtlas, 
		image				= "kyno_sugartree_petals.tex",
	},
	{"CRAFTING_STATION"}
)

--[[
AddRecipe2("kyno_sugarfly_p", {Ingredient("butterfly", 1)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sugarfly",		
		numtogive 			= 1, 
		atlas 				= ModAtlas, 
		image				= "kyno_sugarfly.tex",
	},
	{"CRAFTING_STATION"}
)
]]--

AddRecipe2("kyno_sugartree_bud_p", {Ingredient("kyno_syrup", 3, ModAtlas)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sugartree_bud",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "kyno_sugartree_bud.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("dug_kyno_spotbush_p", {Ingredient("kyno_spotspice_leaf", 3)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,		
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "dug_kyno_spotbush",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "dug_kyno_spotbush.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("dug_kyno_wildwheat_p", {Ingredient("kyno_wheat", 3)}, TECH.LOST,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "dug_kyno_wildwheat",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "dug_kyno_wildwheat.tex",
	},
	{"CRAFTING_STATION"}
)