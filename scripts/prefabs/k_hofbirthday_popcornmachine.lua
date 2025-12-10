require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/cartography_desk.zip"),
}

local prefabs =
{
	"corn_cooked",
	"collapse_small",
	
	"kyno_hofbirthday_popcorn",
}

local MACHINE_STATES = 
{
	ON = "_on",
	OFF = "_off",
}

local POPCORN_PER_CORN = TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_CONSUME_CORN
local POPCORN_INTERVAL = TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_INTERVAL

local function OnHammred(inst, worker)
	if inst.components.container ~= nil then 
		inst.components.container:DropEverything() 
	end
	
	inst.components.lootdropper:DropLoot()
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("metal")

	inst:Remove()
end

local function StopWorking(inst)
	if inst._pop_task ~= nil then
		inst._pop_task:Cancel()
		inst._pop_task = nil
	end
	
	inst.AnimState:PlayAnimation("idle")
	-- inst.SoundEmitter:KillSound("working_loop")
end

local function GetPopcornPrefab(inst)
	return IsSpecialEventActive(SPECIAL_EVENTS.HOFBIRTHDAY) and "kyno_hofbirthday_popcorn" or "corn_cooked"
end

local function ProducePopcorn(inst)
	local fueled = inst.components.fueled
	local container = inst.components.container

	if fueled == nil or container == nil or fueled:IsEmpty() then
		StopWorking(inst)
		return
	end

	local corn = container:GetItemInSlot(1)
	
	if corn == nil then
		StopWorking(inst)
		return
	end

	local popcorn = container:GetItemInSlot(2)
	local size = 0

    if popcorn ~= nil and popcorn.components.stackable ~= nil then
        size = popcorn.components.stackable:StackSize()
		local maxsize = popcorn.components.stackable.maxsize

		if size >= maxsize then
			StopWorking(inst)
			return
		end
	end

	local newpop = SpawnPrefab(GetPopcornPrefab(inst))
	
	if newpop ~= nil then
		local pos = Vector3(inst.Transform:GetWorldPosition())
		newpop.Transform:SetPosition(pos.x, pos.y, pos.z)
		
		local success = container:GiveItem(newpop, 2, pos)
		
		if success then
			inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
		
			fueled:DoDelta(TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_CONSUME_FUEL)
			inst._pop_count = inst._pop_count + 1
		else			
			newpop:Remove()
			StopWorking(inst)
		end
    end

	if inst._pop_count >= POPCORN_PER_CORN then
		inst._pop_count = inst._pop_count - POPCORN_PER_CORN
		
		if corn.components.stackable ~= nil then
			corn.components.stackable:Get(1):Remove()
		else
			container:RemoveItem(corn):Remove()
		end
	end
end

local function StartWorking(inst)
	if inst._pop_task ~= nil then
		return
	end

	local fueled = inst.components.fueled
	local container = inst.components.container
	
	if fueled == nil or container == nil or fueled:IsEmpty() then
		return
	end

	local item = container:GetItemInSlot(1)
	
	if item == nil then
		return
	end
	
	-- inst.AnimState:PlayAnimation("place") -- on anim
	inst.AnimState:PushAnimation("idle")
	-- inst.SoundEmitter:PlaySound(""dontstarve_DLC001/common/machine_melting"", "working_loop")
	
	inst._pop_task = inst:DoPeriodicTask(POPCORN_INTERVAL, ProducePopcorn)
end

local function OnOpen(inst) 
	-- inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve/common/icebox_open")
end

local function OnClose(inst)
	-- inst.AnimState:PlayAnimation("close")
	inst.SoundEmitter:PlaySound("dontstarve/common/icebox_close")
	
	StartWorking(inst)
end

local function OnItemGet(inst, data)
	if data.slot == 1 then
		local item = data.item
		
		if item and item.prefab == "corn" then
			if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
				StartWorking(inst)
			end
		end
	end

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function OnItemLose(inst, data)	
	if data.slot == 1 then
		StopWorking(inst)
	end

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function OnDropped(inst)
	StartWorking(inst)
end

local function OnPutInInventory(inst)
	StopWorking(inst)
end

local function OnAddFuel(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
	StartWorking(inst)
end

local function OnFuelEmpty(inst)
	StopWorking(inst)
end

local function OnBuilt(inst)

end

local function OnSave(inst, data)
	if inst._pop_count ~= nil and inst._pop_count > 0 then
		data.pop_count = inst._pop_count
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.pop_count ~= nil then
		inst._pop_count = data.pop_count
	end
	
	local fueled = inst.components.fueled
	local container = inst.components.container
	
	if fueled ~= nil and not fueled:IsEmpty() then
		local item = container ~= nil and container:GetItemInSlot(1)
		
		if item ~= nil and item.prefab == "corn" then
			StartWorking(inst)
		end
	else
		StopWorking(inst)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("cartographydesk.png")

	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("cartography_desk")
	inst.AnimState:SetBuild("cartography_desk")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
	inst:AddTag("popcornmachine")

	MakeSnowCoveredPristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("popcornmachine")
		end
        
		return inst
	end
	
	inst._pop_task = nil
	inst._pop_count = 0
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("popcornmachine")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
	inst:AddComponent("fueled")
	inst.components.fueled:SetTakeFuelFn(OnAddFuel)
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
	inst.components.fueled.maxfuel = TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_FUEL_MAX
	inst.components.fueled:InitializeFuelLevel(TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_FUEL_MAX)
	inst.components.fueled:SetSections(TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_SECTIONS)
	inst.components.fueled.accepting = true

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammred)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	MakeSnowCovered(inst)

	return inst
end

return Prefab("kyno_hofbirthday_popcornmachine", fn, assets, prefabs),
MakePlacer("kyno_hofbirthday_popcornmachine_placer", "cartography_desk", "cartography_desk", "idle")