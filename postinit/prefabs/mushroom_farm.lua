local _G = GLOBAL

-- Make Sporecaps plantable at Mushroom Planter.
local function MushroomFarmPostInit(inst)
	local CUSTOM_MUSHROOMS =
	{
		kyno_sporecap =
		{
			skill = "wormwood_mushroomplanter_ratebonus2",
			build = "mushroom_farm_kyno_sporecap_build",
		},

		kyno_sporecap_dark =
		{
			skill = "wormwood_mushroomplanter_ratebonus2",
			build = "mushroom_farm_kyno_sporecap_dark_build",
		},
	}

	local function DoCustomSymbol(inst, product)
		if not product then
			return
		end

		local custom_mushroom = CUSTOM_MUSHROOMS[product]

		if custom_mushroom and custom_mushroom.build then
			inst.AnimState:OverrideSymbol("swap_mushroom", custom_mushroom.build, "swap_mushroom")
		end
	end

	local function StartCustomGrowing(inst, giver, item)
		if not inst.components.harvestable then
			return
		end

		local grower_skilltreeupdater = giver.components.skilltreeupdater
		local planter_is_improved = grower_skilltreeupdater and grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_upgrade")

		local max_produce = planter_is_improved and 6 or 4
		local grow_time_percent = 1.0

		if grower_skilltreeupdater then
			if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus2") then
				grow_time_percent = TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2
			elseif grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus1") then
				grow_time_percent = TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_1
			end
		end

		local grow_time = grow_time_percent * TUNING.MUSHROOMFARM_FULL_GROW_TIME

		DoCustomSymbol(inst, item.prefab)

		inst.components.harvestable:SetProduct(item.prefab, max_produce)
		inst.components.harvestable:SetGrowTime(grow_time / max_produce)
		inst.components.harvestable:Grow()

		_G.TheWorld:PushEvent("itemplanted", { doer = giver, pos = inst:GetPosition() })
	end

	local _accepttest

	local function CustomAcceptTest(inst, item, giver, ...)
		if item == nil then
			return false
		end

		local custom_mushroom = CUSTOM_MUSHROOMS[item.prefab]

		if custom_mushroom then
			local grower_skilltreeupdater = giver.components.skilltreeupdater

			if grower_skilltreeupdater and grower_skilltreeupdater:IsActivated(custom_mushroom.skill) then
				return true
			else
				return false, "MUSHROOMFARM_NOMOONALLOWED"
			end
		end

		return _accepttest(inst, item, giver, ...)
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.trader ~= nil then
		_accepttest = inst.components.trader.abletoaccepttest
		inst.components.trader.abletoaccepttest = CustomAcceptTest

		local _onaccept = inst.components.trader.onaccept

		inst.components.trader.onaccept = function(inst, giver, item, ...)
			local custom_mushroom = CUSTOM_MUSHROOMS[item.prefab]

			if custom_mushroom then
				local skilltreeupdater = giver.components.skilltreeupdater

				if skilltreeupdater and skilltreeupdater:IsActivated(custom_mushroom.skill) then
					StartCustomGrowing(inst, giver, item)
					return
				end
			end

			if _onaccept then
				_onaccept(inst, giver, item, ...)
			end
		end
	end

	if inst.components.harvestable ~= nil then
		local _onharvestfn = inst.components.harvestable.onharvestfn

		inst.components.harvestable:SetOnHarvestFn(function(inst, picker, ...)
			if _onharvestfn then
				_onharvestfn(inst, picker, ...)
			end

			if CUSTOM_MUSHROOMS[inst.components.harvestable.product] then
				-- DO SOMETHING COOL?
				--[[
				if math.random() <= TUNING.KYNO_SPORECAP_SPORECLOUD_CHANCE then
					inst.components.lootdropper:SpawnLootPrefab("sporecloud")
				end
				]]--
			end
		end)
	end

	local _OnLoad = inst.OnLoad

	inst.OnLoad = function(inst, data)
		if _OnLoad then
			_OnLoad(inst, data)
		end

		if data and data.product and CUSTOM_MUSHROOMS[data.product] then
			DoCustomSymbol(inst, data.product)
		end
	end
end

AddPrefabPostInit("mushroom_farm", MushroomFarmPostInit)