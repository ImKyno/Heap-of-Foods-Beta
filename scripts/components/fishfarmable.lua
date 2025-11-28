local FishFarmable = Class(function(self, inst)
	self.inst = inst
	self.inst:AddTag("fishfarmable")
	
	self.roe_prefab = nil
	self.baby_prefab = nil
	
	self.roe_interval = 480 / 1.5
	self.baby_interval = 480 * 1.5
	
	self.valid_phases = { "day", "dusk", "night" }
	self.valid_moonphases = { "new", "quarter", "half", "threequarter", "full" }
	self.valid_seasons = { "autumn", "winter", "spring", "summer" }
	self.valid_worlds = { "forest", "cave" }
end)

function FishFarmable:IsPhaseValid()
	local dayphase = TheWorld:HasTag("cave") 
	and TheWorld.state.cavephase or TheWorld.state.phase
	
	for _, p in ipairs(self.valid_phases) do
		if p == dayphase then
			return true
		end
	end
	
	return false
end

function FishFarmable:IsMoonPhaseValid()
	local moonphase = TheWorld.state.moonphase
	
	-- No Moon in caves!
	if TheWorld:HasTag("cave") then
		return false
	end
	
	for _, mp in ipairs(self.valid_moonphases) do
		if mp == moonphase then
			return true
		end
	end
	
	return false
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

function FishFarmable:IsWorldValid()
	local worldtag = TheWorld:HasTag("cave") and "cave" or "forest"

	for _, w in ipairs(self.valid_worlds) do
		if w == worldtag then
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

function FishFarmable:SetPhases(phases)
	self.valid_phases = phases or { "day", "dusk", "night" }
end

function FishFarmable:SetMoonPhases(moonphases)
	self.valid_moonphases = moonphases or { "new", "quarter", "half", "threequarter", "full" }
end

function FishFarmable:SetSeasons(seasons)
	self.valid_seasons = seasons or { "autumn", "winter", "spring", "summer" }
end

function FishFarmable:SetWorlds(worlds)
	self.valid_worlds = worlds or { "forest", "cave" }
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