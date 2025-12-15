require("worldsettingsutil")

local assets =
{
    Asset("ANIM", "anim/seaweed.zip"),
	Asset("ANIM", "anim/seaweed_seed.zip"),
	Asset("ANIM", "anim/kyno_meatrack_seaweeds.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
	
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
	"kyno_seaweeds_ocean",
	"kyno_seaweeds_cooked",
	"kyno_seaweeds_dried",
	"kyno_seaweeds_root",
	
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
    local plant = SpawnPrefab("kyno_seaweeds_ocean")
	
    if plant ~= nil then
        plant.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
		plant.components.pickable:MakeEmpty()
		
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end

local function CheckBeached(inst)
    inst._checkgroundtask = nil
    local x, y, z = inst.Transform:GetWorldPosition()
	
    if inst:GetCurrentPlatform() ~= nil or TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
        if inst.components.pickable ~= nil then
            inst.components.pickable:Pick(TheWorld)
        end
		
        inst:Remove()
		
        local beached = SpawnPrefab("kyno_seaweeds_root")
        beached.Transform:SetPosition(x, y, z)
    end
end

local function OnCollide(inst, other)
    if inst._checkgroundtask == nil then
        inst._checkgroundtask = inst:DoTaskInTime(1 + math.random(), CheckBeached)
    end
end

local function OnPreLoad(inst, data)
    WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_WEEDSEA_GROWTIME)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_seaweeds.tex")

    MakeInventoryPhysics(inst, nil, 0.7)

    inst.AnimState:SetBank("seaweed")
	inst.AnimState:SetBuild("seaweed")
	inst.AnimState:PlayAnimation("idle_plant", true)

	inst:AddTag("plant")
    inst:AddTag("blocker")
    inst:AddTag("weedsea")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.AnimState:SetTime(math.random() * 2)

    local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_WEEDSEA_GROWTIME, true)
    inst.components.pickable:SetUp("kyno_seaweeds", TUNING.KYNO_WEEDSEA_GROWTIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

	inst.Physics:SetCollisionCallback(OnCollide)
	inst:DoTaskInTime(1 + math.random(), CheckBeached)

	inst.OnPreLoad = OnPreLoad
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    MakeHauntableIgnite(inst)
	AddToRegrowthManager(inst)

    return inst
end

local function seaweed()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("seaweed")
	inst.AnimState:SetBuild("seaweed")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("veggie")
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

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WEEDSEA_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WEEDSEA_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WEEDSEA_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("kyno_seaweeds_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst.components.dryable:SetBuildFile("kyno_meatrack_seaweeds")
	inst.components.dryable:SetDriedBuildFile("kyno_meatrack_seaweeds")

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seaweeds"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_seaweeds_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function seaweed_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("seaweed")
	inst.AnimState:SetBuild("seaweed")
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
	inst.components.edible.healthvalue = TUNING.KYNO_WEEDSEA_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WEEDSEA_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WEEDSEA_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seaweeds_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function seaweed_root()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("seaweed_seed")
	inst.AnimState:SetBuild("seaweed_seed")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("deployedplant")

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

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seaweeds_root"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

local function WaxedPlant_MasterPostInit(inst)
	if inst.components.deployable ~= nil then
		inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)
	end
end

return Prefab("kyno_seaweeds_ocean", fn, assets, prefabs),
Prefab("kyno_seaweeds", seaweed, assets, prefabs),
Prefab("kyno_seaweeds_cooked", seaweed_cooked, assets, prefabs),
Prefab("kyno_seaweeds_root", seaweed_root, assets, prefabs),
MakePlacer("kyno_seaweeds_root_placer", "seaweed", "seaweed", "idle_plant", false, false, false, nil, nil, nil, nil, 2)