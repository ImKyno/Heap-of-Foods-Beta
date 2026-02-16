require("worldsettingsutil")

local assets =
{
    Asset("ANIM", "anim/quagmire_sapbucket.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_short.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_normal.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_tall.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_build.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_trunk_build.zip"),
	
	-- Scrapbook anims, these ones up are funky.
	Asset("ANIM", "anim/kyno_sugartree_scrapbook.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"charcoal",

	"kyno_sap",
	"kyno_sapbucket_installer",
	"kyno_sugartree_sapped",
	"kyno_sugartree_stump",
	"kyno_sugartree_bud",
}

local SPOIL_SAP_TIMER = "kyno_sugartree_timer"

local function SpoilSap(inst)
	local ruined = SpawnPrefab("kyno_sugartree_ruined")
	ruined.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
	ruined.Transform:SetPosition(inst.Transform:GetWorldPosition())
	ruined.components.pickable:Regen()
	
	inst:Remove()
end

local function onpickedfn(inst)
    -- inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
	
	inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst.sapped = false
	inst:RemoveTag("sap_overflow")
	
	inst.components.worldsettingstimer:StopTimer(SPOIL_SAP_TIMER)
end

local function onregenfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")

    inst.AnimState:Show("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow")
	
	inst.sapped = true
	inst:AddTag("sap_overflow")
	
	if not inst.components.worldsettingstimer:ActiveTimerExists(SPOIL_SAP_TIMER) then
		inst.components.worldsettingstimer:StartTimer(SPOIL_SAP_TIMER, TUNING.KYNO_SAP_SPOILTIME)
	end
end

local function makeemptyfn(inst)
    inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst.sapped = false
	inst:RemoveTag("sap_overflow")
	
	inst.components.worldsettingstimer:StopTimer(SPOIL_SAP_TIMER)
end

-- Ruined Sap.
local function onpicked_ruinedfn(inst)
    -- inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")
	
	inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst.sapped = false
	inst:RemoveTag("sap_overflow_spoiled")
end

local function onregen_ruinedfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/sap_extractor")

    inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow_spoiled")
	
	inst.sapped = true
	inst:AddTag("sap_overflow_spoiled")
end

local function makeempty_ruinedfn(inst)
    inst.AnimState:Hide("sap")
	inst.AnimState:Show("swap_tapper")
    inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_empty")
	
	inst.sapped = false
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
		giver:PushEvent("cookwareinstallfail")
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

local function OnGetItemFromPlayer2(inst, giver, item)
	if item.components.inventoryitem ~= nil and item:HasTag("sap_bucket_installer") then
		local tree = SpawnPrefab("kyno_sugartree_ruined")
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
	
	inst:DoTaskInTime(14 * FRAMES, ChopTreeShake)
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
	
	inst:DoTaskInTime(14 * FRAMES, ChopTreeShake)
    inst:ListenForEvent("animover", setupstump_ruined)
end

local function tree_chop(inst, chopper)
    inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation("sway2_loop", true)
	
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
end

local function tree_startburn(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
	
	if inst.components.cookwareinstaller ~= nil then
		inst.components.cookwareinstaller:Disable()
	end
end

local function tree_burnt(inst)
    local burnt_tree = SpawnPrefab("kyno_sugartree_burnt")
    burnt_tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	if inst:HasTag("has_sap") then
		if inst.components.pickable:CanBePicked() then -- Sap burned, spawn ashes.
			inst.components.lootdropper:SpawnLootPrefab("ash")
			inst.components.lootdropper:SpawnLootPrefab("ash")
			inst.components.lootdropper:SpawnLootPrefab("ash")
			inst.components.lootdropper:DropLoot()
		else
			inst.components.lootdropper:DropLoot()
		end
	end
	
    inst:Remove()
end

local function burnt_chopped(inst)
    inst.components.workable:SetWorkable(false)
	
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    inst.AnimState:PlayAnimation("chop_burnt")
	
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
	
    inst.persists = false
    inst:DoTaskInTime(40 * FRAMES, inst.Remove)
end

local function GetStatus(inst, viewer)
	return (inst:HasTag("stump") and "CHOPPED")
	or (inst:HasTag("burnt") and "BURNT")
	or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning() and "BURNING")
	or (inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() and "SAPPED")
	or (inst.components.pickable ~= nil and not inst.components.pickable:CanBePicked() and "PICKED")
	or "GENERIC"
end

local function GetStatusRuined(inst, viewer)
	return (inst:HasTag("stump") and "CHOPPED")
	or (inst:HasTag("burnt") and "BURNT")
	or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning() and "BURNING")
	or (inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() and "SAPPED")
	or (inst.components.pickable ~= nil and not inst.components.pickable:CanBePicked() and "PICKED")
	or "GENERIC"
end

local function OnSave(inst, data)
	data.sapped = inst.sapped
	
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data and data.sapped then
		if data.sapped == true then
			inst.sapped = true 
		else
			inst.sapped = false
		end
	end
	
	if data and data.burnt then
		inst.components.lootdropper:SpawnLootPrefab("charcoal")
	end
end

local function OnPreLoad(inst, data)
    WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_SAP_GROWTIME)
	
	WorldSettings_Timer_PreLoad(inst, data, SPOIL_SAP_TIMER, TUNING.KYNO_SAP_SPOILTIME_MAX)
    WorldSettings_Timer_PreLoad_Fix(inst, data, SPOIL_SAP_TIMER, 1)
end

local function OnPreLoadRuined(inst, data)
    WorldSettings_Pickable_PreLoad(inst, data, TUNING.KYNO_SAP_RUINED_GROWTIME)
end

local s = .85

local function treefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sugartree.tex")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("swap_tapper")
	inst.AnimState:Hide("sap")
	
	inst:AddTag("tree")
	inst:AddTag("plant")
    inst:AddTag("shelter")
	inst:AddTag("sugartree")
	inst:AddTag("cookware_other_installable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "log", "kyno_sugartree_bud", "kyno_sap"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SUGARTREE"
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("cookwareinstaller")
	inst.components.cookwareinstaller:SetAcceptTest(TestItem)
    inst.components.cookwareinstaller.onaccept = OnGetItemFromPlayer

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(tree_chopped)
    inst.components.workable:SetOnWorkCallback(tree_chop)
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_SUGARTREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_sugartree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("sugartree")
	
	MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(tree_startburn)
    inst.components.burnable:SetOnBurntFn(tree_burnt)
	MakeMediumPropagator(inst)
	
	MakeWaxablePlant(inst)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function stumpfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_sugartree_stump.tex")

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("stump")
	inst:AddTag("sugartree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SUGARTREE"
	inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_STUMP_WORKLEFT)
    inst.components.workable:SetOnWorkCallback(stump_dug)
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_SUGARTREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_sugartree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("sugartree")
	
	MakeSmallBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(stump_startburn)
    inst.components.burnable:SetOnBurntFn(stump_burnt)
	MakeSmallPropagator(inst)
	
	MakeWaxablePlant(inst)
	
	inst.OnSave = OnSaveStump
    inst.OnLoad = OnLoadStump

    return inst
end

local function treesapfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sugartree_tapped.tex")

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
	inst:AddTag("plant")
	inst:AddTag("has_sap")
    inst:AddTag("shelter")
	inst:AddTag("sugartree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_sapbucket_installer"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SUGARTREE"
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/quagmire/common/craft/sap_extractor"
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_SAP_GROWTIME, true)
    inst.components.pickable:SetUp("kyno_sap", TUNING.KYNO_SAP_GROWTIME, 3)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_TAPPED_WORKLEFT)
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_SUGARTREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_sugartree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("sugartree")
	
	-- Check if it's there any tree with sap to be picked and 
	-- Make the Tree and Sap spoil after 2 Days (5 Days in total).
	--[[
	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "kyno_sugartree_timer" then
            SpoilSap(inst)
        end
    end)
	]]--
	
	inst:AddComponent("worldsettingstimer")
    inst:ListenForEvent("timerdone", function(inst, data)
		if data.name == SPOIL_SAP_TIMER then
			SpoilSap(inst)
		end
	end)
    inst.components.worldsettingstimer:AddTimer(SPOIL_SAP_TIMER, TUNING.KYNO_SAP_SPOILTIME_MAX, TUNING.KYNO_SAP_SPOILS)
    inst.components.worldsettingstimer:StartTimer(SPOIL_SAP_TIMER, TUNING.KYNO_SAP_SPOILTIME)
	
	inst.OnPreLoad = OnPreLoad
	
	MakeMediumBurnable(inst)
	inst.components.burnable:SetOnIgniteFn(tree_startburn)
	inst.components.burnable:SetOnBurntFn(tree_burnt)
	MakeMediumPropagator(inst)
	
	MakeWaxablePlant(inst)

    return inst
end

local function ruinedfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sugartree_tapped_ruined.tex")

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
	inst.AnimState:Show("swap_tapper")
	inst.AnimState:OverrideSymbol("swap_sapbucket", "quagmire_sapbucket", "swap_sapbucket_overflow_spoiled")
	
	inst:AddTag("tree")
	inst:AddTag("plant")
	inst:AddTag("has_sap")
    inst:AddTag("shelter")
	inst:AddTag("sugartree")
	inst:AddTag("sap_healable")
	inst:AddTag("sap_healable_bucket")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.flies = SpawnPrefab("flies")
	inst.flies.entity:SetParent(inst.entity)
	inst.flies.Transform:SetPosition(0, 0, 0)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_sapbucket_installer"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SUGARTREE_RUINED"
	inst.components.inspectable.getstatus = GetStatusRuined

	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/quagmire/common/craft/sap_extractor"
	WorldSettings_Pickable_RegenTime(inst, TUNING.KYNO_SAP_RUINED_GROWTIME, true)
    inst.components.pickable:SetUp("kyno_sap_spoiled", TUNING.KYNO_SAP_RUINED_GROWTIME, 3)
    inst.components.pickable.onregenfn = onregen_ruinedfn
    inst.components.pickable.onpickedfn = onpicked_ruinedfn
    inst.components.pickable.makeemptyfn = makeempty_ruinedfn
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammeredRuined)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_TAPPED_WORKLEFT)
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_SUGARTREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_sugartree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("sugartree")
	
	inst.OnPreLoad = OnPreLoadRuined
	
	MakeMediumBurnable(inst)
	inst.components.burnable:SetOnIgniteFn(tree_startburn)
	inst.components.burnable:SetOnBurntFn(tree_burnt)
	MakeMediumPropagator(inst)
	
	MakeWaxablePlant(inst)

    return inst
end

local function ruined2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sugartree_ruined.tex")

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
	inst:AddTag("plant")
    inst:AddTag("shelter")
	inst:AddTag("sugartree")
	inst:AddTag("sap_healable")
	inst:AddTag("cookware_other_installable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.flies = SpawnPrefab("flies")
	inst.flies.entity:SetParent(inst.entity)
	inst.flies.Transform:SetPosition(0, 0, 0)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "log", "kyno_sap_spoiled"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SUGARTREE_RUINED"
	inst.components.inspectable.getstatus = GetStatusRuined

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_WORKLEFT)
    inst.components.workable:SetOnFinishCallback(tree_chopped_ruined)
    inst.components.workable:SetOnWorkCallback(tree_chop)
	
	inst:AddComponent("cookwareinstaller")
	inst.components.cookwareinstaller:SetAcceptTest(TestItem)
    inst.components.cookwareinstaller.onaccept = OnGetItemFromPlayer2
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_SUGARTREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_sugartree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("sugartree")
	
	MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(tree_startburn)
    inst.components.burnable:SetOnBurntFn(tree_burnt)
	MakeMediumPropagator(inst)
	
	MakeWaxablePlant(inst)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function burntfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

    MakeObstaclePhysics(inst, .25)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_sugartree_burnt.tex")

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("burnt")
	
	inst:AddTag("burnt")
	inst:AddTag("sugartree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SUGARTREE"
	inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(burnt_chopped)
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_SUGARTREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_sugartree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("sugartree")
	
	MakeWaxablePlant(inst)

    return inst
end

local function stump_ruinedfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_sugartree_stump_ruined.tex")

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")
	inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("stump")
	inst:AddTag("sugartree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SUGARTREE_RUINED"
	inst.components.inspectable.getstatus = GetStatusRuined

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(TUNING.KYNO_SUGARTREE_STUMP_WORKLEFT)
    inst.components.workable:SetOnWorkCallback(stump_dug)
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_SUGARTREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_sugartree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("sugartree")
	
	MakeSmallBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(stump_startburn)
    inst.components.burnable:SetOnBurntFn(stump_burnt)
	MakeSmallPropagator(inst)
	
	MakeWaxablePlant(inst)
	
	inst.OnSave = OnSaveStump
    inst.OnLoad = OnLoadStump

    return inst
end

return Prefab("kyno_sugartree", treefn, assets, prefabs),
Prefab("kyno_sugartree_sapped", treesapfn, assets, prefabs),
Prefab("kyno_sugartree_ruined", ruinedfn, assets, prefabs),
Prefab("kyno_sugartree_ruined2", ruined2fn, assets, prefabs),
Prefab("kyno_sugartree_burnt", burntfn, assets, prefabs),
Prefab("kyno_sugartree_stump", stumpfn, assets, prefabs),
Prefab("kyno_sugartree_stump_ruined", stump_ruinedfn, assets, prefabs)