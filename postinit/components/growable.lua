local _G = GLOBAL

-- Custom event for when oversized crops are grown.
AddComponentPostInit("growable", function(self)
	local _DoGrowth = self.DoGrowth

	function self:DoGrowth(...)
		local inst = self.inst
		local next_stage = self:GetNextStage()
		local stage_data = self.stages[next_stage]

		local result = _DoGrowth(self, ...)

		if inst ~= nil and stage_data ~= nil and stage_data.name == "full" and inst.is_oversized then
			_G.PushOversizedGrownEvent(inst)
		end

		return result
	end
end)
