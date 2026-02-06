require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/tree_leaf_tall.zip"),
    Asset("ANIM", "anim/teatree_trunk_build.zip"),
    Asset("ANIM", "anim/teatree_build.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"green_leaves_chop",
	"driftwood_log",

	"kyno_oaktree_pod",
	"kyno_twiggynuts",
	"kyno_tealeaf",
	"kyno_piko",
	"kyno_piko_orange",
}

local LEAF_PREFAB = "kyno_tealeaf" 
local NUT_PREFAB = "kyno_twiggynuts"
local RANDOM_CHANCE = .50
local VEC_CHANCE = .33

local function RemoveChild(inst)
    if inst.components.spawner and inst.components.spawner.child then
        local child = inst.components.spawner.child

        if child.components.knownlocations then
            child.components.knownlocations:ForgetLocation("home")
        end

        child:RemoveComponent("homeseeker")
    end
end

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

	--[[
	if inst.components.spawner and inst.components.spawner:IsOccupied() then
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/piko/in_tree")
    end
	]]--

    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("green_leaves_chop").Transform:SetPosition(x, y + math.random(), z)
	
	-- Chance to get some leaves/nuts when chopping.
	if math.random() < TUNING.KYNO_MEADOWISLAND_TREE_DROP_CHANCE then
		local item_to_drop = math.random() < RANDOM_CHANCE and LEAF_PREFAB or NUT_PREFAB
	
		local item = SpawnPrefab(item_to_drop)
		if math.random() < VEC_CHANCE then 
			LaunchAt(item, inst, chopper, .5, 4, 1.3, 5)
		else
			LaunchAt(item, inst, nil, .5, 4, 1.1, 5)
		end
		
		item.components.inventoryitem:SetLanded(true)
	end
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

	inst.components.inventory:DropEverything(false, false)

    if inst.components.spawner and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end

    RemoveChild(inst)

	inst.persists = false
	inst:DoTaskInTime(14 * FRAMES, ChopTreeShake)
	
	local stump = SpawnPrefab("kyno_meadowisland_tree_stump")
	stump.Transform:SetPosition(inst.Transform:GetWorldPosition())
	stump.AnimState:PlayAnimation("stump_tall")
	stump.level = "tall"

	inst:ListenForEvent("animover", inst.Remove)
end

local function DigUp(inst, chopper)
    inst.components.lootdropper:SpawnLootPrefab("driftwood_log")
    inst:Remove()
end

local function OnIgnite(inst)
	if inst.components.spawner then
        local child = inst.components.spawner.child

        if child then
            child.components.knownlocations:ForgetLocation("home")
        end

        if inst.components.spawner:IsOccupied() then
            inst.components.spawner:ReleaseChild()
        end
    end
end

local function OnBurnt(inst)
	RemoveChild(inst)
	
	if inst.components.spawner then
		inst:RemoveComponent("spawner")
	end

    local burnt = SpawnPrefab("kyno_meadowisland_tree_burnt")
	burnt.Transform:SetPosition(inst.Transform:GetWorldPosition())
    burnt.AnimState:PlayAnimation("burnt_tall")
	burnt.level = "tall"
	
    inst:Remove()
end

local function BurnInventoryItems(inst)
    if inst.components.inventory then
        local burnableItems = inst.components.inventory:GetItems(function(k, v) return v.components.burnable end)
        for index, burnableItem in ipairs(burnableItems) do
            burnableItem.components.burnable:Ignite(true)
        end
    end
end

local function GetChild(inst)
	if not TUNING.KYNO_PIKO_ENABLED then
		return "kyno_piko_orange"
	end
    
	if TUNING.KYNO_PIKO_ORANGE_ENABLED then
		if math.random() < TUNING.KYNO_PIKO_ORANGE_CHANCE then
			return "kyno_piko_orange"
		end
	end

	return "kyno_piko"
end

local function StartSpawning(inst)
    if inst.components.spawner then
        inst.components.spawner:SpawnWithDelay(2 + math.random(20))
    end
end

local function StopSpawning(inst)
    if inst.components.spawner then
        inst.components.spawner:CancelSpawning()
    end
end

local function OnSpawned(inst, child)
    child.sg:GoToState("descendtree")
end

local function TestSpawning(inst)
    if TheWorld.state.isday or TheWorld.state.iscaveday then
        StartSpawning(inst)
    else
        StopSpawning(inst)
    end
end

local function OnOcuppied(inst, child)
    if child.components.inventory:NumItems() > 0 then
        for i, item in ipairs(child.components.inventory:GetItems(function() return true end)) do
            child.components.inventory:DropItem(item)
            inst.components.inventory:GiveItem(item)
        end
    end
end

local function GetStatus(inst, viewer)
	return (inst.components.burnable:IsBurning() and "BURNING")
	or "GENERIC"
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

local function OnPreLoad(inst, data)
    WorldSettings_Spawner_PreLoad(inst, data, TUNING.KYNO_PIKO_SPAWN_TIME)
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

	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("shelter")
	inst:AddTag("infested_tree")
	inst:AddTag("dumpchildrenonignite")
	inst:AddTag("meadowislandtree")

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    local color = 0.7
    inst.AnimState:SetMultColour(color, color, color, 1)

	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	-- Only make it a spawner if any pikos are enabled.
	if TUNING.KYNO_PIKO_ENABLED or TUNING.KYNO_PIKO_ORANGE_ENABLED then
		inst:AddComponent("spawner")
		WorldSettings_Spawner_SpawnDelay(inst, TUNING.KYNO_PIKO_SPAWN_TIME, true)
		inst.components.spawner:Configure(nil, TUNING.KYNO_PIKO_SPAWN_TIME)
		inst.components.spawner.childfn = GetChild
		inst.components.spawner:SetOnVacateFn(OnSpawned)
		inst.components.spawner:SetOnOccupiedFn(OnOcuppied)
		
		inst.OnPreLoad = OnPreLoad
	end

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(
	{
		"driftwood_log", 
		"driftwood_log",
		"driftwood_log",
		"kyno_twiggynuts", 
		"kyno_twiggynuts",
		"kyno_tealeaf",
		"kyno_tealeaf",
		"kyno_oaktree_pod",
		"kyno_oaktree_pod",
		"kyno_oaktree_pod",
	})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_MEADOWISLAND_TREE_WORKLEFT)
	inst.components.workable:SetOnWorkCallback(ChopTree)
    inst.components.workable:SetOnFinishCallback(ChopDownTree)
	
	-- inst:AddComponent("plantregrowth")
	-- inst.components.plantregrowth:SetRegrowthRate(TUNING.KYNO_MEADOWISLAND_TREE_REGROWTH_TIME)
	-- inst.components.plantregrowth:SetProduct("kyno_meadowisland_tree_sapling")
	-- inst.components.plantregrowth:SetSearchTag("meadowislandtree")

    MakeMediumBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
	MakeSmallPropagator(inst)
	
	MakeSnowCovered(inst)
	MakeWaxablePlant(inst)

	inst:WatchWorldState("isday", TestSpawning)
    TestSpawning(inst, TheWorld.state.isday)

	inst:WatchWorldState("iscaveday", TestSpawning)
    TestSpawning(inst, TheWorld.state.iscaveday)

	inst:WatchWorldState("isdusk", TestSpawning)
    TestSpawning(inst, TheWorld.state.isdusk)

	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_meadowisland_pikotree", fn, assets, prefabs)