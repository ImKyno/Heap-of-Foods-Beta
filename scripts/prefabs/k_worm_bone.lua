local assets =
{
    Asset("ANIM", "anim/snake_bone.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function OnHammered(inst, worker)
    local bone = inst 
    if inst.components.inventoryitem then 
		local owner = inst.components.inventoryitem.owner
        if inst.components.stackable and inst.components.stackable.stacksize > 1 then 
            bone = inst.components.stackable:Get()
            inst.components.workable:SetWorkLeft(1)
        end
		
		local hammered
		
        if owner then
			local container = owner.components.inventory or owner.components.container
			if container then 
				local hammered = SpawnPrefab("boneshard")
				hammered.components.stackable.stacksize = 2
				container:GiveItem(hammered)
            elseif owner.components.lootdropper then
                hammered = owner.components.lootdropper:SpawnLootPrefab("boneshard")
                owner.components.lootdropper:SpawnLootPrefab("boneshard")
            end
        else 
            hammered = inst.components.lootdropper:SpawnLootPrefab("boneshard")
            inst.components.lootdropper:SpawnLootPrefab("boneshard")
        end 
		
		if worker and worker.SoundEmitter then
			worker.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		else
			inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		end
    end
	
    bone:Remove()
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("snake_bone")
    inst.AnimState:SetBuild("snake_bone")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("worm_bone")
	
	inst.pickupsound = "rock"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"boneshard", "boneshard"})

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_worm_bone"
    inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnHammered)

    MakeHauntableLaunchAndSmash(inst)

    return inst
end

return Prefab("kyno_worm_bone", fn, assets)