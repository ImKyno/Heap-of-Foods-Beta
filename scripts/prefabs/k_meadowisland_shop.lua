local HOF_MAPUTIL = require("map/hof_maputil")

local assets =
{	
	Asset("ANIM", "anim/kyno_meadowisland_shop.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"small_puff",
	
	"kyno_meadowisland_mermcart",
	"kyno_meadowisland_seller",
	"kyno_smokecloud",
}

local function OnOcuppiedDoorTask(inst)
    inst.doortask = nil
end

local function OnOcuppied(inst, child)
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

local function OnStartDuskDoorTask(inst)
	inst.doortask = nil
	
	if inst.components.spawner ~= nil then
		inst.components.spawner:ReleaseChild()
	end
end

local function OnStartDuskTask(inst, isday)
	if not TheWorld.state.isday then
		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStartDuskDoorTask)
	else
		inst.doortask = nil
	end
end

local function OnStartDusk(inst)
	if inst.components.spawner:IsOccupied() then
		if inst.doortask ~= nil then
			inst.doortask:Cancel()
		end
		
		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStartDuskTask)
	end
end

local function SpawnCheckDusk(inst, isdusk)
	inst.inittask = nil
	inst:WatchWorldState("isdusk", OnStartDusk)
	
	if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
		if TheWorld.state.isdusk then
			inst.components.spawner:ReleaseChild()
		else
			OnOcuppiedDoorTask(inst)
		end
	end
end

local function OnInit(inst)
	inst.inittask = inst:DoTaskInTime(math.random(), SpawnCheckDusk)
	
	if inst.components.spawner ~= nil and inst.components.spawner.child == nil and inst.components.spawner.childname ~= nil and 
	not inst.components.spawner:IsSpawnPending() then
		local child = SpawnPrefab(inst.components.spawner.childname)
		
		if child ~= nil then
			inst.components.spawner:TakeOwnership(child)
			inst.components.spawner:GoHome(child)
		end
	end
end

local function OnSeasonChange(inst, season)
	return TheWorld.state.season
end

local function SetHouseArt(inst, season)
	local season = OnSeasonChange(inst)
	
	if TheWorld.state.isday then
		inst.AnimState:PlayAnimation("idle_"..season or "idle", true)
	else
		inst.AnimState:PlayAnimation("lit_"..season or "lit", true)
	end
end

local function SetChimneyFX(inst)
	if not inst.smokecloud then
		inst.smokecloud = SpawnPrefab("kyno_smokecloud")
		inst.smokecloud.entity:SetParent(inst.entity)

		inst.smokecloud.entity:AddFollower()
		inst.smokecloud.Follower:FollowSymbol(inst.GUID, "chimney", 0, 200, 0) -- Why positive makes it go down ???
	end
end

local function CancelChimneyTask(inst)
    if inst._chimneytask ~= nil then
        inst._chimneytask:Cancel()
        inst._chimneytask = nil
    end
end

local function StartChimneyTask(inst)
    if not inst.inlimbo and inst._chimneytask == nil then
        inst._chimneytask = inst:DoTaskInTime(GetRandomMinMax(10, 20), SetChimneyFX)
    end
end

local function OnIsDay(inst, isday)
	local season = OnSeasonChange(inst)
	
    if TheWorld.state.isday then
		inst.Light:Enable(false)
		inst.AnimState:PlayAnimation("idle_"..season or "idle", true)
    else
		inst.Light:Enable(true)
		inst.AnimState:PlayAnimation("lit_"..season or "lit", true)
	end
end

local function GetStatus(inst, viewer)
	return (inst.components.spawner:IsOccupied() and "OCCUPIED")
	or "GENERIC"
end

local function RetrofitMapTags(inst)
	local info = HOF_MAPUTIL.GetLayoutInfoFromPrefab(inst, 671, 736, 61, 61)

	if TUNING.HOF_DEBUG_MODE then
		print("Layout Origin:", info.origin.x, info.origin.z)
		print("Layout Center:", info.center.x, info.center.z)
		print("Prefab Origin:", info.prefab.x, info.prefab.z)
	end
	
	HOF_MAPUTIL.AddPrefabTopologyNode(inst, 671, 736, 61, 61, "StaticLayoutIsland:NewMeadowIsland", 
	{ "RoadPoison", "not_mainland", "nohunt", "MeadowArea" })
end

local function fn(oldshop)
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
	minimap:SetIcon("kyno_meadowisland_shop.tex")
	minimap:SetPriority(2)
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_meadowisland_shop")
    inst.AnimState:SetBuild("kyno_meadowisland_shop")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
    inst:AddTag("sammyhouse")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("meadow_marker")
	
	if not TheNet:IsDedicated() then
        inst:AddComponent("pointofinterest")
        inst.components.pointofinterest:SetHeight(80)
    end
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("spawner")
	inst.components.spawner:Configure("kyno_meadowisland_seller", 10) -- TUNING.TOTAL_DAY_TIME
	inst.components.spawner.onoccupied = OnOcuppied
	inst.components.spawner.onvacate = OnVacate
	inst.components.spawner:SetWaterSpawning(false, true)
	inst.components.spawner:CancelSpawning()

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	-- inst:DoTaskInTime(1, RetrofitMapTags)
	
	inst:WatchWorldState("season", SetHouseArt)
	SetHouseArt(inst, TheWorld.state.season)
	
	inst:WatchWorldState("isday", OnIsDay)
	OnIsDay(inst, TheWorld.state.isday)
	
	inst.OnEntitySleep = CancelChimneyTask
	inst.OnEntityWake = StartChimneyTask
	
	StartChimneyTask(inst)
	inst.inittask = inst:DoTaskInTime(0, OnInit)
	
	-- SetChimneyFX(inst) -- Only used for testing.
	
	return inst
end

return Prefab("kyno_meadowisland_shop", fn, assets, prefabs)