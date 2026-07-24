local assets =
{
	Asset("ANIM", "anim/kyno_wx78_inventorydryer.zip"),
	Asset("ANIM", "anim/ui_wx78_inventorydryer_1x1.zip"),

	Asset("ANIM", "anim/kyno_wx78_inventorydryer2.zip"),
	Asset("ANIM", "anim/ui_wx78_inventorydryer2_1x1.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function IsSkillActivated(owner, skill)
	return owner.components.skilltreeupdater and owner.components.skilltreeupdater:IsActivated(skill)
end

local function UpdateDrying(inst)
	if not inst.components.dryingrack then
		return
	end

	local owner = inst.components.inventoryitem.owner

	if owner == nil then
		inst.components.dryingrack:PauseDrying()
		return
	end

	if owner.components.moisture ~= nil then
		if owner.components.moisture:GetMoisture() <= TUNING.KYNO_WX78_MODULES_DRYER_THRESHOLD
		and inst.components.container.canbeopened then
			inst.components.dryingrack:ResumeDrying()
		else
			inst.components.dryingrack:PauseDrying()
		end
	end
end

local function OnOwnerChanged(inst)
	local owner = inst.components.inventoryitem.owner

	if inst._moistureowner then
		inst._moistureowner:RemoveEventCallback("moisturedelta", UpdateDrying, inst)
		inst._moistureowner = nil
	end

	if owner then
		inst._moistureowner = owner
		owner:ListenForEvent("moisturedelta", UpdateDrying, inst)
	end

	UpdateDrying(inst)
end

local function OnSaltChanged(inst, num)
	inst._saltcount = num
end

local function ClearInvSaltDried(item)
	item:RemoveEventCallback("onputininventory", ClearInvSaltDried)
	item:RemoveEventCallback("ondropped", ClearInvSaltDried)

	item.components.driedsalticon:HideSaltIcon()
end

local function OnItemGet(inst, data)
	UpdateDrying(inst)

	if inst.components.container ~= nil and inst.components.container:IsOpen() then
		inst.SoundEmitter:PlaySound("dontstarve/common/together/put_meat_rack")
	end

	local owner = inst.components.inventoryitem.owner

	if owner ~= nil and IsSkillActivated(owner, "wx78_circuitry_betabuffs_2") then
		if data and data.item and inst.components.dryingracksaltcollector then
			if data.item.components.driedsalticon and data.slot then
				if data.item.components.driedsalticon.collects then
					inst.components.dryingracksaltcollector:AddSalt(data.slot)
				end

				if inst.components.dryingracksaltcollector:HasSalt(data.slot) then
					data.item.components.driedsalticon:ShowSaltIcon()
					data.item:ListenForEvent("onputininventory", ClearInvSaltDried)
					data.item:ListenForEvent("ondropped", ClearInvSaltDried)
				end
			end

			if data.item.prefab == "saltrock" then
				OnSaltChanged(inst, inst.components.dryingracksaltcollector:GetNumSalts())
			end
		end
	end
end

local function DoItemTaken(inst, slot)
	local owner = inst.components.inventoryitem.owner

	if owner ~= nil and IsSkillActivated(owner, "wx78_circuitry_betabuffs_2") then
		if inst.components.container and inst.components.dryingracksaltcollector then
			local other = inst.components.container:GetItemInSlot(slot)

			if other then
				if other.components.driedsalticon == nil then
					if inst.components.dryingracksaltcollector:RemoveSalt(slot) then
						local salt = SpawnPrefab("saltrock")
						salt.Transform:SetPosition(inst.Transform:GetWorldPosition())
						salt.components.inventoryitem:OnDropped(true)
					end
				end
			elseif inst.components.dryingracksaltcollector:RemoveSalt(slot) then
				inst.components.container:GiveItem(SpawnPrefab("saltrock"), slot)
			end
		end
	end
end

local function OnItemLose(inst, data)
	UpdateDrying(inst)

	local owner = inst.components.inventoryitem.owner

	if owner ~= nil and IsSkillActivated(owner, "wx78_circuitry_betabuffs_2") then
		if data and inst.components.dryingracksaltcollector then
			if data.slot and inst.components.dryingracksaltcollector:HasSalt(data.slot) then
				if data.prev_item and data.prev_item:IsValid() then
					inst:DoStaticTaskInTime(0, DoItemTaken, data.slot)
				else
					inst.components.dryingracksaltcollector:RemoveSalt(data.slot)
				end
			end

			if data.prev_item and data.prev_item.prefab == "saltrock" then
				OnSaltChanged(inst, inst.components.dryingracksaltcollector:GetNumSalts())
			end
		end
	end
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

	OnOwnerChanged(inst)
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

	OnOwnerChanged(inst)
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
	local prefab = inst.prefab

	inst.components.inventoryitem:ChangeImageName((inst.components.container:IsOpen() and (prefab.."_open"))
	or (inst.components.container.canbeopened and (prefab.."_powered")) or prefab)
end

local function OnOpen(inst)
	RefreshIcon(inst)
end

local function OnClose(inst)
	RefreshIcon(inst)
end

local function SetPowered(inst, powered)
	if inst.components.container.canbeopened ~= powered then
		inst.components.container.canbeopened = powered

		if not powered then
			if inst.components.container:IsOpen() then
				inst.components.container:Close()
			end
		end

		UpdateDrying(inst)
		RefreshIcon(inst)
	end
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
	local name = string.upper(inst.prefab)

	return inventoryitem and inventoryitem:IsHeld() and STRINGS.NAMES[name.."_HELD"] or STRINGS.NAMES[name]
end

local function OnLoad(inst)
	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddPostUpdateFn(ValidateOnLoad)
end

local function OnLoadPostPass(inst)
	if inst.components.container and inst.components.dryingracksaltcollector
	and inst.components.dryingracksaltcollector:HasSalt() then
		for i = 1, inst.components.container:GetNumSlots() do
			if inst.components.dryingracksaltcollector:HasSalt(i) then
				local item = inst.components.container:GetItemInSlot(i)

				if item then
					if item.components.driedsalticon == nil then
						if inst.components.dryingracksaltcollector:RemoveSalt(i) then
							local salt = SpawnPrefab("saltrock")
							salt.Transform:SetPosition(inst.Transform:GetWorldPosition())
							salt.components.inventoryitem:OnDropped(true)
						end
					end
				elseif inst.components.dryingracksaltcollector:RemoveSalt(i) then
					inst.components.container:GiveItem(SpawnPrefab("saltrock"), i)
				end
			end
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_wx78_inventorydryer")
	inst.AnimState:SetBuild("kyno_wx78_inventorydryer")
	inst.AnimState:PlayAnimation("dropped_idle")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.35, 1.15, nil, nil, { bank = "kyno_wx78_inventorydryer", anim = "dropped_idle" })

	inst:AddTag("nosteal")
	inst:AddTag("pickable_rummage_str")
	inst:AddTag("no_container_store")

	inst.displaynamefn = DisplayNameFn

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if not inst:HasTag("burnt") then
				inst.replica.container:WidgetSetup("wx78_inventorydryer") 
			end
		end

		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem.canbepickedup = false

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("wx78_inventorydryer")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.canbeopened = false

	inst:AddComponent("dryingrack")
	inst.components.dryingrack:EnableDrying()

	inst:AddComponent("pickable")
	inst.components.pickable:SetUp(nil, 0)
	inst.components.pickable.onpickedfn = OnPicked

	inst.SetPowered = SetPowered
	inst.OnLoad = OnLoad

	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)

	MakeHauntableLaunchAndDropFirstItem(inst)

	return inst
end

local function fn2()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_wx78_inventorydryer2")
	inst.AnimState:SetBuild("kyno_wx78_inventorydryer2")
	inst.AnimState:PlayAnimation("dropped_idle")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.35, 1.15, nil, nil, { bank = "kyno_wx78_inventorydryer2", anim = "dropped_idle" })

	inst:AddTag("nosteal")
	inst:AddTag("pickable_rummage_str")
	inst:AddTag("no_container_store")

	inst.displaynamefn = DisplayNameFn

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) 
			if not inst:HasTag("burnt") then
				inst.replica.container:WidgetSetup("wx78_inventorydryer2") 
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
	inst.components.container:WidgetSetup("wx78_inventorydryer2")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.canbeopened = false

	inst:AddComponent("dryingrack")
	inst.components.dryingrack:EnableDrying()

	inst:AddComponent("dryingracksaltcollector")
	inst.components.dryingracksaltcollector:SetOnSaltChangedFn(OnSaltChanged)

	inst:AddComponent("pickable")
	inst.components.pickable:SetUp(nil, 0)
	inst.components.pickable.onpickedfn = OnPicked

	inst.SetPowered = SetPowered
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)

	MakeHauntableLaunchAndDropFirstItem(inst)

	return inst
end

return Prefab("kyno_wx78_inventorydryer", fn, assets),
Prefab("kyno_wx78_inventorydryer2", fn2, assets)