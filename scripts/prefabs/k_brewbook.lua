require("screens/brewbookpopupscreen")

local assets =
{
    Asset("ANIM", "anim/kyno_brewbook.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function OnReadBook(inst, doer)
	doer:ShowPopUp(POPUPS.BREWBOOK, true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", nil, 0.75)
	
	inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst.AnimState:SetBank("kyno_brewbook")
    inst.AnimState:SetBuild("kyno_brewbook")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("brewbook")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_brewbook"

	inst:AddComponent("brewbook")
	inst.components.brewbook.onreadfn = OnReadBook
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("kyno_brewbook", fn, assets, prefabs)