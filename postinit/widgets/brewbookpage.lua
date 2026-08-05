local _G                = GLOBAL
local require           = _G.require
local Widget            = require("widgets/widget")
local Text              = require("widgets/text")
local Image             = require("widgets/image")
local TextButton        = require("widgets/textbutton")

local HOF_PIGCOINVALUES = GetModConfigData("PIGCOINVALUES", true)
local HOF_VIEWRECIPE    = GetModConfigData("VIEWRECIPE", true)

local BrewbookPage = require("widgets/redux/brewbookpage")
local _PopulateRecipeDetailPanel = BrewbookPage.PopulateRecipeDetailPanel

BrewbookPage.PopulateRecipeDetailPanel = function(self, data, ...)
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
				print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel: Children:")

				for i, child in pairs(result.children) do
					print(i, child.name, child)
				end
			else
				print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel: No children found.")
			end
		end

		if not portrait_root then
			if TUNING.HOF_DEBUG_MODE then
				print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel: PORTRAIT_ROOT Not found!")
				print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel:Recipe:", data.recipe_name)
				print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel:Prefab:", data.recipe_def.name)
				print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel:Recipe Def:", data.recipe_def)

				if result and result.children then
					print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel: Children:")
				
					for _, child in pairs(result.children) do
						print(child.name)
					end
				else
					print("Heap of Foods Mod - BrewbookPage.PopulateRecipeDetailPanel: Result has no children.")
				end
			end

			return result
		end

		if HOF_PIGCOINVALUES then
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
	end

	-- Show button for opening the recipe card on the Website.
	if HOF_VIEWRECIPE then
		if data and data.recipe_def and data.recipe_def.website_page then
			local button = result:AddChild(TextButton("images/ui.xml", "blank.tex", "blank.tex", "blank.tex", "blank.tex"))

			button:SetPosition(0, -212)
			button:SetFont(HEADERFONT)
			button:SetText(_G.STRINGS.UI.COOKBOOK.VIEW_RECIPE_WEBSITE)
			button:SetTextColour(UICOLOURS.BROWN_DARK)
			button:SetTextFocusColour(UICOLOURS.BROWN_MEDIUM)
			button:SetTextSize(20)

			button:SetOnGainFocus(function() button.text:SetSize(21) end)
			button:SetOnLoseFocus(function() button.text:SetSize(20) end)

			button:SetOnClick(function()
				VisitURL(("https://heap-of-foods.com/%s?recipe=%s"):format(data.recipe_def.website_page, data.prefab, false))
			end)
		end
	end

	return result
end