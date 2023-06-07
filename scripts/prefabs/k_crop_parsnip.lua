local assets =
{
	Asset("ANIM", "anim/kyno_crop_seeds.zip"),
	Asset("ANIM", "anim/parsnip.zip"),
	Asset("ANIM", "anim/grotto_parsnip_giant.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_parsnipminimap.tex"),
	Asset("ATLAS", "images/minimapimages/hof_parsnipminimap.xml"),
}

-- I'm going to use parznip because T.A.P has a parsnip prefab too.
local prefabs = 
{
	"kyno_parznip",
	"kyno_parznip_eaten",
	"kyno_parznip_cooked",
	"kyno_parznip_seeds",
	"kyno_parznip_big",
	"spoiled_food",
}

local function onpicked(inst)
    TheWorld:PushEvent("beginregrowth", inst)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("parsnip")
    inst.AnimState:SetBuild("parsnip")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("kyno_parznip", 10)
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function parznip_eaten()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("parsnip")
	inst.AnimState:SetBuild("parsnip")
	inst.AnimState:PlayAnimation("idle_eaten")
	
	inst:AddTag("veggie")
	inst:AddTag("cookable")
	inst:AddTag("modded_crop")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_PARZNIP_EATEN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_PARZNIP_EATEN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_PARZNIP_EATEN_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_parznip_eaten"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_parznip_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function onworked(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
end

local function onworkfinish(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	
	TheWorld:PushEvent("beginregrowth", inst)
	inst.components.lootdropper:DropLoot()
end

local function onburnt(inst)
    inst.components.lootdropper:SpawnLootPrefab("kyno_parznip_cooked")
	inst.components.lootdropper:SpawnLootPrefab("kyno_parznip_cooked")
	inst.components.lootdropper:SpawnLootPrefab("ash")
    inst:Remove()
end

local function parznip_big()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_parsnipminimap.tex")
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("grotto_parsnip_giant")
	inst.AnimState:SetBuild("grotto_parsnip_giant")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("modded_crop")
	inst:AddTag("giant_modded_crop")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_parznip", "kyno_parznip", "kyno_parznip"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_PARZNIP_BIG_WORKLEFT)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeLargeBurnable(inst)
	inst.components.burnable:SetFXLevel(4)
	inst.components.burnable:SetOnBurntFn(onburnt)
    MakeLargePropagator(inst)
	
	return inst
end

return Prefab("kyno_parznip_ground", fn, assets, prefabs),
Prefab("kyno_parznip_eaten", parznip_eaten, assets, prefabs),
Prefab("kyno_parznip_big", parznip_big, assets, prefabs)