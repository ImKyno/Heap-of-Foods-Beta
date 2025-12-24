local FishResearchable = Class(function(self, inst)
	self.inst = inst

	self.inst:AddTag("fishresearchable")
end)

function FishResearchable:SetResearchFn(fn)
    self.reasearchinfofn = fn
end

function FishResearchable:GetResearchInfo()
	if self.reasearchinfofn then
		return self.reasearchinfofn(self.inst)
	end
end

function FishResearchable:LearnFish(doer)
	local fish = self:GetResearchInfo()
	
	if fish then
		doer:PushEvent("learnfish", { fish = fish })
	end
end

return FishResearchable