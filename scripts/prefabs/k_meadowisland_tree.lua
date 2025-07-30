local assets =
{
	Asset("ANIM", "anim/tree_leaf_short.zip"),
    Asset("ANIM", "anim/tree_leaf_normal.zip"),
    Asset("ANIM", "anim/tree_leaf_tall.zip"),
    Asset("ANIM", "anim/teatree_trunk_build.zip"),
    Asset("ANIM", "anim/teatree_build.zip"),
	
	Asset("SOUND", "sound/forest.fsb"),

	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"green_leaves_chop",
	"driftwood_log",
	"ash",
	"charcoal",

	"kyno_oaktree_pod",
	"kyno_twiggynuts",
	"kyno_tealeaf",
	"kyno_piko",
	"kyno_piko_orange",
}

local builds =
{
	normal = 
	{
		file        = "teatree_build",
		prefab_name = "kyno_meadowisland_tree",
		normal_loot = {"driftwood_log", "driftwood_log", "kyno_tealeaf", "kyno_oaktree_pod"},
		short_loot  = {"driftwood_log", "kyno_tealeaf"},
		tall_loot   = {"driftwood_log", "driftwood_log", "driftwood_log", "kyno_tealeaf", "kyno_tealeaf", 
		"kyno_twiggynuts", "kyno_twiggynuts", "kyno_oaktree_pod", "kyno_oaktree_pod"},
	}
}

local function makeanims(stage)
	return 
	{
		idle            = "idle_"..stage,
		sway1           = "sway1_loop_"..stage,
		sway2           = "sway2_loop_"..stage,
		swayaggropre    = "sway_agro_pre",
        swayaggro       = "sway_loop_agro",
        swayaggropst    = "sway_agro_pst",
        swayaggroloop   = "idle_loop_agro",
		swayfx          = "swayfx_"..stage,
		chop            = "chop_"..stage,
		fallleft        = "fallleft_"..stage,
		fallright       = "fallright_"..stage,
		stump           = "stump_"..stage,
		burning         = "burning_loop_"..stage,
		burnt           = "burnt_"..stage,
		chop_burnt      = "chop_burnt_"..stage,
		idle_chop_burnt = "idle_chop_burnt_"..stage,
		dropleaves      = "drop_leaves_"..stage,
        growleaves      = "grow_leaves_"..stage,
		blown1          = "blown_loop_"..stage.."1",
		blown2          = "blown_loop_"..stage.."2",
		blown_pre       = "blown_pre_"..stage,
		blown_pst       = "blown_pst_"..stage
	}
end

local short_anims   = makeanims("short")
local tall_anims    = makeanims("tall")
local normal_anims  = makeanims("normal")
local old_anims     =
{
	idle            = "idle_old",
	sway1           = "idle_old",
	sway2           = "idle_old",
	chop            = "chop_old",
	fallleft        = "chop_old",
	fallright       = "chop_old",
	stump           = "stump_old",
	burning         = "idle_olds",
	burnt           = "burnt_tall",
	chop_burnt      = "chop_burnt_tall",
	idle_chop_burnt = "idle_chop_burnt_tall",
	blown           = "blown_loop",
	blown_pre       = "blown_pre",
	blown_pst       = "blown_pst"
}

local LEAF_PREFAB   = "kyno_tealeaf" 
local NUT_PREFAB    = "kyno_twiggynuts"
local RANDOM_CHANCE = .50
local VEC_CHANCE    = .33

local function dig_up_stump(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("driftwood_log")
end

local function chop_down_burnt_tree(inst, chopper)
	inst:RemoveComponent("workable")
	
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	
	inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
	
	RemovePhysicsColliders(inst)
	
	inst:ListenForEvent("animover", function() 
		inst:Remove() 
	end)
	
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:DropLoot()
	
	if inst.pineconetask then
		inst.pineconetask:Cancel()
		inst.pineconetask = nil
	end
end

local function GetBuild(inst)
	local build = builds[inst.build]
	
	if build == nil then
		return builds["normal"]
	end
	
	return build
end

local burnt_highlight_override = {.5,.5,.5}
local function OnBurnt(inst, imm)
	local function changes()
		if inst.components.burnable then
			inst.components.burnable:Extinguish()
		end
		
		inst.MiniMapEntity:SetIcon("kyno_meadowisland_tree_burnt.tex")
		
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
		inst:RemoveComponent("growable")

		inst:RemoveTag("shelter")
		inst:RemoveTag("fire")

		inst.components.lootdropper:SetLoot({})

		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnWorkCallback(nil)
			inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
		end
	end

	if imm then
		changes()
	else
		inst:DoTaskInTime( 0.5, changes)
	end
	
	inst.AnimState:PlayAnimation(inst.anims.burnt, true)
	inst:AddTag("burnt")

	inst.highlight_override = burnt_highlight_override
end

local function PushSway(inst)
	if math.random() > .5 then
		inst.AnimState:PushAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PushAnimation(inst.anims.sway2, true)
	end
end

local function Sway(inst)
	if math.random() > .5 then
		inst.AnimState:PlayAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PlayAnimation(inst.anims.sway2, true)
	end
	inst.AnimState:SetTime(math.random() * 2)
end

local function SetShort(inst, level)
	inst.anims = short_anims
	inst.level = "short"

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.KYNO_MEADOWISLAND_TREE_SHORT_WORKLEFT)
	end

	inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
	Sway(inst)
end

local function GrowShort(inst)
	inst.AnimState:PlayAnimation("grow_tall_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
	PushSway(inst)
end

local function SetNormal(inst, level)
	inst.anims = normal_anims
	inst.level = "normal"

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.KYNO_MEADOWISLAND_TREE_NORMAL_WORKLEFT)
	end

	inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
	Sway(inst)
end

local function GrowNormal(inst)
	inst.AnimState:PlayAnimation("grow_short_to_normal")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function SetTall(inst, level)
	inst.anims = tall_anims
	inst.level = "tall"
	
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.KYNO_MEADOWISLAND_TREE_TALL_WORKLEFT)
	end

	inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
	Sway(inst)
end

local function GrowTall(inst)
	inst.AnimState:PlayAnimation("grow_normal_to_tall")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function inspect_tree(inst)
	if inst:HasTag("burnt") then
		return "BURNT"
	elseif inst:HasTag("stump") then
		return "CHOPPED"
	end
end

local growth_stages =
{
	{
		name = "short", time = function(inst) return 
			GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base, 
			TUNING.EVERGREEN_GROW_TIME[1].random) 
		end,
		
		fn = function(inst) 
			SetShort(inst) 
		end,
		
		growfn = function(inst) 
			GrowShort(inst) 
		end,
		
		leifscale = .7 
	},
	{
		name = "normal", time = function(inst) return 
			GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base, 
			TUNING.EVERGREEN_GROW_TIME[2].random) 
		end, 
		
		fn = function(inst) 
			SetNormal(inst) 
		end, 
		
		growfn = function(inst) 
			GrowNormal(inst) 
		end, 
		
		leifscale = 1 
	},
	{
		name = "tall", time = function(inst) return 
			GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base, 
			TUNING.EVERGREEN_GROW_TIME[3].random) 
		end, 
		
		fn = function(inst) 
			SetTall(inst) 
		end, 
		
		growfn = function(inst) 
			GrowTall(inst) 
		end, 
		
		leifscale = 1.25
	},
}

local function chop_tree(inst, chopper, chops, level)
	if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(chopper ~= nil and chopper:HasTag("beaver") and
		"dontstarve/characters/woodie/beaver_chop_tree" or "dontstarve/wilson/use_axe_tree")
    end

	inst.AnimState:PlayAnimation(inst.anims.chop)
	inst.AnimState:PushAnimation(inst.anims.sway1, true)
	
	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("green_leaves_chop").Transform:SetPosition(x, y + math.random(), z)
	
	if inst.level == "tall" then
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
end

local function ChopTreeShake(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .25, .03, .5, inst, 6)
end

local function chop_down_tree(inst, chopper)
	inst:RemoveComponent("burnable")
	MakeSmallBurnable(inst)
	
	inst:RemoveComponent("propagator")
	MakeSmallPropagator(inst)
	
	inst:RemoveComponent("workable")
	
	inst:RemoveTag("shelter")
	
	inst.MiniMapEntity:SetIcon("kyno_meadowisland_tree_stump.tex")
	
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(chopper.Transform:GetWorldPosition())
	local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

	if he_right then
		inst.AnimState:PlayAnimation(inst.anims.fallleft)
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation(inst.anims.fallright)
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end

	RemovePhysicsColliders(inst)
	
	inst.AnimState:PushAnimation(inst.anims.stump)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_stump)
	inst.components.workable:SetWorkLeft(1)

	inst:AddTag("stump")
	
	if inst.components.growable then
		inst.components.growable:StopGrowing()
	end
	
	inst:DoTaskInTime(14 * FRAMES, ChopTreeShake)
end

local function tree_burnt(inst)
	OnBurnt(inst)
	
	inst.pineconetask = inst:DoTaskInTime(10, function()
		local pt = Vector3(inst.Transform:GetWorldPosition())
		
		if math.random(0, 1) == 1 then
			pt = pt + TheCamera:GetRightVec()
		else
			pt = pt - TheCamera:GetRightVec()
		end
		
		inst.components.lootdropper:DropLoot(pt)
		inst.pineconetask = nil
	end)
end

local function handler_growfromseed(inst)
	inst.components.growable:SetStage(1)
	
	inst.AnimState:PlayAnimation("grow_seed_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function TestItem(inst, item, giver, level)
	if item.components.inventoryitem and item:HasTag("squirrel") and inst.level == "tall" then
		return true -- Infest the tree.
	else
		giver.components.talker:Say(GetString(giver, "ANNOUNCE_PIKOTREE_TOOSMALL"))
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

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end

	if inst:HasTag("stump") then
		data.stump = true
	end

	if inst.build ~= "normal" then
		data.build = inst.build
	end
	
	if inst.level then
		data.level = inst.level
	end
end

local function onload(inst, data)
	if data then
		if not data.build or builds[data.build] == nil then
			inst.build = "normal"
		else
			inst.build = data.build
		end
		
		if data.level then
			inst.level = data.level
		end

		if data.burnt then
			inst:AddTag("fire")
			inst.MiniMapEntity:SetIcon("kyno_meadowisland_tree_burnt.tex")
			
			inst.build = data.build
			inst.level = data.level
			
		elseif data.stump then
			inst.MiniMapEntity:SetIcon("kyno_meadowisland_tree_stump.tex")
		
			inst:RemoveComponent("burnable")
			MakeSmallBurnable(inst)
			
			inst:RemoveComponent("propagator")
			MakeSmallPropagator(inst)
			
			inst:RemoveComponent("workable")
			inst:RemoveComponent("growable")
			
			RemovePhysicsColliders(inst)
			
			inst.AnimState:PlayAnimation(inst.anims.stump)
			
			inst:AddTag("stump")
			inst:RemoveTag("shelter")
			
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(dig_up_stump)
			inst.components.workable:SetWorkLeft(1)
			
			inst.build = data.build
			inst.level = data.level
		end
	end
end

local function OnEntitySleep(inst)
	local fire = false
	
	if inst:HasTag("fire") then
		fire = true
	end
	
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("inspectable")
	
	if fire then
		inst:AddTag("fire")
	end
end

local function OnEntityWake(inst)
	if not inst:HasTag("burnt") and not inst:HasTag("fire") then
		if not inst.components.burnable then
			if inst:HasTag("stump") then
				MakeSmallBurnable(inst)
			else
				MakeLargeBurnable(inst)
				inst.components.burnable:SetFXLevel(5)
				inst.components.burnable:SetOnBurntFn(tree_burnt)
			end
		end

		if not inst.components.propagator then
			if inst:HasTag("stump") then
				MakeSmallPropagator(inst)
			else
				MakeLargePropagator(inst)
			end
		end
	elseif not inst:HasTag("burnt") and inst:HasTag("fire") then
		OnBurnt(inst, true)
	end

	if not inst.components.inspectable then
		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = inspect_tree
	end
end

local function makefn(build, stage, data, level)
	local function fn()
		local l_stage = stage
		
		if l_stage == 0 then
			l_stage = math.random(1, 3)
		end

		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("kyno_meadowisland_tree.tex")
		minimap:SetPriority(5)
		
		MakeObstaclePhysics(inst, .4)

		inst:AddTag("plant")
		inst:AddTag("tree")
		inst:AddTag("shelter")
		inst:AddTag("infestable_tree")
		inst:AddTag("cookware_other_installable")
		
		inst:SetPrefabNameOverride("kyno_meadowisland_tree")
		
		MakeSnowCoveredPristine(inst)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
            return inst
        end

		inst.build = build
		inst.AnimState:SetBank("tree_leaf")
		inst.AnimState:SetBuild(GetBuild(inst).file)
		inst.AnimState:AddOverrideBuild("teatree_trunk_build")
		
		inst.level = level
		
		inst:AddComponent("lootdropper")

		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = inspect_tree
		
		inst:AddComponent("cookwareinstaller")
		inst.components.cookwareinstaller:SetAcceptTest(TestItem)
		inst.components.cookwareinstaller.onaccept = OnGetItemFromPlayer

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetOnWorkCallback(chop_tree)
		inst.components.workable:SetOnFinishCallback(chop_down_tree)

		inst:AddComponent("growable")
		inst.components.growable.stages = growth_stages
		inst.components.growable:SetStage(l_stage)
		inst.components.growable.springgrowth = true
		inst.components.growable.loopstages = false
		inst.components.growable:StartGrowing()

		inst.growfromseed = handler_growfromseed

		-- PushSway(inst)
		inst.AnimState:SetTime(math.random() * 2)

		inst.OnSave = onsave
		inst.OnLoad = onload

		inst:SetPrefabName(GetBuild(inst).prefab_name)

		if data == "burnt" then
			OnBurnt(inst)
			
			inst.MiniMapEntity:SetIcon("kyno_meadowisland_tree_burnt.tex")
		end

		if data == "stump" then
			inst.MiniMapEntity:SetIcon("kyno_meadowisland_tree_stump.tex")
			
			inst:RemoveComponent("burnable")
			MakeSmallBurnable(inst)
			
			inst:RemoveComponent("propagator")
			MakeSmallPropagator(inst)
			
			inst:RemoveComponent("workable")
			inst:RemoveComponent("growable")
	
			RemovePhysicsColliders(inst)
			
			inst.AnimState:PlayAnimation(inst.anims.stump)
			
			inst:AddTag("stump")
			
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(dig_up_stump)
			inst.components.workable:SetWorkLeft(1)
		end

		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake
		
		MakeLargeBurnable(inst)
		inst.components.burnable:SetFXLevel(5)
		inst.components.burnable:SetOnBurntFn(tree_burnt)
		MakeLargePropagator(inst)
		
		MakeSnowCovered(inst)
		MakeWaxablePlant(inst)

		return inst
	end
	
	return fn
end

local function tree(name, build, stage, data, level)
	return Prefab(name, makefn(build, stage, data, level), assets, prefabs)
end

return tree("kyno_meadowisland_tree", "normal", 0),
tree("kyno_meadowisland_tree_short",  "normal", 1, nil, "short"),
tree("kyno_meadowisland_tree_normal", "normal", 2, nil, "normal"),
tree("kyno_meadowisland_tree_tall",   "normal", 3, nil, "tall"),
tree("kyno_meadowisland_tree_burnt",  "normal", 0, "burnt"),
tree("kyno_meadowisland_tree_stump",  "normal", 0, "stump")