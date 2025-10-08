local assets =
{	
	Asset("ANIM", "anim/kyno_deciduousforest_shop.zip"),

    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
	"collapse_big",
	"small_puff",
}

local function OnOcuppiedDoorTask(inst)
    inst.doortask = nil
end

local function OnOcuppied(inst, child)
	inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

	if inst.doortask ~= nil then
		inst.doortask:Cancel()
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

local function OnStartDayTask(inst, isday)
	if not TheWorld.state.isdusk then
		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStartDuskDoorTask)
	else
		inst.doortask = nil
	end
end

local function OnStartDay(inst)
	if inst.components.spawner:IsOccupied() then
		if inst.doortask ~= nil then
			inst.doortask:Cancel()
		end
		
		inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, OnStartDuskTask)
	end
end

local function SpawnCheckDay(inst, isdusk)
	inst.inittask = nil
	inst:WatchWorldState("isday", OnStartDusk)
	
	if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
		if TheWorld.state.isday then
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
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
	inst:AddTag("deciduousforestshop")
	inst:AddTag("antlion_sinkhole_blocker")
	
	if not TheNet:IsDedicated() then
        inst:AddComponent("pointofinterest")
        inst.components.pointofinterest:SetHeight(80)
    end
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	--[[
	inst:AddComponent("spawner")
	inst.components.spawner:Configure("kyno_deciduousforest_seller", 10)
	inst.components.spawner.onoccupied = OnOcuppied
	inst.components.spawner.onvacate = OnVacate
	inst.components.spawner:SetWaterSpawning(false, true)
	inst.components.spawner:CancelSpawning()
	]]--

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	-- inst:WatchWorldState("isday", OnIsDay)
	-- OnIsDay(inst, TheWorld.state.isday)
	
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

	inst:AddComponent("inspectable")
	
	return inst
end

return Prefab("kyno_deciduousforest_shop", fn, assets, prefabs),
Prefab("kyno_fruittree_placeholder", placeholderfn, assets, prefabs)