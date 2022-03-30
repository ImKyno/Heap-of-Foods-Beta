local assets =
{
	Asset("ANIM", "anim/meat_human.zip"),
	Asset("ANIM", "anim/kyno_humanmeat.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_humanmeat_cooked",
	"kyno_humanmeat_dried",
	"spoiled_food",
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("meat_human")
	inst.AnimState:SetBuild("meat_human")
	inst.AnimState:PlayAnimation("raw")

	inst:AddTag("meat")
	inst:AddTag("human_meat")
	inst:AddTag("dryable")
	inst:AddTag("cookable")
	inst:AddTag("lureplant_bait")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("selfstacker")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -20
	inst.components.edible.hungervalue = 12.5
	inst.components.edible.sanityvalue = -33
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_humanmeat"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_humanmeat_cooked"
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("kyno_humanmeat_dried")
	inst.components.dryable:SetBuildFile("humanmeat")
	inst.components.dryable:SetDriedBuildFile("humanmeat_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function fn_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("meat_human")
	inst.AnimState:SetBuild("meat_human")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("meat")
	inst:AddTag("human_meat")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -3
	inst.components.edible.hungervalue = 18.75
	inst.components.edible.sanityvalue = -20
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_humanmeat_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function fn_dried()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("meat_human")
	inst.AnimState:SetBuild("meat_human")
	inst.AnimState:PlayAnimation("idle_dried_human")
	
	inst:AddTag("meat")
	inst:AddTag("human_meat")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -3
	inst.components.edible.hungervalue = 25
	inst.components.edible.sanityvalue = -15
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_humanmeat_dried"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_humanmeat", fn, assets),
Prefab("kyno_humanmeat_cooked", fn_cooked, assets),
Prefab("kyno_humanmeat_dried", fn_dried, assets)