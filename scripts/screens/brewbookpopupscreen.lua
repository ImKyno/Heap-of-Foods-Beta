local Screen = require "widgets/screen"
local MapWidget = require("widgets/mapwidget")
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local BrewbookWidget = require "widgets/redux/brewbookwidget"
local TEMPLATES = require "widgets/redux/templates"

local BrewbookPopupScreen = Class(Screen, function(self, owner)
    self.owner = owner
    Screen._ctor(self, "BrewbookPopupScreen")

    local black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    black.image:SetVRegPoint(ANCHOR_MIDDLE)
    black.image:SetHRegPoint(ANCHOR_MIDDLE)
    black.image:SetVAnchor(ANCHOR_MIDDLE)
    black.image:SetHAnchor(ANCHOR_MIDDLE)
    black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
    black.image:SetTint(0,0,0,.5)
    black:SetOnClick(function() TheFrontEnd:PopScreen() end)
    black:SetHelpTextMessage("")

	local root = self:AddChild(Widget("root"))
	root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    root:SetHAnchor(ANCHOR_MIDDLE)
    root:SetVAnchor(ANCHOR_MIDDLE)
	root:SetPosition(0, -25)

	self.book = root:AddChild(BrewbookWidget(owner))

	self.default_focus = self.book

    SetAutopaused(true)
end)

function BrewbookPopupScreen:OnDestroy()
    SetAutopaused(false)

    POPUPS.BREWBOOK:Close(self.owner)

	TheCookbook:ClearNewFlags()
	TheCookbook:Save()

	BrewbookPopupScreen._base.OnDestroy(self)
end

function BrewbookPopupScreen:OnBecomeInactive()
    BrewbookPopupScreen._base.OnBecomeInactive(self)
end

function BrewbookPopupScreen:OnBecomeActive()
    BrewbookPopupScreen._base.OnBecomeActive(self)
end

function BrewbookPopupScreen:OnControl(control, down)
    if BrewbookPopupScreen._base.OnControl(self, control, down) then return true end

    if not down and (control == CONTROL_MAP or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
        TheFrontEnd:PopScreen()
        return true
    end

	return false
end

function BrewbookPopupScreen:GetHelpText()
    local controller_id = TheInput:GetControllerID()
    local t = {}

    table.insert(t,  TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

    return table.concat(t, "  ")
end

return BrewbookPopupScreen
