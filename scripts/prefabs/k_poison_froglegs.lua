local assets =
{
	Asset("ANIM", "anim/kyno_poison_froglegs.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_poison_froglegs_cooked",
	
	"smallmeat_dried",
	"spoiled_food",
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_poison_froglegs")
	inst.AnimState:SetBuild("kyno_poison_froglegs")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("dryable")
	inst:AddTag("lureplant_bait")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_POISON_FROGLEGS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_POISON_FROGLEGS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_POISON_FROGLEGS_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("smallmeat_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_MED)

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_poison_froglegs"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_poison_froglegs_cooked"

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

	inst.AnimState:SetBank("kyno_poison_froglegs")
	inst.AnimState:SetBuild("kyno_poison_froglegs")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("meat")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_POISON_FROGLEGS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_POISON_FROGLEGS_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_POISON_FROGLEGS_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_poison_froglegs_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_poison_froglegs", fn, assets),
Prefab("kyno_poison_froglegs_cooked", fn_cooked, assets)