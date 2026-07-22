local assets =
{
	Asset("ANIM", "anim/kyno_banana.zip"),
	Asset("ANIM", "anim/kyno_bananatree_sapling.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_banana",
	"kyno_banana_cooked",
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_banana")
	inst.AnimState:SetBuild("kyno_banana")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("fruit")
	inst:AddTag("cookable")
	inst:AddTag("cattoy")
	inst:AddTag("surface_banana")
	inst:AddTag("monkeyqueenbribe")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("inventoryitem")

	   inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BANANA_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BANANA_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BANANA_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_banana_cooked"

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

	inst.AnimState:SetBank("kyno_banana")
	inst.AnimState:SetBuild("kyno_banana")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("fruit")
	inst:AddTag("surface_banana")
	inst:AddTag("monkeyqueenbribe")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("inventoryitem")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BANANA_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BANANA_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BANANA_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_banana", fn, assets, prefabs),
Prefab("kyno_banana_cooked", fn_cooked, assets, prefabs)