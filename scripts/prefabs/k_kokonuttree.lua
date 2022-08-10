local assets =
{
    Asset("ANIM", "anim/kyno_kokonuttree.zip"),
    
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs_tree =
{
    "log",
    "twigs",
	
	"kyno_kokonut",
	"kyno_kokonut_halved",
	"kyno_kokonut_cooked",
    "kyno_kokonuttree_stump",
    "kyno_kokonuttree_burnt",
}

local prefabs_stump =
{
    "ash",
}

local prefabs_burnt =
{
    "charcoal",
}

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("chop")
	if math.random() > .5 then
		inst.AnimState:PushAnimation("sway1_loop", true)
	else
		inst.AnimState:PushAnimation("sway2_loop", true)
	end
    inst.AnimState:Show("coconut")
end

local function makefullfn(inst)
    if math.random() > .5 then
		inst.AnimState:PushAnimation("sway1_loop", true)
	else
		inst.AnimState:PushAnimation("sway2_loop", true)
	end
    inst.AnimState:Show("coconut")
end

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("chop")
	if math.random() > .5 then
		inst.AnimState:PushAnimation("sway1_loop", true)
	else
		inst.AnimState:PushAnimation("sway2_loop", true)
	end
	inst.AnimState:Hide("coconut")
end

local function makeemptyfn(inst)
	if math.random() > .5 then
		inst.AnimState:PushAnimation("sway1_loop", true)
	else
		inst.AnimState:PushAnimation("sway2_loop", true)
	end
	inst.AnimState:Hide("coconut")
end

local function setupstump(inst)
    SpawnPrefab("kyno_kokonuttree_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function tree_chopped(inst, chopper)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(chopper.Transform:GetWorldPosition())

	local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
	if he_right then
		inst.AnimState:PlayAnimation("fallleft")
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation("fallright")
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end
	
    inst.AnimState:Hide("coconut")
	
    if inst.components.pickable ~= nil and inst.components.pickable.canbepicked then
        inst.components.lootdropper:SpawnLootPrefab("kyno_kokonut")
    end
    inst.components.pickable.caninteractwith = false
    inst.components.workable:SetWorkable(false)
	
    inst:ListenForEvent("animover", setupstump)
end

local function tree_chop(inst, chopper)
    inst.AnimState:PlayAnimation("chop")
	if math.random() > .5 then
		inst.AnimState:PushAnimation("sway1_loop", true)
	else
		inst.AnimState:PushAnimation("sway2_loop", true)
	end
	
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
    local burnt_tree = SpawnPrefab("kyno_kokonuttree_burnt")
    burnt_tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
    burnt_tree.no_kokonut = inst.components.pickable == nil or not inst.components.pickable.canbepicked
    if burnt_tree.no_kokonut then
        burnt_tree.AnimState:Hide("coconut")
    end
    inst:Remove()
end

local function tree_onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
        data.no_kokonut = inst.components.pickable == nil or not inst.components.pickable.canbepicked
    end
end

local function tree_onload(inst, data)
    if data ~= nil then
        if data.burnt then
            if data.no_kokonut and inst.components.pickable ~= nil then
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
	minimap:SetIcon("kyno_kokonuttree.tex")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("kyno_kokonuttree")
    inst.AnimState:SetBuild("kyno_kokonuttree")
    if math.random() > .5 then
		inst.AnimState:PushAnimation("sway1_loop", true)
	else
		inst.AnimState:PushAnimation("sway2_loop", true)
	end
	
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("kokonuttree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("kyno_kokonut", TUNING.KYNO_KOKONUTTREE_GROWTIME, 2)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.makefullfn = makefullfn

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_KOKONUTTREE_WORKLEFT)
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
    minimap:SetIcon("kyno_kokonuttree_stump.tex")

    inst.AnimState:SetBank("kyno_kokonuttree")
    inst.AnimState:SetBuild("kyno_kokonuttree")
    inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("plant")

    inst:SetPrefabNameOverride("kyno_kokonuttree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_KOKONUTTREE_STUMP_WORKLEFT)
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
    data.no_kokonut = inst.no_kokonut or nil
end

local function burnt_onload(inst, data)
    if data ~= nil and data.no_kokonut then
        inst.no_kokonut = data.no_kokonut
        inst.AnimState:Hide("coconut")
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
    minimap:SetIcon("kyno_kokonuttree_burnt.tex")

    inst.AnimState:SetBank("kyno_kokonuttree")
    inst.AnimState:SetBuild("kyno_kokonuttree")
    inst.AnimState:PlayAnimation("burnt")

    inst:SetPrefabNameOverride("kyno_kokonuttree")
	
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_KOKONUTTREE_STUMP_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(burnt_chopped)

    MakeHauntableWorkAndIgnite(inst)

    inst.OnSave = burnt_onsave
    inst.OnLoad = burnt_onload

    return inst
end

return Prefab("kyno_kokonuttree", tree_fn, assets, prefabs_tree),
Prefab("kyno_kokonuttree_burnt", burnt_fn, assets, prefabs_burnt),
Prefab("kyno_kokonuttree_stump", stump_fn, assets, prefabs_stump)