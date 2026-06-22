local _G = GLOBAL

-- Immunity to freezing via tags.
AddComponentPostInit("freezable", function(self)
	local _AddColdness = self.AddColdness

	function self:AddColdness(coldness, freezetime, nofreeze, ...)
		if self.inst:HasTag("freezeimmune") then
			return
		end

		return _AddColdness(self, coldness, freezetime, nofreeze, ...)
	end
end)