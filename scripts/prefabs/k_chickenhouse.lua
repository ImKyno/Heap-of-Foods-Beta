require("prefabutil")
require("worldsettingsutil")

local assets =
{
	Asset("ANIM", "anim/kyno_chickenhouse.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"kyno_chicken_coop",
	"kyno_chicken_egg",
	"kyno_chicken_egg_large",
	"collapse_small",
}

local EGG_STAGES =
{
	[1] = { "egg", "egg2"  },
	[2] = { "egg3", "egg4" },
	[3] = { "egg5", "egg6" },
}

local function TurnChickenWild(chicken)
	if chicken ~= nil and chicken:IsValid() and chicken:HasTag("chicken_coop") then
		local x, y, z = chicken.Transform:GetWorldPosition()

		chicken:DoTaskInTime(5 + math.random(), function()
			local wild = SpawnPrefab("kyno_chicken2")
			wild.Transform:SetPosition(x, y, z)

			local fx = SpawnPrefab("small_puff")
			fx.Transform:SetPosition(x, y, z)

			chicken:Remove()
		end)
	end
end

local function OnRemoveChickens(inst)
	if inst.components.childspawner ~= nil then
		for child in pairs(inst.components.childspawner.childrenoutside) do
			TurnChickenWild(child)
		end

		inst.components.childspawner.childrenoutside = {}
		inst.components.childspawner.numchildrenoutside = 0
		
		local inside = inst.components.childspawner.childreninside or 0

		for i = 1, inside do
			local x, y, z = inst.Transform:GetWorldPosition()

			local wild = SpawnPrefab("kyno_chicken2")
			wild.Transform:SetPosition(x, y, z)
		end
	end
end

local function OnHammered(inst, worker)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	
	if inst.components.harvestable ~= nil then
		inst.components.harvestable:Harvest()
	end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end
	
	if inst.components.childspawner ~= nil then
		for child in pairs(inst.components.childspawner.childrenoutside) do
			TurnChickenWild(child)
		end

		inst.components.childspawner.childrenoutside = {}
		inst.components.childspawner.numchildrenoutside = 0
		
		local inside = inst.components.childspawner.childreninside or 0

		for i = 1, inside do
			local x, y, z = inst.Transform:GetWorldPosition()

			local wild = SpawnPrefab("kyno_chicken2")
			wild.Transform:SetPosition(x, y, z)
		end
	end
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function CanStartGrowing(inst)
	return not inst:HasTag("burnt")
	and inst.components.harvestable 
	and not TheWorld.state.iswinter
	and (inst.components.childspawner and inst.components.childspawner:NumChildren() > 0)
end

local function StopSpawning(inst)
	if inst.components.harvestable ~= nil and inst.components.harvestable.growtime ~= nil then
		inst.components.harvestable:PauseGrowing()
	end
	
	if inst.components.childspawner ~= nil then
		inst.components.childspawner:StopSpawning()
	end
end

local function StartSpawning(inst)
	if CanStartGrowing(inst) and inst.components.harvestable.growtime then
		inst.components.harvestable:StartGrowing()
	end
	
	if inst.components.childspawner ~= nil then
		inst.components.childspawner:StartSpawning()
	end
end

local function OnIsCaveDay(inst, isday)
	if not isday then
		StopSpawning(inst)
	elseif not (TheWorld.state.iswinter or inst:HasTag("burnt")) and inst:IsInLight() then
		StartSpawning(inst)
	end
end

local function OnEnterLight(inst)
	if not (TheWorld.state.iswinter or inst:HasTag("burnt")) and TheWorld.state.iscaveday then
		StartSpawning(inst)
	end
end

local function OnEnterDark(inst)
	StopSpawning(inst)
end

local function OnRefreshEggs(inst)
	if inst:HasTag("burnt") then
		return
	end

	local h = inst.components.harvestable
	local count = h ~= nil and h.produce or 0

	if not inst.AnimState:IsCurrentAnimation("idle") then
		inst.AnimState:PlayAnimation("idle", true)
	end

	for _, stage in pairs(EGG_STAGES) do
		for _, symbol in ipairs(stage) do
			inst.AnimState:HideSymbol(symbol)
		end
	end

	for i = 1, math.min(count, #EGG_STAGES) do
		for _, symbol in ipairs(EGG_STAGES[i]) do
			inst.AnimState:ShowSymbol(symbol)
		end
	end
end

local function OnHarvest(inst, picker, produce)
	if not inst:HasTag("burnt") then
		local pos = inst:GetPosition()
		local data = inst._egg_result or { small = 0, giant = 0 }
		
		if (data.small or 0) <= 0 and (data.giant or 0) <= 0 then
			return
		end

		inst._egg_result = { small = 0, giant = 0 }

		-- Helper function from hof_util.lua
		SpawnLootForPicker("kyno_chicken_egg", data.small, picker, pos, inst)
		SpawnLootForPicker("kyno_chicken_egg_large", data.giant, picker, pos, inst)
		
		if inst.components.harvestable ~= nil then
			inst.components.harvestable:SetGrowTime(nil)
			inst.components.harvestable.pausetime = nil
			inst.components.harvestable:StopGrowing()
		end
		
		OnRefreshEggs(inst)
	end
end

local function OnChildSpawn(inst, child)
	if not (TheWorld.state.iswinter or inst:HasTag("burnt")) then
		child.sg:GoToState("honk")
	end
	
	if inst._chicken_data ~= nil and #inst._chicken_data > 0 then
		local data = table.remove(inst._chicken_data, 1)

		if data.name ~= nil and child.components.named ~= nil then
			child.components.named:SetName(data.name)
		end

		if data.build ~= nil then
			child._color_build = data.build
			child.AnimState:AddOverrideBuild(data.build)
		end
		
		if data.icon ~= nil and child.components.inventoryitem ~= nil then
			child._icon_name = data.icon
			child.components.inventoryitem:ChangeImageName(data.icon)
		end
	end
end

local function OnChildGoingHome(inst, data)
	if inst:HasTag("burnt") or data.child == nil then
		return
	end

	local chicken = data.child
	
	inst._chicken_data = inst._chicken_data or {}
	
	table.insert(inst._chicken_data,
	{
		name = chicken.components.named ~= nil and chicken.components.named.name or nil,
		build = chicken._color_build,
		icon = chicken._icon_name,
	})

	if inst.components.harvestable ~= nil and chicken._has_eaten_today then
		inst.components.harvestable:Grow() -- Chickens needs to eat something first in order to produce eggs.
		
		inst._egg_result = inst._egg_result or { small = 0, giant = 0 }

		if math.random() < TUNING.KYNO_CHICKENHOUSE_GIANT_EGG_CHANCE then
			inst._egg_result.giant = inst._egg_result.giant + 1
		else
			inst._egg_result.small = inst._egg_result.small + 1
		end
		
		inst.AnimState:PlayAnimation("pick")
		inst.SoundEmitter:PlaySound("summerevent/cannon/fire3")
	end
	
	-- Destroy anything left inside their inventory for clean up.
	if chicken ~= nil and chicken.components.inventory ~= nil then
		chicken.components.inventory:DestroyContents()
	end

	chicken._has_eaten_today = false
	chicken._has_food_buffered = false
end

local function TryStartSleepGrowing(inst)
	if CanStartGrowing(inst) then
		inst.components.harvestable:SetGrowTime(TUNING.KYNO_CHICKENHOUSE_GROWTIME)
		inst.components.harvestable:StartGrowing()
	elseif inst.components.harvestable ~= nil then
		inst.components.harvestable:PauseGrowing()
	end
end

local function StopSleepGrowing(inst)
	if not inst:HasTag("burnt") and inst.components.harvestable ~= nil then
		inst.components.harvestable:SetGrowTime(nil)
		inst.components.harvestable:PauseGrowing()
	end
end

local function OnIgnite(inst)
	if inst.components.childspawner ~= nil then
		inst.components.childspawner:ReleaseAllChildren()
		inst.components.childspawner:StopSpawning()
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)

	inst.SoundEmitter:PlaySound("dontstarve/common/rabbit_hutch_craft")
end

local function OnEntityWake(inst)
	StopSleepGrowing(inst)
end

local function OnEntitySleep(inst)
	TryStartSleepGrowing(inst)
end

local function AsleepGrowth(inst)
	if inst:IsAsleep() then
		TryStartSleepGrowing(inst)
	end
end

local function GetStatus(inst, viewer)
	return (inst:HasTag("burnt") and "BURNT")
	or (inst.components.burnable:IsBurning() and "BURNT")
	or (inst.components.harvestable:CanBeHarvested() and "FULL")
	or "GENERIC"
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
	
	if inst._chicken_data then
		data.chicken_data = inst._chicken_data
	end
	
	if inst._egg_result then
		data.egg_result = inst._egg_result
	end
end

local function OnLoad(inst, data)
	if data ~= nil then
		if data.chicken_data then
			inst._chicken_data = data.chicken_data
		end
		
		if data.egg_result then
			inst._egg_result = data.egg_result
		end
	
		if data.burnt then
			inst.components.burnable.onburnt(inst)
		else
			OnRefreshEggs(inst)
		end
	end
end

local function OnPreLoad(inst, data)
	WorldSettings_ChildSpawner_PreLoad(inst, data, TUNING.KYNO_CHICKENHOUSE_RELEASE_TIME, TUNING.KYNO_CHICKENHOUSE_REGEN_TIME)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_chickenhouse.tex")

	inst:SetDeploySmartRadius(1.25)
	MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(1.2, 1.2, 1.2)

	inst.AnimState:SetBank("kyno_chickenhouse")
	inst.AnimState:SetBuild("kyno_chickenhouse")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")
	inst:AddTag("chickenhouse")

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._chicken_data = nil	
	inst._egg_result =
	{
		small = 0,
		giant = 0,
	}
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("harvestable")
	inst.components.harvestable:SetUp(nil, 3, nil, OnHarvest, OnRefreshEggs)

	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "kyno_chicken_coop"
	inst.components.childspawner.allowwater = true
	inst.components.childspawner:SetSpawnedFn(OnChildSpawn)
	inst.components.childspawner:SetSpawnPeriod(TUNING.KYNO_CHICKENHOUSE_RELEASE_TIME)
	inst.components.childspawner:SetRegenPeriod(TUNING.KYNO_CHICKENHOUSE_REGEN_TIME)
	inst.components.childspawner:SetMaxChildren(TUNING.KYNO_CHICKENHOUSE_AMOUNT)
	
	WorldSettings_ChildSpawner_SpawnPeriod(inst, TUNING.KYNO_CHICKENHOUSE_RELEASE_TIME, TUNING.KYNO_CHICKEN_ENABLED)
	WorldSettings_ChildSpawner_RegenPeriod(inst, TUNING.KYNO_CHICKENHOUSE_REGEN_TIME, TUNING.KYNO_CHICKEN_ENABLED)
	if not TUNING.KYNO_CHICKEN_ENABLED then
		inst.components.childspawner.childreninside = 0
	end

	if TheWorld.state.isday and not TheWorld.state.iswinter then
		inst.components.childspawner:StartSpawning()
	end

	OnRefreshEggs(inst)

	inst:WatchWorldState("iswinter", AsleepGrowth)
	inst:WatchWorldState("iscaveday", OnIsCaveDay)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("onignite", OnIgnite)
	inst:ListenForEvent("enterlight", OnEnterLight)
	inst:ListenForEvent("enterdark", OnEnterDark)
	inst:ListenForEvent("childgoinghome", OnChildGoingHome)
	inst:ListenForEvent("onburnt", OnRemoveChickens)
	inst:ListenForEvent("ondeconstructstructure", OnRemoveChickens)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnPreLoad = OnPreLoad
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	MakeHauntableWork(inst)
	MakeSnowCovered(inst)
	
	SetLunarHailBuildupAmountSmall(inst)

	return inst
end

return Prefab("kyno_chickenhouse", fn, assets, prefabs),
MakePlacer("kyno_chickenhouse_placer", "kyno_chickenhouse", "kyno_chickenhouse", "idle", false, nil, nil, 1.2)