local assets =
{
    Asset("ANIM", "anim/kyno_driedcap_red.zip"),
	Asset("ANIM", "anim/kyno_driedcap_green.zip"),
	Asset("ANIM", "anim/kyno_driedcap_blue.zip"),
	Asset("ANIM", "anim/kyno_driedcap_moon.zip"),
	
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
	"spoiled_food",
}

local function fn(bank, build, anim, cap_name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim)

    inst:AddTag("dried_cap")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("tradable")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_CAP_DRIED"

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
	
local function fn_red()
	local inst = fn("kyno_driedcap_red", "kyno_driedcap_red", "idle_ground", "kyno_red_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_RED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_RED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_RED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

local function fn_green()
	local inst = fn("kyno_driedcap_green", "kyno_driedcap_green", "idle_ground", "kyno_green_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_GREEN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_GREEN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_GREEN_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

local function fn_blue()
	local inst = fn("kyno_driedcap_blue", "kyno_driedcap_blue", "idle_ground", "kyno_blue_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_BLUE_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_BLUE_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_BLUE_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

local function fn_moon()
	local inst = fn("kyno_driedcap_moon", "kyno_driedcap_moon", "idle_ground", "kyno_moon_cap_dried")

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.edible.healthvalue = TUNING.KYNO_DRIEDCAP_MOON_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DRIEDCAP_MOON_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DRIEDCAP_MOON_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	return inst
end

return Prefab("kyno_red_cap_dried", fn_red, assets, prefabs),
Prefab("kyno_green_cap_dried", fn_green, assets, prefabs),
Prefab("kyno_blue_cap_dried", fn_blue, assets, prefabs),
Prefab("kyno_moon_cap_dried", fn_moon, assets, prefabs)