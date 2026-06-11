local _G = GLOBAL

-- Can't aggro players that are stealthed.
AddComponentPostInit("combat", function(self)
	local _SetTarget = self.SetTarget

	function self:SetTarget(target)
		if target ~= nil and target:HasTag("player") and target:HasTag("stealthed") then
			return false
		end

		return _SetTarget(self, target)
	end
end)