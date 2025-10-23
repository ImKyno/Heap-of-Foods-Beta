require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_fishfarmplot.zip"),
	Asset("ANIM", "anim/ui_fishfarmplot_3x4.zip"),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"rocks",
	"collapse_small",
}

local function SpawnPlants(inst)
	inst.task = nil

	if inst.plant_ents ~= nil then
		return
	end

	local radius_x = 3.5
	local radius_z = 3
	local total = math.random(3, 6)
	local sector = TWOPI / total
	
	inst.plant_ents = {}
	
	for i = 1, total do
		local theta = i * sector + (math.random() * 0.2 - 0.1)
		local dist = radius_x + math.random() * 0.2
		local is_rock = math.random() < 0.5

		local x = math.cos(theta) * radius_x
		local z = math.sin(theta) * radius_z
		local y = 0

		local plant_prefab = inst.planttype or "marsh_plant"
		local plant = SpawnPrefab(plant_prefab)

		if plant ~= nil then
			plant.entity:SetParent(inst.entity)
			plant.Transform:SetPosition(x, y, z)
			plant.persists = false
			plant.Transform:SetRotation(math.random() * 360)
			table.insert(inst.plant_ents, plant)

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
				local rock = SpawnPrefab(rock_prefab)

				if rock ~= nil then
					rock.entity:SetParent(inst.entity)

					local rx = x + math.cos(theta + off) * offset_dist
					local rz = z + math.sin(theta + off) * offset_dist

					rock.Transform:SetPosition(rx, y, rz)
					rock.persists = false
					rock.Transform:SetRotation(math.random() * 360)

					if rock.AnimState then
						local shade = 0.7 + math.random() * 0.1
						
						rock.AnimState:SetMultColour(shade, shade, shade, 1)
						rock.AnimState:SetScale(.9, .9, .9)
					end

					table.insert(inst.plant_ents, rock)
				end
			end
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

local function OnHammred(inst, worker)
	inst.components.lootdropper:DropLoot()

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")

	inst:Remove()
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

local function OnStartWorking(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding")
end

local function OnStopWorking(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl1_ding")
end

local function OnWorking(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
end

-- Handled by the fishfarmmanager component.
local function OnAddFuel(inst)
	DoFishFarmSplash(inst)
	inst.components.fishfarmmanager:OnAddFuel()
end

local function OnFuelEmpty(inst)
	inst.components.fishfarmmanager:OnFuelEmpty()
end

local function OnOpen(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
end

local function OnClose(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
end

local function OnItemGet(inst)
	DoFishFarmSplash(inst)
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/splash/small")
end

local function OnItemLose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
end

local function OnBuilt(inst, data)
	inst.AnimState:PlayAnimation("dry_pst")
	inst.AnimState:PushAnimation("idle", true)
	
	inst.SoundEmitter:PlaySound("dontstarve/common/together/sculpting_table/craft")
end

local function OnSnowLevel(inst, snowlevel)
	if snowlevel > .02 then
        if not inst.frozen then
			inst.frozen = true
			DespawnPlants(inst)
		end
	elseif inst.frozen then
		inst.frozen = false
		SpawnPlants(inst)
	elseif inst.frozen == nil then
		inst.frozen = false
		SpawnPlants(inst)
	end
end

local function OnSave(inst, data)
	data.plants = inst.plants
end

local function OnLoad(inst, data)
	if data ~= nil then
		if inst.task ~= nil and inst.plants == nil then
			inst.plants = data.plants
		end
	end
end

local function OnInit(inst)
	inst.task = nil
	SpawnPlants(inst)

	-- inst:WatchWorldState("snowlevel", OnSnowLevel)
	-- OnSnowLevel(inst, TheWorld.state.snowlevel)
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

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("fishfarmplot")
		end
		
		return inst
	end

	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	inst:AddComponent("savedrotation")
	inst:AddComponent("watersource")
	
	inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammred)
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
	inst.components.fueled:StartConsuming()
	
	inst:AddComponent("fishfarmmanager")
	inst.components.fishfarmmanager:SetSlotStart(3)
	inst.components.fishfarmmanager:SetSlotEnd(11)
	inst.components.fishfarmmanager:SetRoeConsumption(TUNING.KYNO_FISHFARMLAKE_ROE_CONSUMPTION)
	inst.components.fishfarmmanager:SetBabyConsumption(TUNING.KYNO_FISHFARMLAKE_BABY_CONSUMPTION)
	-- inst.components.fishfarmmanager:SetStartWorkingFn(OnStartWorking)
	-- inst.components.fishfarmmanager:SetStopWorkingFn(OnStopWorking)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)
	
	inst.planttype = "marsh_plant"
	inst.dayspawn = true
	inst.task = inst:DoTaskInTime(0, OnInit)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_fishfarmplot", fn, assets, prefabs)