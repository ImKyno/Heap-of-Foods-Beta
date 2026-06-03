local _G = GLOBAL

-- Make all seeds a valid fuel for Animal Trough.
local function SeedsPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.edible ~= nil then
		if inst.components.edible.foodtype == _G.FOODTYPE.SEEDS and not inst:HasTag("gourmet_ingredient") then
			if not inst.components.fuel then
				inst:AddComponent("fuel")
			end
	
			if inst.components.fuel ~= nil then
				inst.components.fuel.fueltype = _G.FUELTYPE.ANIMALFOOD
				inst.components.fuel.fuelvalue = TUNING.MED_FUEL
			end
		end
	end
end

local function DailyRecipePostInit(inst)
	if _G.TheWorld.net == inst then
		inst._dailyrecipe = net_string(inst.GUID, "dailyrecipe._dailyrecipe", "dailyrecipe_dirty")

		if not _G.TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("dailyrecipe")

		if TUNING.HOF_DEBUG_MODE or TUNING.HOF_DAILYRECIPES_DEBUG_ENABLED then
			print("Heap of Foods Mod - DailyRecipe component added to:", inst)
		end
	end
end

local function PigFriendlyPostInit(inst)
	if inst:HasTag("player") and not inst:HasTag("playermerm") then
		inst:AddTag("pigfriendly")
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

local function ApplyBoosterFarmPlantPostInit(inst)
	local function SetLunarThrallProtection(inst, protected)
		inst._lunarthrall_protected = protected == true

		if inst._lunarthrall_protected then
			inst:RemoveTag("lunarplant_target")
		else
			inst:AddTag("lunarplant_target")
		end
	end

	if inst:HasTag("farm_plant") then
		inst:AddTag("plantboostable")
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.farmplantable ~= nil or inst.components.farmplanttendable ~= nil then
		inst.SetLunarThrallProtection = SetLunarThrallProtection

		inst._bonus_yield = false
		inst._lunarthrall_protected = false

		inst:AddComponent("plantboostable")

		inst:ListenForEvent("picked", _G.PlantBoosterBonusYield)

		local _OnSave = inst.OnSave
		local _OnLoad = inst.OnLoad

		inst.OnSave = function(inst, data)
			if _OnSave ~= nil then
				_OnSave(inst, data)
			end

			data.bonus_yield = inst._bonus_yield
			data.lunarthrall_protected = inst._lunarthrall_protected
		end

		inst.OnLoad = function(inst, data)
			if _OnLoad ~= nil then
				_OnLoad(inst, data)
			end

			if data ~= nil then
				if data.bonus_yield ~= nil then
					inst._bonus_yield = data.bonus_yield

					if inst._bonus_yield then
						inst:AddTag("plantboosted_yield")
					else
						inst:RemoveTag("plantboosted_yield")
					end
				end

				if data.lunarthrall_protected ~= nil then
					SetLunarThrallProtection(inst, data.lunarthrall_protected)
				end
			end
		end
	end
end

AddPrefabPostInitAny(SeedsPostInit)
AddPrefabPostInitAny(DailyRecipePostInit)
AddPrefabPostInitAny(PigFriendlyPostInit)
AddPrefabPostInitAny(ApplyBoosterFarmPlantPostInit)