-- Common Dependencies.
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

-- Anniversary Event.
AddRecipe2("kyno_hofbirthday_5hat", {}, TECH.HOFBIRTHDAY,
	{
		hint_msg           = "NEEDSHOFBIRTHDAY",
		description        = "kyno_hofbirthday_hat",
		atlas              = ModAtlas,
		image              = "kyno_hofbirthday_5hat.tex",
	},
	{"SPECIAL_EVENT", "CLOTHING"}
)

AddRecipe2("kyno_hofbirthday_candle", {Ingredient("kyno_hofbirthday_cheer", 1), Ingredient("twigs", 1), Ingredient("beeswax", 1)}, TECH.HOFBIRTHDAY,
	{
		numtogive           = 5,
		hint_msg            = "NEEDSHOFBIRTHDAY",
		atlas               = ModAtlas,
		image               = "kyno_hofbirthday_candle.tex",
	},
	{"SPECIAL_EVENT", "LIGHT"}
)

AddRecipe2("kyno_hofbirthday_cake_empty_construction", {Ingredient("kyno_hofbirthday_cheer", 15), Ingredient("marble", 2)}, TECH.HOFBIRTHDAY,
	{
		min_spacing         = 2,
		placer              = "kyno_hofbirthday_cake_placer",
		hint_msg            = "NEEDSHOFBIRTHDAY",
		atlas               = ModAtlas,
		image               = "kyno_hofbirthday_cake.tex",
	},
	{"SPECIAL_EVENT", "COOKING"}
)

AddRecipe2("kyno_hofbirthday_balloons", {Ingredient("kyno_hofbirthday_cheer", 3), Ingredient("log", 1), Ingredient("rope", 1)}, TECH.HOFBIRTHDAY,
	{
		min_spacing         = 1,
		placer              = "kyno_hofbirthday_balloons_placer",
		hint_msg            = "NEEDSHOFBIRTHDAY",
		atlas               = ModAtlas,
		image               = "kyno_hofbirthday_balloons.tex",
	},
	{"SPECIAL_EVENT", "STRUCTURES", "DECOR"}
)

AddRecipe2("kyno_hofbirthday_popcornmachine", {Ingredient("kyno_hofbirthday_cheer", 15), Ingredient("gears", 3), Ingredient("transistor", 2), 
Ingredient("boards", 3)}, TECH.HOFBIRTHDAY,
	{
		hint_msg            = "NEEDSHOFBIRTHDAY",
		atlas               = ModAtlas,
		image               = "kyno_hofbirthday_popcornmachine.tex",
	},
	{"SPECIAL_EVENT", "COOKING", "STRUCTURES"}
)

-- I would like to let players use alternative ingredients
-- but well, Klei doesn't have a proper system for it. 🤡🤡
CONSTRUCTION_PLANS["kyno_hofbirthday_cake_empty_construction"] =
{
	Ingredient("kyno_flour",              5, ModAtlas, nil),
	Ingredient("bird_egg",                5, nil,      nil),
	Ingredient("kyno_milk_beefalo",       2, ModAtlas, nil),
	Ingredient("butter_beefalo",          1, ModAtlas, nil),
}

CONSTRUCTION_PLANS["kyno_hofbirthday_cake_construction"] =
{
	Ingredient("kyno_flour",              5, ModAtlas, nil),
	Ingredient("bird_egg",                5, nil,      nil),
	Ingredient("kyno_milk_beefalo",       3, ModAtlas, nil),
	Ingredient("kyno_hofbirthday_cheer",  1, ModAtlas, nil),
}

AddDeconstructRecipe("kyno_hofbirthday_cake_construction", {Ingredient("kyno_flour", 5), 
Ingredient("bird_egg", 5), Ingredient("kyno_milk_beefalo", 2), Ingredient("butter_beefalo", 1)})

CONSTRUCTION_PLANS["kyno_hofbirthday_cake_stage1_construction"] =
{
	Ingredient("kyno_sugar",              5, ModAtlas, nil),
	Ingredient("kyno_lotus_flower",       5, ModAtlas, nil),
	Ingredient("kyno_salt",               5, ModAtlas, nil),
	Ingredient("kyno_hofbirthday_cheer",  1, ModAtlas, nil),
}

AddDeconstructRecipe("kyno_hofbirthday_cake_stage1_construction", {Ingredient("kyno_flour", 5), 
Ingredient("bird_egg", 5), Ingredient("kyno_milk_beefalo", 3), Ingredient("kyno_hofbirthday_cheer", 1)})

CONSTRUCTION_PLANS["kyno_hofbirthday_cake_stage2_construction"] =
{
	Ingredient("kyno_flour",              5, ModAtlas, nil),
	Ingredient("bird_egg",                5, nil,      nil),
	Ingredient("kyno_milk_beefalo",       2, ModAtlas, nil),
	Ingredient("butter_beefalo",          1, ModAtlas, nil),
}

AddDeconstructRecipe("kyno_hofbirthday_cake_stage2_construction", {Ingredient("kyno_sugar", 5), 
Ingredient("kyno_lotus_flower", 5), Ingredient("kyno_salt", 5), Ingredient("kyno_hofbirthday_cheer", 1)})

CONSTRUCTION_PLANS["kyno_hofbirthday_cake_stage3_construction"] =
{
	Ingredient("kyno_sugar",              5, ModAtlas, nil),
	Ingredient("kyno_pineapple",          5, ModAtlas, nil),
	Ingredient("kyno_salt",               5, ModAtlas, nil),
	Ingredient("kyno_hofbirthday_cheer",  1, ModAtlas, nil),
}

AddDeconstructRecipe("kyno_hofbirthday_cake_stage3_construction", {Ingredient("kyno_flour", 5), 
Ingredient("bird_egg", 5), Ingredient("kyno_milk_beefalo", 2), Ingredient("butter_beefalo", 1)})

CONSTRUCTION_PLANS["kyno_hofbirthday_cake_stage4_construction"] =
{
	Ingredient("kyno_flour",              5, ModAtlas, nil),
	Ingredient("bird_egg",                5, nil,      nil),
	Ingredient("kyno_milk_beefalo",       2, ModAtlas, nil),
	Ingredient("butter_beefalo",          1, ModAtlas, nil),
}

AddDeconstructRecipe("kyno_hofbirthday_cake_stage4_construction", {Ingredient("kyno_sugar", 5), 
Ingredient("kyno_pineapple", 5), Ingredient("kyno_salt", 5), Ingredient("kyno_hofbirthday_cheer", 1)})

CONSTRUCTION_PLANS["kyno_hofbirthday_cake_stage5_construction"] =
{
	Ingredient("kyno_sugar",              5, ModAtlas, nil),
	Ingredient("chocolate_black",         5, ModAtlas, nil),
	Ingredient("kyno_salt",               5, ModAtlas, nil),
	Ingredient("kyno_hofbirthday_candle", 5, ModAtlas, nil),
}

AddDeconstructRecipe("kyno_hofbirthday_cake_stage5_construction", {Ingredient("kyno_flour", 5), 
Ingredient("bird_egg", 5), Ingredient("kyno_milk_beefalo", 2), Ingredient("butter_beefalo", 1)})

AddDeconstructRecipe("kyno_hofbirthday_cake", {Ingredient("kyno_flour", 5), Ingredient("kyno_hofbirthday_cheer", 1),
Ingredient("bird_egg", 5), Ingredient("kyno_milk_beefalo", 5), Ingredient("butter_beefalo", 1), Ingredient("kyno_salt", 5)})