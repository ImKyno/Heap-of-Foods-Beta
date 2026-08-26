local _G = GLOBAL

-- Does not lose invincibility while the debuff is active.
AddComponentPostInit("health", function(self)
	local _SetInvincible = self.SetInvincible

	function self:SetInvincible(val, ...)
		if val == false and self.inst ~= nil and self.inst.components.debuffable ~= nil
		and self.inst.components.debuffable:HasDebuff("kyno_invinciblebuff") then
			val = true
		end

		return _SetInvincible(self, val, ...)
	end
end)