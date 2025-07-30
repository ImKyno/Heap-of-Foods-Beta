local assets =
{
	Asset("ANIM", "anim/kyno_poison_froglegs.zip"),
	Asset("ANIM", "anim/kyno_moon_froglegs.zip"),
	
	Asset("ANIM", "anim/meat_rack_food.zip"),
	Asset("ANIM", "anim/kyno_meatrack_poison_froglegs.zip"),
	Asset("ANIM", "anim/kyno_meatrack_moon_froglegs.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_poison_froglegs_cooked",
	"kyno_moon_froglegs_cooked",
	
	"smallmeat_dried",
	"spoiled_food",
}

local function fn(bank, build, anim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation(anim)

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
	inst:AddComponent("cookable")

   	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("smallmeat_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_MED)
	inst.components.dryable:SetDriedBuildFile("meat_rack_food") -- Uses smallmeat_dried build.

	inst:AddComponent("perishable")
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function fn_poison()
	local inst = fn("kyno_poison_froglegs", "kyno_poison_froglegs", "idle")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.tradable.goldvalue = 1
	inst.components.dryable:SetBuildFile("kyno_meatrack_poison_froglegs")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	
	inst.components.inventoryitem.imagename = "kyno_poison_froglegs"
	inst.components.cookable.product = "kyno_poison_froglegs_cooked"
	
	inst.components.edible.healthvalue = TUNING.KYNO_POISON_FROGLEGS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_POISON_FROGLEGS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_POISON_FROGLEGS_SANITY
	
	return inst
end

local function fn_moon()
	local inst = fn("kyno_moon_froglegs", "kyno_moon_froglegs", "idle")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.tradable.goldvalue = 1
	inst.components.dryable:SetBuildFile("kyno_meatrack_moon_froglegs")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	
	inst.components.inspectable.nameoverride = "FROGLEGS"
	inst.components.inventoryitem.imagename = "kyno_moon_froglegs"
	inst.components.cookable.product = "kyno_moon_froglegs_cooked"
	
	inst.components.edible.healthvalue = TUNING.KYNO_MOON_FROGLEGS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_MOON_FROGLEGS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_MOON_FROGLEGS_SANITY
	
	return inst
end

local function fn_cooked(bank, build, anim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation(anim)
	
	inst:AddTag("meat")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("perishable")
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function fn_poison_cooked()
	local inst = fn("kyno_poison_froglegs", "kyno_poison_froglegs", "cooked")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.tradable.goldvalue = 1
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.inventoryitem.imagename = "kyno_poison_froglegs_cooked"
	
	inst.components.edible.healthvalue = TUNING.KYNO_POISON_FROGLEGS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_POISON_FROGLEGS_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_POISON_FROGLEGS_COOKED_SANITY
	
	return inst
end

local function fn_moon_cooked()
	local inst = fn("kyno_moon_froglegs", "kyno_moon_froglegs", "cooked")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.tradable.goldvalue = 1
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	
	inst.components.inspectable.nameoverride = "FROGLEGS_COOKED"
	inst.components.inventoryitem.imagename = "kyno_moon_froglegs_cooked"
	
	inst.components.edible.healthvalue = TUNING.KYNO_MOON_FROGLEGS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_MOON_FROGLEGS_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_MOON_FROGLEGS_COOKED_SANITY
	
	return inst
end

return Prefab("kyno_poison_froglegs", fn_poison, assets, prefabs),
Prefab("kyno_poison_froglegs_cooked", fn_poison_cooked, assets),
Prefab("kyno_moon_froglegs", fn_moon, assets, prefabs),
Prefab("kyno_moon_froglegs_cooked", fn_moon_cooked, assets, prefabs)