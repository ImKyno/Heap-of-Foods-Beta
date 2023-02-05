local assets =
{
    Asset("ANIM", "anim/kyno_sugarflywings.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.03)

    inst.AnimState:SetBank("kyno_sugarflywings")
    inst.AnimState:SetBuild("kyno_sugarflywings")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")
	inst:AddTag("honeyed")
	inst:AddTag("_named")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("inspectable")
    inst:AddComponent("tradable")
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = {STRINGS.NAMES["KYNO_SUGARFLYWINGS1"], STRINGS.NAMES["KYNO_SUGARFLYWINGS2"], STRINGS.NAMES["KYNO_SUGARFLYWINGS3"]}
    inst.components.named:PickNewName()

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.KYNO_SUGARFLYWINGS_HEALTH
    inst.components.edible.hungervalue = TUNING.KYNO_SUGARFLYWINGS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_SUGARFLYWINGS_SANITY
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_sugarflywings"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("kyno_sugarflywings", fn, assets, prefabs)