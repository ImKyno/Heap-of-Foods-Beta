local _G = GLOBAL

-- Pollinators will also target Sugar Flowers as well.
AddComponentPostInit("pollinator", function(self)
	local _CanPollinate = self.CanPollinate

	function self:CanPollinate(flower, ...)
		local FLOWER_TAGS = { "flower", "sugarflower" }

		if self.inst:HasTag("sugarflowerpollinator") then -- Both Flowers.
			return flower ~= nil and flower:HasOneOfTags(FLOWER_TAGS) and not table.contains(self.flowers, flower)
		elseif self.inst:HasTag("sugarflowerpollinatoronly") then -- Only Sugar Flowers.
			return flower ~= nil and flower:HasTag("sugarflower") and not table.contains(self.flowers, flower)
		else
			return _CanPollinate(self, flower, ...)
		end
	end
end)