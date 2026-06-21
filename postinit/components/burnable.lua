local _G = GLOBAL

-- Bypass Willow's controlled_burn restrictions, allowing it to be used in any character.
AddComponentPostInit("burnable", function(self)
	local _Ignite = self.Ignite

	function self:Ignite(immediate, source, doer, ...)
		local burner =
			(doer ~= nil and doer:HasTag("kyno_controlled_burner"))
			or (source ~= nil and source:HasTag("kyno_controlled_burner"))

		if burner and not self.burning and not self.inst:HasTag("fireimmune") then
			local old = self.controlled_burn

			_Ignite(self, immediate, source, doer, ...)

			self.controlled_burn = 
			{
				duration_creature = nil,
				damage = nil,
			}

			self.stokeablefire = self.inst.components.health == nil

			for _, fx in ipairs(self.fxchildren) do
				if fx.components.firefx ~= nil then
					fx.components.firefx.level = nil
					fx.components.firefx:SetLevel(self.fxlevel, true, self.controlled_burn)
				end
			end

			return
		end

		return _Ignite(self, immediate, source, doer, ...)
	end
end)