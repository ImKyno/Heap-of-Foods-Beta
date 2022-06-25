local Widget         = require("widgets/widget")
local BrewbookWidget = require("widgets/redux/brewbookwidget")

local BrewbookPanel = Class(Widget, function(self, parent_screen)
    Widget._ctor(self, "BrewbookPanel")

    self.root = self:AddChild(Widget("ROOT"))

    self.root:SetPosition(0, -15)

	TheCookbook:ClearFilters()

	self.book = self.root:AddChild(BrewbookWidget(self))

    self.focus_forward = self.book
end)

return BrewbookPanel
