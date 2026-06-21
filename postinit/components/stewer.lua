local _G = GLOBAL

local function GetBaseFoodPrefab(prefab)
	local spice_pos = prefab:find("_spice_")

	if spice_pos then
		return prefab:sub(1, spice_pos - 1)
	end

	return prefab
end

AddComponentPostInit("stewer", function(self)
	local _Harvest = self.Harvest

	self.Harvest = function(self, harvester, ...)
		if not self.done then
			return _Harvest(self, harvester, ...)
		end

		local product_prefab = self.product
		local loot_captured = nil

		if harvester and harvester.components.inventory then
			local _GiveItem = harvester.components.inventory.GiveItem

			harvester.components.inventory.GiveItem = function(inv, item, ...)
				loot_captured = item
				return _GiveItem(inv, item, ...)
			end

			local result = _Harvest(self, harvester, ...)

			harvester.components.inventory.GiveItem = _GiveItem

			if result and loot_captured then
				local base_loot = GetBaseFoodPrefab(loot_captured.prefab) -- Blocks spiced foods.

				if not TUNING.HOFBIRTHDAY_BLOCKED_RECIPES[base_loot] and _G.IsSpecialEventActive(_G.SPECIAL_EVENTS.HOFBIRTHDAY)
				and harvester:HasTag("cheer_rewardable") --[[math.random() <= TUNING.HOFBIRTHDAY_CHEER_CHANCE]] then
					inv = harvester.components.inventory
					local cheer = _G.SpawnPrefab("kyno_hofbirthday_cheer")

					if inv then
						inv:GiveItem(cheer, nil, self.inst:GetPosition())
					else
						_G.LaunchAt(cheer, self.inst, nil, 1, 1)
					end
				end

				-- For refunding Empty Bottles when harvesting.
				if loot_captured and loot_captured.prefab == base_loot and loot_captured:HasTag("bottled") then
					local amount = loot_captured.bottlesize or 1

					for i = 1, amount do
						local bottle = _G.SpawnPrefab("messagebottleempty")

						if bottle then
							local inv = harvester.components.inventory

							if inv then
								inv:GiveItem(bottle, nil, self.inst:GetPosition())
							else
								_G.LaunchAt(bottle, self.inst, nil, 1, 1)
							end
						end
					end
				end

				-- Preserver Powder spice refreshes spoilage time.
				if loot_captured and loot_captured.components.perishable ~= nil
				and loot_captured.prefab:find("_spice_cure$") then
					loot_captured.components.perishable:SetPercent(1)
					loot_captured.components.perishable:StartPerishing()
				end
			end

			return result
		end

		local result = _Harvest(self, harvester, ...)

		if result and product_prefab then
			local loot = _G.SpawnPrefab(product_prefab)

			if loot and not TUNING.HOFBIRTHDAY_BLOCKED_RECIPES[loot.prefab] and
			_G.IsSpecialEventActive(_G.SPECIAL_EVENTS.HOFBIRTHDAY) and math.random() <= TUNING.HOFBIRTHDAY_CHEER_CHANCE then
				local cheer = _G.SpawnPrefab("kyno_hofbirthday_cheer")
				_G.LaunchAt(cheer, self.inst, nil, 1, 1)
			end
		end

		return result
	end
end)