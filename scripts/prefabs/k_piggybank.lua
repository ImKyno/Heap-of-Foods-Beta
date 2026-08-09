local assets =
{
	Asset("ANIM", "anim/ui_chest_3x2.zip"),

	Asset("ANIM", "anim/kyno_piggybank.zip"),
	Asset("ANIM", "anim/kyno_piggybank_upgraded.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"dirt_puff",
	"chestupgrade_stacksize_fx",
}

local SOUNDS =
{
	open = "meta5/wendy/basket_open",
	close = "meta5/wendy/basket_close",
}

local function OnHammered(inst, worker)
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:DropLoot()
	end

	if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:SpawnLootPrefab("alterguardianhatshard")
		end
	end
	
	local fx = SpawnPrefab("dirt_puff")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_pot")

	inst:Remove()
end

local function OnOpen(inst)
	inst.AnimState:PlayAnimation("interact")
	inst.SoundEmitter:PlaySound(inst._sounds.open)
end

local function OnClose(inst)
	inst.AnimState:PlayAnimation("interact")
	inst.SoundEmitter:PlaySound(inst._sounds.close)
end

local function OnPutInInventory(inst)
	inst.AnimState:PlayAnimation("interact", false)

	if inst.components.container ~= nil then
		inst.components.container:Close()
	end
end

local function OnHasCoins(inst)
	if inst.components.container ~= nil then
		for slot = 1, inst.components.container:GetNumSlots() do
			if inst.components.container:GetItemInSlot(slot) ~= nil then
				return true
			end
		end

		return false
	end
end

local function OnDropped(inst)
	if OnHasCoins(inst) then
		inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/coins/drop")
	end
end

local function OnItemGet(inst)
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/coins/drop")
end

local function OnItemLose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/coins/drop")
end

local function GetStatus(inst, viewer)
	return (inst.components.container ~= nil
	and inst.components.container:IsFull() and "FULL")
	or "GENERIC"
end

local function OnUpgrade(inst, performer, upgraded_from_item)
	local numupgrades = inst.components.upgradeable.numupgrades

	if numupgrades == 1 then
		inst._chestupgrade_stacksize = true

		if inst.components.container ~= nil then
			inst.components.container:Close()
			inst.components.container:EnableInfiniteStackSize(true)
			inst.components.inspectable.getstatus = GetStatus
		end

		if upgraded_from_item then
			local x, y, z = inst.Transform:GetWorldPosition()
			local fx = SpawnPrefab("chestupgrade_stacksize_fx")
			fx.Transform:SetPosition(x, y, z)
		end
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetLoot({"alterguardianhatshard"})
	end

	if inst.components.upgradeable ~= nil then
		inst.components.upgradeable.upgradetype = nil
	end

	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:ChangeImageName("kyno_piggybank_upgraded")
	end

	if inst.components.named ~= nil then
		inst.components.named:SetName(STRINGS.NAMES.KYNO_PIGGYBANK_UPGRADED)
	end

	if inst.MiniMapEntity ~= nil then
		inst.MiniMapEntity:SetIcon("kyno_piggybank_upgraded.tex")
	end

	if inst.AnimState ~= nil then
		inst.AnimState:SetBank("kyno_piggybank_upgraded")
		inst.AnimState:SetBuild("kyno_piggybank_upgraded")
	end
end

local function OnDecontruct(inst, caster)
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end

	if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:SpawnLootPrefab("alterguardianhatshard")
		end
	end
end

local function OnLoadPostPass(inst, newents, data)
	if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
		OnUpgrade(inst)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddFollower()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_piggybank.tex")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", .05, .7, nil, nil, { anim = "idle" })

	inst.AnimState:SetBank("kyno_piggybank")
	inst.AnimState:SetBuild("kyno_piggybank")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("nosteal")
	inst:AddTag("piggybank")
	inst:AddTag("furnituredecor")
	inst:AddTag("portablestorage")
	inst:AddTag("_named")

	inst.pickupsound = "item_gold"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("piggybank")
		end

		return inst
	end

	inst:RemoveTag("_named")

	inst._sounds = SOUNDS

	inst:AddComponent("named")
	inst:AddComponent("lootdropper")
	inst:AddComponent("furnituredecor")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(1)

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("piggybank")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	inst.components.container.droponopen = true
	inst.components.container.thiefproof = true

	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)

	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)
	inst:ListenForEvent("ondropped", OnDropped)
	inst:ListenForEvent("ondeconstructstructure", OnDecontruct)

	inst.OnLoadPostPass = OnLoadPostPass

	AddHauntableDropItemOrWork(inst)

	return inst
end

return Prefab("kyno_piggybank", fn, assets, prefabs)