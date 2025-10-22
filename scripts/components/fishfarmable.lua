local FishFarmable = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("fishfarmable")
	
	self.roe_prefab = nil
	self.baby_prefab = nil
	
	self.roe_interval = 480 / 1.5
	self.baby_interval = 480 * 1.5
	
	self.valid_seasons = { "autumn", "winter", "spring", "summer" }
end)

function FishFarmable:SetSeasons(seasons)
	self.valid_seasons = seasons or { "autumn", "winter", "spring", "summer" }
end

function FishFarmable:IsSeasonValid()
	local season = TheWorld.state.season
	
	for _, s in ipairs(self.valid_seasons) do
		if s == season then
			return true
		end
	end
	
	return false
end

function FishFarmable:SetProducts(roe, baby)
	self.roe_prefab = roe
	self.baby_prefab = baby
end

function FishFarmable:SetTimes(roe, baby)
	self.roe_interval = roe
	self.baby_interval = baby
end

function FishFarmable:GetRoePrefab()
	return self.roe_prefab
end

function FishFarmable:GetRoeTime()
	return self.roe_interval
end

function FishFarmable:GetBabyPrefab()
	return self.baby_prefab
end


function FishFarmable:GetBabyTime()
	return self.baby_interval
end

function FishFarmable:IsValidFish()
	return self.roe_prefab ~= nil and self.baby_prefab ~= nil
end

return FishFarmable