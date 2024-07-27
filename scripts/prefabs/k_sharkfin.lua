local assets =
{
    Asset("ANIM", "anim/shark_fin.zip"),
	
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
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank("shark_fin")
    inst.AnimState:SetBuild("shark_fin")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("meat")
	inst:AddTag("catfood")
	inst:AddTag("shark_fin")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 5

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_shark_fin"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.KYNO_SHARKFIN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_SHARKFIN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_SHARKFIN_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("kyno_shark_fin", fn, assets, prefabs)