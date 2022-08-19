local assets =
{
	Asset("ANIM", "anim/meat_rack_food.zip"),
	Asset("ANIM", "anim/meat_human.zip"),
	
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
	inst.components.edible.healthvalue = TUNING.KYNO_HUMANMEAT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_HUMANMEAT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_HUMANMEAT_SANITY
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
	inst.components.edible.healthvalue = TUNING.KYNO_HUMANMEAT_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_HUMANMEAT_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_HUMANMEAT_COOKED_SANITY
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

return Prefab("kyno_humanmeat", fn, assets),
Prefab("kyno_humanmeat_cooked", fn_cooked, assets)