require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/lobster_den.zip"),
	Asset("ANIM", "anim/lobster_den_build.zip"),
}

local prefabs =
{
    "rock_break_fx",
    "rocks",
    "wobster_sheller",
	"moonglass_wobster_den",
}

local spawner_prefabs =
{
    "kyno_wobster_den_monkeyisland",
}

SetSharedLootTable("kyno_wobster_den_monkeyisland",
{
	{"rocks",                1.00},
	{"rocks",                1.00},
	{"rocks",                1.00},
	{"rocks",                0.50},
	{"wobster_monkeyisland", 1.00},
	{"wobster_monkeyisland", 1.00},
	{"wobster_monkeyisland", 0.50},
})

local FIRST_WORK_LEVEL = math.ceil(2 * TUNING.WOBSTER_DEN_WORK / 3)
local SECOND_WORK_LEVEL = math.ceil(TUNING.WOBSTER_DEN_WORK / 3)

local function GetIdleAnim(inst, num_children)
	local workleft = inst.components.workable.workleft
	
	if workleft > FIRST_WORK_LEVEL then
		if num_children > 0 then
			return "eyes_loop"
		else
			return "full"
		end
	elseif workleft > SECOND_WORK_LEVEL then
		return "med"
	else
		return "low"
	end
end

local function UpdateArt(inst)
	local anim = GetIdleAnim(inst, inst.components.childspawner.childreninside)
	inst.AnimState:PlayAnimation(anim, true)
end

local function TryBlink(inst)
	if inst.components.workable.workleft > FIRST_WORK_LEVEL and inst.components.childspawner.childreninside > 0 then
		inst.AnimState:PlayAnimation("blink")
		inst.AnimState:PushAnimation("eyes_loop", true)
	elseif inst._blink_task ~= nil then
		inst._blink_task:Cancel()
		inst._blink_task = nil
	end
end

local function OnOccupied(inst)
	if inst.components.workable.workleft > FIRST_WORK_LEVEL and inst._blink_task == nil then
		inst._blink_task = inst:DoPeriodicTask(5, TryBlink, math.random() * 3)
		
		inst.AnimState:PlayAnimation("eyes_pre")
		inst.AnimState:PushAnimation("eyes_loop", true)
	end
end

local function OnVacated(inst)
	if inst.components.workable.workleft > FIRST_WORK_LEVEL then
		if inst._blink_task ~= nil then
			inst._blink_task:Cancel()
			inst._blink_task = nil
		end

		inst.AnimState:PlayAnimation("eyes_post")
		inst.AnimState:PushAnimation(GetIdleAnim(inst, 0), true)
	end
end

local function StopSpawning(inst)
	if inst.components.childspawner.spawning then
		inst.components.childspawner:StopSpawning()
	end
end

local function OnDayEnded(inst)
	if inst._spawning_update_task ~= nil then
		inst._spawning_update_task:Cancel()
	end
	
	inst._spawning_update_task = inst:DoTaskInTime(1 + math.random() * 2, StopSpawning)
end

local function StartSpawning(inst)
	if not inst.components.childspawner.spawning then
		inst.components.childspawner:StartSpawning()
	end
end

local function OnDayStarted(inst)
	if inst._spawning_update_task ~= nil then
		inst._spawning_update_task:Cancel()
	end
	
	inst._spawning_update_task = inst:DoTaskInTime(1 + math.random() * 2, StartSpawning)
end

local function Initialize(inst)
	UpdateArt(inst)

	if inst.components.childspawner.childreninside > 0 then
		inst._blink_task = inst:DoPeriodicTask(5, TryBlink, math.random() * 3)
	end

    if TheWorld.state.isdusk or TheWorld.state.isnight then
		inst.components.childspawner:StopSpawning()
	end

	inst:WatchWorldState("isday", OnDayStarted)
	inst:WatchWorldState("isdusk", OnDayEnded)
	inst:WatchWorldState("isnight", OnDayEnded)
end

local function OnWork(inst, worker, workleft)
	if workleft <= 0 then
		local pt = inst:GetPosition()

		inst.components.lootdropper:DropLoot(pt)

		if inst.components.childspawner ~= nil then
			inst.components.childspawner:ReleaseAllChildren()
		end

		inst:Remove()
		
		SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
	else
		UpdateArt(inst)
	end
end

local DAMAGE_SCALE = 0.5

local function OnCollide(inst, data)
	local boat_physics = data.other.components.boatphysics
    
	if boat_physics ~= nil then
		local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
		inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
	end

	if inst.components.childspawner ~= nil then
		inst.components.childspawner:ReleaseAllChildren()
	end
end

local function OnPreLoad(inst, data)
	WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.KYNO_WOBSTER_MONKEYISLAND_SPAWN_TIME, TUNING.KYNO_WOBSTER_MONKEYISLAND_REGEN_TIME)
end

local function basefn(build, loot_table_name, child_name)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("wobster_den.png")

	inst:SetPhysicsRadiusOverride(2.35)
    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)
	
	MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.9, 1.1})
	inst.components.floater:SetIsObstacle()
	inst.components.floater.bob_percent = 0

	inst.AnimState:SetBank("lobster_den")
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation("full")
	
    inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("event_trigger")
	
	inst:SetPrefabNameOverride("WOBSTER_DEN")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	local land_time = (POPULATING and math.random() * 5 * FRAMES) or 0
	
	inst:DoTaskInTime(land_time, function(inst)
		inst.components.floater:OnLandedServer()
	end)
	
	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable(loot_table_name)
	inst.components.lootdropper.max_speed = 2
	inst.components.lootdropper.min_speed = 0.3
	inst.components.lootdropper.y_speed = 14
	inst.components.lootdropper.y_speed_variance = 4
	inst.components.lootdropper.spawn_loot_inside_prefab = true

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.WOBSTER_DEN_WORK)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable.savestate = true

	inst:AddComponent("childspawner")
	inst.components.childspawner:SetSpawnPeriod(TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_SPAWN_TIME)
	inst.components.childspawner:SetRegenPeriod(TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_AMOUNT)

	WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_SPAWN_TIME, TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_ENABLED)
	WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_REGEN_TIME, TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_ENABLED)
	if not TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_ENABLED then
		inst.components.childspawner.childreninside = 0
	end

	inst.components.childspawner:StartRegen()
	inst.components.childspawner.spawnradius = TUNING.KYNO_WOBSTER_MONKEYISLAND_DEN_RADIUS
	inst.components.childspawner.childname = child_name
	inst.components.childspawner.wateronly = true
	inst.components.childspawner:SetOccupiedFn(OnOccupied)
	inst.components.childspawner:SetVacateFn(OnVacated)
	inst.components.childspawner:StartSpawning()

	inst:ListenForEvent("on_collide", OnCollide)

	inst:DoTaskInTime(0, Initialize)

	inst.OnPreLoad = OnPreLoad

	return inst
end

local function MoonConversionOverride(inst)
	inst.prefab = "moonglass_wobster_den"
	inst.AnimState:SetBuild("lobster_den_moonglass_build")
	inst.components.lootdropper:SetChanceLootTable("moonglass_wobster_den")
	inst.components.childspawner.childname = "wobster_moonglass"

	inst:RemoveComponent("halloweenmoonmutable")

	return inst, nil
end

local function fn()
	local inst = basefn("lobster_den_build", "kyno_wobster_den_monkeyisland", "wobster_monkeyisland")

	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetConversionOverrideFn(MoonConversionOverride)

	return inst
end

return Prefab("kyno_wobster_den_monkeyisland", fn, assets, prefabs)