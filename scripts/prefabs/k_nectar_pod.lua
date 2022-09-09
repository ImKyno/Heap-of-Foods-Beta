local assets =
{
	Asset("ANIM", "anim/nectar_pod.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"spoiled_food",
}

local function TransformToHoney(inst, kyno_antchest)
    kyno_antchest.components.container:RemoveItem(inst)
    local numNectarPods = 1

    if inst.components.stackable and inst.components.stackable:IsStack() and inst.components.stackable:StackSize() > 1 then
        numNectarPods = inst.components.stackable:StackSize() + 1
    end

    inst:Remove()

    for index = 1, numNectarPods, 1 do
        local honey = SpawnPrefab("honey")
        local position = Vector3(kyno_antchest.Transform:GetWorldPosition())
        honey.Transform:SetPosition(position.x, position.y, position.z)
        kyno_antchest.components.container:GiveItem(honey, nil, Vector3(inst.Transform:GetWorldPosition()))
    end
end

local function OnPutInInventory(inst, owner)
    if owner.prefab == "kyno_antchest" then
        inst:DoTaskInTime(TUNING.NECTAR_TO_HONEY_TIME, function() TransformToHoney(inst, owner) end)
        inst.components.perishable:StopPerishing()
    else
		inst:CancelAllPendingTasks()
        inst.components.perishable:StartPerishing()
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
    
    inst.AnimState:SetBuild("nectar_pod")
    inst.AnimState:SetBank("nectar_pod")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("nectar")
	inst:AddTag("honeyed")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tradable")
    inst:AddComponent("inspectable")
    
    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.KYNO_NECTAR_POD_HEALTH
    inst.components.edible.hungervalue = TUNING.KYNO_NECTAR_POD_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_NECTAR_POD_SANITY

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_nectar_pod"
    
    return inst
end

return Prefab("kyno_nectar_pod", fn, assets, prefabs)