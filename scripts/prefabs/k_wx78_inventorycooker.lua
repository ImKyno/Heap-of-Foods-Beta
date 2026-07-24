local assets =
{
	Asset("ANIM", "anim/kyno_wx78_inventorycooker.zip"),
	Asset("ANIM", "anim/ui_wx78_inventorycooker_1x2.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local COOKED_PRODUCT_TAGS =
{
	charcoal_source = "charcoal",
}

local DoCook
local UpdateCooking

local function GetCookedProduct(inst, item, owner)
	for tag, prefab in pairs(COOKED_PRODUCT_TAGS) do
		if item:HasTag(tag) then
			return SpawnPrefab(prefab)
		end
	end

	if item.components.cookable ~= nil then
		return item.components.cookable:Cook(cooker, chef)
	end

	if item.components.burnable ~= nil then
		return SpawnPrefab("ash")
	end

	return nil
end

local function GetCookTime(inst)
	--[[
	local time = TUNING.KYNO_WX78_MODULES_COOKER_TIME or 5
	local owner = inst.components.inventoryitem.owner

	if owner and owner.prefab == "wx78" or owner.prefab == "wx78_possessedbody" then
		if owner._cookerchips and owner._cookerchips > 0 and IsSkillActivated(owner, "wx78_circuitry_betabuffs_1") then
			time = TUNING.KYNO_WX78_MODULES_COOKER_TIME - 5 or 5
		end
	end

	return time
	]]--

	return TUNING.KYNO_WX78_MODULES_COOKER_TIME or 5
end

local function AddCookingRecharge(item, time)
	if item.components.rechargeable == nil then
		item:AddComponent("rechargeable")
	end

	item.components.rechargeable:SetMaxCharge(1)
	item.components.rechargeable:Discharge(time)
	item.rechargeable_temp = true
end

local function RemoveCookingRecharge(item)
	if item == nil then
		return
	end

	if item.components.rechargeable ~= nil and item.rechargeable_temp then
		item:RemoveComponent("rechargeable")
		item:RemoveTag("rechargeable")
		item.rechargeable_temp = nil
	end
end

local function CanCook(inst)
	if not inst.components.container.canbeopened then
		return false
	end

	local input = inst.components.container:GetItemInSlot(1)

	if input == nil then
		return false
	end

	local product

	if input.components.cookable ~= nil then
		product = input.components.cookable.product
	elseif input:HasTag("charcoal_source") then
		product = "charcoal"
	elseif input.components.burnable ~= nil then
		product = "ash"
	else
		return false
	end

	local output = inst.components.container:GetItemInSlot(2)

	if output == nil then
		return true
	end

	return output.prefab == product and output.components.stackable ~= nil and output.components.stackable:RoomLeft() > 0
end

local function StopCooking(inst)
	if inst._cooktask ~= nil then
		inst._cooktask:Cancel()
		inst._cooktask = nil
	end

	-- RemoveCookingRecharge(inst.components.container:GetItemInSlot(1))
end

local function StartCooking(inst)
	if inst._cooktask ~= nil then
		return
	end

	local cooktime = GetCookTime(inst)
	local item = inst.components.container:GetItemInSlot(1)

	if item ~= nil then
		-- AddCookingRecharge(item, cooktime)
	end

	inst._cooktask = inst:DoTaskInTime(cooktime, function()
		inst._cooktask = nil

		DoCook(inst)
		UpdateCooking(inst)
	end)
end

UpdateCooking = function(inst)
	if inst._cooking then
		return
	end

	if not inst.components.container.canbeopened then
		StopCooking(inst)
		return
	end

	if inst.components.container:GetItemInSlot(1) == nil then
		StopCooking(inst)
		return
	end

	if inst._cooktask == nil and CanCook(inst) then
		StartCooking(inst)
	end
end

DoCook = function(inst)
	if inst._cooking then
		return
	end

	inst._cooking = true

	if not CanCook(inst) then
		inst._cooking = false
		return
	end

	local owner = inst.components.inventoryitem.owner
	local item = inst.components.container:GetItemInSlot(1)

	-- RemoveCookingRecharge(item)

	if item == nil then
		inst._cooking = false
		return
	end

	if item.components.stackable ~= nil and item.components.stackable:StackSize() > 1 then
		item = item.components.stackable:Get()
	else
		item = inst.components.container:RemoveItemBySlot(1)
	end

	local cooked

	if item.components.cookable ~= nil then
		cooked = item.components.cookable:Cook(inst, owner)

	elseif item:HasTag("charcoal_source") then
		item:Remove()
		cooked = SpawnPrefab("charcoal")
	elseif item.components.burnable ~= nil then
		item:Remove()
		cooked = SpawnPrefab("ash")
	end

	if cooked ~= nil then
		local output = inst.components.container:GetItemInSlot(2)

		if output ~= nil and output.prefab == cooked.prefab and output.components.stackable ~= nil then
			output.components.stackable:Put(cooked)
		else
			inst.components.container:GiveItem(cooked, 2)
		end

		if inst.components.container ~= nil and inst.components.container:IsOpen() then
			inst.SoundEmitter:PlaySound("dontstarve/wilson/cook")
		end
	else
		item:Remove()
	end

	inst._cooking = false
	UpdateCooking(inst)
end

local function ShouldCollapse(inst)
	local overstacks = 0

	for k, v in pairs(inst.components.container.slots) do
		local stackable = v.components.stackable

		if stackable then
			overstacks = overstacks + math.ceil(stackable:StackSize() / (stackable.originalmaxsize or stackable.maxsize))
			if overstacks >= TUNING.COLLAPSED_CHEST_EXCESS_STACKS_THRESHOLD then
				return true
			end
		end
	end

	return false
end

local function OnPutInInventory(inst)
	inst:RemoveTag("no_container_store")
	inst.components.inventoryitem.islockedinslot = true
end

local function OnDropped(inst)
	inst:AddTag("no_container_store")

	if ShouldCollapse(inst) then
		inst.components.container:DropEverythingUpToMaxStacks(TUNING.COLLAPSED_CHEST_MAX_EXCESS_STACKS_DROPS)

		if inst.components.container:IsEmpty() then
			inst:Remove()
		end
	else
		inst.components.container:DropEverything()
		inst:Remove()
	end
end

local function OnPicked(inst, picker, loot)
	inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_pst")

	local loots = inst.components.container:GetAllItems()

	if #loots > 0 then
		local item = loots[math.random(#loots)]

		if picker and picker.components.inventory then
			item = inst.components.container:RemoveItem(item, true, nil, true)
			picker.components.inventory:GiveItem(item, nil, inst:GetPosition())
		else
			local slot = inst.components.container:GetItemSlot(item)
			inst.components.container:DropItemBySlot(slot, inst:GetPosition(), true)
		end
	end

	if inst.components.container:IsEmpty() then
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("metal")

		inst:Remove()
	else
		inst.AnimState:PlayAnimation("dropped_rummage")
		inst.AnimState:PushAnimation("dropped_idle", false)
	end
end

local function RefreshIcon(inst)
	inst.components.inventoryitem:ChangeImageName((inst.components.container:IsOpen()
	and (("kyno_wx78_inventorycooker").."_open"))
	or (inst.components.container.canbeopened and (("kyno_wx78_inventorycooker").."_powered"))
	or "kyno_wx78_inventorycooker")
end

local function OnOpen(inst)
	RefreshIcon(inst)
end

local function OnClose(inst)
	RefreshIcon(inst)
end

local function OnItemGet(inst, data)
	UpdateCooking(inst)
end

local function OnItemLose(inst, data)
	if data.slot == 1 and data.prev_item ~= nil then
		-- RemoveCookingRecharge(data.prev_item)
	end

	UpdateCooking(inst)
end

local function SetPowered(inst, powered)
	if inst.components.container.canbeopened ~= powered then
		inst.components.container.canbeopened = powered

		if not powered then
			StopCooking(inst)

			if inst.components.container:IsOpen() then
				inst.components.container:Close()
			end
		else
			UpdateCooking(inst)
		end

		RefreshIcon(inst)
	end
end

local function PreserverRateFn(inst, item)
	local owner = inst.components.inventoryitem.owner
	return owner ~= nil and owner.components.preserver ~= nil and owner.components.preserver:GetPerishRateMultiplier(item)
end

local function ValidateOnLoad(inst)
	inst:RemoveComponent("updatelooper")

	local owner = inst.components.inventoryitem.owner
	if owner == nil then
		return
	end

	local inventory = owner.components.inventory or owner.components.container

	local maxcount = owner._stacksize_modules or 0
	local minslot = inventory:GetNumSlots() - (maxcount - 1)
	local slot = inventory:GetItemSlot(inst)

	if slot and slot >= minslot then
		maxcount = owner._stacksize_active_modules or 0
		minslot = inventory:GetNumSlots() - (maxcount - 1)

		inst:SetPowered(slot >= minslot)
		return
	end

	inst.components.inventoryitem.islockedinslot = false
	inventory:DropItem(inst)
end

local function GetStatus(inst)
	return inst.components.inventoryitem:IsHeld()
	and (inst.components.container.canbeopened and "HELD" or "NOPOWER") or nil
end

local function DisplayNameFn(inst)
	local inventoryitem = inst.replica.inventoryitem
	return inventoryitem and inventoryitem:IsHeld() and STRINGS.NAMES.KYNO_WX78_INVENTORYCOOKER_HELD
	or STRINGS.NAMES.KYNO_WX78_INVENTORYCOOKER
end

local function OnLoad(inst)
	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddPostUpdateFn(ValidateOnLoad)

	UpdateCooking(inst)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_wx78_inventorycooker")
	inst.AnimState:SetBuild("kyno_wx78_inventorycooker")
	inst.AnimState:PlayAnimation("dropped_idle")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.35, 1.15, nil, nil, { bank = "kyno_wx78_inventorycooker", anim = "dropped_idle" })

	inst:AddTag("nosteal")
	inst:AddTag("pickable_rummage_str")
	inst:AddTag("no_container_store")

	inst.displaynamefn = DisplayNameFn

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if not inst:HasTag("burnt") then
				inst.replica.container:WidgetSetup("wx78_inventorycooker") 
			end
		end

		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	inst.components.inspectable.nameoverride = "WX78_INVENTORYCONTAINER"

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem.canbepickedup = false

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("wx78_inventorycooker")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.canbeopened = false

	inst:AddComponent("pickable")
	inst.components.pickable:SetUp(nil, 0)
	inst.components.pickable.onpickedfn = OnPicked

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(PreserverRateFn)

	inst.SetPowered = SetPowered
	inst.OnLoad = OnLoad

	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)

	MakeHauntableLaunchAndDropFirstItem(inst)

	return inst
end

return Prefab("kyno_wx78_inventorycooker", fn, assets)