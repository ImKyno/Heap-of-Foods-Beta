local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local assets =
{
	Asset("ANIM", "anim/mystery_meat.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"boneshard",
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
	
	inst.AnimState:SetScale(.7, .7, .7)

	inst.AnimState:SetBank("mysterymeat")
	inst.AnimState:SetBuild("mystery_meat")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("cattoy")
	inst:AddTag("mysterymeat")
	inst:AddTag("kittenchow")
	
	inst:AddTag("fertilizerresearchable")

	inst.GetFertilizerKey = GetFertilizerKey

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("fertilizerresearchable")
	inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_mysterymeat"
	
	inst:AddComponent("fertilizer")
	inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE
	inst.components.fertilizer.soil_cycles = TUNING.POOP_SOILCYCLES
	inst.components.fertilizer.withered_cycles = TUNING.POOP_WITHEREDCYCLES
	inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.kyno_mysterymeat.nutrients)

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_MYSTERYMEAT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_MYSTERYMEAT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_MYSTERYMEAT_SANITY
	inst.components.edible.foodtype = FOODTYPE.HORRIBLE

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunch(inst)
	MakeDeployableFertilizer(inst)

	return inst
end

return Prefab("kyno_mysterymeat", fn, assets, prefabs)