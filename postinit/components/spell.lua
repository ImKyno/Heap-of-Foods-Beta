local _G = GLOBAL

AddComponentPostInit("spell", function(self)
	local _OnSave = self.OnSave

	function self:OnSave(...)
		local ret = {_OnSave(self, ...)}

		if self.target ~= nil and self.target.components.trophyscale then
			return ret[1], { self.target.GUID }
		end

		return unpack(ret)
	end
end)