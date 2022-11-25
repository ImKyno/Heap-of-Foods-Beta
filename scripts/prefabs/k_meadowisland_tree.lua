local assets =
{
	Asset("ANIM", "anim/tree_leaf_tall.zip"),
    Asset("ANIM", "anim/teatree_trunk_build.zip"),
    Asset("ANIM", "anim/teatree_build.zip"), 
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"green_leaves_chop",
	"driftwood_log",
	
	"kyno_oaktree_pod",
	"kyno_twiggynuts",
	"kyno_piko",
	"kyno_piko_orange",
}

local function ChopTree(inst, chopper, chopsleft, numchops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(chopper ~= nil and chopper:HasTag("beaver") and
		"dontstarve/characters/woodie/beaver_chop_tree" or "dontstarve/wilson/use_axe_tree")
    end

    inst.AnimState:PlayAnimation("chop_tall")
	if math.random() < 0.5 then 
		inst.AnimState:PushAnimation("sway1_loop_tall", true)
	else	
		inst.AnimState:PushAnimation("sway2_loop_tall", true)
	end

    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab(math.random() < 0.5 and "green_leaves_chop" or "green_leaves_chop").Transform:SetPosition(x, y + math.random(), z)
end

local function ChopTreeShake(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .25, .03, .5, inst, 6)
end

local function ChopDownTree(inst, chopper)
    local pt = inst:GetPosition()

    local he_right = true
    if chopper then
        local hispos = chopper:GetPosition()
        he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    else
        if math.random() > 0.5 then
            he_right = false
        end
    end
    if he_right then
        inst.AnimState:PlayAnimation("fallright_tall")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    else
        inst.AnimState:PlayAnimation("fallleft_tall")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    end

	inst.persists = false
	inst:DoTaskInTime(14 * FRAMES, ChopTreeShake)
	inst:ListenForEvent("animover", inst.Remove)
	SpawnPrefab("kyno_meadowisland_tree_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function DigUp(inst, chopper)
    inst.components.lootdropper:SpawnLootPrefab("driftwood_log")
    inst:Remove()
end

local function OnIgnite(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
end

local function OnBurnt(inst)
    local burnt_tree = SpawnPrefab("kyno_meadowisland_tree_burnt")
    burnt_tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item:HasTag("squirrel") then
		return true -- Infest the tree.
	else
		giver.components.talker:Say(GetString(giver, "ANNOUNCE_PIKO_FAIL"))
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item:HasTag("squirrel") then
		local tree = SpawnPrefab("kyno_meadowisland_pikotree")
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		local fx = SpawnPrefab("green_leaves_chop")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	inst:Remove()
end

local function OnSave(inst, data)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data and data.burnt then
		OnBurnt(inst)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_tree.tex")
	minimap:SetPriority(5)

    MakeObstaclePhysics(inst, .4)

	inst.AnimState:SetBank("tree_leaf")
	inst.AnimState:SetBuild("teatree_build")
	inst.AnimState:AddOverrideBuild("teatree_trunk_build")
	if math.random() < 0.5 then 
		inst.AnimState:PlayAnimation("sway1_loop_tall", true)
	else	
		inst.AnimState:PlayAnimation("sway2_loop_tall", true)
	end
	
	inst:AddTag("structure")
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("shelter")
	inst:AddTag("infestable_tree")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	-- inst.AnimState:SetTime(math.random()*2)

    -- local color = 0.5 + math.random() * 0.5
    -- inst.AnimState:SetMultColour(color, color, color, 1)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"driftwood_log", "driftwood_log", "kyno_twiggynuts", "kyno_twiggynuts", "kyno_oaktree_pod"})
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_MEADOWISLAND_TREE_WORKLEFT)
	inst.components.workable:SetOnWorkCallback(ChopTree)
    inst.components.workable:SetOnFinishCallback(ChopDownTree)

    MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
	MakeSmallPropagator(inst)
	MakeSnowCovered(inst)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	return inst
end

local function StumpOnIgnite(inst)
    -- Blank fn to override default one since we do not
    -- Want to add "tree" tag but we still want to save
end

local function StumpOnBurnt(inst)
    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function StumpOnSave(inst, data)
    data.burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or nil
end

local function StumpOnLoad(inst, data)
    if data ~= nil and data.burnt then
        StumpOnBurnt(inst)
    end
end

local function stumpfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_tree_stump.tex")
	minimap:SetPriority(5)

    inst.AnimState:SetBank("tree_leaf")
    inst.AnimState:SetBuild("teatree_build")
	inst.AnimState:AddOverrideBuild("teatree_trunk_build")
    inst.AnimState:PlayAnimation("stump_tall", true)

    inst:AddTag("stump")
	
	inst:SetPrefabNameOverride("kyno_meadowisland_tree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.AnimState:SetTime(math.random()*2)

    -- local color = 0.5 + math.random() * 0.5
    -- inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(DigUp)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_MEADOWISLAND_TREE_STUMP_WORKLEFT)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(StumpOnIgnite)
    inst.components.burnable:SetOnBurntFn(StumpOnBurnt)
	MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
	
	inst.OnSave = StumpOnSave
    inst.OnLoad = StumpOnLoad

    return inst
end

local function ChopBurntTree(inst)
    inst.components.workable:SetWorkable(false)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	
    inst.AnimState:PlayAnimation("chop_burnt_tall")
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
	
    inst.persists = false
    inst:DoTaskInTime(50 * FRAMES, inst.Remove)
end

local function burntfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_meadowisland_tree_burnt.tex")
	
	MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("tree_leaf")
    inst.AnimState:SetBuild("teatree_build")
	inst.AnimState:AddOverrideBuild("teatree_trunk_build")
    inst.AnimState:PlayAnimation("burnt_tall")

    inst:SetPrefabNameOverride("kyno_meadowisland_tree")
	
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_MEADOWISLAND_TREE_BURNT_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(ChopBurntTree)

    return inst
end

return Prefab("kyno_meadowisland_tree", fn, assets, prefabs),
Prefab("kyno_meadowisland_tree_stump", stumpfn, assets, prefabs),
Prefab("kyno_meadowisland_tree_burnt", burntfn, assets, prefabs)