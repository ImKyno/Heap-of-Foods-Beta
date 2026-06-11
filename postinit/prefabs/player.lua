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

	inst.OnLearnFish = OnLearnFish
	inst.OnLearnRoe = OnLearnRoe

	inst:ListenForEvent("learnfish", inst.OnLearnFish)
	inst:ListenForEvent("learnroe", inst.OnLearnRoe)
end

AddPlayerPostInit(PlayerPostInit)