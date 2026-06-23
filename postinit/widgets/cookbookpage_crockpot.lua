local _G      = GLOBAL
local require = _G.require
local Widget  = require("widgets/widget")
local Image   = require("widgets/image")
local Text    = require("widgets/text")

local CookbookPageCrockPot = require("widgets/redux/cookbookpage_crockpot")
local _PopulateRecipeDetailPanel = CookbookPageCrockPot.PopulateRecipeDetailPanel

CookbookPageCrockPot.PopulateRecipeDetailPanel = function(self, data, ...)
	local result = _PopulateRecipeDetailPanel(self, data, ...)

	if data and data.recipe_def then
		local portrait_root

		for _, child in pairs(result.children or {}) do
			if child.name == "portrait_root" then
				portrait_root = child
				break
			end
		end

		if data.recipe_def.pigcoinvalue then
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