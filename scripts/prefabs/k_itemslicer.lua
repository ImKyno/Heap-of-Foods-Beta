local assets =
{
    Asset("ANIM", "anim/kyno_itemslicer.zip"),
	Asset("ANIM", "anim/kyno_itemslicer_gold.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function OnLanded(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
		inst.AnimState:PlayAnimation("idle_water")
	else
		inst.AnimState:PlayAnimation("idle")
	end
end

local function main()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05, {1.2, 0.75, 1.2})

    inst:AddTag("sharp")
    inst:AddTag("tool")
	inst:AddTag("slicer")
	
	inst.pickupsound = "metal"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("slicer")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	
	inst:ListenForEvent("on_landed", OnLanded)

    MakeHauntableLaunch(inst)

    return inst
end

local function fn()
	local inst = main()
	
	inst.AnimState:SetBank("kyno_itemslicer")
    inst.AnimState:SetBuild("kyno_itemslicer")
	inst.AnimState:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_itemslicer"
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_ITEMSLICER_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_ITEMSLICER_USES)
	inst.components.finiteuses:SetConsumption(ACTIONS.SLICE, 2)
	inst.components.finiteuses:SetConsumption(ACTIONS.SLICESTACK, 2)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	return inst
end

local function goldfn()
	local inst = main()
	
	inst.AnimState:SetBank("kyno_itemslicer_gold")
    inst.AnimState:SetBuild("kyno_itemslicer_gold")
	inst.AnimState:PlayAnimation("idle_gold")
	
	inst:AddTag("professionalslicer")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_itemslicer_gold"
	
	return inst
end

return Prefab("kyno_itemslicer", fn, assets),
Prefab("kyno_itemslicer_gold", goldfn, assets)