local assets =
{
	Asset("ANIM", "anim/kyno_seedsbag.zip"),
	Asset("ANIM", "anim/ui_chest_2x2.zip"),
}

local prefabs =
{
	"alterguardianhatshard",
}

local function OnOpen(inst)
	-- inst.AnimState:PlayAnimation("open")

	local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

	if SoundEmitter then
		SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
	end
end

local function OnClose(inst)
	if not inst.components.inventoryitem:IsHeld() then
		-- inst.AnimState:PlayAnimation("close")
		-- inst.AnimState:PushAnimation("closed", false)
	else
		-- inst.AnimState:PlayAnimation("closed", false)
	end

	local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

	if SoundEmitter then
		SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
	end
end

local function OnPutInInventory(inst)
	inst.components.container:Close()
	-- inst.AnimState:PlayAnimation("closed", false)
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

	inst.components.upgradeable.upgradetype = nil
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

local function OnSave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
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
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_seedsbag.tex")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_seedsbag")
	inst.AnimState:SetBuild("kyno_seedsbag")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("portablestorage")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("seedsbag")
		end

		return inst
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SEEDPOUCH"

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seedsbag"

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_SEEDSBAG_PRESERVER_RATE)

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("seedsbag")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	inst.components.container.droponopen = true

	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)

	inst:ListenForEvent("ondeconstructstructure", OnDecontruct)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

	MakeMediumBurnable(inst)
	MakeLargePropagator(inst)
	MakeHauntableLaunchAndDropFirstItem(inst)

	return inst
end

return Prefab("kyno_seedsbag", fn, assets, prefabs)