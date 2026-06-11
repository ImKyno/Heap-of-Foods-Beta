local _G = GLOBAL

-- inst.components.debuffable:RemoveAllDebuffs()
AddComponentPostInit("debuffable", function(self)
	function self:RemoveAllDebuffs()
		for name, _ in pairs(self.debuffs) do
			self:RemoveDebuff(name)
		end
	end
end)