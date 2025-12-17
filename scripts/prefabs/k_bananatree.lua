local assets =
{
    Asset("ANIM", "anim/kyno_bananatree.zip"),
    
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs_tree =
{
    "twigs",
	
	"kyno_banana",
	"kyno_banana_cooked",
    "kyno_bananatree_stump",
    "kyno_bananatree_burnt",
}

local prefabs_stump =
{

}

local prefabs_burnt =
{
    "charcoal",
}

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_loop", true)
    inst.AnimState:Show("BANANA")
end

local function makefullfn(inst)
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Show("BANANA")
end

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("pick")
    inst.AnimState:PushAnimation("idle_loop")
    inst.AnimState:Hide("BANANA")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("BANANA")
end

local function setupstump(inst)
    SpawnPrefab("kyno_bananatree_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function tree_chopped(inst, chopper)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

    inst.components.lootdropper:SpawnLootPrefab("log")
    inst.components.lootdropper:SpawnLootPrefab("twigs")
    inst.components.lootdropper:SpawnLootPrefab("twigs")
    inst.AnimState:Hide("BANANA")
    if inst.components.pickable ~= nil and inst.components.pickable.canbepicked then
        inst.components.lootdropper:SpawnLootPrefab("kyno_banana")
    end
    inst.components.pickable.caninteractwith = false
    inst.components.workable:SetWorkable(false)
    inst.AnimState:PlayAnimation("fall")
    inst:ListenForEvent("animover", setupstump)
end

local function tree_chop(inst, chopper)
    inst.AnimState:PlayAnimation("chop")
    inst.AnimState:PushAnimation("idle_loop", true)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
end

local function tree_startburn(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
end

local function tree_burnt(inst)
    local burnt_tree = SpawnPrefab("kyno_bananatree_burnt")
    burnt_tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
    burnt_tree.no_banana = inst.components.pickable == nil or not inst.components.pickable.canbepicked
    if burnt_tree.no_banana then
        burnt_tree.AnimState:Hide("BANANA")
    end
    inst:Remove()
end

local function tree_onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
        data.no_banana = inst.components.pickable == nil or not inst.components.pickable.canbepicked
    end
end

local function tree_onload(inst, data)
    if data ~= nil then
        if data.burnt then
            if data.no_banana and inst.components.pickable ~= nil then
                inst.components.pickable.canbepicked = false
            end
            tree_burnt(inst)
        end
    end
end

local function tree_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_bananatree.tex")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("kyno_bananatree")
    inst.AnimState:SetBuild("kyno_bananatree")
    inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("realbananatree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("kyno_banana", TUNING.KYNO_BANANATREE_GROWTIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.makefullfn = makefullfn

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_BANANATREE_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(tree_chopped)
    inst.components.workable:SetOnWorkCallback(tree_chop)

	MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(tree_startburn)
    inst.components.burnable:SetOnBurntFn(tree_burnt)
	
	MakeSmallPropagator(inst)
    MakeNoGrowInWinter(inst)

    inst.OnSave = tree_onsave
    inst.OnLoad = tree_onload

    return inst
end

local function stump_startburn(inst)
    -- Blank fn to override default one since we do not
    -- Want to add "tree" tag but we still want to save
end

local function stump_burnt(inst)
    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function stump_dug(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function stump_onsave(inst, data)
    data.burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or nil
end

local function stump_onload(inst, data)
    if data ~= nil and data.burnt then
        stump_burnt(inst)
    end
end

local function stump_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_bananatree_stump.tex")

    inst.AnimState:SetBank("kyno_bananatree")
    inst.AnimState:SetBuild("kyno_bananatree")
    inst.AnimState:PlayAnimation("idle_stump")
	
	inst:AddTag("plant")

    inst:SetPrefabNameOverride("kyno_bananatree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_BANANATREE_STUMP_WORKLEFT)
    inst.components.workable:SetOnWorkCallback(stump_dug)

    MakeSmallBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(stump_startburn)
    inst.components.burnable:SetOnBurntFn(stump_burnt)
	
	MakeSmallPropagator(inst)

    inst.OnSave = stump_onsave
    inst.OnLoad = stump_onload

    return inst
end

local function burnt_chopped(inst)
    inst.components.workable:SetWorkable(false)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    inst.AnimState:PlayAnimation("chop_burnt")
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.persists = false
    inst:DoTaskInTime(50 * FRAMES, inst.Remove)
end

local function burnt_onsave(inst, data)
    data.no_banana = inst.no_banana or nil
end

local function burnt_onload(inst, data)
    if data ~= nil and data.no_banana then
        inst.no_banana = data.no_banana
        inst.AnimState:Hide("BANANA")
    end
end

local function burnt_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .25)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_bananatree_burnt.tex")

    inst.AnimState:SetBank("kyno_bananatree")
    inst.AnimState:SetBuild("kyno_bananatree")
    inst.AnimState:PlayAnimation("burnt")

    inst:SetPrefabNameOverride("kyno_bananatree")
	
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_BANANATREE_STUMP_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(burnt_chopped)

    MakeHauntableWorkAndIgnite(inst)

    inst.OnSave = burnt_onsave
    inst.OnLoad = burnt_onload

    return inst
end

return Prefab("kyno_bananatree", tree_fn, assets, prefabs_tree),
Prefab("kyno_bananatree_burnt", burnt_fn, assets, prefabs_burnt),
Prefab("kyno_bananatree_stump", stump_fn, assets, prefabs_stump)