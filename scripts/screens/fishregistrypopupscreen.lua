local Screen             = require("widgets/screen")
local Widget             = require("widgets/widget")
local ImageButton        = require("widgets/imagebutton")
local TEMPLATES          = require("widgets/redux/templates")
local FishRegistryWidget = require("widgets/redux/fishregistrywidget")

local FishRegistryPopupScreen = Class(Screen, function(self, owner)
	self.owner = owner
	Screen._ctor(self, "FishRegistryPopupScreen")

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

	self.fishregistry = root:AddChild(FishRegistryWidget(owner))
	self.default_focus = self.fishregistry.parent_default_focus or self.fishregistry

	SetAutopaused(true)
end)

function FishRegistryPopupScreen:OnDestroy()
	SetAutopaused(false)

	POPUPS.FISHREGISTRY:Close(self.owner)
	FishRegistryPopupScreen._base.OnDestroy(self)
end

function FishRegistryPopupScreen:OnBecomeInactive()
	FishRegistryPopupScreen._base.OnBecomeInactive(self)
end

function FishRegistryPopupScreen:OnBecomeActive()
	FishRegistryPopupScreen._base.OnBecomeActive(self)
end

function FishRegistryPopupScreen:OnControl(control, down)
	if FishRegistryPopupScreen._base.OnControl(self, control, down) then
		return true
	end

	if not down and (control == CONTROL_MENU_BACK or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
		TheFrontEnd:PopScreen()
		return true
	end

	return false
end

function FishRegistryPopupScreen:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

	return table.concat(t, "  ")
end

return FishRegistryPopupScreen