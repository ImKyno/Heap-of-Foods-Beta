local assets =
{
    Asset("ANIM", "anim/seataro.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
	"kyno_taroroot_ocean",
	"kyno_taroroot",
	"kyno_taroroot_cooked",
	"spoiled_food",
}

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked", true)
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_plant", true)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picked", true)
end

local function ondeploy(inst, pt, deployer)
    local plant = SpawnPrefab("kyno_taroroot_ocean")
    if plant ~= nil then
        plant.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
		plant.components.pickable:MakeEmpty()
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.7, .7, .7)

    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_taroroot.tex")

    MakeInventoryPhysics(inst, nil, 0.7)

    inst.AnimState:SetBank("seataro")
	inst.AnimState:SetBuild("seataro")
	inst.AnimState:PlayAnimation("idle_plant", true)

	inst:AddTag("plant")
    inst:AddTag("blocker")
    inst:AddTag("taroroot")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst.AnimState:SetTime(math.random() * 2)

    local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
    inst.components.pickable:SetUp("kyno_taroroot", TUNING.KYNO_TAROSEA_GROWTIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
	-- MakeWaxablePlant(inst)

    return inst
end

local function taroroot()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("seataro")
	inst.AnimState:SetBuild("seataro")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("veggie")
	inst:AddTag("cookable")
	inst:AddTag("deployedplant")
	inst:AddTag("saltbox_valid")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")
	
	inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_TAROROOT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_TAROROOT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_TAROROOT_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_taroroot"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_taroroot_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function taroroot_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("seataro")
	inst.AnimState:SetBuild("seataro")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("veggie")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_TAROROOT_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_TAROROOT_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_TAROROOT_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_taroroot_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function taroplacer(inst)
	inst.AnimState:SetScale(.7, .7, .7)
end

return Prefab("kyno_taroroot_ocean", fn, assets, prefabs),
Prefab("kyno_taroroot", taroroot, assets, prefabs),
Prefab("kyno_taroroot_cooked", taroroot_cooked, assets, prefabs),
MakePlacer("kyno_taroroot_placer", "seataro", "seataro", "idle_plant", false, false, false, nil, nil, nil, taroplacer, 2)