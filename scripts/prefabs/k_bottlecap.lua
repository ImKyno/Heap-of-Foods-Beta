local assets =
{
    Asset("ANIM", "anim/kyno_bottlecap.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("kyno_bottlecap")
    inst.AnimState:SetBuild("kyno_bottlecap")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("molebait")
    inst:AddTag("quakedebris")
	inst:AddTag("_named")
	
	inst.pickupsound = "metal"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveTag("_named")
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 20

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bottlecap"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = {STRINGS.NAMES["KYNO_BOTTLECAP1"], STRINGS.NAMES["KYNO_BOTTLECAP2"], STRINGS.NAMES["KYNO_BOTTLECAP3"]}
    inst.components.named:PickNewName()

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab("kyno_bottlecap", fn, assets)