local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local assets =
{
	Asset("ANIM", "anim/kyno_floatilizer.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"gridplacer_farmablesoil",
}

local function GetFertilizerKey(inst)
    return inst.prefab
end

local function fertilizerresearchfn(inst)
    return inst:GetFertilizerKey()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)
	MakeDeployableFertilizerPristine(inst)

	inst.AnimState:SetBank("kyno_floatilizer")
	inst.AnimState:SetBuild("kyno_floatilizer")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("fertilizerresearchable")

	inst.GetFertilizerKey = GetFertilizerKey
	
	inst.pickupsound = "rock"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("smotherer")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	inst:AddComponent("fertilizerresearchable")
	inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_FLOATILIZER_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_FLOATILIZER_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)

	inst:AddComponent("fertilizer")
	inst.components.fertilizer.fertilizervalue = TUNING.KYNO_FLOATILIZER_FERTILIZE
	inst.components.fertilizer.soil_cycles = TUNING.KYNO_FLOATILIZER_SOILCYCLES
	inst.components.fertilizer.withered_cycles = TUNING.KYNO_FLOATILIZER_WITHEREDCYCLES
	inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.kyno_floatilizer.nutrients)

	MakeDeployableFertilizer(inst)
	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("kyno_floatilizer", fn, assets, prefabs)