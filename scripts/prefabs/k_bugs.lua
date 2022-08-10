local assets =
{
	Asset("ANIM", "anim/jellybug.zip"),
	Asset("ANIM", "anim/jellybug_cooked.zip"),
	
	Asset("ANIM", "anim/slugbug.zip"),
	Asset("ANIM", "anim/slugbug_cooked.zip"), 
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_beanbugs_cooked",
	"kyno_gummybug_cooked",
	"spoiled_food",
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("jellybug")
	inst.AnimState:SetBuild("jellybug")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("veggie")
	inst:AddTag("cookable")
	inst:AddTag("slugbug_fishfarmbait")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 9.375
	inst.components.edible.sanityvalue = -10
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_beanbugs"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_beanbugs_cooked"

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

	inst.AnimState:SetBank("jellybug_cooked")
	inst.AnimState:SetBuild("jellybug_cooked")
	inst.AnimState:PlayAnimation("cooked", true)
	
	inst:AddTag("veggie")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 1
	inst.components.edible.hungervalue = 12.5
	inst.components.edible.sanityvalue = -5
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_beanbugs_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function gumfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("slugbug")
	inst.AnimState:SetBuild("slugbug")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("veggie")
	inst:AddTag("cookable")
	inst:AddTag("gummybug_fishfarmbait")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BEANBUGS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BEANBUGS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BEANBUGS_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_gummybug"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_gummybug_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function gumfn_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("slugbug_cooked")
	inst.AnimState:SetBuild("slugbug_cooked")
	inst.AnimState:PlayAnimation("cooked", true)
	
	inst:AddTag("veggie")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BEANBUGS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BEANBUGS_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BEANBUGS_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_gummybug_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_beanbugs", fn, assets),
Prefab("kyno_beanbugs_cooked", fn_cooked, assets),
Prefab("kyno_gummybug", gumfn, assets),
Prefab("kyno_gummybug_cooked", gumfn_cooked, assets)