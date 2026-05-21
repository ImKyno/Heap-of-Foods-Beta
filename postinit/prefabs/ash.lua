local _G = GLOBAL

-- Ashes are now a Fertilizer. Also using the Nutrients of Manure as placeholder for now, check "ash.lua".
local function AshPostInit(inst)
	local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

	local function GetFertilizerKey(inst)
		return inst.prefab
	end

	local function fertilizerresearchfn(inst)
		return inst:GetFertilizerKey()
	end

	MakeDeployableFertilizerPristine(inst)

	inst:AddTag("fertilizerresearchable")
	inst:AddTag("coffeefertilizer2")
	inst:AddTag("fertilizer_volcanic")

	inst.GetFertilizerKey = GetFertilizerKey

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("fertilizerresearchable")
	inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

	inst:AddComponent("fertilizer")
	inst.components.fertilizer.fertilizervalue = TUNING.SPOILEDFOOD_FERTILIZE
	inst.components.fertilizer.soil_cycles = TUNING.SPOILEDFOOD_SOILCYCLES
	inst.components.fertilizer.withered_cycles = TUNING.SPOILEDFOOD_WITHEREDCYCLES
	inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.ash.nutrients)

	MakeDeployableFertilizer(inst)
end

AddPrefabPostInit("ash", AshPostInit)