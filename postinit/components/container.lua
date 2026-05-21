local _G = GLOBAL

-- Extra distance for Fish Hatchery.
-- Why these morons at klei didn't add a self.containerdistance?
AddComponentPostInit("container", function(self)
	local _OnUpdate = self.OnUpdate

	function self:OnUpdate(dt)
		local old_distance = nil

		if self.inst:HasTag("fishhatchery") then
			old_distance = _G.CONTAINER_AUTOCLOSE_DISTANCE
			_G.CONTAINER_AUTOCLOSE_DISTANCE = 6
		end

		_OnUpdate(self, dt)

		if old_distance ~= nil then
			_G.CONTAINER_AUTOCLOSE_DISTANCE = old_distance
		end
	end
end)