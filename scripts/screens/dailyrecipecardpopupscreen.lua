local Screen                = require("widgets/screen")
local Widget                = require("widgets/widget")
local ImageButton           = require("widgets/imagebutton")
local TEMPLATES             = require("widgets/redux/templates")
local DailyRecipeCardWidget = require("widgets/redux/dailyrecipecardwidget")
local DAILY_RECIPES         = require("hof_dailyrecipes")

local DailyRecipeCardPopupScreen = Class(Screen, function(self, owner)
	self.owner = owner
	Screen._ctor(self, "DailyRecipeCardPopupScreen")

	local black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
	black.image:SetVRegPoint(ANCHOR_MIDDLE)
	black.image:SetHRegPoint(ANCHOR_MIDDLE)
	black.image:SetVAnchor(ANCHOR_MIDDLE)
	black.image:SetHAnchor(ANCHOR_MIDDLE)
	black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
	black.image:SetTint(0, 0, 0, .5)
	black:SetOnClick(function() TheFrontEnd:PopScreen() end)
	black:SetHelpTextMessage("")

	local root = self:AddChild(Widget("root"))
	root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	root:SetHAnchor(ANCHOR_MIDDLE)
	root:SetVAnchor(ANCHOR_MIDDLE)
	root:SetPosition(0, -25)

	local prefab = DAILY_RECIPES.GetDailyRecipe()
	local data = DAILY_RECIPES.GetDailyRecipeData(prefab)

	self.dailyrecipecard = root:AddChild(DailyRecipeCardWidget(owner, data))
	self.default_focus = self.dailyrecipecard.parent_default_focus or self.dailyrecipecard

	SetAutopaused(true)
end)

function DailyRecipeCardPopupScreen:OnDestroy()
	SetAutopaused(false)

	POPUPS.DAILYRECIPECARD:Close(self.owner)
	DailyRecipeCardPopupScreen._base.OnDestroy(self)
end

function DailyRecipeCardPopupScreen:OnBecomeInactive()
	DailyRecipeCardPopupScreen._base.OnBecomeInactive(self)
end

function DailyRecipeCardPopupScreen:OnBecomeActive()
	DailyRecipeCardPopupScreen._base.OnBecomeActive(self)
end

function DailyRecipeCardPopupScreen:OnControl(control, down)
	if DailyRecipeCardPopupScreen._base.OnControl(self, control, down) then
		return true
	end

	if not down and (control == CONTROL_MENU_BACK or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
		TheFrontEnd:PopScreen()
		return true
	end

	return false
end

function DailyRecipeCardPopupScreen:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

	return table.concat(t, "  ")
end

return DailyRecipeCardPopupScreen