require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_fishfarmplot.zip"),
	Asset("ANIM", "anim/kyno_fishfarmplot_kit.zip"),
	Asset("ANIM", "anim/kyno_fishfarmplot_shoal.zip"),
	Asset("ANIM", "anim/kyno_fishfarmplot_scrapbook.zip"),
	Asset("ANIM", "anim/ui_fishfarmplot_3x4.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"boards",
	"rope",
	"marsh_plant",
	"splash_green_small",
	
	"kyno_fishfarmplot_shoal",
	"kyno_fishfarmplot_shoal_marker",
}

local function SpawnPlants(inst)
	inst.task = nil

	if inst.plant_ents ~= nil then
		return
	end

	inst.plant_ents = {}
	inst.plants = inst.plants or {}

	if #inst.plants == 0 then
		local radius_x = 3.5
		local radius_z = 3
		local total = math.random(3, 6)
		local sector = TWOPI / total
	
		for i = 1, total do
			local theta = i * sector + (math.random() * 0.2 - 0.1)
			local dist = radius_x + math.random() * 0.2

			local x = math.cos(theta) * radius_x
			local z = math.sin(theta) * radius_z
			local y = 0

			local plant_prefab = inst.planttype or "marsh_plant"
			local plant_rot = math.random() * 360

			table.insert(inst.plants, 
			{
				prefab = plant_prefab,
				pos = { x, y, z },
				rot = plant_rot,
			})

			local rock_variants = 
			{
				"kyno_fishfarmplot_rock1",
				"kyno_fishfarmplot_rock2",
				"kyno_fishfarmplot_rock3",
			}
			
			local offsets = { math.pi / 2, -math.pi / 2 }
			local offset_dist = 0.3 + math.random() * 0.2

			for _, off in ipairs(offsets) do
				local rock_prefab = rock_variants[math.random(#rock_variants)]
				local rx = x + math.cos(theta + off) * offset_dist
				local rz = z + math.sin(theta + off) * offset_dist
				local r_rot = math.random() * 360
				local shade = 0.7 + math.random() * 0.1

				table.insert(inst.plants, 
				{
					prefab = rock_prefab,
					pos = { rx, y, rz },
					rot = r_rot,
					shade = shade,
					scale = 0.9,
				})
			end
		end
	end

	for _, data in ipairs(inst.plants) do
		local deco = SpawnPrefab(data.prefab)
		
		if deco ~= nil then
			deco.entity:SetParent(inst.entity)
			deco.Transform:SetPosition(unpack(data.pos))
			deco.Transform:SetRotation(data.rot or 0)
			deco.persists = false

			if deco.AnimState and data.shade then
				deco.AnimState:SetMultColour(data.shade, data.shade, data.shade, 1)
				deco.AnimState:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)
			end

			table.insert(inst.plant_ents, deco)
		end
	end
end

local function DespawnPlants(inst)
	if inst.plant_ents ~= nil then
		for _, v in ipairs(inst.plant_ents) do
			if v:IsValid() then
				v:Remove()
			end
		end
		
		inst.plant_ents = nil
	end
	
	inst.plants = nil
end

local function DoFishFarmSplash(inst)
	local splash_variants =
	{
		"ocean_splash_med1",
		"ocean_splash_med2",
	}
				
	local splash_prefab = splash_variants[math.random(#splash_variants)]
	local splash = SpawnPrefab(splash_prefab)

	splash.Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function UpdateFishArt(inst)
	if inst.shoal ~= nil and inst.shoal:IsValid() then
		inst.shoal:Remove()
		inst.shoal = nil
	end
	
	if inst.shoal_marker ~= nil and inst.shoal_marker:IsValid() then
		inst.shoal_marker:Remove()
		inst.shoal_marker = nil
	end

	local container = inst.components.container
	
	if not container then
		return
	end

	local has_fish = false
	local valid_slots = {1, 2, 3, 4, 5, 6, 7, 8}

	for _, slot in ipairs(valid_slots) do
		local item = container:GetItemInSlot(slot)
		
		if item and item:HasTag("fishfarmable") then
			has_fish = true
			break
		end
	end

	local shoal = SpawnPrefab("kyno_fishfarmplot_shoal")
	local shoal_marker = SpawnPrefab("kyno_fishfarmplot_shoal_marker")
	
	if shoal and shoal_marker then
		shoal_marker.entity:SetParent(inst.entity)
		shoal.AnimState:SetMultColour(.7, .7, .7, 1)
		
		shoal.entity:SetParent(inst.entity)
		
		if shoal.Follower == nil then
			shoal.entity:AddFollower()
		end
	
		shoal.Follower:FollowSymbol(shoal_marker.GUID, "marker", 0, -180, 0)
		
		local visual_to_slot = 
		{
			[1] = 1,
			[3] = 3,
			[4] = 4,
			[5] = 5,
			[6] = 6,
			[7] = 7,
			[8] = 8,
		}
		
		local all_symbols =
		{
			"fish_body", 
			"fish_fin",
			"fish",
			"water_ripple",
		}
		
		for _, symbol in ipairs(all_symbols) do
			shoal.AnimState:HideSymbol(symbol)
		end
		
		for visual_index, slot in pairs(visual_to_slot) do
			local fish = container:GetItemInSlot(slot)
			
			if fish and fish:HasTag("fishfarmable") then
				if slot == 1 then
					shoal.AnimState:ShowSymbol("fish_body")
					shoal.AnimState:ShowSymbol("fish_fin")
					shoal.AnimState:ShowSymbol("water_ripple")
				else
					shoal.AnimState:ShowSymbol("fish")
				end
			end
		end
		
		shoal.persists = false
		shoal_marker.persists = false
		
		inst.shoal = shoal
		inst.shoal_marker = shoal_marker
	else
		shoal.Follower:StopFollowing()
	end
end

local function StartHungryTask(inst)
	if inst.hungry_task ~= nil then
		return
	end

	local function DoHungrySplash()
		if inst.components.fueled == nil or not inst.components.fueled:IsEmpty() then
			inst.hungry_task:Cancel()
			inst.hungry_task = nil
			return
		end

		local container = inst.components.container
		local fish = container ~= nil and container:GetItemInSlot(1) or nil
		
		if fish == nil or not fish:HasTag("fishfarmable") then
			return
		end

		local x, y, z = inst.Transform:GetWorldPosition()
		local radius = 2

        local count = math.random(2, 3)

		for i = 1, count do
			local delay = (i - 1) * math.random(0.3, 0.5)
			
			inst:DoTaskInTime(delay, function()
				local theta = math.random() * 2 * PI
				local dist = radius * math.sqrt(math.random())
				local fx_x = x + math.cos(theta) * dist
				local fx_z = z + math.sin(theta) * dist

				local fx = SpawnPrefab("splash_green_small")
				
				if fx ~= nil then
					fx.Transform:SetPosition(fx_x, 0, fx_z)
				end
			end)
		end
	end

    inst.hungry_task = inst:DoPeriodicTask(math.random(4, 8), function()
		DoHungrySplash()
		
		if inst.hungry_task ~= nil then
			local next_time = math.random(5, 9)
			
			inst.hungry_task:Cancel()
			inst.hungry_task = inst:DoPeriodicTask(next_time, DoHungrySplash)
		end
	end)
end

local function StopHungryTask(inst)
	if inst.hungry_task ~= nil then
		inst.hungry_task:Cancel()
		inst.hungry_task = nil
	end
end

local function OnStartWorking(inst)
	-- inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding")
end

local function OnStopWorking(inst)
	-- inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding")
end

local function OnWorking(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
end

-- Handled by the fishfarmmanager component.
local function OnAddFuel(inst)
	DoFishFarmSplash(inst)
	StopHungryTask(inst)
	
	inst.components.fishfarmmanager:OnAddFuel()
	inst.components.fishfarmmanager:StartWorking()
end

local function OnFuelEmpty(inst)
	StartHungryTask(inst)
	inst.components.fishfarmmanager:OnFuelEmpty()
end

local function OnOpen(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
end

local function OnClose(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
end

local function OnItemGet(inst, data)
	DoFishFarmSplash(inst)
	UpdateFishArt(inst)
	
	if data.slot == 1 then
		local fish = data.item
		
		if fish and fish:HasTag("fishfarmable") then
			if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
				inst.components.fishfarmmanager:StartWorking()
			end
		end
	end

	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
end

local function OnItemLose(inst, data)
	UpdateFishArt(inst)
	
	if data.slot == 1 then
		inst.components.fishfarmmanager:StopWorking()
	end

	inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
end

local function OnBuilt(inst, data)
	DoFishFarmSplash(inst)
	
	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")

	inst.AnimState:PlayAnimation("dry_pst")
	inst.AnimState:PushAnimation("idle", true)
	
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/emerge/large")
end

local function OnDeploy(inst, pt, deployer)
	local obj = SpawnPrefab("kyno_fishfarmplot_construction")
		
	if obj ~= nil then
		obj.Transform:SetPosition(pt:Get())
		obj:PushEvent("onbuilt")
			
		inst:Remove()
	end
end

local function OnHammered(inst, worker)
	if inst.components.container ~= nil then 
		inst.components.container:DropEverything() 
	end
	
	inst.components.lootdropper:DropLoot()

	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")
	
	StopHungryTask(inst)
	inst:Remove()
end

local function OnEntityRemove(inst)
	StopHungryTask(inst)
end

local function OnSave(inst, data)
	if inst.plants ~= nil then
		data.plants = inst.plants
	end
end

local function OnLoad(inst, data)
	if data and data.plants then
		inst.plants = data.plants
	end
	
	if inst.components.fueled and not inst.components.fueled:IsEmpty() then
		local container = inst.components.container
		local fish = container and container:GetItemInSlot(1)

		if fish and fish:HasTag("fishfarmable") then
			inst.components.fishfarmmanager:StartWorking()
		end
	else
		StartHungryTask(inst)
	end
end

local function OnInit(inst)
	inst.task = nil
	
	SpawnPlants(inst)
	UpdateFishArt(inst)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_fishfarmplot.tex")

	MakeObstaclePhysics(inst, 5)
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_fishfarmplot")
	inst.AnimState:SetBuild("kyno_fishfarmplot")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddTag("structure")
	inst:AddTag("fishhatchery")
	inst:AddTag("watersource")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("fishfarmplot")
		end
		
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("savedrotation")
	inst:AddComponent("watersource")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper.spawn_loot_inside_prefab = true
	
	inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_FISHFARMLAKE_PRESERVER_RATE)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("fishfarmplot")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

	inst:AddComponent("fueled")
	inst.components.fueled.accepting = true
	inst.components.fueled.fueltype = FUELTYPE.FISHFOOD
	inst.components.fueled:SetTakeFuelFn(OnAddFuel)
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.maxfuel = TUNING.KYNO_FISHFARMLAKE_FUEL_MAX
	inst.components.fueled:InitializeFuelLevel(TUNING.KYNO_FISHFARMLAKE_FUEL_MAX)
	inst.components.fueled:SetSections(TUNING.KYNO_FISHFARMLAKE_SECTIONS)
	
	inst:AddComponent("fishfarmmanager")
	inst.components.fishfarmmanager:SetSlotStart(3)
	inst.components.fishfarmmanager:SetSlotEnd(8)
	inst.components.fishfarmmanager:SetRoeConsumption(TUNING.KYNO_FISHFARMLAKE_ROE_CONSUMPTION)
	inst.components.fishfarmmanager:SetBabyConsumption(TUNING.KYNO_FISHFARMLAKE_BABY_CONSUMPTION)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)
	inst:ListenForEvent("onremove", OnEntityRemove)
	
	inst.planttype = "marsh_plant"
	inst.dayspawn = true
	inst.task = inst:DoTaskInTime(0, OnInit)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

local function kitfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.pickupsound = "wood"
	
	inst.AnimState:SetBank("kyno_fishfarmplot_kit")
	inst.AnimState:SetBuild("kyno_fishfarmplot_kit")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("deploykititem")
	inst:AddTag("fishfarmplot_kit") -- For extra deploy range.
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_fishfarmplot_kit"
	
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.DEFAULT)
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LARGE)
	inst.components.deployable.ondeploy = OnDeploy
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
	MakeHauntableLaunchAndIgnite(inst)
	
	return inst
end

local function shoalfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.9, .9, .9)
	
	inst.AnimState:SetBank("kyno_fishfarmplot_shoal")
	inst.AnimState:SetBuild("kyno_fishfarmplot_shoal")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetFinalOffset(4)
	
	inst:AddTag("NOCLICK")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("savedrotation")

	return inst
end

local function markerfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_fishfarmplot_shoal")
	inst.AnimState:SetBuild("kyno_fishfarmplot_shoal")
	inst.AnimState:PlayAnimation("marker")
	inst.AnimState:SetFinalOffset(4)
	
	inst:AddTag("NOCLICK")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	
	inst.no_wet_prefix = true
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("savedrotation")

	return inst
end

return Prefab("kyno_fishfarmplot", fn, assets, prefabs),
Prefab("kyno_fishfarmplot_kit", kitfn, assets, prefabs),
Prefab("kyno_fishfarmplot_shoal", shoalfn, assets, prefabs),
Prefab("kyno_fishfarmplot_shoal_marker", markerfn, assets, prefabs),
MakePlacer("kyno_fishfarmplot_kit_placer", "kyno_fishfarmplot", "kyno_fishfarmplot", "idle", true, nil, nil, .9)