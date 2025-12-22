local RoeResearchable = Class(function(self, inst)
	self.inst = inst

	self.inst:AddTag("roeresearchable")
end)

function RoeResearchable:SetResearchFn(fn)
    self.reasearchinfofn = fn
end

function RoeResearchable:GetResearchInfo()
	if self.reasearchinfofn then
		return self.reasearchinfofn(self.inst)
	end
end

function RoeResearchable:LearnRoe(doer)
	local roe = self:GetResearchInfo()
	
	if roe then
		doer:PushEvent("learnroe", { roe = roe })
		doer:PushEvent("learnrecipecard") -- Despite the name, its just for playing a sound.
	end
end

return RoeResearchable