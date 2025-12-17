require("prefabutil")
require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/seataro.zip"),
	Asset("ANIM", "anim/kyno_plant_ocean_seeds.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"kyno_taroroot_ocean",
	"kyno_taroroot",
	"kyno_taroroot_cooked",
	"kyno_taroroot_root",
	
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

local function CheckBeached(inst)
    inst._checkgroundtask = nil
    local x, y, z = inst.Transform:GetWorldPosition()
	
    if inst:GetCurrentPlatform() ~= nil or TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
        if inst.components.pickable ~= nil then
            inst.components.pickable:Pick(TheWorld)
        end
		
        inst:Remove()

		local beached = SpawnPrefab("kyno_taroroot_root")
        beached.Transform:SetPosition(x, y, z)
    end
end

local function OnCollide(inst, other)
    if inst._checkgroundtask == nil then
        inst._checkgroundtask = inst:DoTaskInTime(1 + math.random(), CheckBeached)
    end
end

local function OnPreLoad(inst, data)
    WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_TAROSEA_GROWTIME)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local s = .7
	inst.AnimState:SetScale(s, s, s)

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
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_TAROSEA_GROWTIME, true)
    inst.components.pickable:SetUp("kyno_taroroot", TUNING.KYNO_TAROSEA_GROWTIME)
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
	inst:AddTag("saltbox_valid")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

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

local function taroroot_root()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_plant_ocean_seeds")
	inst.AnimState:SetBuild("kyno_plant_ocean_seeds")
	inst.AnimState:PlayAnimation("taroroot")
	
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
	inst.components.inventoryitem.imagename = "kyno_taroroot_root"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("kyno_taroroot_ocean", fn, assets, prefabs),
Prefab("kyno_taroroot", taroroot, assets, prefabs),
Prefab("kyno_taroroot_cooked", taroroot_cooked, assets, prefabs),
Prefab("kyno_taroroot_root", taroroot_root, assets, prefabs),
MakePlacer("kyno_taroroot_root_placer", "seataro", "seataro", "idle_plant", false, false, false, .7, nil, nil, nil, 2)