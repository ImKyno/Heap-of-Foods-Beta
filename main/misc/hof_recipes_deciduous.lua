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

CONSTRUCTION_PLANS["kyno_deciduousforest_shop"] =
{
	Ingredient("kyno_truffles",          20, ModAtlas, nil),
	Ingredient("cutstone",               10, nil,      nil),
	Ingredient("boards",                  5, nil,      nil),
	Ingredient("lantern",                 1, nil,      nil),
}