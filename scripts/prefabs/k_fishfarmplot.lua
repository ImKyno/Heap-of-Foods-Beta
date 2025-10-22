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

local function OnHammred(inst, worker)
	inst.components.lootdropper:DropLoot()

	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")

	inst:Remove()
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

local function OnBuilt(inst, data)
	inst.AnimState:PlayAnimation("dry_pst")
	inst.AnimState:PushAnimation("idle", true)
	
	inst.SoundEmitter:PlaySound("dontstarve/common/together/sculpting_table/craft")
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
	inst.AnimState:SetLightOverride(0.25)

	inst:AddTag("structure")
	inst:AddTag("fishhatchery")

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("fishfarmplot")
		end
		
		return inst
	end

	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	inst:AddComponent("savedrotation")
	
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
	inst.components.fueled.fueltype = FUELTYPE.FISHFOOD
	inst.components.fueled:SetTakeFuelFn(OnAddFuel)
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.maxfuel = TUNING.KYNO_FISHFARMLAKE_FUEL_MAX
	inst.components.fueled:InitializeFuelLevel(TUNING.KYNO_FISHFARMLAKE_FUEL_MAX)
	inst.components.fueled:SetSections(TUNING.KYNO_FISHFARMLAKE_SECTIONS)
	inst.components.fueled.accepting = true
	inst.components.fueled:StartConsuming()
	
	inst:AddComponent("fishfarmmanager")
	inst.components.fishfarmmanager:SetSlotStart(3)
	inst.components.fishfarmmanager:SetSlotEnd(11)
	inst.components.fishfarmmanager:SetRoeConsumption(TUNING.KYNO_FISHFARMLAKE_ROE_CONSUMPTION)
	inst.components.fishfarmmanager:SetBabyConsumption(TUNING.KYNO_FISHFARMLAKE_BABY_CONSUMPTION)
	inst.components.fishfarmmanager:SetStartWorkingFn(OnStartWorking)
	inst.components.fishfarmmanager:SetStopWorkingFn(OnStopWorking)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

return Prefab("kyno_fishfarmplot", fn, assets, prefabs)