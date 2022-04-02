------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G            = GLOBAL
local TECH 			= _G.TECH
local Ingredient 	= _G.Ingredient
local RECIPETABS 	= _G.RECIPETABS
local AllRecipes 	= _G.AllRecipes
local Recipe 		= _G.Recipe
local Recipe2 		= _G.Recipe2
local TechTree = require("techtree")
local RecipeFilter		= require("recipes_filter")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Custom TechTree for Mealing Stone.
table.insert(TechTree.AVAILABLE_TECH, "MEALING")
table.insert(TechTree.AVAILABLE_TECH, "SERENITYSHOP")

TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
	    t[v] = t[v] or 0
	end
	return t
end

-- Mealing Stone.
_G.TECH.NONE.MEALING 		= 0
_G.TECH.MEALING_ONE 		= { MEALING 			= 1 }
_G.TECH.MEALING_TWO 		= { MEALING 			= 2 }

-- Pig Elder.
_G.TECH.NONE.SERENITYSHOP	= 0
_G.TECH.SERENITYSHOP_ONE 	= { SERENITYSHOP 		= 1 }
_G.TECH.SERENITYSHOP_TWO	= { SERENITYSHOP_TWO 	= 2 }

for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v.MEALING 		= 0
	v.SERENITYSHOP 	= 0
end

TUNING.PROTOTYPER_TREES.MEALING_ONE 		= TechTree.Create({
    MEALING 		= 1,
})
TUNING.PROTOTYPER_TREES.MEALING_TWO 		= TechTree.Create({
	MEALING 		= 2,
})

TUNING.PROTOTYPER_TREES.SERENITYSHOP_ONE 	= TechTree.Create({
	SERENITYSHOP	= 1,
})

TUNING.PROTOTYPER_TREES.SERENITYSHOP_TWO 	= TechTree.Create({
	SERENITYSHOP	= 2,
})

for i, v in pairs(_G.AllRecipes) do
	if v.level.MEALING == nil then
		v.level.MEALING = 0
	end
	
	if v.level.SERENITYSHOP == nil then
		v.level.SERENITYSHOP = 0
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Custom Prototyper and Recipe Filters.
AddPrototyperDef("kyno_mealgrinder", 
	{ 
		icon_atlas 			= "images/tabimages/hof_tabimages.xml", 
		icon_image 			= "kyno_tab_mealing.tex", 
		is_crafting_station = true, 
		action_str 			= "MEALGRINDER", 
		filter_text 		= "Food Ingredients",
	}
)

AddPrototyperDef("kyno_serenityisland_shop",
	{
		icon_atlas			= "images/tabimages/hof_tabimages.xml",
		icon_image			= "kyno_tab_serenity.tex",
		is_crafting_station	= true,
		action_str			= "TRADE",
		filter_text			= "Elder's Supplies",
	}
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ingredient and Structures Recipes.
local DefaultAtlas 			= "images/inventoryimages.xml"
local ModAtlas     			= "images/inventoryimages/hof_inventoryimages.xml"
local ModBuildAtlas			= "images/inventoryimages/hof_buildingimages.xml"

local KynFlour 				= AddRecipe2("kyno_flour_p", {Ingredient("kyno_wheat", 2, ModAtlas)}, TECH.MEALING_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "MEALGRINDER", 
		product				= "kyno_flour",
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image 				= "quagmire_flour.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSpice 				= AddRecipe2("kyno_spotspice_p", {Ingredient("kyno_spotspice_leaf", 2, ModAtlas)}, TECH.MEALING_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "MEALGRINDER", 
		product				= "kyno_spotspice",
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image 				= "quagmire_spotspice_ground.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSalt 				= AddRecipe2("kyno_salt_p", {Ingredient("saltrock", 2)}, TECH.MEALING_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "MEALGRINDER", 
		product				= "kyno_salt",
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image 				= "quagmire_salt.tex",
	},
	{"CRAFTING_STATION"}
)

local KynBacon 				= AddRecipe2("kyno_bacon_p", {Ingredient("smallmeat", 1)}, TECH.MEALING_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "MEALGRINDER", 
		product				= "kyno_bacon",
		numtogive 			= 2, 
		atlas 				= DefaultAtlas, 
		image 				= "quagmire_smallmeat.tex",
	},
	{"CRAFTING_STATION"}
)

local KynStick 				= AddRecipe2("kyno_musselstick_item", {Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("boards", 1)}, TECH.SCIENCE_TWO, 
	{
		atlas 				= ModAtlas, 
		image 				= "kyno_musselstick_item.tex",
	},
	{"COOKING"}
)

local KynMealing 			= AddRecipe2("kyno_mealgrinder", {Ingredient("cutstone", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO, 
	{
		placer 				= "kyno_mealgrinder_placer", 
		min_spacing 		= 1, 
		atlas 				= ModBuildAtlas, 
		image 				= "hof_mealgrinder.tex",
	},
	{"PROTOTYPERS"}
) 

local KynMusher 			= AddRecipe2("kyno_mushstump", {Ingredient("spoiled_food", 4), Ingredient("poop", 3), Ingredient("livinglog", 2)}, TECH.SCIENCE_TWO, 
	{
		placer 				= "kyno_mushstump_placer", 
		min_spacing			= 1, 
		atlas 				= ModBuildAtlas, 
		image 				= "hof_mushroomstump.tex",
	},
	{"COOKING"}
)

local KynFloat      		= AddRecipe2("kyno_floatilizer", {Ingredient("poop", 3), Ingredient("kelp", 2), Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
	{
		atlas 				= ModAtlas,
		image       		= "kyno_floatilizer.tex",
	},	
	{"GARDENING"}
)

local KynSaltRack 			= AddRecipe2("kyno_saltrack_installer_p", {Ingredient("kyno_salmonfish", 2, ModAtlas)}, TECH.SERENITYSHOP_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give", 
		product				= "kyno_saltrack_installer",
		numtogive 			= 1, 
		atlas 				= ModAtlas, 
		image 				= "kyno_saltrack_installer.tex",
	},
	{"CRAFTING_STATION"}
)

local KynCrabTrap			= AddRecipe2("kyno_crabtrap_installer_p", {Ingredient("quagmire_pigeon", 1)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_crabtrap_installer",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_crabtrap_installer.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSapBucket 			= AddRecipe2("kyno_sapbucket_installer_p", {Ingredient("kyno_salt", 3, ModAtlas)}, TECH.SERENITYSHOP_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sapbucket_installer",		
		numtogive 			= 3, 
		atlas 				= ModAtlas, 
		image 				= "kyno_sapbucket_installer.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSlaughter			= AddRecipe2("kyno_slaughtertool_p", {Ingredient("kyno_crabmeat", 2, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_slaughtertool",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_slaughtertool.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSeedPotato 		= AddRecipe2("kyno_sweetpotato_seeds_p", {Ingredient("potato_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sweetpotato_seeds",		
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image				= "quagmire_seedpacket_4.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSeedTurnip 		= AddRecipe2("kyno_turnip_seeds_p", {Ingredient("garlic_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_turnip_seeds", 		
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image				= "quagmire_seedpacket_5.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSeedRadish 		= AddRecipe2("kyno_radish_seeds_p", {Ingredient("carrot_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_radish_seeds",
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image				= "quagmire_seedpacket_3.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSeedParnip 		= AddRecipe2("kyno_parznip_seeds_p", {Ingredient("pumpkin_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_parznip_seeds", 		
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image				= "quagmire_seedpacket_2.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSeedFennel 		= AddRecipe2("kyno_fennel_seeds_p", {Ingredient("durian_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_fennel_seeds",		
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image				= "quagmire_seedpacket_6.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSeedCucumb 		= AddRecipe2("kyno_cucumber_seeds_p", {Ingredient("watermelon_seeds", 3)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_cucumber_seeds",		
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image				= "quagmire_seedpacket_7.tex",
	},
	{"CRAFTING_STATION"}
)

local KynElderTurf1			= AddRecipe2("turf_pinkpark_p", {Ingredient("turf_deciduous", 2)}, TECH.LOST,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "turf_pinkpark_blueprint",		
		numtogive 			= 1, 
		atlas 				= ModAtlas, 
		image				= "turf_pinkpark.tex",
	},
	{"CRAFTING_STATION"}
)

local KynElderTurf2			= AddRecipe2("turf_stonecity_p", {Ingredient("cutstone", 1), Ingredient("flint", 2)}, TECH.LOST,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "turf_stonecity_blueprint",		
		numtogive 			= 1, 
		atlas 				= ModAtlas, 
		image				= "turf_stonecity.tex",
	},
	{"CRAFTING_STATION"}
)

local KynElderSpotBush		= AddRecipe2("dug_kyno_spotbush_p", {Ingredient("kyno_spotspice_leaf", 2)}, TECH.LOST,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "dug_kyno_spotbush",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "dug_kyno_spotbush.tex",
	},
	{"CRAFTING_STATION"}
)

local KynElderWheatBush		= AddRecipe2("dug_kyno_wildwheat_p", {Ingredient("kyno_sap", 2)}, TECH.LOST,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "dug_kyno_wildwheat",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "dug_kyno_wildwheat.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSugarTreeSeed		= AddRecipe2("kyno_sugartree_bud_p", {Ingredient("gorge_syrup", 1)}, TECH.LOST,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sugartree_bud",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "kyno_sugartree_bud.tex",
	},
	{"CRAFTING_STATION"}
)

-- Don't add the Turfs recipes if T.A.P or Not Enough Turfs is enabled.
if not _G.KnownModIndex:IsModEnabled("workshop-2428854303") or _G.KnownModIndex:IsModEnabled("workshop-2528541304") then
local KynTurfParkfiedl		= AddRecipe2("turf_pinkpark", {Ingredient("turf_deciduous", 1)}, TECH.TURFCRAFTING_ONE,
	{
		numtogive 			= 4, 
		atlas 				= ModAtlas, 
		image				= "turf_pinkpark.tex",
	},
	{"DECOR"}
)	

local KynTurfParkfiedl		= AddRecipe2("turf_stonecity", {Ingredient("cutstone", 1), Ingredient("flint", 2)}, TECH.TURFCRAFTING_ONE,
	{
		numtogive 			= 4, 
		atlas 				= ModAtlas, 
		image				= "turf_stonecity.tex",
	},
	{"DECOR"}
)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------