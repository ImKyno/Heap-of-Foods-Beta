local FISHREGISTRY_FISH_DEFS = require("prefabs/k_fishregistrydefs").FISHREGISTRY_FISH_DEFS
local FISHREGISTRY_ROE_DEFS  = require("prefabs/k_fishregistrydefs").FISHREGISTRY_ROE_DEFS

local FishRegistryData = Class(function(self)
	self.fishes        = {}
	self.roes          = {}
	self.filters       = {}
end)

function FishRegistryData:GetKnownFishes()
	return self.fishes
end

function FishRegistryData:KnowsFish(fish)
	return self.fishes[fish] == true
end

function FishRegistryData:GetKnownRoes()
	return self.roes
end

function FishRegistryData:KnowsRoe(roe)
	return self.roes[roe] == true
end

function FishRegistryData:Save(force_save)
	if force_save or (self.save_enabled and self.dirty) then
		local str = DataDumper({ fishes = self.fishes, roes = self.roes, filters = self.filters }, nil, true)
		
		TheSim:SetPersistentString("hof_fishregistry", str, false)
	end
end

function FishRegistryData:Load()
	TheSim:GetPersistentString("hof_fishregistry", function(load_success, data)
		if load_success and data ~= nil then
			local success, fish_registry = RunInSandbox(data)
			
			if success and fish_registry then
				self.fishes   = fish_registry.fishes   or {}
				self.roes     = fish_registry.roes     or {}
				self.filters  = fish_registry.filters  or {}
			else
				print("Heap of Foods Mod - Fish Registry: Failed to load!")
			end
		end
	end)
end

function FishRegistryData:ClearFilters()
	self.filters = {}
	self.dirty = true
end

function FishRegistryData:SetFilter(category, value)
	if self.filters[category] ~= value then
		self.filters[category] = value
		self.dirty = true
	end
end

function FishRegistryData:GetFilter(category)
	return self.filters[category]
end

function FishRegistryData:LearnFish(fish)
	if fish == nil then
		print("Heap of Foods Mod - Fish Registry: Invalid Fish!")
		return
	end

	local updated = self.fishes[fish] == nil
	self.fishes[fish] = true

	if updated and self.save_enabled then
		self:Save(true)
	end

	return updated
end

function FishRegistryData:LearnRoe(roe)
	if roe == nil then
		print("Heap of Foods Mod - Fish Registry: Invalid Roe!")
		return
	end

	local updated = self.roes[roe] == nil
	self.roes[roe] = true

	if updated and self.save_enabled then
		self:Save(true)
	end

	return updated
end

-- DEBUG Unlocks.
function FishRegistryData:UnlockFishes()
	for fish in pairs(FISHREGISTRY_FISH_DEFS) do
		self.fishes[fish] = true
	end

	self:Save(true)
end

function FishRegistryData:UnlockRoes()
	for roe in pairs(FISHREGISTRY_ROE_DEFS) do
		self.roes[roe] = true
	end

	self:Save(true)
end

function FishRegistryData:UnlockAll()
	for fish in pairs(FISHREGISTRY_FISH_DEFS) do
		self.fishes[fish] = true
	end

	for roe in pairs(FISHREGISTRY_ROE_DEFS) do
		self.roes[roe] = true
	end

	self:Save(true)
end

-- DEBUG Locks.
function FishRegistryData:LockFishes()
	for fish in pairs(FISHREGISTRY_FISH_DEFS) do
		self.fishes[fish] = false
	end

	self:Save(true)
end

function FishRegistryData:LockRoes()
	for roe in pairs(FISHREGISTRY_ROE_DEFS) do
		self.roes[roe] = false
	end

	self:Save(true)
end

function FishRegistryData:LockAll()
	for fish in pairs(FISHREGISTRY_FISH_DEFS) do
		self.fishes[fish] = false
	end

	for roe in pairs(FISHREGISTRY_ROE_DEFS) do
		self.roes[roe] = false
	end

	self:Save(true)
end

return FishRegistryData