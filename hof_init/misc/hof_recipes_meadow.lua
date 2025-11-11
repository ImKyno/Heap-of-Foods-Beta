-- Common Dependencies.
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
local DefaultAtlas2    = "images/inventoryimages2.xml"
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

-- Sammy The Merchant.
AddRecipe2("meadowislandtrader_kyno_itemslicer_gold", {Ingredient("goldnugget", 20)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_itemslicer_gold",
		atlas               = ModAtlas,
		image               = "kyno_itemslicer_gold.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_bucket_metal", {Ingredient("antliontrinket", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_bucket_metal",
		atlas               = ModAtlas,
		image               = "kyno_bucket_metal.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_slow_farmplot_blueprint", {Ingredient("kyno_turnip", 10, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP",
		sg_state            = "give",
		product             = "slow_farmplot_blueprint",
		atlas               = DefaultAtlas,
		image               = "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_fast_farmplot_blueprint", {Ingredient("kyno_radish", 20, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP",
		sg_state            = "give",
		product             = "fast_farmplot_blueprint",
		atlas               = DefaultAtlas,
		image               = "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_goldenapple", {Ingredient("coolant", 1)}, TECH.LOST,
	{
		limitedamount       = true,
		nounlock            = true,
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP",
		sg_state            = "give",
		product             = "kyno_goldenapple",
		atlas               = ModAtlas,
		image               = "kyno_goldenapple.tex",
		fxover              = { bank = "inventory_fx_enchanted", build = "inventory_fx_enchanted", anim = "idle" },
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_foliage", {Ingredient("kyno_wheat", 1, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "foliage",
		atlas               = DefaultAtlas,
		image               = "foliage.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_succulent_picked", {Ingredient("kelp", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "succulent_picked",
		atlas               = DefaultAtlas,
		image               = "succulent_picked.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_barnacle", {Ingredient("fishmeat_small", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "barnacle",
		atlas               = DefaultAtlas1,
		image               = "barnacle.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_tallbirdegg", {Ingredient("kyno_chicken_egg", 1, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "tallbirdegg",
		atlas               = DefaultAtlas,
		image               = "tallbirdegg.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_butter", {Ingredient("butterflywings", 10)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "butter",
		atlas               = DefaultAtlas,
		image               = "butter.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_mandrake", {Ingredient("glommerwings", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "mandrake",
		atlas               = DefaultAtlas,
		image               = "mandrake.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_moon_cap", {Ingredient("kyno_white_cap", 1, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "moon_cap",
		atlas               = DefaultAtlas2,
		image               = "moon_cap.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_pineapple", {Ingredient("durian", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_pineapple",
		atlas               = ModAtlas,
		image               = "kyno_pineapple.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_roe_pondfish", {Ingredient("bird_egg", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_roe_pondfish",
		atlas               = ModAtlas,
		image               = "kyno_roe_pondfish.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_shark_fin", {Ingredient("trunk_summer", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_shark_fin",
		atlas               = ModAtlas,
		image               = "kyno_shark_fin.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_poison_froglegs", {Ingredient("froglegs", 5)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_poison_froglegs",
		atlas               = ModAtlas,
		image               = "kyno_poison_froglegs.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_moon_froglegs", {Ingredient("moonglass_charged", 3)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_moon_froglegs",
		atlas               = ModAtlas,
		image               = "kyno_moon_froglegs.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_crabkingmeat", {Ingredient("kyno_crabmeat", 5, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_crabkingmeat",
		atlas               = ModAtlas,
		image               = "kyno_crabkingmeat.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_worm_bone", {Ingredient("boneshard", 5)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_worm_bone",
		atlas               = ModAtlas,
		image               = "kyno_worm_bone.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_dug_kyno_coffeebush", {Ingredient("dug_berrybush", 3)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "dug_kyno_coffeebush",
		atlas               = ModAtlas,
		image               = "dug_kyno_coffeebush.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_nukashine_sugarfree", {Ingredient("nukashine", 1, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "nukashine_sugarfree",
		atlas               = ModAtlas,
		image               = "nukashine.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_bottlecap", {Ingredient("gears", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_bottlecap",
		atlas               = ModAtlas,
		image               = "kyno_bottlecap.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_antchovycan", {Ingredient("smallmeat", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_antchovycan",
		atlas               = ModAtlas,
		image               = "kyno_antchovycan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_tunacan", {Ingredient("meat", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_tunacan",
		atlas               = ModAtlas,
		image               = "kyno_tunacan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_meatcan", {Ingredient("fishmeat", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_meatcan",
		atlas               = ModAtlas,
		image               = "kyno_meatcan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_tomatocan", {Ingredient("kyno_seaweeds", 1, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_tomatocan",
		atlas               = ModAtlas,
		image               = "kyno_tomatocan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_beancan", {Ingredient("corn", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_beancan",
		atlas               = ModAtlas,
		image               = "kyno_beancan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_energycan", {Ingredient("cutlichen", 3)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_energycan",
		atlas               = ModAtlas,
		image               = "kyno_energycan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_cokecan", {Ingredient("kyno_coffeebeans_cooked", 3)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_cokecan",
		atlas               = ModAtlas,
		image               = "kyno_cokecan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_sodacan", {Ingredient("fig", 3)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_sodacan",
		atlas               = ModAtlas,
		image               = "kyno_sodacan.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_oceanfish_small_6_inv", {Ingredient("red_cap", 4)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "oceanfish_small_6_inv",
		atlas               = DefaultAtlas2,
		image               = "oceanfish_small_6_inv.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_oceanfish_medium_8_inv", {Ingredient("bluegem", 8)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "oceanfish_medium_8_inv",
		atlas               = DefaultAtlas2,
		image               = "oceanfish_medium_8_inv.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_oceanfish_small_7_inv", {Ingredient("plantmeat", 4)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "oceanfish_small_7_inv",
		atlas               = DefaultAtlas2,
		image               = "oceanfish_small_7_inv.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_oceanfish_small_8_inv", {Ingredient("redgem", 8)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "oceanfish_small_8_inv",
		atlas               = DefaultAtlas2,
		image               = "oceanfish_small_8_inv.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_piko", {Ingredient("rabbit", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_piko",
		atlas               = ModAtlas,
		image               = "kyno_piko.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_piko_orange", {Ingredient("rabbit", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_piko_orange",
		atlas               = ModAtlas,
		image               = "kyno_piko_orange.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_chicken2", {Ingredient("crow", 1)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_chicken2",
		atlas               = ModAtlas,
		image               = "kyno_chicken2.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_kyno_seeds_kit_rice", {Ingredient("kyno_aloe_seeds", 3, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "kyno_seeds_kit_rice",
		atlas               = ModAtlas,
		image               = "kyno_seeds_kit_rice.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_forgetmelots_seeds", {Ingredient("kyno_turnip_seeds", 3, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "forgetmelots_seeds",
		numtogive           = 3,
		atlas               = ModAtlas,
		image               = "forgetmelots_seeds.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_tillweed_seeds", {Ingredient("kyno_fennel_seeds", 3, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "tillweed_seeds",
		numtogive           = 3,
		atlas               = ModAtlas,
		image               = "tillweed_seeds.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("meadowislandtrader_firenettles_seeds", {Ingredient("kyno_radish_seeds", 3, ModAtlas)}, TECH.LOST,
	{
		limitedamount       = true, 
		nounlock            = true, 
		no_deconstruction   = true,
		hint_msg            = "NEEDSMEADOWSHOP",
		actionstr           = "MEADOWSHOP", 
		sg_state            = "give", 
		product             = "firenettles_seeds",
		numtogive           = 3,
		atlas               = ModAtlas,
		image               = "firenettles_seeds.tex",
	},
	{"CRAFTING_STATION"}
)