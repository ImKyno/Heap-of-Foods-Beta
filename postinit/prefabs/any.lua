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
	if inst:HasTag("farm_plant") then
		inst:AddTag("plantboostable")
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.farmmplantable ~= nil then
		inst:AddComponent("plantboostable")
	end
end

AddPrefabPostInitAny(SeedsPostInit)
AddPrefabPostInitAny(DailyRecipePostInit)
AddPrefabPostInitAny(PigFriendlyPostInit)
AddPrefabPostInitAny(ApplyBoosterFarmPlantPostInit)