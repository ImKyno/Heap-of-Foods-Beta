require("worldsettingsutil")
require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_eldermandrakehouse.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"boards",
	"cutgrass",
	"mandrake",

	"collapse_small",
	"splash_sink",

	"kyno_eldermandrake",
}

local function OnHammered(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end

	if inst.doortask ~= nil then
		inst.doortask:Cancel()
		inst.doortask = nil
	end

	if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
		inst.components.spawner:ReleaseChild()
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")

	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle")
	end
end

local function OnOcuppied(inst, child)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
	end
end

local function OnVacate(inst, child)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle", true)
		inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

		if child then
			if child.components.health ~= nil then
				child.components.health:SetPercent(1)
			end

			child:PushEvent("onvacatehome")

			if child.components.drownable ~= nil then
				child.components.drownable:CheckDrownable()
			end
		end
	end
end

local function OnStopCaveDayDoorTask(inst)
	inst.doortask = nil

	if inst.components.spawner ~= nil then
		inst.components.spawner:ReleaseChild()
	end
end

local function OnStopCaveDay(inst)
	if not inst:HasTag("burnt") and inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
		if inst.doortask ~= nil then
			inst.doortask:Cancel()
		end

		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStopCaveDayDoorTask)
	end
end

local function OnAcidRainingChanged(inst, isacidraining)
	if not isacidraining and not TheWorld.state.iscaveday then
		OnStopCaveDay(inst)
	end
end

local function OnSpawnCheckCaveDay(inst)
	inst.inittask = nil

	inst:WatchWorldState("stopcaveday", OnStopCaveDay)
	inst:WatchWorldState("isacidraining", OnAcidRainingChanged)

	if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
		if not TheWorld.state.iscaveday or
			(inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
			inst.components.spawner:ReleaseChild()
		end
	end
end

local function OnInit(inst)
	inst.inittask = inst:DoTaskInTime(math.random(), OnSpawnCheckCaveDay)

	if inst.components.spawner ~= nil and inst.components.spawner.child == nil and 
	inst.components.spawner.childname ~= nil and not inst.components.spawner:IsSpawnPending() then
		local child = SpawnPrefab(inst.components.spawner.childname)

		if child ~= nil then
			inst.components.spawner:TakeOwnership(child)
			inst.components.spawner:GoHome(child)
		end
	end
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")

	inst.SoundEmitter:PlaySound("dontstarve/common/rabbit_hutch_craft")
end

local function GetStatus(inst, viewer)
	return (inst.components.spawner:IsOccupied() and "OCCUPIED")
	or "GENERIC"
end

local function OnPreLoad(inst, data)
	WorldSettings_Spawner_PreLoad(inst, data, TUNING.KYNO_ELDERMANDRAKE_SPAWN_TIME)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_eldermandrakehouse.tex")

	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_eldermandrakehouse")
	inst.AnimState:SetBuild("kyno_eldermandrakehouse")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")
	inst:AddTag("cavedweller")
	inst:AddTag("eldermandrakehouse")

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(TUNING.KYNO_ELDERMANDRAKEHOUSE_WORKLEFT)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetOnFinishCallback(OnHammered)

	if TUNING.KYNO_ELDERMANDRAKE_ENABLED then
		inst:AddComponent("spawner")
		WorldSettings_Spawner_SpawnDelay(inst, TUNING.KYNO_ELDERMANDRAKE_SPAWN_TIME, TUNING.KYNO_ELDERMANDRAKE_ENABLED)
		inst.components.spawner:Configure("kyno_eldermandrake", TUNING.KYNO_ELDERMANDRAKE_SPAWN_TIME)
		inst.components.spawner.onoccupied = OnOcuppied
		inst.components.spawner.onvacate = OnVacate
		inst.components.spawner:CancelSpawning()

		inst.OnPreLoad = OnPreLoad
	end

	inst.inittask = inst:DoTaskInTime(0, OnInit)

	inst:ListenForEvent("onbuilt", OnBuilt)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	MakeSnowCovered(inst)

	MakeHauntableWork(inst)
	SetLunarHailBuildupAmountLarge(inst)

	return inst
end

return Prefab("kyno_eldermandrakehouse", fn, assets, prefabs),
MakePlacer("kyno_eldermandrakehouse_placer", "kyno_eldermandrakehouse", "kyno_eldermandrakehouse", "idle")