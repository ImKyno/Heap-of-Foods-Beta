local assets =
{
    Asset("ANIM", "anim/quagmire_sapbucket.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_short.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_normal.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_tall.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_build.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_trunk_build.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"log",
	"ash",
	"charcoal",

	"kyno_sap",
	"kyno_sap_spoiled",
	"kyno_sugartree_short_stump",
	"kyno_sugartree_normal_stump",
	"kyno_sugartree_bud",
}

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item:HasTag("sap_bucket_installer") then
		giver.components.talker:Say(GetString(giver, "ANNOUNCE_SUGARTREE_TOOSMALL"))
	end
end

local function setupstump_short(inst)
    SpawnPrefab("kyno_sugartree_short_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function setupstump_normal(inst)
    SpawnPrefab("kyno_sugartree_normal_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function stump_dug(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function stump_startburn(inst)
    -- Blank fn to override default one since we do not
    -- Want to add "tree" tag but we still want to save
end

local function stump_burnt(inst)
    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function OnSaveStump(inst, data)
    data.burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or nil
end

local function OnLoadStump(inst, data)
    if data ~= nil and data.burnt then
        stump_burnt(inst)
    end
end

local function ChopTreeShake(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .25, .03, .5, inst, 6)
end

local function tree_chopped_short(inst, chopper)
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
	
	inst:DoTaskInTime(14 * FRAMES, ChopTreeShake)
    inst:ListenForEvent("animover", setupstump_short)
end

local function tree_chopped_normal(inst, chopper)
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
	
	inst:DoTaskInTime(14 * FRAMES, ChopTreeShake)
    inst:ListenForEvent("animover", setupstump_normal)
end

local function tree_chop(inst, chopper)
    inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation("sway2_loop", true)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
end

local function GrowNormal(inst)
	local normal = SpawnPrefab("kyno_sugartree_normal")
	normal.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
	normal.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function GrowTall(inst)
	local tall = SpawnPrefab("kyno_sugartree")
	tall.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	tall.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function StopGrowingShort(inst)
    inst.components.timer:StopTimer("kyno_sugartree_short_timer")
end

local function StopGrowingNormal(inst)
    inst.components.timer:StopTimer("kyno_sugartree_normal_timer")
end

StartGrowingShort = function(inst)
    if not inst.components.timer:TimerExists("kyno_sugartree_short_timer") then
        inst.components.timer:StartTimer("kyno_sugartree_short_timer")
    end
end

StartGrowingNormal = function(inst)
    if not inst.components.timer:TimerExists("kyno_sugartree_normal_timer") then
        inst.components.timer:StartTimer("kyno_sugartree_normal_timer")
    end
end

local function tree_startburn(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
	
	if inst.components.trader ~= nil then
		inst.components.trader:Disable()
	end
end

local function tree_burnt(inst)
    local burnt_tree = SpawnPrefab("charcoal") -- No burnt animations?
    burnt_tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
    inst:Remove()
end

local function OnSave(inst, data)
	-- data.sapped = inst.sapped
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
	end
end

local function OnLoad(inst, data)
	--[[
	if inst:HasTag("sapoverflow") then
		ShowSapStuff(inst)
	else
		HideSapStuff(inst)
	end
	]]--
	
	if data and data.burnt then
		inst.components.lootdropper:SpawnLootPrefab("charcoal")
	end
end

local s = .85

local function shortfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_sugarwoodtree.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_short")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("swap_tapper")
	inst.AnimState:Hide("sap")
	
	inst:AddTag("tree")
	inst:AddTag("plant")
    inst:AddTag("shelter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_sugartree_short_timer", TUNING.KYNO_SUGARTREE_SHORT_GROWTIME)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "kyno_sap"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_SHORT_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(tree_chopped_short)
    inst.components.workable:SetOnWorkCallback(tree_chop)
	
	inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "kyno_sugartree_short_timer" then
            GrowNormal(inst)
        end
    end)
	
	inst:ListenForEvent("onignite", StopGrowingShort)
	inst:ListenForEvent("onextinguish", StartGrowingShort)
	
	MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(tree_startburn)
    inst.components.burnable:SetOnBurntFn(tree_burnt)
	MakeSmallPropagator(inst)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function normalfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_sugarwoodtree.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_normal")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("swap_tapper")
	inst.AnimState:Hide("sap")
	
	inst:AddTag("tree")
	inst:AddTag("plant")
    inst:AddTag("shelter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_sugartree_normal_timer", TUNING.KYNO_SUGARTREE_NORMAL_GROWTIME)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "kyno_sugartree_bud", "kyno_sap"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_NORMAL_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(tree_chopped_normal)
    inst.components.workable:SetOnWorkCallback(tree_chop)
	
	inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "kyno_sugartree_normal_timer" then
            GrowTall(inst)
        end
    end)
	
	inst:ListenForEvent("onignite", StopGrowingNormal)
	inst:ListenForEvent("onextinguish", StartGrowingNormal)
	
	MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(tree_startburn)
    inst.components.burnable:SetOnBurntFn(tree_burnt)
	MakeSmallPropagator(inst)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function stump_shortfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_bananatree_stump.tex") -- KEKW

    inst.AnimState:SetBank("quagmire_tree_cotton_short")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("plant")
	inst:AddTag("stump")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_STUMP_WORKLEFT)
    inst.components.workable:SetOnWorkCallback(stump_dug)
	
	MakeSmallBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(stump_startburn)
    inst.components.burnable:SetOnBurntFn(stump_burnt)
	MakeSmallPropagator(inst)
	
	inst.OnSave = OnSaveStump
    inst.OnLoad = OnLoadStump

    return inst
end

local function stump_normalfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_bananatree_stump.tex") -- KEKW

    inst.AnimState:SetBank("quagmire_tree_cotton_normal")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("plant")
	inst:AddTag("stump")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_STUMP_WORKLEFT)
    inst.components.workable:SetOnWorkCallback(stump_dug)
	
	MakeSmallBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(stump_startburn)
    inst.components.burnable:SetOnBurntFn(stump_burnt)
	MakeSmallPropagator(inst)
	
	inst.OnSave = OnSaveStump
    inst.OnLoad = OnLoadStump

    return inst
end

return Prefab("kyno_sugartree_short", shortfn, assets, prefabs),
Prefab("kyno_sugartree_normal", normalfn, assets, prefabs),
Prefab("kyno_sugartree_short_stump", stump_shortfn, assets, prefabs),
Prefab("kyno_sugartree_normal_stump", stump_normalfn, assets, prefabs)