
local _G                      = GLOBAL
local require                 = _G.require
local IngredientUI            = require("widgets/ingredientui")
local CraftingMenuIngredients = require("widgets/redux/craftingmenu_ingredients")

require("util")

local INGREDIENTS_SCALE = 0.75

local function OnValidItem(recipe)
	if recipe == nil then
		return false
	end

	local recipe_name = recipe.name or recipe.product

	if recipe_name ~= nil and table.contains(TUNING.KYNO_CRAFTINGBUFF_BLACKLIST, recipe_name) then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "chesspiece") then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "critter") then
		return false
	end

	if recipe.actionstr ~= nil and string.find(recipe.actionstr, "SHOP") then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "shop") then
		return false
	end

	if recipe.actionstr ~= nil and string.find(recipe.actionstr, "TRADER") then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "trader") then
		return false
	end

	if recipe.hint_msg ~= nil and string.find(recipe.hint_msg, "HERMITCRAB") then
		return false
	end

	if recipe.name ~= nil and string.find(recipe.name, "hermitcrab") then
		return false
	end

	if recipe.placer ~= nil then
		return false
	end

	if recipe.manufactured then
		return false
	end

	return true
end

local _SetRecipe = CraftingMenuIngredients.SetRecipe
function CraftingMenuIngredients:SetRecipe(recipe, ...)
	local ret = { _SetRecipe(self, recipe, ...) }

	local owner = self.owner
	local builder = owner.replica.builder
	local inventory = owner.replica.inventory
	local last_ingredient = self.ingredient_widgets[#self.ingredient_widgets]

	if last_ingredient == nil or owner.kyno_craftingbuff_active == nil
	or not owner.kyno_craftingbuff_active:value() or not OnValidItem(recipe) then
		return _G.unpack(ret)
	end

	local root = last_ingredient:GetParent()

	local w = 64
	local div = 10
	local half_div = div * 0.5

	self.num_items = self.num_items + 1

	local scale = math.min(1, self.max_ingredients_wide / self.num_items)
	root:SetScale(scale * INGREDIENTS_SCALE)

	local quant_text_scale = math.max(1, 1 / (scale * 1.125))

	if self.extra_quantity_scale ~= nil then
		quant_text_scale = quant_text_scale * self.extra_quantity_scale
	end

	for _, ing in ipairs(self.ingredient_widgets) do
		if ing.quant ~= nil and ing.quant.SetScale ~= nil then
			ing.quant:SetScale(quant_text_scale, quant_text_scale)
		end

		local x, y, z = ing:GetPosition():Get()
		ing:SetPosition(x - (w * 0.5 + half_div), y, z)
	end

	local offset = last_ingredient:GetPosition():Get()

	offset = offset + w + half_div

	local brain_atlas = _G.resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")
	local brain_img = "brainmettersoup.tex"

	local brain = root:AddChild(IngredientUI(brain_atlas, brain_img, nil, nil, true,
	_G.STRINGS.BRAINMETTERSOUP_TOOLTIP, owner, nil, quant_text_scale))

	brain:SetPosition(offset + half_div, 0)

	table.insert(self.ingredient_widgets, brain)

	return _G.unpack(ret)
end