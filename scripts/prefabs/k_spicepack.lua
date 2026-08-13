local assets =
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_chefpack.zip"),

	Asset("ANIM", "anim/ui_chest_2x2.zip"),
	Asset("ANIM", "anim/ui_icepack_2x3.zip"),
}

local prefabs =
{
	"ash",
}

local function OnOpen(inst)
	local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

	if SoundEmitter then
		SoundEmitter:PlaySound("meta5/walter/ammo_bag_open")
	end
end

local function OnClose(inst)
	local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

	if SoundEmitter then
		SoundEmitter:PlaySound("meta5/walter/ammo_bag_close")
	end
end

local function OnPutInInventory(inst)
	if inst.components.container ~= nil then
		inst.components.container:Close()
	end
end

local function OnBurnt(inst)
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
		inst.components.container:Close()
	end

	SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

	inst:Remove()
end

local function OnIgnite(inst)
	if inst.components.container ~= nil then
		inst.components.container.canbeopened = false
	end
end

local function OnExtinguish(inst)
	if inst.components.container ~= nil then
		inst.components.container.canbeopened = true
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("spicepack.png")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.15, 0.85)

	inst.AnimState:SetBank("backpack1")
	inst.AnimState:SetBuild("swap_chefpack")
	inst.AnimState:PlayAnimation("anim")

	inst:AddTag("foodpreserver")
	inst:AddTag("portablestorage")

	inst.pickupsound = "cloth"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("spicepack")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	inst.components.container.droponopen = true

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_SPICEPACK_PRESERVER_RATE)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	inst.components.burnable:SetOnBurntFn(OnBurnt)
	inst.components.burnable:SetOnIgniteFn(OnIgnite)
	inst.components.burnable:SetOnExtinguishFn(OnExtinguish)

	MakeHauntableLaunchAndDropFirstItem(inst)

	return inst
end

return Prefab("spicepack", fn, assets, prefabs)