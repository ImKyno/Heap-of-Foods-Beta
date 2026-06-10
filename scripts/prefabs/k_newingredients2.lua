local assets =
{
	Asset("ANIM", "anim/kyno_cavetuber.zip"),
	Asset("ANIM", "anim/kyno_cavetuber_blooming.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function tuberfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_cavetuber")
	inst.AnimState:SetBuild("kyno_cavetuber")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("cookable")
	inst:AddTag("cavetuber")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cavetuber"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_cavetuber_cooked"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CAVETUBER_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CAVETUBER_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CAVETUBER_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function tuber_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_cavetuber")
	inst.AnimState:SetBuild("kyno_cavetuber")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("cavetuber")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cavetuber_cooked"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_FUEL

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CAVETUBER_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CAVETUBER_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CAVETUBER_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function tuber_bloomingfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_cavetuber_blooming")
	inst.AnimState:SetBuild("kyno_cavetuber_blooming")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("cookable")
	inst:AddTag("cavetuber")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cavetuber_blooming"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_cavetuber_blooming_cooked"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CAVETUBER_BLOOMING_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CAVETUBER_BLOOMING_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CAVETUBER_BLOOMING_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function tuber_blooming_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_cavetuber_blooming")
	inst.AnimState:SetBuild("kyno_cavetuber_blooming")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("cavetuber")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cavetuber_blooming_cooked"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_LARGE_FUEL

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CAVETUBER_BLOOMING_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CAVETUBER_BLOOMING_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CAVETUBER_BLOOMING_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_cavetuber", tuberfn, assets),
Prefab("kyno_cavetuber_cooked", tuber_cookedfn, assets),
Prefab("kyno_cavetuber_blooming", tuber_bloomingfn, assets),
Prefab("kyno_cavetuber_blooming_cooked", tuber_blooming_cookedfn, assets)