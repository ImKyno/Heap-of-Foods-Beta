local _G   = GLOBAL
local next = _G.next

-- Some hacks for trap component since it does not support water creatures.
-- We basically remove the fish from scene and spawn its inventory prefab.
AddComponentPostInit("trap", function(self)
	local _DoTriggerOn = self.DoTriggerOn
	local _Harvest = self.Harvest
	local _OnSave = self.OnSave
	local _OnLoad = self.OnLoad

	function self:DoTriggerOn(target)
		if self.inst:HasTag("smalloceanfish_trap") and target ~= nil and target:HasTag("smalloceanfish") and not target:HasTag("partiallyhooked") then
			self.target = target
			self.captured_fish = target

			self.issprung = true

			local loot_prefab = TUNING.HOF_OCEANTRAP_PREFAB_INDEX[target.prefab] or (target.prefab .. "_inv")
			self.lootprefabs = { loot_prefab }

			if self.bait ~= nil then
				if self.bait:IsValid() then
					self.bait:Remove()
				end

				if self.RemoveBait ~= nil then
					self:RemoveBait()
				end

				self.bait = nil
			end

			if self.captured_fish ~= nil and self.captured_fish:IsValid() then
				self.captured_fish:RemoveFromScene()
			end

			self:StopUpdating()
			self.inst:PushEvent("springtrap")

			return
		end

		_DoTriggerOn(self, target)
	end

	function self:Harvest(doer)
		if self.inst:HasTag("smalloceanfish_trap") and self.captured_fish ~= nil then
			local fish = self.captured_fish
			local pos = self.inst:GetPosition()

			local loot_prefab = TUNING.HOF_OCEANTRAP_PREFAB_INDEX[fish.prefab] or (fish.prefab .. "_inv")
			local loot = _G.SpawnPrefab(loot_prefab)

			if loot ~= nil then
				loot.Transform:SetPosition(pos:Get())

				if doer ~= nil and doer.components.inventory ~= nil then
					doer.components.inventory:GiveItem(loot)
				end
			end

			if fish:IsValid() then
				fish:Remove()
			end

			self.captured_fish = nil
			self.target = nil
			self.lootprefabs = nil
		end

		_Harvest(self, doer)
	end

	function self:OnSave()
		local data, refs = _OnSave ~= nil and _OnSave(self) or {}, {}

		if self.inst:HasTag("smalloceanfish_trap") then
			if self.captured_fish ~= nil and self.captured_fish:IsValid() then
				data.captured_fish_prefab = self.captured_fish.prefab
			end

			if self.lootprefabs ~= nil and next(self.lootprefabs) ~= nil then
				data.loot = self.lootprefabs
			end

			if self.issprung then
				data.issprung = true
			end
		end

		return data, refs
	end

	function self:OnLoad(data)
		if _OnLoad ~= nil then
			_OnLoad(self, data)
		end

		if self.inst:HasTag("smalloceanfish_trap") and data ~= nil then
			if data.loot ~= nil then
				self.lootprefabs = type(data.loot) == "table" and data.loot or { data.loot }
			end

			if data.captured_fish_prefab ~= nil then
				local fish = _G.SpawnPrefab(data.captured_fish_prefab)

				if fish ~= nil then
					fish:RemoveFromScene()
					self.captured_fish = fish
				end
			end

			if data.issprung then
				self.issprung = true
				self.inst:PushEvent("springtrap")
			end
		end
	end
end)