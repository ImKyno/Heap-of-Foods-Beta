local _G      = GLOBAL
local require = _G.require

local function GetBaseFoodPrefab(prefab)
	local spice_pos = prefab:find("_spice_")

	if spice_pos then
		return prefab:sub(1, spice_pos - 1)
	end

	return prefab
end

-- Fish Registry player extension.
local function OnLearnFish(inst, data)
	local fishregistryupdater = data ~= nil and inst.components.fishregistryupdater

	if fishregistryupdater then
		fishregistryupdater:LearnFish(data.fish)
	end
end

local function OnLearnRoe(inst, data)
	local fishregistryupdater = data ~= nil and inst.components.fishregistryupdater

	if fishregistryupdater then
		fishregistryupdater:LearnRoe(data.roe)
	end
end

local function OnFishCaught(inst, data)
	if not inst:HasTag("skilledfisherman") then
		return
	end

	local baseFish = data.fish

	if baseFish ~= nil then
		local prefab = baseFish.prefab

		if prefab == nil then
    		return
		end

		local fishprefab = TUNING.HOF_OCEANTRAP_PREFAB_INDEX[prefab] or (prefab .. "_inv")
		local extraFish = _G.SpawnPrefab(fishprefab)

		if extraFish ~= nil then
			if extraFish.components.weighable ~= nil then
				extraFish.components.weighable:SetPlayerAsOwner(inst)
			end

			if inst.components.inventory ~= nil then
				inst.components.inventory:GiveItem(extraFish, nil, inst:GetPosition())
			end
		end

		local luck = _G.TryLuckRoll(inst, TUNING.KYNO_FISHINGBUFF_EXTRA_FISH_CHANCE, HofLuckFormulas.SkilledFisherman)

		if luck then
			local extraFish2 = _G.SpawnPrefab(fishprefab)

			if extraFish2 ~= nil then
				if extraFish2.components.weighable ~= nil then
					extraFish2.components.weighable:SetPlayerAsOwner(inst)
				end

				if inst.components.inventory ~= nil then
					inst.components.inventory:GiveItem(extraFish2, nil, inst:GetPosition())
				end
			end
		end
	end
end

local function PlayerPostInit(inst)
	inst:AddComponent("fishregistryupdater")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	-- Daily Recipes.
	if inst.components.eater ~= nil then
		local _oneatfn = inst.components.eater.oneatfn

		inst.components.eater:SetOnEatFn(function(inst, food)
			if _oneatfn ~= nil then
				_oneatfn(inst, food)
			end

			if food == nil then
				return
			end

			local bonus = TUNING.HOF_DAILYRECIPES_BONUS
			local base_recipe = GetBaseFoodPrefab(food.prefab)

			if _G.TheWorld ~= nil and _G.TheWorld.net ~= nil and _G.TheWorld.net.components.dailyrecipe ~= nil then
				local recipe = _G.TheWorld.net.components.dailyrecipe:GetDailyRecipe()

				if base_recipe == recipe then
					if inst.components.health ~= nil then
						inst.components.health:DoDelta(bonus)
					end

					if inst.components.hunger ~= nil then
						inst.components.hunger:DoDelta(bonus)
					end

					if inst.components.sanity ~= nil then
						inst.components.sanity:DoDelta(bonus)
					end

					inst:AddDebuff("kyno_luckbuff", "kyno_luckbuff")
					inst:PushEvent("dailyrecipeeaten")
				end
			end
		end)
	end

	if inst.components.trader ~= nil then
		local _test = inst.components.trader.test

		inst.components.trader:SetAcceptTest(function(inst, item, giver, ...)
			if item ~= nil and item:HasTag("foodreviver") and inst:HasTag("playerghost") then
				return inst:IsOnPassablePoint()
			end

			return _test ~= nil and _test(inst, item, giver, ...) or false
		end)

		local _onaccept = inst.components.trader.onaccept

		inst.components.trader.onaccept = function(inst, giver, item, ...)
			if item ~= nil and item:HasTag("foodreviver") and inst:HasTag("playerghost") then
				local x, y, z = item.Transform:GetWorldPosition()

				-- Using a proxy item since the original item goes to the ghost's inventory (LIMBO)
				-- and does not trigger the ressurrection functions.
				local proxy = _G.SpawnPrefab("kyno_foodreviver_proxy")
				proxy.Transform:SetPosition(x, y, z)

				item:Remove()

				inst:PushEvent("respawnfromghost", { source = proxy, user = giver })

				inst:DoTaskInTime(0.2, function()
					local fx = _G.SpawnPrefab("halloween_firepuff_cold_3")
					fx.Transform:SetPosition(x, y, z)
				end)

				if giver.components.sanity ~= nil then
					giver.components.sanity:DoDelta(TUNING.REVIVE_OTHER_SANITY_BONUS)
				end
			end

			if _onaccept ~= nil then
				return _onaccept(inst, giver, item, ...)
			end
		end
	end

	inst.OnLearnFish = OnLearnFish
	inst.OnLearnRoe = OnLearnRoe
	inst.OnFishCaught = OnFishCaught

	inst:ListenForEvent("learnfish", inst.OnLearnFish)
	inst:ListenForEvent("learnroe", inst.OnLearnRoe)
	inst:ListenForEvent("fishcaught", inst.OnFishCaught)
end

AddPlayerPostInit(PlayerPostInit)