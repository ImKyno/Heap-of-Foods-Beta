local assets =
{
	Asset("ANIM", "anim/hotspring_hermitcrab.zip"),
	
	Asset("ANIM", "anim/kyno_meadowisland_pond.zip"),
	Asset("ANIM", "anim/kyno_meadowisland_planty.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_meadowisland_planty",
	
	"kyno_tropicalfish",
	"kyno_pierrotfish",
	"kyno_neonfish",
	"kyno_grouper",
	"kyno_koi",
}

local function SpawnPlants(inst, plantname, count, maxradius)
	if inst.decor then
		for i, item in ipairs(inst.decor) do
			item:Remove()
		end
	end
	
	inst.decor = {}
	local plant_offsets = {}

	for i = 1, math.random(math.ceil(count / 2), count) do
		local a = math.random() * math.pi * 2
		local x = math.sin(a) * maxradius + math.random() * 0.3
		local z = math.cos(a) * maxradius + math.random() * 0.3
		table.insert(plant_offsets, {x, 0, z})
	end

	for k, offset in pairs(plant_offsets) do
		local plant = SpawnPrefab(plantname)
		plant.entity:SetParent(inst.entity)
		plant.Transform:SetPosition(offset[1], offset[2], offset[3])
		table.insert(inst.decor, plant)
	end
end

local sizes =
{
	{anim = "small_idle", rad = 2.0, plantcount = 2, plantrad = 1.6},
	{anim = "med_idle",   rad = 2.6, plantcount = 3, plantrad = 2.5},
	{anim = "big_idle",   rad = 3.6, plantcount = 4, plantrad = 3.4},
}

local function SetSize(inst, size)
	inst.size = size or math.random(1, #sizes)
	inst.AnimState:PlayAnimation(sizes[inst.size].anim, true)
	inst.Physics:SetCylinder(sizes[inst.size].rad, 1.0)
	SpawnPlants(inst, "kyno_meadowisland_planty", sizes[inst.size].plantcount, sizes[inst.size].plantrad)
end

local function GetFish(inst, isfullmoon)
    return (TheWorld.state.isautumn and "kyno_tropicalfish") or (TheWorld.state.iswinter and "kyno_neonfish") 
	or (TheWorld.state.isspring and "kyno_pierrotfish") or (TheWorld.state.issummer and "kyno_koi")
end

local function EnableBubbles(inst, enable)
	if enable then
		if inst.bubbles_task ~= nil then
			return
		end
		
		local function DoBubbles()
			local x, y, z = inst.Transform:GetWorldPosition()
			local radius = 1
			local count = 1
		
			for i = 1, count do
				local delay = (i - 1) * math.random(0.3, 0.5)
			
				inst:DoTaskInTime(delay, function()
					local theta = math.random() * 2 * PI
					local dist = radius * math.sqrt(math.random())
					local fx_x = x + math.cos(theta) * dist
					local fx_z = z + math.sin(theta) * dist

					local fx = SpawnPrefab("crab_king_bubble1")
				
					if fx ~= nil then
						fx.Transform:SetPosition(fx_x, 0, fx_z)
					end
				end)
			end
		end
		
		inst.bubbles_task = inst:DoPeriodicTask(math.random(4, 8), function()
			DoBubbles()
		
			if inst.bubbles_task ~= nil then
				local next_time = math.random(5, 9)
			
				inst.bubbles_task:Cancel()
				inst.bubbles_task = inst:DoPeriodicTask(next_time, DoBubbles)
			end
		end)
	elseif inst.bubbles_task ~= nil then
		inst.bubbles_task:Cancel()
		inst.bubbles_task = nil
	end
end

local function OnBathingPoolTick_PerOccupant(inst, occupant, dt)
	if occupant.components.health ~= nil then
		occupant.components.health:DoDelta(TUNING.KYNO_MEADOWISLAND_POND_HEALTH_PER_SECOND * dt, true, inst.prefab, true)
	end
	
	if occupant.components.sanity ~= nil then
		local rate = TUNING.KYNO_MEADOWISLAND_POND_SANITY_PER_SECOND
		
		if TheWorld.Map:IsInLunacyArea(occupant.Transform:GetWorldPosition()) then
			rate = -rate
		end
		
		occupant.components.sanity.externalmodifiers:SetModifier(inst, rate)
	end
end

local function OnBathingPoolTick(inst)
	local bathingpool = inst.components.bathingpool
	
	if bathingpool ~= nil then
		bathingpool:ForEachOccupant(OnBathingPoolTick_PerOccupant, TUNING.KYNO_MEADOWISLAND_POND_TICK_PERIOD)
	end
end

local function OnStartBeingOccupiedBy(inst, ent)
	if not inst.bathingpoolents then
		inst.bathingpoolents = 
		{
			[ent] = true,
		}
		
		inst.bathingpooltask = inst:DoPeriodicTask(TUNING.KYNO_MEADOWISLAND_POND_TICK_PERIOD, OnBathingPoolTick)
	else
		inst.bathingpoolents[ent] = true
	end
	
	if ent.components.sanity then
		local rate = TUNING.KYNO_MEADOWISLAND_POND_SANITY_PER_SECOND
		
		if TheWorld.Map:IsInLunacyArea(ent.Transform:GetWorldPosition()) then
			rate = -rate
		end
		
		ent.components.sanity.externalmodifiers:SetModifier(inst, rate)
	end
end

local function OnStopBeingOccupiedBy(inst, ent)
	if inst.bathingpoolents then
		inst.bathingpoolents[ent] = nil
		
		if ent.components.sanity then
			ent.components.sanity.externalmodifiers:RemoveModifier(inst)
		end
		
		if next(inst.bathingpoolents) == nil then
			if inst.bathingpooltask then
				inst.bathingpooltask:Cancel()
				inst.bathingpooltask = nil
			end
			
			inst.bathingpoolents = nil
		end
	end
end

local function EnableBathingPool(inst, enable)
	if not enable then
		inst:RemoveComponent("bathingpool")
	elseif inst.components.bathingpool == nil then
		inst:AddComponent("bathingpool")
		inst.components.bathingpool:SetRadius(sizes[inst.size].rad)
		inst.components.bathingpool:SetOnStartBeingOccupiedBy(OnStartBeingOccupiedBy)
		inst.components.bathingpool:SetOnStopBeingOccupiedBy(OnStopBeingOccupiedBy)
	end
end

local function ForceJumpOut(inst, ent)
	inst.components.bathingpool:LeavePool(ent)
end

local function RefreshPond(inst)
	inst.components.timer:StopTimer("bathbombed")
	
	if inst.components.bathingpool ~= nil then
		inst.components.bathingpool:ForEachOccupant(ForceJumpOut)
	end
		
	inst:DoTaskInTime(1, function()
		EnableBubbles(inst, false)
		EnableBathingPool(inst, false)
		
		inst.components.fishable:Unfreeze()
		inst.components.bathbombable:Reset()
	end)
end

local function OnTimerDone(inst, data)
	if data and data.name == "bathbombed" then
		RefreshPond(inst)
	end
end

local function OnBathBombed(inst)
	EnableBubbles(inst, true)
	EnableBathingPool(inst, true)

	if not inst.components.timer:TimerExists("bathbombed") then
		inst.components.timer:StartTimer("bathbombed", TUNING.KYNO_MEADOWISLAND_POND_BATHBOMB_DURATION)
	end

	if not (POPULATING or inst:IsAsleep()) then
		inst.SoundEmitter:PlaySound("turnoftides/common/together/water/hotspring/small_splash")
		inst.SoundEmitter:PlaySound("turnoftides/common/together/water/hotspring/bathbomb")
	end
	
	inst.components.fishable:Freeze()
end

local function GetHeat(inst)
	if not inst.components.watersource.available then
		inst.components.heater:SetThermics(false, false)
		return 0
	end
	
	inst.components.heater:SetThermics(true, false)
	return inst.components.bathbombable.is_bathbombed and TUNING.HOTSPRING_HEAT.ACTIVE or TUNING.HOTSPRING_HEAT.PASSIVE
end

local function GetStatus(inst, viewer)
	return inst.components.bathbombable.is_bathbombed and "BOMBED" or nil
end

local function OnSave(inst, data)
	data.size = inst.size
	data.isbathbombed = inst.components.bathbombable.is_bathbombed and inst.components.timer:TimerExists("bathbombed") or nil
end

local function OnLoad(inst, data, newents)
	if data and data.size then
		SetSize(inst, data.size)
	end
	
	if data and data.isbathbombed then
		inst.components.bathbombable:OnBathBombed()
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_meadowisland_pond.tex")
	
    MakeObstaclePhysics(inst, 3.5)

    inst.AnimState:SetBuild("kyno_meadowisland_pond")
    inst.AnimState:SetBank("kyno_meadowisland_pond")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddTag("fishable")
	inst:AddTag("watersource")
	inst:AddTag("blocker")
	inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("tidalpool")
	inst:AddTag("HASHEATER")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("timer")
    inst:AddComponent("inspectable")
	inst:AddComponent("savedrotation")
	inst:AddComponent("watersource")
	
	inst:AddComponent("heater")
	inst.components.heater.heatfn = GetHeat
	
	inst:AddComponent("bathbombable")
	inst.components.bathbombable:SetOnBathBombedFn(OnBathBombed)

	inst:AddComponent("fishable")
	inst.components.fishable.maxfish = TUNING.KYNO_MEADOWISLAND_POND_MAX_FISH
	inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
	inst.components.fishable:SetGetFishFn(GetFish)
	
	inst:ListenForEvent("timerdone", OnTimerDone)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	SetSize(inst)

	return inst
end

local function plantfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_meadowisland_planty")
	inst.AnimState:SetBuild("kyno_meadowisland_planty")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)
	
	return inst
end

return Prefab("kyno_meadowisland_pond", fn, assets, prefabs),
Prefab("kyno_meadowisland_planty", plantfn, assets, prefabs)