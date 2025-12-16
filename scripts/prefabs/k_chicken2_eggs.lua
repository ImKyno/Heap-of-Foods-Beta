local assets =
{
	Asset("ANIM", "anim/kyno_chicken_eggs.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_chicken_egg_cooked",
	"rottenegg",
	"kyno_chicken2",
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_chicken_eggs")
	inst.AnimState:SetBuild("kyno_chicken_eggs")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("saltbox_valid")
	inst:AddTag("catfood")
	inst:AddTag("chicken_egg")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CHICKEN_EGG_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CHICKEN_EGG_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CHICKEN_EGG_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "rottenegg"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken_egg"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_chicken_egg_cooked"
	
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

	inst.AnimState:SetBank("kyno_chicken_eggs")
	inst.AnimState:SetBuild("kyno_chicken_eggs")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("meat")
	inst:AddTag("chicken_egg")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CHICKEN_EGG_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CHICKEN_EGG_COOKED_HUNGER 
	inst.components.edible.sanityvalue = TUNING.KYNO_CHICKEN_EGG_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "rottenegg"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken_egg_cooked"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_chicken_egg", fn, assets, prefabs),
Prefab("kyno_chicken_egg_cooked", fn_cooked, assets, prefabs)