local _G = GLOBAL

-- For increasing fishing yields.
AddComponentPostInit("fishingrod", function(self)
	local oldReel = self.Reel

	function self:Reel(...)
		local ret = {oldReel(self, ...)}

		if self.target ~= nil and self.caughtfish ~= nil and self.fisherman ~= nil and self.fisherman:HasTag("skilledfisherman") then
			local extraFish = _G.SpawnPrefab(self.caughtfish.prefab)

			if self.fisherman ~= nil and extraFish.components.weighable ~= nil then
				extraFish.components.weighable:SetPlayerAsOwner(self.fisherman)
			end

			local spawnPos = self.fisherman:GetPosition()
			local offset = spawnPos - self.target:GetPosition()
			spawnPos = spawnPos + offset:GetNormalized()

			self.inst:DoTaskInTime(.8, function()
				if extraFish.Physics ~= nil then
					extraFish.Physics:Teleport(spawnPos:Get())
				else
					extraFish.Transform:SetPosition(spawnPos:Get())
				end
			end)

			-- Random chance for one more extra fish.
			if _G.TryLuckRoll(self.fisherman, TUNING.KYNO_FISHINGBUFF_EXTRA_FISH_CHANCE, HofLuckFormulas.SkilledFisherman) then
				local extraFish2 = _G.SpawnPrefab(self.caughtfish.prefab)

				if self.fisherman ~= nil and extraFish2.components.weighable ~= nil then
					extraFish2.components.weighable:SetPlayerAsOwner(self.fisherman)
				end

				local spawnPos = self.fisherman:GetPosition()
				local offset = spawnPos - self.target:GetPosition()
				spawnPos = spawnPos + offset:GetNormalized()

				self.inst:DoTaskInTime(.8, function()
					if extraFish2.Physics ~= nil then
						extraFish2.Physics:Teleport(spawnPos:Get())
					else
						extraFish2.Transform:SetPosition(spawnPos:Get())
					end
				end)
			end
		end

		return unpack(ret)
	end

	-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
	function self:OnUpdate()
		if self:IsFishing() then
			if not self.fisherman:IsValid()
			or (not self.fisherman.sg:HasStateTag("fishing") and not self.fisherman.sg:HasStateTag("catchfish"))
			or (self.inst.components.equippable and not self.inst.components.equippable.isequipped) then
				self:StopFishing()
			end
		end
	end
end)