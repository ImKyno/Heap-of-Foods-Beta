local assets =
{
	Asset("ANIM", "anim/ui_popcornmachine_1x2.zip"),
	Asset("ANIM", "anim/kyno_hofbirthday_popcornmachine.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"corn_cooked",
	"collapse_small",
	
	"kyno_hofbirthday_popcorn",
}

local MACHINE_STATES = 
{
	LOW  = "_tier1",
	MED  = "_tier2",
	HIGH = "_tier3",
}

local POPCORN_PER_CORN = TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_CONSUME_CORN
local POPCORN_INTERVAL = TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_INTERVAL

local function GetMachineTier(inst)
	local container = inst.components.container
	
	if container == nil then
		return nil
	end

	local popcorn = container:GetItemInSlot(2)
	
	if popcorn == nil or popcorn.components.stackable == nil then
		return nil
	end

	local amount = popcorn.components.stackable:StackSize()

	if amount >= 20 then
		return MACHINE_STATES.HIGH
	elseif amount >= 10 then
		return MACHINE_STATES.MED
	elseif amount >= 1 then
		return MACHINE_STATES.LOW
	end

	return nil
end

local function PlayMachineAnim(inst, baseanim, loop)
	local tier = GetMachineTier(inst)
	local anim = baseanim .. (tier or "")

	if loop then
		inst.AnimState:PlayAnimation(anim, true)
	else
		inst.AnimState:PlayAnimation(anim)
	end
end

local function PlayMachinePopAnim(inst)
	local container = inst.components.container
	local popcorn = container ~= nil and container:GetItemInSlot(2)
	
	local amount = 0
	local tier
	local popanim
	
	if popcorn ~= nil and popcorn.components.stackable ~= nil then
		amount = popcorn.components.stackable:StackSize()
	end
	
	if amount >= 20 then
		tier = 3
	elseif amount >= 10 then
		tier = 2
	else
		tier = 1
	end

	if amount >= (tier == 3 and 20 or tier == 2 and 10 or 1) then
		popanim = "pop_tier" .. tier .. "_loop"
	else
		popanim = "pop_tier" .. tier
	end
	
	local workanim = "working_tier" .. tier

	inst.AnimState:PlayAnimation(popanim, false)
	inst.AnimState:PushAnimation(workanim, true)
end

local function RefreshMachineAnim(inst)
	if inst._pop_task ~= nil then
		PlayMachineAnim(inst, "working", true)
	else
		PlayMachineAnim(inst, "idle")
	end
end

local function OnPopcornStackChanged(popcorn, data)
	local inst = popcorn._popcorn_machine
	
	if inst ~= nil and inst:IsValid() then
		RefreshMachineAnim(inst)
	end
end

local function OnHammred(inst, worker)
	inst.AnimState:PlayAnimation("remove")
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")

	if inst.components.container ~= nil then 
		inst.components.container:DropEverything() 
	end

	inst.components.lootdropper:DropLoot()

	inst:ListenForEvent("animover", inst.Remove)
end

local function OnHit(inst, worker)
	if inst.components.container ~= nil and inst.components.container:IsOpen() then
		inst.components.container:Close() -- This already plays the sound.
	else
		inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_close")
	end
	
	local tier = GetMachineTier(inst)

	local hitanim = "hit" .. (tier or "")
	local nextanim

	if inst._pop_task ~= nil then
		nextanim = "working" .. (tier or "")
	else
		nextanim = "idle" .. (tier or "")
	end

	inst.AnimState:PlayAnimation(hitanim, false)
	inst.AnimState:PushAnimation(nextanim, true)
end

local function StopWorking(inst)
	if inst._pop_task ~= nil then
		inst._pop_task:Cancel()
		inst._pop_task = nil
	end
	
	PlayMachineAnim(inst, "idle")
	
	inst.SoundEmitter:KillSound("rattle")
	inst.SoundEmitter:KillSound("working")
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
			PlayMachinePopAnim(inst) -- Replaced with a fn so it doesn't cut the animation.
			
			inst.SoundEmitter:PlaySound("summerevent/cannon/fire3")
		
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

	PlayMachineAnim(inst, "working", true)
	
	inst.SoundEmitter:KillSound("rattle")
	inst.SoundEmitter:PlaySound("rifts3/sawhorse/proximity_lp", "rattle")
	
	inst._pop_task = inst:DoPeriodicTask(POPCORN_INTERVAL, ProducePopcorn)
end

local function OnOpen(inst)
	if inst._pop_task ~= nil then
		PlayMachineAnim(inst, "working_open", true)
	else
		PlayMachineAnim(inst, "open_idle")
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_open")
end

local function OnClose(inst)
	RefreshMachineAnim(inst)	
	StartWorking(inst)
	
	inst.SoundEmitter:PlaySound("dontstarve/common/wardrobe_close")
end

local function OnItemGet(inst, data)
	if data.slot == 1 then		
		if data.item and data.item.prefab == "corn" then
			if inst.components.fueled ~= nil and not inst.components.fueled:IsEmpty() then
				StartWorking(inst)
			end
		end
	end
	
	if data.item ~= nil and data.slot == 2 then
		data.item._popcorn_machine = inst
		inst:ListenForEvent("stacksizechange", OnPopcornStackChanged, data.item)
	end

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function OnItemLose(inst, data)	
	if data.slot == 1 then
		StopWorking(inst)
	end
	
	if data.item ~= nil and data.slot == 2 then
		inst:RemoveEventCallback("stacksizechange", OnPopcornStackChanged, data.item)
		data.item._popcorn_machine = nil
	end
	
	RefreshMachineAnim(inst)

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function OnDropped(inst)
	if inst.components.container ~= nil then
		inst.components.container:Close()
		inst.components.container.canbeopened = true
	end

	StartWorking(inst)
end

local function OnPutInInventory(inst)
	if inst.components.container ~= nil then
		inst.components.container:Close()
		inst.components.container.canbeopened = false
	end

	StopWorking(inst)
end

local function OnPutOnFurniture(inst)
	if inst.components.workable ~= nil then
		inst.components.workable:SetWorkable(false)
	end
	
	if inst.components.container ~= nil then
		inst.components.container:Close()
		inst.components.container.canbeopened = true
	end
	
	StartWorking(inst)
end

local function OnTakeOffFurniture(inst)
	if inst.components.workable ~= nil then
		inst.components.workable:SetWorkable(true)
	end
	
	if inst.components.container ~= nil then
		inst.components.container:Close()
		inst.components.container.canbeopened = true
	end
	
	StopWorking(inst)
end

local function OnTakeFuel(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
	
	local fuelAnim = "fuel"
	local currentfuel = inst.components.fueled.currentfuel
	local maxfuel = inst.components.fueled.maxfuel
	
	if inst.components.fueled ~= nil then
		if currentfuel / maxfuel <= 0.01 then 
			fuelAnim = "fuel"
		elseif currentfuel / maxfuel <= 0.25 then 
			fuelAnim = "fuel1"
		elseif currentfuel / maxfuel <= 0.5 then
			fuelAnim = "fuel2"
		elseif currentfuel / maxfuel <= 1 then
			fuelAnim = "fuel3"
		end
	end
		
	inst.AnimState:OverrideSymbol("fuel", "kyno_hofbirthday_popcornmachine", fuelAnim)
	
	StartWorking(inst)
end

local function OnFuelSectionChange(old, new, inst)
	local fuelAnim = "fuel"
	local currentfuel = inst.components.fueled.currentfuel
	local maxfuel = inst.components.fueled.maxfuel
	
	if inst.components.fueled ~= nil then
		if currentfuel / maxfuel <= 0.01 then 
			fuelAnim = "fuel"
		elseif currentfuel / maxfuel <= 0.25 then 
			fuelAnim = "fuel1"
		elseif currentfuel / maxfuel <= 0.5 then
			fuelAnim = "fuel2"
		elseif currentfuel / maxfuel <= 1 then
			fuelAnim = "fuel3"
		end
	end
		
	inst.AnimState:OverrideSymbol("fuel", "kyno_hofbirthday_popcornmachine", fuelAnim)
end

local function OnFuelEmpty(inst)
	StopWorking(inst)
end

local function GetStatus(inst, viewer)
	return (inst.components.fueled:IsEmpty() and "EMPTY")
	or (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.25 and "FUEL_LOW") 
	or (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.50 and "FUEL_MED")
	or (inst.components.fueled.currentfuel / inst.components.fueled.maxfuel <= 0.70 and "FUEL_HIGH")
	or "GENERIC"
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
	
	local working = false
	
	if fueled ~= nil and not fueled:IsEmpty() then
		local item = container ~= nil and container:GetItemInSlot(1)
		
		if item ~= nil and item.prefab == "corn" then
			StartWorking(inst)
			working = true
		end
	else
		StopWorking(inst)
	end
	
	local popcorn = container and container:GetItemInSlot(2)
	
	if popcorn ~= nil then
		popcorn._popcorn_machine = inst
		inst:ListenForEvent("stacksizechange", OnPopcornStackChanged, popcorn)
	end
	
	RefreshMachineAnim(inst)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddFollower()
	inst.entity:AddNetwork()
	
	inst.Transform:SetScale(1.2, 1.2, 1.2)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_hofbirthday_popcornmachine.tex")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_hofbirthday_popcornmachine")
	inst.AnimState:SetBuild("kyno_hofbirthday_popcornmachine")
	PlayMachineAnim(inst, "idle")

	inst:AddTag("structure")
	inst:AddTag("popcornmachine")
	inst:AddTag("furnituredecor")
	
	inst.pickupsound = "metal"

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
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("furnituredecor")
	inst.components.furnituredecor.onputonfurniture = OnPutOnFurniture
	inst.components.furnituredecor.ontakeofffurniture = OnTakeOffFurniture
	
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_hofbirthday_popcornmachine"
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("popcornmachine")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
	inst:AddComponent("fueled")
	inst.components.fueled:SetTakeFuelFn(OnTakeFuel)
	inst.components.fueled:SetDepletedFn(OnFuelEmpty)
	inst.components.fueled:SetSectionCallback(OnFuelSectionChange)
	inst.components.fueled.secondaryfueltype = FUELTYPE.CHEMICAL
	inst.components.fueled.maxfuel = TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_FUEL_MAX
	inst.components.fueled:InitializeFuelLevel(TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_FUEL_MAX)
	inst.components.fueled:SetSections(TUNING.KYNO_HOFBIRTHDAY_POPCORNMACHINE_SECTIONS)
	inst.components.fueled.accepting = true

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammred)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_hofbirthday_popcornmachine", fn, assets, prefabs)