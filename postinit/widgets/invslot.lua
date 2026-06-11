local _G = GLOBAL

-- Makes icons appear for containers that are integrated to player's inventory.
AddClassPostConstruct("widgets/invslot", function(self)
	if self.owner == _G.ThePlayer and self.container ~= nil and self.container.GetWidget ~= nil then
		local widget = self.container:GetWidget()
		local bgoverride = widget.slotbg ~= nil and widget.slotbg[self.num] or nil

		if bgoverride ~= nil then
			self.bgimage:SetTexture(bgoverride.atlas or "images/hud.xml", bgoverride.image or "inv_slot.tex")
		end
	end
end)