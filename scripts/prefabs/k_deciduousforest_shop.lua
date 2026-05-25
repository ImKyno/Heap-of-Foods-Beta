local assets =
{
	Asset("ANIM", "anim/kyno_deciduousforest_shop.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),

	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
	"small_puff",
	"kyno_deciduousforest_seller",
}

local function AllNightTest(inst)
	if inst.segs and inst.segs["night"] + inst.segs["dusk"] >= 16 then
		return true
	end

	return false
end

local function RefreshHouseState(inst)
	local occupied = inst.components.spawner ~= nil and inst.components.spawner:IsOccupied()

	if not inst.HouseRepaired then
		inst.Light:Enable(false)
		inst.AnimState:PlayAnimation("rundown", true)
		return
	end

	if occupied then
		inst.Light:Enable(true)
		inst.AnimState:PushAnimation("idle_lit", true)
	else
		inst.Light:Enable(false)
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function OnOcuppiedDoorTask(inst)
	inst.doortask = nil
end

local function OnOcuppied(inst, child)
	RefreshHouseState(inst)

	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

	if inst.doortask ~= nil then
		inst.doortask:Cancel()
	end

	-- Get another hat when at home.
	if child ~= nil then
		if child.SetHatless then
			child:SetHatless(false)
		end
	end

	inst.doortask = inst:DoTaskInTime(1, OnOcuppiedDoorTask)
end

local function OnVacate(inst, child)
	RefreshHouseState(inst)

	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

	if inst.doortask ~= nil then
		inst.doortask:Cancel()
		inst.doortask = nil
	end

	if child ~= nil then
		local child_platform = child:GetCurrentPlatform()

		if (child_platform == nil and not child:IsOnValidGround()) then
			local fx = SpawnPrefab("splash_sink")
			fx.Transform:SetPosition(child.Transform:GetWorldPosition())

			child:Remove()
		else
			if child.components.health ~= nil then
				child.components.health:SetPercent(1)
			end

			child:PushEvent("onvacatehome")
		end
	end
end

local function OnStartDayDoorTask(inst)
	inst.doortask = nil

	if inst.components.spawner ~= nil then
		inst.components.spawner:ReleaseChild()
	end
end

local function OnStartDayTask(inst, isday)
	if TheWorld.state.isday or AllNightTest(inst) then
		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStartDayDoorTask)
	else
		inst.doortask = nil
	end
end

local function OnStartDay(inst)
	if inst.components.spawner:IsOccupied() then
		if inst.doortask ~= nil then
			inst.doortask:Cancel()
		end

		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStartDayTask)
	end
end

local function SpawnCheckDay(inst, isday)
	inst.inittask = nil
	inst:WatchWorldState("isday", OnStartDay)

	if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
		if TheWorld.state.isday or AllNightTest(inst) then
			inst.components.spawner:ReleaseChild()
		else
			OnOcuppiedDoorTask(inst)
		end
	end
end

local function OnInit(inst)
	inst.inittask = inst:DoTaskInTime(math.random(), SpawnCheckDay)

	if inst.components.spawner ~= nil and inst.components.spawner.child == nil and inst.components.spawner.childname ~= nil and
	not inst.components.spawner:IsSpawnPending() then
		local child = SpawnPrefab(inst.components.spawner.childname)

		if child ~= nil then
			inst.components.spawner:TakeOwnership(child)
			inst.components.spawner:GoHome(child)
		end
	end
end

local function OnConstructed(inst, doer)
	local concluded = true

	for _, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
		if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
			concluded = false
			break
		end
	end

	if concluded then
		inst:SetRepaired(true)
		inst:PushEvent("onbuilt")
		
		-- For the Stategraph.
		if doer ~= nil and not doer:HasTag("playermerm") then
			local child = inst.components.spawner ~= nil and inst.components.spawner.child or nil

			if child ~= nil then
				child.sg:GoToState("appreciate")
			end
		end
	end
end

local function SetupConstructionSite(inst)
	if inst.components.constructionsite == nil then
		inst:AddComponent("constructionsite")
		inst.components.constructionsite:SetConstructionPrefab("construction_container")
		inst.components.constructionsite:SetOnConstructedFn(OnConstructed)
	end
end

local function SetHouseRepaired(inst, repaired)
	inst.HouseRepaired = repaired

	if repaired then
		inst:RemoveTag("constructionsite")

		if inst.components.constructionsite then
			inst:RemoveComponent("constructionsite")
		end

		if inst.components.named ~= nil then
			inst.components.named:SetName(STRINGS.NAMES.KYNO_DECIDUOUSFOREST_SHOP_REPAIRED)
		end
	else
		SetupConstructionSite(inst)
	end

	RefreshHouseState(inst)
end

local function OnBuilt(inst, isday)
	inst.AnimState:PlayAnimation("place")
	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

	inst:DoTaskInTime(0, function()
		RefreshHouseState(inst)
	end)
end

local function GetStatus(inst, viewer)
	return ((inst.components.spawner:IsOccupied() and inst.HouseRepaired) and "OCCUPIED_REPAIRED")
	or ((inst.components.spawner:IsOccupied() and not inst.HouseRepaired) and "OCCUPIED")
	or (inst.HouseRepaired and "REPAIRED")
	or "GENERIC"
end

local function OnSave(inst, data)
	data.repaired = inst.HouseRepaired
end

local function OnLoad(inst, data)
	if data ~= nil then
		inst:SetRepaired(data.repaired == true)
	else
		inst:SetRepaired(false)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()

	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetRadius(2.8)
	inst.Light:Enable(false)
	inst.Light:SetColour(180/255, 195/255, 50/255)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pighouse.png")
	minimap:SetPriority(2)

	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_deciduousforest_shop")
	inst.AnimState:SetBuild("kyno_deciduousforest_shop")
	inst.AnimState:PlayAnimation("rundown", true)

	inst:AddTag("structure")
	inst:AddTag("partitiohouse")
	inst:AddTag("deciduousforestshop")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("_named")

	if not TheNet:IsDedicated() then
		inst:AddComponent("pointofinterest")
		inst.components.pointofinterest:SetHeight(80)
	end

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:RemoveTag("_named")

	inst.HouseRepaired = false
	inst.SetRepaired = SetHouseRepaired

	inst:AddComponent("named")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("spawner")
	inst.components.spawner:Configure("kyno_deciduousforest_seller", 10)
	inst.components.spawner.onoccupied = OnOcuppied
	inst.components.spawner.onvacate = OnVacate
	inst.components.spawner:SetWaterSpawning(false, true)
	inst.components.spawner:CancelSpawning()

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)

	inst:WatchWorldState("isday", function()
		RefreshHouseState(inst)
	end)

	SetupConstructionSite(inst)
	RefreshHouseState(inst)

	inst:ListenForEvent("onbuilt", OnBuilt) -- For when repaired.

	inst:ListenForEvent("clocksegschanged", function(world, data)
		inst.segs = data
	end, TheWorld)

	inst.inittask = inst:DoTaskInTime(0, OnInit)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	MakeSnowCovered(inst)
	SetLunarHailBuildupAmountSmall(inst)

	return inst
end

local function placeholderfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("placeholder")
	inst:AddTag("fruittree")
	inst:AddTag("antlion_sinkhole_blocker")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	return inst
end

return Prefab("kyno_deciduousforest_shop", fn, assets, prefabs),
Prefab("kyno_fruittree_placeholder", placeholderfn, assets, prefabs)