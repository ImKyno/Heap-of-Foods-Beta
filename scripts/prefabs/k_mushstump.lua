require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_mushroomstump.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs = 
{
	"kyno_white_cap",
}

local function dig_up(inst, chopper)
	if inst:HasTag("mushroom_stump_natural") then
		inst.components.lootdropper:SpawnLootPrefab("kyno_white_cap")
		inst.components.lootdropper:SpawnLootPrefab("livinglog")
		
		TheWorld:PushEvent("beginregrowth", inst)
	else
		inst.components.lootdropper:DropLoot()
	end
	
	inst:Remove()
end

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_plants")
    inst.AnimState:PlayAnimation("pick")
    inst.AnimState:PlayAnimation("empty", true)
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("pick")
    inst.AnimState:PushAnimation("idle", true)
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("empty", true)
end

local function onbuilt(inst)
	inst.components.pickable:MakeEmpty()
    inst.AnimState:PlayAnimation("empty", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_mushroomstump.tex")
	minimap:SetPriority(-2)
	
	inst.AnimState:SetScale(.8, .8, .8)
	MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetBank("kyno_mushroomstump")
	inst.AnimState:SetBuild("kyno_mushroomstump")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("mushroom_stump")
	inst:AddTag("plant")
	inst:AddTag("renewable")
	inst:AddTag("silviculture")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_MUSHROOMSTUMP"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("kyno_white_cap", TUNING.KYNO_MUSHSTUMP_GROWTIME, 2)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_MUSHSTUMP_WORKLEFT)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	MakeNoGrowInWinter(inst)
    MakeHauntableIgnite(inst)
	-- MakeWaxablePlant(inst)

	return inst
end

local function mushplacefn(inst)
	inst.AnimState:SetScale(.8, .8, .8)
end

return Prefab("kyno_mushstump", fn, assets, prefabs),
Prefab("kyno_mushstump_natural", fn, assets, prefabs),
Prefab("kyno_mushstump_cave", fn, assets, prefabs),
MakePlacer("kyno_mushstump_placer", "kyno_mushroomstump", "kyno_mushroomstump", "idle", false, nil, nil, nil, nil, nil, mushplacefn)