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
	"kyno_sapbucket_installer",
	"kyno_sugartree_sapped",
	"kyno_sugartree_stump",
	"kyno_sugartree_bud",
}

local SAP_REGROW_TIME = 1440 -- 3 Days.
local SAP_SPOIL_TIME  = 2880 -- After 6 Days the Sap in the tree spoils.

local function SpoilSap(inst)
	local ruined = SpawnPrefab("kyno_sugartree_ruined")
	ruined.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
	ruined.Transform:SetPosition(inst.Transform:GetWorldPosition())
	ruined.components.pickable:Regen()
	inst:Remove()
end

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
	
	inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst:RemoveTag("sap_overflow")
	
	inst.components.timer:StopTimer("kyno_sugartree_timer")
end

local function onregenfn(inst)
    inst.AnimState:Show("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow")
	
	inst.sapped = true
	inst:AddTag("sap_overflow")
	
	inst.components.timer:StartTimer("kyno_sugartree_timer", SAP_SPOIL_TIME)
end

local function makeemptyfn(inst)
    inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst:RemoveTag("sap_overflow")
	
	inst.components.timer:StopTimer("kyno_sugartree_timer")
end

-- Ruined Sap.
local function onpicked_ruinedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
	
	inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst:RemoveTag("sap_overflow_spoiled")
end

local function onregen_ruinedfn(inst)
    inst.AnimState:Show("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow_spoiled")
	
	inst.sapped = true
	inst:AddTag("sap_overflow_spoiled")
end

local function makeempty_ruinedfn(inst)
    inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst:RemoveTag("sap_overflow_spoiled")
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	if inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
	end
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("kyno_sugartree").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function OnHammeredRuined(inst, worker)
	inst.components.lootdropper:DropLoot()
	if inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
	end
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("kyno_sugartree_ruined2").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function TestItem(inst, item, giver)
	if item.components.inventoryitem and item:HasTag("sap_bucket_installer") then
		return true -- Install the Sap Bucket.
	else
		giver.components.talker:Say(GetString(giver, "ANNOUNCE_SAPBUCKET_FAIL"))
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item:HasTag("sap_bucket_installer") then
		local tree = SpawnPrefab("kyno_sugartree_sapped")
		tree.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
		tree.AnimState:PlayAnimation("install")
		tree.components.pickable:MakeEmpty()
	end
	inst:Remove()
end

local function setupstump(inst)
    SpawnPrefab("kyno_sugartree_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function setupstump_ruined(inst)
    SpawnPrefab("kyno_sugartree_stump_ruined").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function stump_dug(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
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
	
    inst:ListenForEvent("animover", setupstump)
end

local function tree_chopped_ruined(inst, chopper)
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
	
    inst:ListenForEvent("animover", setupstump_ruined)
end

local function tree_chop(inst, chopper)
    inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation("sway2_loop", true)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
end

local function OnSave(inst, data)
	data.sapped = inst.sapped
end

local function OnLoad(inst, data)
	if inst:HasTag("sapoverflow") then
		ShowSapStuff(inst)
	else
		HideSapStuff(inst)
	end
end

local function treefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1, 1, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_sugarwoodtree.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("swap_tapper")
	inst.AnimState:Hide("sap")
	
	inst:AddTag("tree")
    inst:AddTag("shelter")
	inst:AddTag("sugartree_installable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "log", "kyno_sugartree_bud", "kyno_sap"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(15)
    inst.components.workable:SetOnFinishCallback(tree_chopped)
    inst.components.workable:SetOnWorkCallback(tree_chop)

    return inst
end

local function stumpfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1, 1, 1)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_bananatree_stump.tex") -- KEKW

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(stump_dug)

    return inst
end

local function treesapfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1, 1, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_sugarwoodtree_tapped.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:AddOverrideBuild("quagmire_sapbucket")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Show("sap")
	inst.AnimState:Show("swap_tapper")
	inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow")
	
	inst:AddTag("tree")
	inst:AddTag("has_sap")
    inst:AddTag("shelter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_sapbucket_installer"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/quagmire/common/craft/sap_extractor"
    inst.components.pickable:SetUp("kyno_sap", SAP_REGROW_TIME, 3)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(3)
	
	-- Check if it's there any tree with sap to be picked and 
	-- Make the Tree and Sap spoil after 2 Days (5 Days in total).
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "kyno_sugartree_timer" then
            SpoilSap(inst)
        end
    end)

    return inst
end

local function ruinedfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1, 1, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_sugarwoodtree_tapped.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:AddOverrideBuild("quagmire_sapbucket")
	inst.AnimState:OverrideSymbol("leaf_overlay", "quagmire_tree_cotton_build", "leaf_withered_overlay")
	inst.AnimState:OverrideSymbol("swap_leaves", "quagmire_tree_cotton_build", "swap_leaves_withered")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Show("sap")
	inst.AnimState:Show("swap_tapper")
	inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow_spoiled")
	
	inst:AddTag("tree")
	inst:AddTag("has_sap")
    inst:AddTag("shelter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_sapbucket_installer"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/quagmire/common/craft/sap_extractor"
    inst.components.pickable:SetUp("kyno_sap_spoiled", SAP_REGROW_TIME, 3)
    inst.components.pickable.onregenfn = onregen_ruinedfn
    inst.components.pickable.onpickedfn = onpicked_ruinedfn
    inst.components.pickable.makeemptyfn = makeempty_ruinedfn
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredRuined)
	inst.components.workable:SetWorkLeft(3)

    return inst
end

local function ruined2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1, 1, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_sugarwoodtree.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:AddOverrideBuild("quagmire_sapbucket")
	inst.AnimState:OverrideSymbol("leaf_overlay", "quagmire_tree_cotton_build", "leaf_withered_overlay")
	inst.AnimState:OverrideSymbol("swap_leaves", "quagmire_tree_cotton_build", "swap_leaves_withered")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("sap")
	inst.AnimState:Hide("swap_tapper")
	
	inst:AddTag("tree")
    inst:AddTag("shelter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "log", "kyno_sap_spoiled", "kyno_sap_spoiled"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(15)
    inst.components.workable:SetOnFinishCallback(tree_chopped_ruined)
    inst.components.workable:SetOnWorkCallback(tree_chop)

    return inst
end

local function stump_ruinedfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1, 1, 1)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_bananatree_stump.tex") -- KEKW

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")
	inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(stump_dug)

    return inst
end

return Prefab("kyno_sugartree", treefn, assets, prefabs),
Prefab("kyno_sugartree_sapped", treesapfn, assets, prefabs),
Prefab("kyno_sugartree_ruined", ruinedfn, assets, prefabs),
Prefab("kyno_sugartree_ruined2", ruined2fn, assets, prefabs),
Prefab("kyno_sugartree_stump", stumpfn, assets, prefabs),
Prefab("kyno_sugartree_stump_ruined", stump_ruinedfn, assets, prefabs)