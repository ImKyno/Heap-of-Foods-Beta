local Brewbook = Class(function(self, inst)
	self.inst = inst

	self.inst:AddTag("brewbook")

	-- self.onreadfn = nil
end)

function Brewbook:OnRemoveFromEntity()
    self.inst:RemoveTag("brewbook")
end

function Brewbook:Read(doer)
	if not CanEntitySeeTarget(doer, self.inst) then
		return false
	end

	if self.onreadfn then
		self.onreadfn(self.inst, doer)
	end
end

return Brewbook