local assets =
{
    Asset("ANIM", "anim/lotus.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
	"kyno_lotus_flower",
	"kyno_lotus_flower_cooked",
	"spoiled_food",
}

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked", true)
	inst:AddTag("nolotus")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_plant", true)
	inst:RemoveTag("nolotus")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picked", true)
	inst:AddTag("nolotus")
end

local function WakeUp(inst, isday)
	if isday and not inst:HasTag("nolotus") then
		inst.AnimState:PlayAnimation("open")
		inst.AnimState:PushAnimation("idle_plant", true)
	end
end

local function Sleep(inst, isdusk)
	if isdusk and not inst:HasTag("nolotus") then
		inst.AnimState:PlayAnimation("close")
		inst.AnimState:PushAnimation("idle_plant_close", true)
	end
end

local function ondeploy(inst, pt, deployer)
    local plant = SpawnPrefab("kyno_lotus_ocean")
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

    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_lotus.tex")

    MakeInventoryPhysics(inst, nil, 0.7)

    inst.AnimState:SetBank("lotus")
	inst.AnimState:SetBuild("lotus")
	inst.AnimState:PlayAnimation("idle_plant", true)

	inst:AddTag("plant")
    inst:AddTag("blocker")
    inst:AddTag("lotus")

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
    inst.components.pickable:SetUp("kyno_lotus_flower", TUNING.KYNO_LOTUS_GROWTIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
	inst:DoTaskInTime(1/30, function()
		inst:WatchWorldState("isday", WakeUp)
		WakeUp(inst, TheWorld.state.isday)
	end)
	
	inst:DoTaskInTime(1/30, function()
		inst:WatchWorldState("isdusk", Sleep)
		Sleep(inst, TheWorld.state.isdusk)
	end)
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
	-- MakeWaxablePlant(inst)

    return inst
end

local function lotus()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("lotus")
	inst.AnimState:SetBuild("lotus")
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
	inst.components.edible.healthvalue = TUNING.KYNO_LOTUS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_LOTUS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_LOTUS_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_lotus_flower"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_lotus_flower_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function lotus_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("lotus")
	inst.AnimState:SetBuild("lotus")
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
	inst.components.edible.healthvalue = TUNING.KYNO_LOTUS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_LOTUS_COOKED_HUNGER 
	inst.components.edible.sanityvalue = TUNING.KYNO_LOTUS_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_lotus_flower_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_lotus_ocean", fn, assets, prefabs),
Prefab("kyno_lotus_flower", lotus, assets, prefabs),
Prefab("kyno_lotus_flower_cooked", lotus_cooked, assets, prefabs),
MakePlacer("kyno_lotus_flower_placer", "lotus", "lotus", "idle_plant", false, false, false, nil, nil, nil, nil, 2)