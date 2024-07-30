local assets =
{
	Asset("ANIM", "anim/kyno_waterycress.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_waterycress",
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
    local plant = SpawnPrefab("kyno_waterycress_ocean")
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

	inst.AnimState:SetScale(1.2, 1.2, 1.2)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_waterycress.tex")

    MakeInventoryPhysics(inst, nil, 0.7)

    inst.AnimState:SetBank("kyno_waterycress")
    inst.AnimState:SetBuild("kyno_waterycress")
    inst.AnimState:PlayAnimation("idle_plant", true)
    inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("plant")
	inst:AddTag("blocker")
	inst:AddTag("waterycress")

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
    inst.components.pickable:SetUp("kyno_waterycress", TUNING.KYNO_WATERYCRESS_GROWTIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	MakeHauntableIgnite(inst)
	-- MakeWaxablePlant(inst)

    return inst
end

local function waterycress()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_waterycress")
	inst.AnimState:SetBuild("kyno_waterycress")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("veggie")
	inst:AddTag("modded_crop")
	inst:AddTag("deployedplant")
	inst:AddTag("saltbox_valid")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WATERYCRESS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WATERYCRESS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WATERYCRESS_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_waterycress"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function waterycress_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_waterycress")
	inst.AnimState:SetBuild("kyno_waterycress")
	inst.AnimState:PlayAnimation("idle_cooked")

	inst:AddTag("veggie")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WATERYCRESS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WATERYCRESS_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WATERYCRESS_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_waterycress_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function OnDeploy(inst, pt, deployer, rot)
    local plant = SpawnPrefab("plant_normal_ground")
    plant.components.crop:StartGrowing(inst.components.plantable.product, inst.components.plantable.growtime)
    plant.Transform:SetPosition(pt.x, 0, pt.z)
    plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
    inst:Remove()
end

return Prefab("kyno_waterycress_ocean", fn, assets, prefabs),
Prefab("kyno_waterycress", waterycress, assets, prefabs),
MakePlacer("kyno_waterycress_placer", "kyno_waterycress", "kyno_waterycress", "idle_plant", false, false, false, nil, nil, nil, nil, 2)