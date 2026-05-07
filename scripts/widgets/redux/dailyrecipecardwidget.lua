local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Widget = require("widgets/widget")
local UIAnim = require("widgets/uianim")
local Text = require("widgets/text")
local Grid = require("widgets/grid")
local Spinner = require("widgets/spinner")
local TEMPLATES = require("widgets/redux/templates")
local DAILY_RECIPES = require("hof_dailyrecipes")

local cooking = require("cooking")
local brewing = require("hof_brewing")

require("util")

local function MakeDetailsLine(parent, x, y, scale, tex)
	local line = parent:AddChild(Image("images/quagmire_recipebook.xml", tex or "quagmire_recipe_line.tex"))

	line:SetPosition(x, y)
	line:SetScale(scale or 1, scale or 1)

	return line
end

local DailyRecipeCardWidget = Class(Widget, function(self, owner, data)
	Widget._ctor(self, "DailyRecipeCardWidget")

	self.owner = owner

	self.root = self:AddChild(Widget("root"))
	self.root:SetPosition(0, 40)
	self.root:SetScale(1, 1)

	self.details_root = self.root:AddChild(Widget("details_root"))
	self.details_root:SetPosition(0, 0)
	self.details_root.panel_width = 350
	self.details_root.panel_height = 500

	if data ~= nil then
		self:BuildDailyRecipeCard(data)
	end
end)

local ingredient_icon_remap  = {}
ingredient_icon_remap.onion  = "quagmire_onion"
ingredient_icon_remap.tomato = "quagmire_tomato"
ingredient_icon_remap.acorn  = "acorn_cooked"
ingredient_icon_remap.trunk  = "trunk_cooked"

local ingredient_name_remap  = {}
ingredient_name_remap.acorn  = "acorn_cooked"
ingredient_name_remap.trunk  = "trunk_cooked"

function DailyRecipeCardWidget:SetupRecipeIngredientDetails(recipes, parent, y)
	local ingredient_size = 30
	local x_spacing = 2

	local inv_backing_root = parent:AddChild(Widget("inv_backing_root"))
	local inv_item_root = parent:AddChild(Widget("inv_item_root"))

	local items = recipes

	if not items then
		return
	end

	local function ParseIngredient(ing)
		if type(ing) == "table" then
			if type(ing[1]) == "string" then
				return ing[1], ing[2] or 1
			elseif ing.name then
				return ing.name, ing.amount or 1
			end
		end

		return nil, nil
	end

	local total_width = 0

	for i = 1, #items do
		local _, amount = ParseIngredient(items[i])
		total_width = total_width + amount
	end

	total_width = total_width * ingredient_size + (total_width - 1) * x_spacing
	local start_x = -total_width / 2.6

	local x_cursor = 0

	for i = 1, #items do
		local name, amount = ParseIngredient(items[i])

		if name and amount > 0 then
			for a = 1, amount do
				local x = start_x + x_cursor * (ingredient_size + x_spacing)

				local pos = Vector3(x, y - ingredient_size / 2, 0)

				local backing = inv_backing_root:AddChild(
					Image("images/quagmire_recipebook.xml", "ingredient_slot.tex")
				)
				backing:ScaleToSize(ingredient_size, ingredient_size)
				backing:SetPosition(pos)

				local img_name = (ingredient_icon_remap[name] or name) .. ".tex"
				local img_atlas = GetInventoryItemAtlas(img_name, true)

				local img = inv_item_root:AddChild(
					Image(img_atlas or "images/quagmire_recipebook.xml",
					img_atlas ~= nil and img_name or "cookbook_missing.tex")
				)

				img:ScaleToSize(ingredient_size, ingredient_size)
				img:SetPosition(pos)

				img:SetHoverText(
					STRINGS.NAMES[string.upper(ingredient_name_remap[name] or name)] or name
				)

				x_cursor = x_cursor + 1
			end
		end
	end
end

function DailyRecipeCardWidget:GetCookingTimeString(cooktime)
	return cooktime == nil and STRINGS.UI.COOKBOOK.COOKINGTIME_UNKNOWN
	or cooktime < 1.0 and STRINGS.UI.COOKBOOK.COOKINGTIME_SHORT
	or cooktime < 2.0 and STRINGS.UI.COOKBOOK.COOKINGTIME_AVERAGE
	or cooktime < 2.5 and STRINGS.UI.COOKBOOK.COOKINGTIME_LONG
	or STRINGS.UI.COOKBOOK.COOKINGTIME_VERY_LONG
end

function DailyRecipeCardWidget:GetBrewingTimeString(cooktime)
	return cooktime == nil and STRINGS.UI.COOKBOOK.COOKINGTIME_UNKNOWN
	or cooktime < 25 and STRINGS.UI.COOKBOOK.COOKINGTIME_SHORT
	or cooktime < 49 and STRINGS.UI.COOKBOOK.COOKINGTIME_AVERAGE
	or cooktime < 73 and STRINGS.UI.COOKBOOK.COOKINGTIME_LONG
	or STRINGS.UI.COOKBOOK.COOKINGTIME_VERY_LONG
end

function DailyRecipeCardWidget:GetSpoilString(perishtime)
	return perishtime == nil and STRINGS.UI.COOKBOOK.PERISH_NEVER
	or perishtime <= TUNING.PERISH_SUPERFAST and STRINGS.UI.COOKBOOK.PERISH_VERY_QUICKLY
	or perishtime <= TUNING.PERISH_FAST and STRINGS.UI.COOKBOOK.PERISH_QUICKLY
	or perishtime <= TUNING.PERISH_MED and STRINGS.UI.COOKBOOK.PERISH_AVERAGE
	or perishtime <= TUNING.PERISH_SLOW and STRINGS.UI.COOKBOOK.PERISH_SLOWLY
	or STRINGS.UI.COOKBOOK.PERISH_VERY_SLOWLY
end

function DailyRecipeCardWidget:GetSideEffectString(recipe_def)
	return recipe_def.oneat_desc
	or (recipe_def.temperature ~= nil and recipe_def.temperature > 0) and STRINGS.UI.COOKBOOK.FOOD_EFFECTS_HOT_FOOD
	or (recipe_def.temperature ~= nil and recipe_def.temperature < 0) and STRINGS.UI.COOKBOOK.FOOD_EFFECTS_COLD_FOOD
	or STRINGS.UI.COOKBOOK.FOOD_EFFECTS_NONE
end

function DailyRecipeCardWidget:GetDailyRecipeCardAssets(data)
	local recipe_def = data.recipe_def

	local prefab = data.prefab
	local img_name = recipe_def.cookbook_tex or (prefab..".tex")

	local atlas = recipe_def.cookbook_atlas or GetInventoryItemAtlas(img_name, true)

	if atlas ~= nil then
		return atlas, img_name
	end

	return "images/quagmire_recipebook.xml", "cookbook_missing.tex"
end

function DailyRecipeCardWidget:BuildDailyRecipeCard(data)
	local top = self.details_root.panel_height / 2
	local left = -self.details_root.panel_width / 2

	local details_root = self.details_root
	details_root:KillAllChildren()

	local y = top - 11
	local image_size = 110

	local name_font_size = 34
	local title_font_size = 18
	local body_font_size = 16
	local value_title_font_size = 18
	local value_body_font_size = 16

	if data.recipe_def then
		local bg = details_root:AddChild(Image("images/hof_dailyrecipecard.xml", "hof_dailyrecipecard.tex"))
		bg:SetPosition(0, 0)
		bg:SetTint(1, 1, 1, 1)
		bg:MoveToBack()
		bg:ScaleToSize(self.details_root.panel_width * 1.2, self.details_root.panel_height * 1.1)

		----------------------------------------------------------------
		-- RECIPE OF THE DAY
		y = y - 5

		local main_title = details_root:AddChild(
			Text(HEADERFONT, name_font_size - 2, STRINGS.DAILYRECIPE, UICOLOURS.BROWN_DARK)
		)
		main_title:SetPosition(0, y)

		y = y - name_font_size / 2
		MakeDetailsLine(details_root, 0, y - 12, .7, "quagmire_recipe_line_break.tex")
		y = y - 25

		----------------------------------------------------------------
		-- RECIPE NAME
		y = y - name_font_size / 2

		local title = details_root:AddChild(
			Text(HEADERFONT, name_font_size - 8, data.name, UICOLOURS.BROWN_DARK)
		)
		title:SetPosition(0, y - 8)

		y = y - name_font_size / 2
		MakeDetailsLine(details_root, 0, y - 6, 1, "quagmire_recipe_line_short.tex")
		y = y - 25

		----------------------------------------------------------------
		-- RECIPE ICON
		local frame = details_root:AddChild(Image("images/quagmire_recipebook.xml", "recipe_known.tex"))
		frame:ScaleToSize(image_size, image_size)

		y = y - image_size / 2
		frame:SetPosition(left + image_size / 2 + 30, y)
		y = y - image_size / 2

		local portrait_root = details_root:AddChild(Widget("portrait_root"))
		portrait_root:SetPosition(frame:GetPosition())

		local atlas, tex = self:GetDailyRecipeCardAssets(data)
		local icon_size = image_size - 20

		local food_img = portrait_root:AddChild(Image(atlas, tex))
		food_img:ScaleToSize(icon_size, icon_size)

		----------------------------------------------------------------
		-- RECIPE STATS
		local details_x = 60
		local details_y = y + 85
		local status_scale = 0.7

		local health = data.recipe_def.health and math.floor(10 * data.recipe_def.health) / 10 + 15 or 0
		local hunger = data.recipe_def.hunger and math.floor(10 * data.recipe_def.hunger) / 10 + 15 or 0
		local sanity = data.recipe_def.sanity and math.floor(10 * data.recipe_def.sanity) / 10 + 15 or 0

		local h = details_root:AddChild(TEMPLATES.MakeUIStatusBadge("health"))
		h:SetPosition(details_x - 60, details_y)
		h.status_value:SetString(health)
		h:SetScale(status_scale)

		local hu = details_root:AddChild(TEMPLATES.MakeUIStatusBadge("hunger"))
		hu:SetPosition(details_x, details_y)
		hu.status_value:SetString(hunger)
		hu:SetScale(status_scale)

		local s = details_root:AddChild(TEMPLATES.MakeUIStatusBadge("sanity"))
		s:SetPosition(details_x + 60, details_y)
		s.status_value:SetString(sanity)
		s:SetScale(status_scale)

		y = details_y - 50

		----------------------------------------------------------------
		-- RECIPE SIDE EFFECT
		local effects_str = self:GetSideEffectString(data.recipe_def)

		if effects_str then
			local effects_title = details_root:AddChild(
				Text(HEADERFONT, value_title_font_size, STRINGS.UI.COOKBOOK.FOOD_EFFECTS_TITLE, UICOLOURS.BROWN_DARK)
			)
			effects_title:SetPosition(details_x, y - 6)

			y = y - 15
			MakeDetailsLine(details_root, details_x, y, .5, "quagmire_recipe_line_short.tex")

			y = y - 15

			local effects = details_root:AddChild(
				Text(HEADERFONT, value_body_font_size, effects_str, UICOLOURS.BROWN_DARK)
			)
			effects:SetPosition(details_x, y)

			y = y - 25
		end

		----------------------------------------------------------------
		-- RECIPE FOOD TYPE / SPOILS
		local row_start_y = y
		local column_offset_x = 80

		-- FOOD TYPE
		y = row_start_y
		local food_title = details_root:AddChild(
			Text(HEADERFONT, title_font_size, STRINGS.UI.COOKBOOK.FOOD_TYPE_TITLE, UICOLOURS.BROWN_DARK)
		)
		food_title:SetPosition(-column_offset_x, y - 5)

		y = y - 14
		MakeDetailsLine(details_root, -column_offset_x, y, .5, "quagmire_recipe_line_veryshort.tex")

		y = y - 14
		local food_str = STRINGS.UI.FOOD_TYPES[data.recipe_def.foodtype or FOODTYPE.GENERIC]

		local food_text = details_root:AddChild(
			Text(HEADERFONT, body_font_size, food_str, UICOLOURS.BROWN_DARK)
		)
		food_text:SetPosition(-column_offset_x, y)

		-- SPOILS
		y = row_start_y

		local spoil_title = details_root:AddChild(
			Text(HEADERFONT, title_font_size, STRINGS.UI.COOKBOOK.PERISH_RATE_TITLE, UICOLOURS.BROWN_DARK)
		)
		spoil_title:SetPosition(column_offset_x, y - 5)

		y = y - 14
		MakeDetailsLine(details_root, column_offset_x, y, .5, "quagmire_recipe_line_veryshort.tex")

		y = y - 14
		local spoil = self:GetSpoilString(data.recipe_def.perishtime)

		local spoil_text = details_root:AddChild(
			Text(HEADERFONT, body_font_size, spoil, UICOLOURS.BROWN_DARK)
		)
		spoil_text:SetPosition(column_offset_x, y)

		----------------------------------------------------------------
		-- RECIPE COOKTIME
		y = y - 25

		local cooktitle = (data.system == "brewing")
			and STRINGS.UI.COOKBOOK.BREWINGTIME_TITLE
			or STRINGS.UI.COOKBOOK.COOKINGTIME_TITLE

		local cook_title = details_root:AddChild(
			Text(HEADERFONT, title_font_size, cooktitle, UICOLOURS.BROWN_DARK)
		)
		cook_title:SetPosition(0, y - 5)

		y = y - 15
		MakeDetailsLine(details_root, 0, y, .7, "quagmire_recipe_line_veryshort.tex")

		y = y - 15

		local cooktime = (data.system == "brewing")
			and self:GetBrewingTimeString(data.recipe_def.cooktime)
			or self:GetCookingTimeString(data.recipe_def.cooktime)

		local cook_text = details_root:AddChild(
			Text(HEADERFONT, body_font_size + 1, cooktime, UICOLOURS.BROWN_DARK)
		)
		cook_text:SetPosition(0, y + 2)

		y = y - 20
		MakeDetailsLine(details_root, 0, y, .8, "quagmire_recipe_line_short.tex")

		----------------------------------------------------------------
		-- RECIPE INGREDIENTS
		y = y - 25

		local ing_title = details_root:AddChild(
			Text(HEADERFONT, title_font_size, STRINGS.DAILYRECIPE_INGREDIENTS, UICOLOURS.BROWN_DARK)
		)
		ing_title:SetPosition(0, y + 6)

		y = y - 15

		self:SetupRecipeIngredientDetails(data.recipes, details_root, y + 7)

		y = y - 33
		MakeDetailsLine(details_root, 0, y, .8, "quagmire_recipe_line_short.tex")

		----------------------------------------------------------------
		-- RECIPE OF THE DAY DESCRIPTION
		y = y - 41

		local description_text = data.recipe_def.description or STRINGS.DAILYRECIPE_DESCRIPTION

		local desc = details_root:AddChild(
			Text(HEADERFONT, body_font_size - 2, description_text, UICOLOURS.BROWN_DARK)
		)
		desc:SetPosition(0, y)
		desc:SetRegionSize(320, 200)
		desc:SetHAlign(ANCHOR_MIDDLE)
	end
end

return DailyRecipeCardWidget