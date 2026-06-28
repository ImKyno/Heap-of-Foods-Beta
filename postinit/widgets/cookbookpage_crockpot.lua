local _G      = GLOBAL
local require = _G.require
local Widget  = require("widgets/widget")
local Image   = require("widgets/image")
local Text    = require("widgets/text")

local CookbookPageCrockPot = require("widgets/redux/cookbookpage_crockpot")
local _PopulateRecipeDetailPanel = CookbookPageCrockPot.PopulateRecipeDetailPanel

CookbookPageCrockPot.PopulateRecipeDetailPanel = function(self, data, ...)
	local result = _PopulateRecipeDetailPanel(self, data, ...)

	-- Remember: locked recipes does not have portrait_root
	if data and data.unlocked and data.recipe_def then
		local portrait_root

		if TUNING.HOF_DEBUG_MODE then
			print("RESULT:", result)
			print("TYPE:", type(result))
		end

		for _, child in pairs(result.children or {}) do
			if child.name == "portrait_root" then
				portrait_root = child
				break
			end
		end

		if TUNING.HOF_DEBUG_MODE then
			if result and result.children then
				print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel: Children:")

				for i, child in pairs(result.children) do
					print(i, child.name, child)
				end
			else
				print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel: No children found.")
			end
		end

		if not portrait_root then
			if TUNING.HOF_DEBUG_MODE then
				print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel: PORTRAIT_ROOT Not found!")
				print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel:Recipe:", data.recipe_name)
				print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel:Prefab:", data.recipe_def.name)
				print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel:Recipe Def:", data.recipe_def)

				if result and result.children then
					print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel: Children:")
				
					for _, child in pairs(result.children) do
						print(child.name)
					end
				else
					print("Heap of Foods Mod - CookbookPageCrockPot.PopulateRecipeDetailPanel: Result has no children.")
				end
			end

			return result
		end

		if portrait_root ~= nil and data.recipe_def.pigcoinvalue then
			local value = data.recipe_def.pigcoinvalue or {0, 0, 0}

			for _, child in pairs(portrait_root.children or {}) do
				if child.name == "coin_root" then
					child:Kill()
				end
			end

			local coin_root = portrait_root:AddChild(Widget("coin_root"))
			coin_root:SetPosition(-28, -50)

			for i = 1, 3 do
				local x = (i - 1) * 24

				local coin_offsets =
				{
					{ textx = 0, texty = -0.5 },
					{ textx = 0, texty = -0.5 },
					{ textx = 0, texty = -0.5 },
				}

				local pos = coin_offsets[i]

				local icon = coin_root:AddChild(Image("images/hof_pigcoinvalue_icons.xml", "kyno_pigcoin"..i..".tex"))
				icon:SetScale(0.55)
				icon:SetPosition(x + 4, 0)

				local str = tostring(value[i] or 0)
				local text = coin_root:AddChild(Text(BODYTEXTFONT, 16, str))

				local offset = 5.5

				if #str == 2 then
					offset = 5.7
				end

				text:SetHAlign(ANCHOR_MIDDLE)
				text:SetPosition(pos.textx + x + offset, pos.texty)
			end
		end
	end

	return result
end

-- Fake stats for showing nice values on Cookbook.
-- i.e: Wortox loses sanity if he's Nice inclined, but will show as positive values.
AddClassPostConstruct("widgets/redux/cookbookpage_crockpot", function(self)
	local _PopulateRecipeDetailPanel = self.PopulateRecipeDetailPanel

	function self:PopulateRecipeDetailPanel(data)
		if data and data.recipe_def then
			data.recipe_def.health = data.recipe_def.health2 or
			(data.recipe_def.health ~= nil and math.floor(10 * data.recipe_def.health) / 10) or nil

			data.recipe_def.hunger = data.recipe_def.hunger2 or
			(data.recipe_def.hunger ~= nil and math.floor(10 * data.recipe_def.hunger) / 10) or nil

			data.recipe_def.sanity = data.recipe_def.sanity2 or
			(data.recipe_def.sanity ~= nil and math.floor(10 * data.recipe_def.sanity) / 10) or nil
		end

		return _PopulateRecipeDetailPanel(self, data)
	end
end)