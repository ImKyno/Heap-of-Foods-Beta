local _G = GLOBAL

AddComponentPostInit("edible", function(self, inst)
	-- For using Salt on Crock Pot foods.
	if not inst.components.saltable and not inst:HasTag("fooddrink") and inst:HasTag("preparedfood") then
		inst:AddComponent("saltable")
	end

	--[[
	function self:GetHunger(eater)
		local multiplier = 1
		local spice_source = self.spice

		local ignore_spoilage = not self.degrades_with_spoilage or self.hungervalue < 0 or
		(eater ~= nil and eater.components.eater ~= nil and eater.components.eater.ignoresspoilage)

		if not ignore_spoilage and self.inst.components.perishable ~= nil then
			if self.inst.components.perishable:IsStale() then
				multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.stale_hunger or self.stale_hunger
			elseif self.inst.components.perishable:IsSpoiled() then
				multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.spoiled_hunger or self.spoiled_hunger
				spice_source = nil
			end
		end

		if eater ~= nil and eater.components.foodaffinity ~= nil then
			local affinity_bonus = eater.components.foodaffinity:GetAffinity(self.inst)

			if affinity_bonus ~= nil then
				multiplier = multiplier * affinity_bonus
			end
		end

		if spice_source and TUNING.SPICE_MULTIPLIERS[spice_source] and TUNING.SPICE_MULTIPLIERS[spice_source].HUNGER then
			multiplier = multiplier + TUNING.SPICE_MULTIPLIERS[spice_source].HUNGER
		end

		return multiplier * self.hungervalue
	end
	]]--

	-- Stuffed Starch spice tweak.
	local _GetHunger = self.GetHunger

	function self:GetHunger(eater)
		local hunger = _GetHunger(self, eater)

		local multiplier = 1
		local spice_source = self.spice

		local ignore_spoilage = not self.degrades_with_spoilage or self.hungervalue < 0 or
		(eater ~= nil and eater.components.eater ~= nil and eater.components.eater.ignoresspoilage)

		if not ignore_spoilage and self.inst.components.perishable ~= nil then
			if self.inst.components.perishable:IsStale() then
				multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.stale_hunger or self.stale_hunger
			elseif self.inst.components.perishable:IsSpoiled() then
				multiplier = eater ~= nil and eater.components.eater ~= nil and eater.components.eater.spoiled_hunger or self.spoiled_hunger
				spice_source = nil
			end
		end

		if spice_source and TUNING.SPICE_MULTIPLIERS[spice_source] and TUNING.SPICE_MULTIPLIERS[spice_source].HUNGER then
			hunger = hunger + (self.hungervalue * TUNING.SPICE_MULTIPLIERS[spice_source].HUNGER)
		end

		return hunger
	end
end)