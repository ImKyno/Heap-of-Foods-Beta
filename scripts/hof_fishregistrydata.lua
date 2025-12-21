local FISHREGISTRY_DEFS = require("prefabs/k_fishregistry_defs").FISHREGISTRY_DEFS

local FishRegistryData = Class(function(self)
	self.fishes       = {}
	self.pictures     = {}
	self.filters      = {}
	
	self.dirty        = false
	self.save_enabled = true
end)

function FishRegistryData:GetKnownFishes()
	return self.fishes
end

function FishRegistryData:KnowsFish(fish)
	return self.fishes[fish] == true
end

function FishRegistryData:Save(force_save)
	if force_save or (self.save_enabled and self.dirty) then
		local str = DataDumper({ fishes = self.fishes, pictures = self.pictures, filters = self.filters }, nil, true)
		
		TheSim:SetPersistentString("hof_fishregistry", str, false)
		self.dirty = false
	end
end

function FishRegistryData:Load()
	self.fishes   = {}
	self.pictures = {}
	self.filters  = {}
	
	local failed = false

	TheSim:GetPersistentString("hof_fishregistry", function(load_success, data)
		if load_success and data ~= nil then
			local success, fish_registry = RunInSandboxSafeCatchInfiniteLoops(data)
			
			if success and fish_registry and type(fish_registry) == "table" then
				self.fishes   = fish_registry.fishes   or {}
				self.pictures = fish_registry.pictures or {}
				self.filters  = fish_registry.filters  or {}
			else
				print("Heap of Foods Mod - Fish Registry: Failed to load!")
				failed = true
			end
		end
	end)

	if failed then
		print("Heap of Foods Mod - Fish Registry: Erasing bad data!")
		self:Save(true)
	end
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
		print("Heap of Foods Mod - Fish Registry: Invalid fish!")
		return false
	end

	if FISHREGISTRY_DEFS[fish] == nil then
		print("Heap of Foods Mod - Fish Registry: Unknown fish:", fish)
		return false
	end

	local updated = self.fishes[fish] ~= true
    
	self.fishes[fish] = true

	if updated then
		self.dirty = true
		self:Save()
	end

	return updated
end

return FishRegistryData