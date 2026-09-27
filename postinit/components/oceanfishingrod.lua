local _G = GLOBAL

AddComponentPostInit("oceanfishingrod", function(self)
	_CatchFish = self.CatchFish

	function self:CatchFish(...)
		local fisher = self.fisher
		local target = self.target

		if _CatchFish ~= nil then
			_CatchFish(self, ...)
		end

		if fisher.tagvar_skilledfisherman then
			local startpos = target:GetPosition()
			local targetpos = self:CalcCatchDest(startpos, fisher:GetPosition(), target.components.oceanfishable.catch_distance)

			local fish = _G.SpawnPrefab(target.prefab)

			if fish ~= nil then
				fish:SetPersistData(target:GetPersistData())
				fish = fish.components.oceanfishable:MakeProjectile()

				if fish.components.weighable ~= nil then
					fish.components.weighable:SetPlayerAsOwner(fisher)
				end

				self:_LaunchFishProjectile(fish, startpos, targetpos)

				fisher:PushEvent("fishcaught", { fish = fish })
			end

			local luck = _G.TryLuckRoll(inst, TUNING.KYNO_FISHINGBUFF_EXTRA_FISH_CHANCE, HofLuckFormulas.SkilledFisherman)

			if luck then
				local fish2 = _G.SpawnPrefab(target.prefab)

				if fish2 ~= nil then
					fish2:SetPersistData(target:GetPersistData())
					fish2 = fish2.components.oceanfishable:MakeProjectile()

					if fish2.components.weighable ~= nil then
						fish2.components.weighable:SetPlayerAsOwner(fisher)
					end

					self:_LaunchFishProjectile(fish2, startpos, targetpos)

					fisher:PushEvent("fishcaught", { fish = fish2 })
				end
			end
		end
	end
end)