local Screen             = require("widgets/screen")
local Widget             = require("widgets/widget")
local ImageButton        = require("widgets/imagebutton")
local TEMPLATES          = require("widgets/redux/templates")
local ContributorsWidget = require("widgets/redux/contributorswidget")

local ContributorsPopupScreen = Class(Screen, function(self, owner)
	self.owner = owner
	Screen._ctor(self, "ContributorsPopupScreen")

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

	self.contributors = root:AddChild(ContributorsWidget(owner))
	self.default_focus = self.contributors.parent_default_focus or self.contributors

	SetAutopaused(true)
end)

function ContributorsPopupScreen:OnDestroy()
	SetAutopaused(false)

	POPUPS.CONTRIBUTORS:Close(self.owner)
	ContributorsPopupScreen._base.OnDestroy(self)
end

function ContributorsPopupScreen:OnBecomeInactive()
	ContributorsPopupScreen._base.OnBecomeInactive(self)
end

function ContributorsPopupScreen:OnBecomeActive()
	ContributorsPopupScreen._base.OnBecomeActive(self)
end

function ContributorsPopupScreen:OnControl(control, down)
	if ContributorsPopupScreen._base.OnControl(self, control, down) then
		return true
	end

	if not down and (control == CONTROL_MENU_BACK or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
		TheFrontEnd:PopScreen()
		return true
	end

	return false
end

function ContributorsPopupScreen:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

	return table.concat(t, "  ")
end

return ContributorsPopupScreen