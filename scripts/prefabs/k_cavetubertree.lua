local assets =
{
	Asset("ANIM", "anim/kyno_tuber_tree.zip"),
	Asset("ANIM", "anim/kyno_tuber_tree_build.zip"),
	Asset("ANIM", "anim/kyno_tuber_tree_bloom_build.zip"),

	Asset("SOUND", "sound/forest.fsb"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"twigs",
	"charcoal",
	"pine_needles_chop",

	"kyno_cavetuber",
	"kyno_cavetuber_blooming",
}

local builds =
{
	normal =
	{
		file             = "kyno_tuber_tree_build",
		prefab_name      = "kyno_cavetubertree",
		tuberslots_short = { 5, 6 },
		tuberslots_tall  = { 8, 5, 7 },
	},

	blooming =
	{
		file             = "kyno_tuber_bloom_build",
		prefab_name      = "kyno_cavetubertree",
		tuberslots_short = { 5, 6 },
		tuberslots_tall  = { 8, 5, 7 },
	}
}

local function makeanims(stage)
	return
	{
		idle            = "idle_"..stage,
		sway1           = "sway1_loop_"..stage,
		sway2           = "sway2_loop_"..stage,
		chop            = "chop_"..stage,
		fallleft        = "fallleft_"..stage,
		fallright       = "fallright_"..stage,
		stump           = "stump_"..stage,
		burning         = "burning_loop_"..stage,
		burnt           = "burnt_"..stage,
		chop_burnt      = "chop_burnt_"..stage,
		idle_chop_burnt = "idle_chop_burnt_"..stage,
	}
end

local short_anims   = makeanims("short")
local tall_anims    = makeanims("tall")
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
}

local function OnGetBuild(inst)
	local build = builds[inst.build]

	if build == nil then
		return builds["normal"]
	end

	return build
end

local function OnUpdateArt(inst)
	if inst.tuberslots == nil then
		return
	end

	for i, slot in ipairs(inst.tuberslots) do
		inst.AnimState:Hide("tubers"..slot)
	end

	for i = 1, math.min(inst.tubers, #inst.tuberslots) do
		local slot = inst.tuberslots[i]

		if slot ~= nil then
			inst.AnimState:Show("tubers"..slot)
		end
	end
end

local function OnUpdateBuild(inst)
	inst.AnimState:SetBuild(OnGetBuild(inst).file)
	OnUpdateArt(inst)
end

local function OnDoBloom(inst)
	inst.build = "blooming"
	OnUpdateBuild(inst)

	if inst.components.named ~= nil then
		inst.components.named:SetName(STRINGS.NAMES.KYNO_CAVETUBERTREE_BLOOMING)
	end
end

local function OnDoUnbloom(inst)
	inst.build = "normal"
	OnUpdateBuild(inst)

	if inst.components.named ~= nil then
		inst.components.named:SetName(STRINGS.NAMES.KYNO_CAVETUBERTREE)
	end
end

local function OnSeasonChange(inst, season)
	return TheWorld.state.season
end

local function OnUpdateBloom(inst, season)
	local season = OnSeasonChange(inst)

	if inst:HasTag("burnt") or inst:HasTag("stump") then
		return
	end

	if season == "spring" then
		OnDoBloom(inst)
	else
		OnDoUnbloom(inst)
	end
end

local function OnDropTuber(inst)
	local product = inst.build == "blooming" and "kyno_cavetuber_blooming" or "kyno_cavetuber"

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SpawnLootPrefab(product)
	end
end

local function OnDigUp(inst, worker)
	local product = inst.build == "blooming" and "kyno_cavetuber_blooming" or "kyno_cavetuber"

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SpawnLootPrefab(product)
	end

	inst:Remove()
end

local function OnPushSway(inst)
	if math.random() > .5 then
		inst.AnimState:PushAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PushAnimation(inst.anims.sway2, true)
	end
end

local function OnSway(inst)
	if math.random() > .5 then
		inst.AnimState:PlayAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PlayAnimation(inst.anims.sway2, true)
	end

	inst.AnimState:SetTime(math.random() * 2)
end

local function OnSetShort(inst)
	inst.anims = short_anims
	inst.maxtubers = 2
	inst.tuberslots = OnGetBuild(inst).tuberslots_short

	inst.currentchops = 0
	inst.nexttuberchop = inst.chopspertuber

	if inst.components.workable ~= nil then
		inst.components.workable:SetWorkLeft(TUNING.KYNO_CAVETUBERTREE_SHORT_WORKLEFT)
	end

	OnSway(inst)
end

local function OnGrowShort(inst)
	-- inst.AnimState:PlayAnimation("grow_tall_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")

	inst.tubers = math.min(inst.tubers, inst.maxtubers)

	OnUpdateArt(inst)
	OnPushSway(inst)
end

local function OnSetTall(inst)
	inst.maxtubers = 3
	inst.anims = tall_anims
	inst.tuberslots = OnGetBuild(inst).tuberslots_tall

	inst.currentchops = 0
	inst.nexttuberchop = inst.chopspertuber

	if inst.components.workable ~= nil then
		inst.components.workable:SetWorkLeft(TUNING.KYNO_CAVETUBERTREE_TALL_WORKLEFT)
	end

	OnSway(inst)
end

local function OnGrowTall(inst)
	-- inst.AnimState:PlayAnimation("grow_short_to_tall")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")

	inst.tubers = math.min(inst.tubers + 1, inst.maxtubers)

	OnUpdateArt(inst)
	OnPushSway(inst)
end

local GROWTH_STAGES =
{
	{
		name = "short", time = function(inst) return
			GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base,
			TUNING.EVERGREEN_GROW_TIME[1].random)
		end,

		fn = function(inst)
			OnSetShort(inst)
		end,

		growfn = function(inst)
			OnGrowShort(inst)
		end,

		leifscale = .7
	},
	{
		name = "tall", time = function(inst) return
			GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base,
			TUNING.EVERGREEN_GROW_TIME[3].random)
		end,

		fn = function(inst)
			OnSetTall(inst)
		end,

		growfn = function(inst)
			OnGrowTall(inst)
		end,

		leifscale = 1.25
	},
}

local function OnRegen(inst)
	local tree = SpawnPrefab("kyno_cavetubertree_short")
	local fx = SpawnPrefab("small_puff")

	tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

	inst:Remove()
end

local function OnSetStump(inst, push_anim)
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	inst:RemoveComponent("growable")
	inst:RemoveComponent("workable")

	RemovePhysicsColliders(inst)

	if push_anim then
		inst.AnimState:PushAnimation(inst.anims.stump)
	else
		inst.AnimState:PlayAnimation(inst.anims.stump)
	end

	inst.MiniMapEntity:SetIcon("kyno_cavetubertree_stump.tex")

	inst:AddTag("stump")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(OnDigUp)
	inst.components.workable:SetWorkLeft(1)

	inst:DoTaskInTime(TUNING.KYNO_CAVETUBERTREE_GROWTIME, OnRegen)
end

local function OnWork(inst, worker, workleft)
	if inst:HasTag("burnt") or inst:HasTag("stump") then
		return
	end

	inst.AnimState:PlayAnimation(inst.anims.chop)
	OnPushSway(inst)

	if not (worker ~= nil and worker:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound(worker ~= nil and worker:HasTag("beaver") and
		"dontstarve/characters/woodie/beaver_chop_tree" or "dontstarve/wilson/use_axe_tree")
	end

	if worker ~= nil then
		local tool = worker.components.inventory ~= nil and worker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
		local toughtool = tool ~= nil and tool.components.tool ~= nil and tool.components.tool:CanDoToughWork()

		if worker:HasTag("toughworker") or toughtool then
			inst.currentchops = inst.currentchops + 1

			if inst.currentchops >= inst.nexttuberchop and inst.tubers > 0 then
				inst.tubers = inst.tubers - 1
				inst.nexttuberchop = inst.nexttuberchop + inst.chopspertuber

				OnDropTuber(inst)
				OnUpdateArt(inst)
			end
		end
	end
end

local function OnWorked(inst, worker)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

	local he_right = math.random() > 0.5
	local pt = Vector3(inst.Transform:GetWorldPosition())

	if worker then
		local hispos = Vector3(worker.Transform:GetWorldPosition())
		he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
	end

	if he_right then
		inst.AnimState:PlayAnimation(inst.anims.fallleft)
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation(inst.anims.fallright)
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end

	OnSetStump(inst, true)
end

local function OnChopBurntTree(inst, worker)
	inst:RemoveComponent("workable")

	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")

	inst.AnimState:PlayAnimation(inst.anims.chop_burnt)

	RemovePhysicsColliders(inst)

	inst.persists = false

	inst:ListenForEvent("animover", inst.Remove)
	inst:ListenForEvent("entitysleep", inst.Remove)

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SpawnLootPrefab("charcoal")
		inst.components.lootdropper:DropLoot()
	end

	if inst.pineconetask then
		inst.pineconetask:Cancel()
		inst.pineconetask = nil
	end
end

local burnt_highlight_override = { .5, .5, .5 }
local function OnBurnt(inst, imm)
	local function changes()
		if inst.components.burnable then
			inst.components.burnable:Extinguish()
		end

		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
		inst:RemoveComponent("growable")

		inst:RemoveTag("fire")

		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:SetLoot({})
		end

		if inst.components.workable ~= nil then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnWorkCallback(nil)
			inst.components.workable:SetOnFinishCallback(OnChopBurntTree)
			inst.components.workable:SetRequiresToughWork(false)
		end
	end

	if imm then
		changes()
	else
		inst:DoTaskInTime(0.5, changes)
	end

	inst.MiniMapEntity:SetIcon("kyno_cavetubertree_burnt.tex")

	inst.AnimState:PlayAnimation(inst.anims.burnt, true)

	inst:AddTag("burnt")

	inst.highlight_override = burnt_highlight_override
end

local function OnTreeBurnt(inst)
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

local function OnIgnite(inst)
	DefaultIgniteFn(inst)
end

local function GetStatus(inst, viewer)
	return (inst:HasTag("stump") and "CHOPPED")
	or (inst:HasTag("burnt") and "BURNT")
	or (inst.components.burnable:IsBurning() and "BURNING")
	or "GENERIC"
end

local function OnEntitySleep(inst)
	local fire = inst:HasTag("fire")

	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")

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
				inst.components.burnable:SetOnBurntFn(OnTreeBurnt)
			end
		end

		if not inst.components.propagator then
			if inst:HasTag("stump") then
				MakeSmallPropagator(inst)
			else
				MakeLargePropagator(inst)
				inst.components.burnable:SetOnIgniteFn(OnIgnite)
			end
		end
	elseif not inst:HasTag("burnt") and inst:HasTag("fire") then
		OnBurnt(inst, true)
	end
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end

	if inst:HasTag("stump") then
		data.stump = true
	end

	if inst.build ~= "normal" then
		data.build = inst.build
	end

	if inst.currentchops ~= nil then
		data.currentchops = inst.currentchops
	end

	if inst.nexttuberchop ~= nil then
		data.nexttuberchop = inst.nexttuberchop
	end

	if inst.tubers ~= nil then
		data.tubers = inst.tubers
	end
end

local function OnLoad(inst, data)
	if data then
		if not data.build or builds[data.build] == nil then
			OnDoUnbloom(inst)
		else
			inst.build = data.build
		end

		if inst.components.growable ~= nil then
			local stage = inst.components.growable:GetStage()

			if stage == 1 then
				OnSetShort(inst)
			elseif stage == 2 then
				OnSetTall(inst)
			end
		end

		inst.currentchops = data.currentchops or 0
		inst.nexttuberchop = data.nexttuberchop or inst.chopspertuber

		inst.tubers = math.min(data.tubers or inst.maxtubers, inst.maxtubers)
		OnUpdateArt(inst)

		if data.burnt then
			OnBurnt(inst, true)
		elseif data.stump then
			OnSetStump(inst)
		end
	end
end

local function makefn(build, stage, data)
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
		minimap:SetIcon("kyno_cavetubertree.tex")

		MakeObstaclePhysics(inst, .25)

		inst.build = build
		inst.AnimState:SetBank("kyno_tubertree")
		inst.AnimState:SetBuild(OnGetBuild(inst).file)

		inst:AddTag("plant")
		inst:AddTag("tree")
		inst:AddTag("cavetubertree")
		inst:AddTag("_named")

		MakeSnowCoveredPristine(inst)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:RemoveTag("_named")

		inst.tubers = 0

		inst:AddComponent("named")
		inst:AddComponent("lootdropper")

		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = GetStatus

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetOnWorkCallback(OnWork)
		inst.components.workable:SetOnFinishCallback(OnWorked)
		inst.components.workable:SetRequiresToughWork(true)
    	inst.components.workable.savestate = true

		inst:AddComponent("growable")
		inst.components.growable.stages = GROWTH_STAGES
		inst.components.growable:SetStage(l_stage)
		inst.components.growable.loopstages = true
		inst.components.growable.springgrowth = true
		inst.components.growable:StartGrowing()

		-- PushSway(inst)
		inst.AnimState:SetTime(math.random() * 2)

		inst:SetPrefabName(OnGetBuild(inst).prefab_name)

		if data == "burnt" then
			OnBurnt(inst)
		end

		if data == "stump" then
			OnSetStump(inst)
		end

		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake

		inst.tubers = inst.maxtubers
		
		inst.chopspertuber = 3
		inst.currentchops = 0
		inst.nexttuberchop = 3

		OnUpdateArt(inst)

		inst:WatchWorldState("season", OnUpdateBloom)
		OnUpdateBloom(inst, TheWorld.state.season)

		inst.OnSave = OnSave
		inst.OnLoad = OnLoad

		MakeSnowCovered(inst)

		MakeLargeBurnable(inst)
		inst.components.burnable:SetFXLevel(3)
		inst.components.burnable:SetOnBurntFn(OnTreeBurnt)

		MakeLargePropagator(inst)
		inst.components.burnable:SetOnIgniteFn(OnIgnite)

		return inst
	end

	return fn
end

local function tree(name, build, stage, data)
	return Prefab(name, makefn(build, stage, data), assets, prefabs)
end

return tree("kyno_cavetubertree", "normal", 0),
tree("kyno_cavetubertree_tall",   "normal", 2),
tree("kyno_cavetubertree_short",  "normal", 1),
tree("kyno_cavetubertree_burnt",  "normal", 0, "burnt"),
tree("kyno_cavetubertree_stump",  "normal", 0, "stump")