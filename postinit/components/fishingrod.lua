local _G = GLOBAL

-- For increasing fishing yields.
AddComponentPostInit("fishingrod", function(self)
	local _Collect = self.Collect

	function self:Collect(...)
		local fisherman = self.fisherman
		local caughtfish = self.caughtfish

		if _Collect ~= nil then
			_Collect(self, ...)
		end

		if fisherman and caughtfish then
			if not fisherman.tagvar_skilledfisherman then
				return
			end

			local extrafish = _G.SpawnPrefab(caughtfish.prefab)

			if extrafish ~= nil then
				extrafish.Transform:SetPosition(caughtfish.Transform:GetWorldPosition())

				if extrafish.components.weighable ~= nil then
					extrafish.components.weighable:SetPlayerAsOwner(fisherman)
				end
			end

			-- Random chance for one more extra fish.
			if _G.TryLuckRoll(self.fisherman, TUNING.KYNO_FISHINGBUFF_EXTRA_FISH_CHANCE, HofLuckFormulas.SkilledFisherman) then
				local extrafish2 = _G.SpawnPrefab(caughtfish.prefab)

				if extrafish2 ~= nil then
					extrafish2.Transform:SetPosition(caughtfish.Transform:GetWorldPosition())

					if extrafish2.components.weighable ~= nil then
						extrafish2.components.weighable:SetPlayerAsOwner(fisherman)
					end
				end
			end
		end
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