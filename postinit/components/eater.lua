local _G = GLOBAL

local HOF_ALCOHOLICDRINKS = GetModConfigData("ALCOHOLICDRINKS")

-- This will prevent some characters from drinking Alcoholic-like drinks.
if HOF_ALCOHOLICDRINKS then
	AddComponentPostInit("eater", function(self)
		local _PrefersToEat = self.PrefersToEat

		function self:PrefersToEat(inst)
			_PrefersToEat(self, inst)

			if inst.prefab == "winter_food4" and self.inst:HasTag("player") then
				return false
			elseif inst:HasTag("alcoholic_drink") and self.inst:HasTag("no_alcoholic_drinker") then
				return false
			elseif self.preferseatingtags ~= nil then
				local preferred = false

				for i, v in ipairs(self.preferseatingtags) do
					if inst:HasTag(v) then
						preferred = true
						break
					end
				end

				if not preferred then
					return false
				end
			end

			return self:TestFood(inst, self.preferseating)
		end
	end)
end