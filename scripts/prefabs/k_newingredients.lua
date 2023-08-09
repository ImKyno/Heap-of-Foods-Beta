local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local assets =
{
    Asset("ANIM", "anim/quagmire_flour.zip"),
	Asset("ANIM", "anim/quagmire_syrup.zip"),
	Asset("ANIM", "anim/quagmire_spotspice_ground.zip"),
	Asset("ANIM", "anim/quagmire_spotspice_sprig.zip"),
	Asset("ANIM", "anim/quagmire_meat_small.zip"),
	Asset("ANIM", "anim/quagmire_crabmeat.zip"),
	Asset("ANIM", "anim/quagmire_mushrooms.zip"),
	Asset("ANIM", "anim/quagmire_sap.zip"),
	Asset("ANIM", "anim/quagmire_crop_wheat.zip"),
	Asset("ANIM", "anim/quagmire_salt.zip"),
	Asset("ANIM", "anim/foliage.zip"),
	Asset("ANIM", "anim/kyno_cookingoil.zip"),
	-- Asset("ANIM", "anim/kyno_sugar.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"spoiled_food",
	"gridplacer_farmablesoil",
	
	"kyno_bacon_cooked",
	"kyno_white_cap_cooked",
	"kyno_wheat_cooked",
	"kyno_salt",
	"kyno_crabmeat_cooked",
}

local function GetFertilizerKey(inst)
    return inst.prefab
end

local function fertilizerresearchfn(inst)
    return inst:GetFertilizerKey()
end

local function OilPickIdle(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsOceanAtPoint(x, y, z, false) then
		inst.AnimState:PlayAnimation("idle_water")
	else
		inst.AnimState:PlayAnimation("idle")
	end
end

local function wheatfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_crop_wheat")
	inst.AnimState:SetBuild("quagmire_crop_wheat")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("cookable")
	inst:AddTag("gourmet_wheat")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WHEAT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WHEAT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WHEAT_SANITY
	inst.components.edible.foodtype = FOODTYPE.SEEDS

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_wheat"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_wheat_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function wheat_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_crop_wheat")
	inst.AnimState:SetBuild("quagmire_crop_wheat")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("gourmet_wheat")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WHEAT_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WHEAT_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WHEAT_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.SEEDS

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_wheat_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function flourfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank("quagmire_flour")
    inst.AnimState:SetBuild("quagmire_flour")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("gourmet_flour")
	inst:AddTag("gourmet_ingredient")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_flour"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function sapfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank("quagmire_sap")
    inst.AnimState:SetBuild("quagmire_sap")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("gourmet_sap")
	inst:AddTag("gourmet_ingredient")
	inst:AddTag("sap_fishfarmbait")
	inst:AddTag("show_spoilage")
	inst:AddTag("honeyed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("bait")
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_sap"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "kyno_sap_spoiled"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_SAP_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_SAP_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_SAP_SANITY
	inst.components.edible.foodtype = FOODTYPE.GOODIES

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function sap_ruinedfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)
	MakeDeployableFertilizerPristine(inst)

    inst.AnimState:SetBank("quagmire_sap")
    inst.AnimState:SetBuild("quagmire_sap")
    inst.AnimState:PlayAnimation("idle_spoiled")

	inst:AddTag("gourmet_sap_spoiled")
	inst:AddTag("gourmet_ingredient")
	inst:AddTag("fertilizerresearchable")
	
	inst.GetFertilizerKey = GetFertilizerKey

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_sap_spoiled"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("fertilizerresearchable")
	inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)
	
	inst:AddComponent("fertilizer")
	inst.components.fertilizer.fertilizervalue = TUNING.GUANO_FERTILIZE
	inst.components.fertilizer.soil_cycles = TUNING.GUANO_SOILCYCLES
	inst.components.fertilizer.withered_cycles = TUNING.GUANO_WITHEREDCYCLES
	inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.kyno_sap_spoiled.nutrients)
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)
	MakeDeployableFertilizer(inst)

    return inst
end

local function syrupfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank("quagmire_syrup")
    inst.AnimState:SetBuild("quagmire_syrup")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("gourmet_syrup")
	inst:AddTag("gourmet_ingredient")
	inst:AddTag("show_spoilage")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_syrup"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_SYRUP_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_SYRUP_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_SYRUP_SANITY
	inst.components.edible.foodtype = FOODTYPE.GOODIES

	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function sprigfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank("quagmire_spotspice_sprig")
    inst.AnimState:SetBuild("quagmire_spotspice_sprig")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("gourmet_sprig")
	inst:AddTag("gourmet_ingredient")
	inst:AddTag("show_spoilage")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("bait")
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_spotspice_leaf"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_SPOTSPICE_LEAF_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_SPOTSPICE_LEAF_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_SPOTSPICE_LEAF_SANITY
	inst.components.edible.foodtype = FOODTYPE.SEEDS
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function spicefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank("quagmire_spotspice_ground")
    inst.AnimState:SetBuild("quagmire_spotspice_ground")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("gourmet_spotspice")
	inst:AddTag("gourmet_ingredient")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_spotspice"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function baconfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_meat_small")
	inst.AnimState:SetBuild("quagmire_meat_small")
	inst.AnimState:PlayAnimation("raw")

	inst:AddTag("meat")
	inst:AddTag("meat_bacon")
	inst:AddTag("cookable")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SMALLMEAT"
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BACON_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BACON_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BACON_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bacon"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_bacon_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function bacon_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_meat_small")
	inst.AnimState:SetBuild("quagmire_meat_small")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("meat")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "COOKEDSMALLMEAT"
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_BACON_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BACON_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BACON_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bacon_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function mushfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_mushrooms")
	inst.AnimState:SetBuild("quagmire_mushrooms")
	inst.AnimState:PlayAnimation("raw")

	inst:AddTag("veggie")
	inst:AddTag("cookable")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "RED_CAP"

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WHITE_CAP_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WHITE_CAP_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WHITE_CAP_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_white_cap"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_white_cap_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function mush_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_mushrooms")
	inst.AnimState:SetBuild("quagmire_mushrooms")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("veggie")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "RED_CAP_COOKED"

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WHITE_CAP_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WHITE_CAP_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WHITE_CAP_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_white_cap_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function foliagefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("foliage")
    inst.AnimState:SetBuild("foliage")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("cattoy")
	inst:AddTag("cookable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("bait")
    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "FOLIAGE"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_foliage"

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = TUNING.KYNO_FOLIAGE_HEALTH
    inst.components.edible.hungervalue = TUNING.KYNO_FOLIAGE_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_FOLIAGE_SANITY
    inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

local function foliage_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("foliage")
	inst.AnimState:SetBuild("foliage")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("gourmet_foliage")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "FOLIAGE"

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_FOLIAGE_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_FOLIAGE_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_FOLIAGE_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_foliage_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function saltfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst.AnimState:SetBank("quagmire_salt")
    inst.AnimState:SetBuild("quagmire_salt")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("gourmet_salt")
	inst:AddTag("gourmet_ingredient")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	inst:AddComponent("salter")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_salt"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function crabmeatfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_crabmeat")
	inst.AnimState:SetBuild("quagmire_crabmeat")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 5

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CRABMEAT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CRABMEAT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CRABMEAT_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_crabmeat"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_crabmeat_cooked"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function crabmeat_cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("quagmire_crabmeat")
	inst.AnimState:SetBuild("quagmire_crabmeat")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("meat")
	inst:AddTag("gourmet_ingredient")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 5

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_CRABMEAT_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_CRABMEAT_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_CRABMEAT_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_crabmeat_cooked"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function oilfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(.8, .8, .8)

    inst.AnimState:SetBank("kyno_cookingoil")
    inst.AnimState:SetBuild("kyno_cookingoil")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("drinkable_food")
	inst:AddTag("gourmet_ingredient")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_OIL_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_OIL_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_OIL_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_oil"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:ListenForEvent("on_landed", OilPickIdle)
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function sugarfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("kyno_sugar")
    inst.AnimState:SetBuild("kyno_sugar")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("gourmet_ingredient")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_sugar"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("kyno_wheat", wheatfn, assets, prefabs),
Prefab("kyno_wheat_cooked", wheat_cookedfn, assets, prefabs),
Prefab("kyno_flour", flourfn, assets, prefabs),
Prefab("kyno_spotspice_leaf", sprigfn, assets, prefabs),
Prefab("kyno_spotspice", spicefn, assets, prefabs),
Prefab("kyno_sap", sapfn, assets, prefabs),
Prefab("kyno_sap_spoiled", sap_ruinedfn, assets, prefabs),
-- Prefab("kyno_syrup", syrupfn, assets, prefabs), Check "modmain.lua" for more info.
Prefab("kyno_bacon", baconfn, assets, prefabs),
Prefab("kyno_bacon_cooked", bacon_cookedfn, assets, prefabs),
Prefab("kyno_white_cap", mushfn, assets, prefabs),
Prefab("kyno_white_cap_cooked", mush_cookedfn, assets, prefabs),
Prefab("kyno_foliage", foliagefn, assets, prefabs), -- False Foliage, check "modmain.lua" for more info.
Prefab("kyno_foliage_cooked", foliage_cookedfn, assets, prefabs),
Prefab("kyno_salt", saltfn, assets, prefabs),
Prefab("kyno_crabmeat", crabmeatfn, assets, prefabs),
Prefab("kyno_crabmeat_cooked", crabmeat_cookedfn, assets, prefabs),
Prefab("kyno_oil", oilfn, assets, prefabs)--[[,
Prefab("kyno_sugar", sugarfn, assets, prefabs)
]]--