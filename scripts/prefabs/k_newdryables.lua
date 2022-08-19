local assets =
{
	Asset("ANIM", "anim/kyno_meatrack_red_cap.zip"),
	Asset("ANIM", "anim/kyno_meatrack_green_cap.zip"),
	Asset("ANIM", "anim/kyno_meatrack_blue_cap.zip"),
	Asset("ANIM", "anim/kyno_meatrack_moon_cap.zip"),
	Asset("ANIM", "anim/kyno_meatrack_plantmeat.zip"),
	Asset("ANIM", "anim/kyno_meatrack_humanmeat.zip"),
	Asset("ANIM", "anim/kyno_meatrack_seaweeds.zip"),
	Asset("ANIM", "anim/kyno_meatrack_pigskin.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"red_cap",
	"green_cap",
	"blue_cap",
	"moon_cap",
	
	"plantmeat",
	
	"pigskin",
	
	"kyno_seaweeds",
	"kyno_humanmeat",
	
	"spoiled_food",
}

local function cap_fn(bank, build, anim, cap_name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("dried_cap")
	inst:AddTag("veggie")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = cap_name
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

local function meat_fn(bank, build, anim, meat_name)
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
	inst:AddTag("lureplant_bait")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = meat_name
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    return inst
end

local function veggie_fn(bank, build, anim, veggie_name)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation(anim)
	
	inst:AddTag("veggie")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = veggie_name
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	return inst
end

local function fn_pigskin()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_meatrack_pigskin")
	inst.AnimState:SetBuild("kyno_meatrack_pigskin")
	inst.AnimState:PlayAnimation("pigskin_idle")
	
	inst:AddTag("dried_pigskin")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 10

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_pigskin_dried"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.HORRIBLE
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

	return inst
end
	
local function fn_red()
	local inst = cap_fn("kyno_meatrack_red_cap", "kyno_meatrack_red_cap", "red_cap_idle", "kyno_red_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "KYNO_CAP_DRIED"
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_RED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_RED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_RED_SANITY
	
	return inst
end

local function fn_green()
	local inst = cap_fn("kyno_meatrack_green_cap", "kyno_meatrack_green_cap", "green_cap_idle", "kyno_green_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "KYNO_CAP_DRIED"
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_GREEN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_GREEN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_GREEN_SANITY
	
	return inst
end

local function fn_blue()
	local inst = cap_fn("kyno_meatrack_blue_cap", "kyno_meatrack_blue_cap", "blue_cap_idle", "kyno_blue_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "KYNO_CAP_DRIED"
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_BLUE_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_BLUE_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_BLUE_SANITY
	
	return inst
end

local function fn_moon()
	local inst = cap_fn("kyno_meatrack_moon_cap", "kyno_meatrack_moon_cap", "moon_cap_idle", "kyno_moon_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "KYNO_CAP_DRIED"
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_MOON_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_MOON_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_MOON_SANITY
	
	return inst
end

local function fn_humanmeat()
	local inst = meat_fn("kyno_meatrack_humanmeat", "kyno_meatrack_humanmeat", "humanmeat_idle", "kyno_humanmeat_dried")
	
	inst:AddTag("human_meat")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.tradable.goldvalue = 1
	
	inst.components.edible.healthvalue = TUNING.KYNO_HUMANMEAT_DRIED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_HUMANMEAT_DRIED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_HUMANMEAT_DRIED_SANITY
	
	return inst
end

local function fn_plantmeat()
	local inst = meat_fn("kyno_meatrack_plantmeat", "kyno_meatrack_plantmeat", "plantmeat_idle", "kyno_plantmeat_dried")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.tradable.goldvalue = 1
	
	inst.components.edible.healthvalue = TUNING.KYNO_PLANTMEAT_DRIED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_PLANTMEAT_DRIED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_PLANTMEAT_DRIED_SANITY
	
	return inst
end 

local function fn_seaweeds()
	local inst = veggie_fn("kyno_meatrack_seaweeds", "kyno_meatrack_seaweeds", "seaweeds_idle", "kyno_seaweeds_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.edible.healthvalue = TUNING.KYNO_WEEDSEA_DRIED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WEEDSEA_DRIED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WEEDSEA_DRIED_SANITY
	
	return inst
end

return Prefab("kyno_red_cap_dried", fn_red, assets, prefabs),
Prefab("kyno_green_cap_dried", fn_green, assets, prefabs),
Prefab("kyno_blue_cap_dried", fn_blue, assets, prefabs),
Prefab("kyno_moon_cap_dried", fn_moon, assets, prefabs),
Prefab("kyno_plantmeat_dried", fn_plantmeat, assets, prefabs),
Prefab("kyno_humanmeat_dried", fn_humanmeat, assets, prefabs),
Prefab("kyno_seaweeds_dried", fn_seaweeds, assets, prefabs),
Prefab("kyno_pigskin_dried", fn_pigskin, assets, prefabs)