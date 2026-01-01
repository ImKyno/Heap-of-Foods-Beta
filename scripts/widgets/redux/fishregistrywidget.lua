local Image              = require("widgets/image")
local ImageButton        = require("widgets/imagebutton")
local Widget             = require("widgets/widget")
local Text               = require("widgets/text")

local FishPage           = require("widgets/redux/fishregistryfishpage")
local RoePage            = require("widgets/redux/fishregistryroepage")

local FISHREGISTRY_ATLAS = "images/hof_fishregistry.xml"

local FishRegistryWidget = Class(Widget, function(self, parent)
	Widget._ctor(self, "FishRegistryWidget")

	self.root = self:AddChild(Widget("root"))
	self.tab_root = self.root:AddChild(Widget("tab_root"))

	self.backdrop = self.root:AddChild(Image(FISHREGISTRY_ATLAS, "backdrop.tex"))

	local base_size = .7

	local button_data =
	{
		{
			text = STRINGS.FISHREGISTRY.TAB_FISH,
			build_panel_fn = function()
				return FishPage(self)
			end
		},
		
		{
			text = STRINGS.FISHREGISTRY.TAB_ROE,
			build_panel_fn = function()
				return RoePage(self)
			end
		},
	}

	local function MakeTab(data, index)
		local tab = ImageButton(FISHREGISTRY_ATLAS, "fish_tab_inactive.tex", nil, nil, nil, "fish_tab_active.tex")

		tab:SetFocusScale(base_size, base_size)
		tab:SetNormalScale(base_size, base_size)

		tab:SetText(data.text)
		tab:SetTextSize(22)
		tab:SetFont(HEADERFONT)
		tab:SetTextColour(UICOLOURS.GOLD)
		tab:SetTextFocusColour(UICOLOURS.GOLD)
		tab:SetTextSelectedColour(UICOLOURS.GOLD)
		tab.text:SetPosition(0, -4)

		tab.clickoffset = Vector3(0, 5, 0)

		tab:SetOnClick(function()
			self.last_selected:Unselect()
			self.last_selected = tab
			
			tab:Select()
			tab:MoveToFront()

			if self.panel ~= nil then
				self.panel:Kill()
			end

			self.panel = self.root:AddChild(data.build_panel_fn())

			if TheInput:ControllerAttached() then
				self.panel.parent_default_focus:SetFocus()
			end
			
			TheFishRegistry:SetFilter("tab", index)
		end)

		tab._tabindex = index - 1
		
		return tab
	end

	self.tabs = {}
	
	for i, data in ipairs(button_data) do
		table.insert(self.tabs, self.tab_root:AddChild(MakeTab(data, i)))
		self.tabs[#self.tabs]:MoveToBack()
	end

	self:_PositionTabs(self.tabs, 200, 285)
	
	local starting_tab = TheFishRegistry:GetFilter("tab")
	
	if self.tabs[starting_tab] == nil then
		starting_tab = 1
	end

	self.last_selected = self.tabs[starting_tab]
	self.last_selected:Select()
	self.last_selected:MoveToFront()
	
	self.panel = self.root:AddChild(button_data[starting_tab].build_panel_fn())

	self.focus_forward = function()
		return self.panel.parent_default_focus
	end
end)

function FishRegistryWidget:Kill()
	TheFishRegistry:Save() -- For saving filter settings.
	FishRegistryWidget._base.Kill(self)
end

function FishRegistryWidget:_PositionTabs(tabs, w, y)
	local offset = #tabs / 2
	
	for i = 1, #tabs do
		tabs[i]:SetPosition((i - offset - 0.5) * w, y)
	end
end

function FishRegistryWidget:OnControlTabs(control, down)
	if control == CONTROL_MENU_L2 then
		local tab = self.tabs[((self.last_selected._tabindex - 1) % #self.tabs) + 1]
		
		if not down then
			tab.onclick()
			return true
		end
	elseif control == CONTROL_MENU_R2 then
		local tab = self.tabs[((self.last_selected._tabindex + 1) % #self.tabs) + 1]
		
		if not down then
			tab.onclick()
			return true
		end
	end
end

function FishRegistryWidget:OnControl(control, down)
	if FishRegistryWidget._base.OnControl(self, control, down) then
		return true
	end

	if #self.tabs > 1 then
		return self:OnControlTabs(control, down)
	end
end

function FishRegistryWidget:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}

	if #self.tabs > 1 then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_MENU_L2).."/"..TheInput:GetLocalizedControl(controller_id, CONTROL_MENU_R2).. " " .. STRINGS.UI.HELP.CHANGE_TAB)
	end

	return table.concat(t, "  ")
end

return FishRegistryWidget