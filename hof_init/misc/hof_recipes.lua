-- Common Dependencies.
local _G            = GLOBAL
local TECH 			= _G.TECH
local Ingredient 	= _G.Ingredient
local RECIPETABS 	= _G.RECIPETABS
local AllRecipes 	= _G.AllRecipes
local Recipe 		= _G.Recipe
local Recipe2 		= _G.Recipe2
local TechTree 		= require("techtree")
local RecipeFilter	= require("recipes_filter")

local TheArchitectPack = _G.KnownModIndex:IsModEnabled("workshop-2428854303")
local NotEnoughTurfs   = _G.KnownModIndex:IsModEnabled("workshop-2528541304")

-- For sorting recipe.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
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

-- Custom Prototyper and Recipe Filters.
AddPrototyperDef("kyno_mealgrinder", 
	{ 
		icon_atlas 			= "images/tabimages/hof_tabimages.xml", 
		icon_image 			= "kyno_tab_mealing.tex", 
		is_crafting_station = true, 
		action_str 			= "MEALING", 
		filter_text 		= _G.STRINGS.UI.CRAFTING_FILTERS.MEALING,
	}
)

AddPrototyperDef("kyno_serenityisland_shop",
	{
		icon_atlas			= "images/tabimages/hof_tabimages.xml",
		icon_image			= "kyno_tab_serenity.tex",
		is_crafting_station	= true,
		action_str			= "TRADE",
		filter_text			= _G.STRINGS.UI.CRAFTING_FILTERS.SERENITYSHOP,
	}
)

-- Ingredient and Structures Recipes.
local DefaultAtlas 			= "images/inventoryimages.xml"
local ModAtlas     			= "images/inventoryimages/hof_inventoryimages.xml"

local KynFlour 				= AddRecipe2("kyno_flour", {Ingredient("kyno_wheat", 2, ModAtlas)}, TECH.MEALING_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "MEALGRINDER", 
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image 				= "quagmire_flour.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSpice 				= AddRecipe2("kyno_spotspice", {Ingredient("kyno_spotspice_leaf", 2, ModAtlas)}, TECH.MEALING_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "MEALGRINDER", 
		numtogive 			= 3, 
		atlas 				= DefaultAtlas, 
		image 				= "quagmire_spotspice_ground.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSalt 				= AddRecipe2("kyno_salt", {Ingredient("saltrock", 2)}, TECH.MEALING_ONE, 
	{
		nounlock 			= true, 
		actionstr 			= "MEALGRINDER", 
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

local KynOil				= AddRecipe2("kyno_oil", {Ingredient("corn", 1), Ingredient("seeds", 1), Ingredient("petals", 2)}, TECH.MEALING_ONE,
	{
		nounlock			= true,
		actionstr			= "MEALGRINDER",
		numtogive			= 3,
		atlas				= ModAtlas,
		image				= "kyno_oil.tex",
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

local KynMealing 			= AddRecipe2("kyno_mealgrinder", {Ingredient("cutstone", 2), Ingredient("flint", 2), Ingredient("hammer", 0)}, TECH.SCIENCE_TWO, 
	{
		placer 				= "kyno_mealgrinder_placer", 
		min_spacing 		= 1, 
		atlas 				= ModAtlas, 
		image 				= "kyno_mealgrinder.tex",
	},
	{"COOKING"}
) 
SortAfter("kyno_mealgrinder", "wintersfeastoven", "COOKING")

local KynMusher 			= AddRecipe2("kyno_mushstump", {Ingredient("spoiled_food", 4), Ingredient("poop", 3), Ingredient("livinglog", 2)}, TECH.SCIENCE_TWO, 
	{
		placer 				= "kyno_mushstump_placer", 
		min_spacing			= 1, 
		atlas 				= ModAtlas, 
		image 				= "kyno_mushroomstump.tex",
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
SortAfter("kyno_floatilizer", "fertilizer", "GARDENING")

local KynBucket				= AddRecipe2("kyno_bucket_empty", {Ingredient("boneshard", 1), Ingredient("boards", 1), Ingredient("rope", 1)}, TECH.SCIENCE_ONE,
	{
		atlas				= ModAtlas,
		image				= "kyno_bucket_empty.tex",
	},
	{"TOOLS"}
)
SortAfter("kyno_bucket_empty", "goldenpitchfork", "TOOLS")

local KynBrewbook			= AddRecipe2("kyno_brewbook", {Ingredient("papyrus", 1), Ingredient("kyno_wheat", 1, ModAtlas)}, TECH.SCIENCE_ONE,
	{
		atlas 				= ModAtlas,
		image				= "kyno_brewbook.tex",
	},
	{"COOKING"}
)
SortAfter("kyno_brewbook", "cookbook", "COOKING")

local KynKeg				= AddRecipe2("kyno_woodenkeg", {Ingredient("boards", 3), Ingredient("rope", 2), Ingredient("nitre", 2), Ingredient("hammer", 0)}, TECH.SCIENCE_TWO,
	{
		placer 				= "kyno_woodenkeg_placer", 
		min_spacing			= 1, 
		atlas 				= ModAtlas, 
		image 				= "kyno_woodenkeg.tex",
	},
	{"COOKING", "STRUCTURES"}
)
SortAfter("kyno_woodenkeg", "cookpot", "COOKING")
SortAfter("kyno_woodenkeg", "cookpot", "STRUCTURES")

local KynJar				= AddRecipe2("kyno_preservesjar", {Ingredient("boards", 3), Ingredient("rope", 2), Ingredient("nitre", 2), Ingredient("hammer", 0)}, TECH.SCIENCE_TWO,
	{
		placer 				= "kyno_preservesjar_placer", 
		min_spacing			= 1, 
		atlas 				= ModAtlas, 
		image 				= "kyno_preservesjar.tex",
	},
	{"COOKING", "STRUCTURES"}
)
SortAfter("kyno_preservesjar", "kyno_woodenkeg", "COOKING")
SortAfter("kyno_preservesjar", "kyno_woodenkeg", "STRUCTURES")

local KynHoneyDeposit       = AddRecipe2("kyno_antchest", {Ingredient("honeycomb", 1), Ingredient("honey", 6), Ingredient("boards", 2)}, TECH.LOST,
	{
		placer				= "kyno_antchest_placer",
		min_spacing			= 1,
		atlas				= ModAtlas,
		image				= "kyno_antchest_honey.tex",
	},
	{"COOKING", "CONTAINERS", "STRUCTURES"}
)
SortAfter("kyno_antchest", "saltbox", "CONTAINERS")
SortAfter("kyno_antchest", "saltbox", "STRUCTURES")
SortAfter("kyno_antchest", "saltbox", "COOKING")

-- Pig Elder Shop.
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

local KynCookpotKit			= AddRecipe2("kyno_kit_hanger_p", {Ingredient("bonestew", 1), Ingredient("gorge_stone_soup", 1, ModAtlas), Ingredient("caviar", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_hanger",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_hanger.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSyrupKit			= AddRecipe2("kyno_kit_syrup_p", {Ingredient("taffy", 1), Ingredient("gorge_berry_tart", 1, ModAtlas), Ingredient("gummy_cake", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_syrup",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_hanger.tex",
	},
	{"CRAFTING_STATION"}
)

local KynOvenKit			= AddRecipe2("kyno_kit_oven_p", {Ingredient("dragonpie", 1), Ingredient("gorge_bread", 1), Ingredient("gorge_carrot_cake", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_oven",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_oven.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSmallGrill			= AddRecipe2("kyno_kit_small_grill_p", {Ingredient("kabobs", 1), Ingredient("gorge_sliders", 1, ModAtlas), Ingredient("steamedhamsandwich", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_small_grill",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_small_grill.tex",
	},
	{"CRAFTING_STATION"}
)

local KynGrill				= AddRecipe2("kyno_kit_grill_p", {Ingredient("frogglebunwich", 1), Ingredient("gorge_hamburger", 1, ModAtlas), Ingredient("hardshell_tacos", 1, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock			= true,
		actionstr			= "SERENITYSHOP",
		sg_state			= "give",
		product				= "kyno_cookware_kit_grill",
		numtogive			= 1,
		atlas				= ModAtlas,
		image				= "kyno_cookware_kit_grill.tex",
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

local KynSugarAntidote		= AddRecipe2("kyno_saphealer_p", {Ingredient("kyno_sap_spoiled", 3, ModAtlas)}, TECH.SERENITYSHOP_ONE,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_saphealer",		
		numtogive 			= 2, 
		atlas 				= ModAtlas, 
		image				= "kyno_saphealer.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSweetFlower		= AddRecipe2("kyno_sugartree_petals_p", {Ingredient("kyno_sugarfly", 3, ModAtlas)}, TECH.LOST,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "kyno_sugartree_petals",		
		numtogive 			= 3, 
		atlas 				= ModAtlas, 
		image				= "kyno_sugartree_petals.tex",
	},
	{"CRAFTING_STATION"}
)

local KynSugarTreeSeed		= AddRecipe2("kyno_sugartree_bud_p", {Ingredient("kyno_syrup", 3, ModAtlas)}, TECH.LOST,
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

local KynElderSpotBush		= AddRecipe2("dug_kyno_spotbush_p", {Ingredient("kyno_spotspice_leaf", 3)}, TECH.LOST,
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

local KynElderWheatBush		= AddRecipe2("dug_kyno_wildwheat_p", {Ingredient("kyno_sap", 3)}, TECH.LOST,
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

local KynPotatoSack        =  AddCharacterRecipe("potatosack2", {Ingredient("cutgrass", 4), Ingredient("papyrus", 1), Ingredient("rope", 2)}, TECH.SCIENCE_ONE,
	{
		builder_tag = "strongman",
		product     = "potatosack",
		atlas       = "images/inventoryimages2.xml",
		image       = "potato_sack_full.tex",
	},
	{"CONTAINERS", "COOKING"}
)
SortAfter("potatosack2", "mighty_gym", "CHARACTER")
SortBefore("potatosack2", "icebox", "CONTAINERS")
SortBefore("potatosack2", "icebox", "COOKING")

AddDeconstructRecipe("potatosack", {Ingredient("cutgrass", 4), Ingredient("papyrus", 1), Ingredient("rope", 2)})

--[[ -- Disabled. You trade directly with him now.
local KynElderTurf1			= AddRecipe2("turf_pinkpark_p", {Ingredient("turf_deciduous", 2)}, TECH.LOST,
	{
		nounlock 			= true, 
		actionstr 			= "SERENITYSHOP",
		sg_state    		= "give",
		product				= "turf_pinkpark",		
		numtogive 			= 4, 
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
		product				= "turf_stonecity",		
		numtogive 			= 4, 
		atlas 				= ModAtlas, 
		image				= "turf_stonecity.tex",
	},
	{"CRAFTING_STATION"}
)
]]--

-- For people who wants to use Warly's Grinding Mill as the Mealing Stone.
local WARLY_MEALGRINDER = GetModConfigData("HOF_WARLYMEALGRINDER")
if WARLY_MEALGRINDER == 1 then
	local WarlyFlour 			= AddRecipe2("kyno_flour_w", {Ingredient("kyno_wheat", 2, ModAtlas)}, TECH.FOODPROCESSING_ONE, 
		{
			nounlock 			= true, 
			actionstr 			= "MEALGRINDER", 
			product				= "kyno_flour",
			builder_tag         = "professionalchef",
			numtogive 			= 3, 
			atlas 				= DefaultAtlas, 
			image 				= "quagmire_flour.tex",
		},
		{"CRAFTING_STATION"}
	)

	local WarlySpice 			= AddRecipe2("kyno_spotspice_w", {Ingredient("kyno_spotspice_leaf", 2, ModAtlas)}, TECH.FOODPROCESSING_ONE, 
		{
			nounlock 			= true, 
			actionstr 			= "MEALGRINDER", 
			product				= "kyno_spotspice",
			builder_tag         = "professionalchef",
			numtogive 			= 3, 
			atlas 				= DefaultAtlas, 
			image 				= "quagmire_spotspice_ground.tex",
		},
		{"CRAFTING_STATION"}
	)

	local WarlySalt 			= AddRecipe2("kyno_salt_w", {Ingredient("saltrock", 2)}, TECH.FOODPROCESSING_ONE, 
		{
			nounlock 			= true, 
			actionstr 			= "MEALGRINDER", 
			product				= "kyno_salt",
			builder_tag         = "professionalchef",
			numtogive 			= 3, 
			atlas 				= DefaultAtlas, 
			image 				= "quagmire_salt.tex",
		},
		{"CRAFTING_STATION"}
	)

	local WarlyBacon 			= AddRecipe2("kyno_bacon_w", {Ingredient("smallmeat", 1)}, TECH.FOODPROCESSING_ONE, 
		{
			nounlock 			= true, 
			actionstr 			= "MEALGRINDER", 
			product				= "kyno_bacon",
			builder_tag         = "professionalchef",
			numtogive 			= 2, 
			atlas 				= DefaultAtlas, 
			image 				= "quagmire_smallmeat.tex",
		},
		{"CRAFTING_STATION"}
	)
	
	local WarlyOil				= AddRecipe2("kyno_oil_w", {Ingredient("corn", 1), Ingredient("seeds", 1), Ingredient("petals", 2)}, TECH.FOODPROCESSING_ONE, 
	    {
			nounlock			= true,
			actionstr			= "MEALGRINDER",
			product				= "kyno_oil",
			builder_tag			= "professionalchef",
			numtogive			= 3,
			atlas				= DefaultAtlas,
			image				= "kyno_oil.tex",
		},
	{"CRAFTING_STATION"}
	)
end

-- Replace the Bucket-o-Poop recipe with ours.
local BUCKETPOOPTWEAK = GetModConfigData("HOF_FERTILIZERTWEAK")
if BUCKETPOOPTWEAK == 1 then
	local BucketPoop			= Recipe2("fertilizer",	{Ingredient("poop", 3), Ingredient("kyno_bucket_empty", 1, ModAtlas)}, TECH.SCIENCE_TWO,
		{
			atlas 				= DefaultAtlas,
			image       		= "fertilizer.tex",
		},	
		{"GARDENING"}
	)
end
