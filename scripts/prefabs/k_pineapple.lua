local assets =
{
	Asset("ANIM", "anim/kyno_pineapple.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_pineapple",
	"kyno_pineapple_cooked",
	"kyno_pineapple_halved",
}

local function OnChopped(inst, worker)
    local pineapple = inst 
    if inst.components.inventoryitem then 
		local owner = inst.components.inventoryitem.owner
        if inst.components.stackable and inst.components.stackable.stacksize > 1 then 
            pineapple = inst.components.stackable:Get()
            inst.components.workable:SetWorkLeft(1)
        end
		
		local cracked
		
        if owner then
			local container = owner.components.inventory or owner.components.container
			if container then 
				local cracked = SpawnPrefab("kyno_pineapple_halved")
				cracked.components.stackable.stacksize = 2
				container:GiveItem(cracked)
            elseif owner.components.lootdropper then
                cracked = owner.components.lootdropper:SpawnLootPrefab("kyno_pineapple_halved")
                owner.components.lootdropper:SpawnLootPrefab("kyno_pineapple_halved")
            end
        else 
            cracked = inst.components.lootdropper:SpawnLootPrefab("kyno_pineapple_halved")
            inst.components.lootdropper:SpawnLootPrefab("kyno_pineapple_halved")
        end 
		
		if worker and worker.SoundEmitter then
			worker.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
		else
			inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
		end
    end
	
    pineapple:Remove()
end 

local function pineapple()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_pineapple")
	inst.AnimState:SetBuild("kyno_pineapple")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("fruit")
	inst:AddTag("show_spoilage")
	inst:AddTag("crackable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnChopped)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_pineapple"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function pineapple_halved()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_pineapple")
	inst.AnimState:SetBuild("kyno_pineapple")
	inst.AnimState:PlayAnimation("halved")
	
	inst:AddTag("veggie")
	inst:AddTag("fruit")
	inst:AddTag("cookable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_PINEAPPLE_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_PINEAPPLE_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_PINEAPPLE_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_pineapple_halved"
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_pineapple_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function pineapple_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_pineapple")
	inst.AnimState:SetBuild("kyno_pineapple")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("veggie")
	inst:AddTag("fruit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_PINEAPPLE_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_PINEAPPLE_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_PINEAPPLE_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_pineapple_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_pineapple", pineapple, assets, prefabs),
Prefab("kyno_pineapple_halved", pineapple_halved, assets, prefabs),
Prefab("kyno_pineapple_cooked", pineapple_cooked, assets, prefabs)