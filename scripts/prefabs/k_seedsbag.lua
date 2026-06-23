local assets =
{
	Asset("ANIM", "anim/kyno_seedsbag.zip"),
	Asset("ANIM", "anim/ui_chest_2x2.zip"),
	Asset("ANIM", "anim/ui_seedsbag_upgraded_2x2.zip"),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

	Asset("INV_IMAGE", "seedsbag_unknown_seeds"),
}

local prefabs =
{
	"alterguardianhatshard",
}

local function SafeRegisterInventoryImages(image)
	if type(image) == "string" and image ~= "" then
		table.insert(assets, Asset("INV_IMAGE", image))
	end
end

for _, seed in ipairs(HOF_SEEDSBAG_SEEDS) do
	local imagekey = SeedsBagGetSeedImageKey(seed)

	if imagekey ~= nil then
		SafeRegisterInventoryImages("seedsbag_" .. imagekey .. "_seeds")
	end
end

local function HasSeedsInside(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
end

local function UpdateAnimation(inst)
	if HasSeedsInside(inst) then
		inst.AnimState:PushAnimation("full")
	else
		inst.AnimState:PushAnimation("empty")
	end
end

local function BuildInventoryLayers(inst)
	local layers = {}

	local hasseed = inst._hasseeds:value()
	local bg = hasseed and "kyno_seedsbag_full" or "kyno_seedsbag_empty"

	table.insert(layers, { image = bg .. ".tex" })

	local seed = inst._seedimage ~= nil and inst._seedimage:value() or ""

	if seed ~= "" then
		local imagekey = SeedsBagGetSeedImageKey(seed)
		table.insert(layers,
		{
			image = (imagekey ~= nil and ("seedsbag_" .. imagekey .. "_seeds")
			or "seedsbag_unknown_seeds") .. ".tex"
		})
	end

	return layers
end

local function CLIENT_LayeredInventoryImageFn(inst)
	if inst._layers == nil then
		inst._layers = BuildInventoryLayers(inst)
	end

	return inst._layers
end

local function UpdateInventoryImage(inst)
	inst._layers = BuildInventoryLayers(inst)
	inst:PushEvent("imagechange")
end

local function OnTransition(inst)
	if inst.components.container ~= nil and inst.components.inventoryitem ~= nil then
		local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter
		local isempty = inst.components.container:IsEmpty()

		if inst._wasempty and not isempty then
			inst._wasempty = false

			inst.AnimState:PlayAnimation("empty_to_full")
			inst.AnimState:PushAnimation("full", true)

			if SoundEmitter then
				SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
			end

			return true
		elseif not inst._wasempty and isempty then
			inst._wasempty = true

			inst.AnimState:PlayAnimation("full_to_empty")
			inst.AnimState:PushAnimation("empty", true)

			if SoundEmitter then
				SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
			end

			return true
		end

		inst._wasempty = isempty
		return false
	end
end

local function OnOpen(inst)
	if HasSeedsInside(inst) then
		inst.AnimState:PlayAnimation("interact_full")
	else
		inst.AnimState:PlayAnimation("interact_empty")
	end

	UpdateAnimation(inst)

	local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

	if SoundEmitter then
		SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
	end
end

local function OnClose(inst)
	if HasSeedsInside(inst) then
		inst.AnimState:PlayAnimation("interact_full")
	else
		inst.AnimState:PlayAnimation("interact_empty")
	end

	UpdateAnimation(inst)

	local SoundEmitter = (inst.components.inventoryitem:GetGrandOwner() or inst).SoundEmitter

	if SoundEmitter then
		SoundEmitter:PlaySound("dontstarve/wilson/use_bedroll")
	end
end

local function OnPutInInventory(inst)
	if inst.components.container ~= nil then
		inst.components.container:Close()
	end

	UpdateAnimation(inst)
end

local function OnItemGet(inst, data)
	local transitioned = OnTransition(inst)

	if not transitioned then
		if HasSeedsInside(inst) then
			inst.AnimState:PlayAnimation("interact_full", false)
		else
			inst.AnimState:PlayAnimation("interact_empty", false)
		end

		UpdateAnimation(inst)
	end

	UpdateInventoryImage(inst)

	inst._hasseeds:set(not inst.components.container:IsEmpty())
end

local function OnItemLose(inst, data)
	local transitioned = OnTransition(inst)

	if not transitioned then
		if HasSeedsInside(inst) then
			inst.AnimState:PlayAnimation("interact_full", false)
		else
			inst.AnimState:PlayAnimation("interact_empty", false)
		end

		UpdateAnimation(inst)
	end

	UpdateInventoryImage(inst)

	inst._hasseeds:set(not inst.components.container:IsEmpty())
end

local function GetStatus(inst, viewer)
	return (HasSeedsInside(inst) and "FULL")
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

	if inst.components.preserver ~= nil then
		inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_SEEDSBAG_PRESERVER_RATE_UPGRADED)
	end

	inst.components.upgradeable.upgradetype = nil

	if inst.Transform ~= nil then
		inst.Transform:SetScale(1.3, 1.3, 1.3)
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

local function OnDisplayName(inst)
	local seedname = inst._seedname:value()

	if seedname ~= "" then
		return subfmt(STRINGS.NAMES.KYNO_SEEDSBAG_NAMED, { item = seedname })
	end

	return STRINGS.NAMES.KYNO_SEEDSBAG
end

local function OnDrawn(inst, image, src, atlas, bgimage, bgatlas)
	if src ~= nil then
		local name = STRINGS.NAMES[string.upper(src.prefab)] or src:GetBasicDisplayName() -- nil?
		local seedimage = src.prefab

		inst._savedseedname = name
		inst._savedseedimage = seedimage

		inst._seedname:set(name)
		inst._seedimage:set(seedimage)

		UpdateInventoryImage(inst)

		inst.SoundEmitter:PlaySound("dontstarve/common/together/draw")

		if HasSeedsInside(inst) then
			inst.AnimState:PlayAnimation("interact")
		end
	end
end

local function OnIgnite(inst)
	DefaultBurnFn(inst)

	if inst.components.drawable ~= nil then
		inst.components.drawable:SetCanDraw(false)
	end
end

local function OnExtinguish(inst)
	DefaultExtinguishFn(inst)

	if inst.components.drawable ~= nil then
		inst.components.drawable:SetCanDraw(true)
	end
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end

	data.seedname = inst._savedseedname
	data.seedimage = inst._savedseedimage
end

local function OnLoad(inst, data)
	if data ~= nil then
		if data.burnt ~= nil then
			inst.components.burnable.onburnt(inst)
		end

		if data.seedname ~= nil then
			inst._savedseedname = data.seedname
			inst._seedname:set(data.seedname)
		end

		if data.seedimage ~= nil then
			inst._savedseedimage = data.seedimage
			inst._seedimage:set(data.seedimage)
		end
	end

	if inst.components.container ~= nil then
		inst._wasempty = inst.components.container:IsEmpty()
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
	UpdateAnimation(inst)

	inst:AddTag("seedsbag")
	inst:AddTag("drawable")
	inst:AddTag("portablestorage")

	inst.pickupsound = "cloth"

	inst.displaynamefn = OnDisplayName

	inst._seedname = net_string(inst.GUID, "kyno_seedsbag._seedname")
	inst._seedimage = net_string(inst.GUID, "kyno_seedsbag._seedimage", "invimagechanged")
	inst._hasseeds = net_bool(inst.GUID, "kyno_seedsbag._hasseeds", "invimagechanged")
	
	inst.layeredinvimagefn = CLIENT_LayeredInventoryImageFn

	UpdateInventoryImage(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("seedsbag")
		end

		inst:ListenForEvent("invimagechanged", function(inst)
			UpdateInventoryImage(inst)
		end)

		return inst
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	inst:AddComponent("drawable")
	inst.components.drawable:SetOnDrawnFn(OnDrawn)

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_SEEDSBAG_PRESERVER_RATE)

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("seedsbag")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	inst.components.container.droponopen = true

	inst._wasempty = inst.components.container:IsEmpty()

	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)

	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)
	inst:ListenForEvent("ondeconstructstructure", OnDecontruct)

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	inst.components.burnable:SetOnIgniteFn(OnIgnite)
	inst.components.burnable:SetOnExtinguishFn(OnExtinguish)

	MakeHauntableLaunchAndDropFirstItem(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass

	return inst
end

return Prefab("kyno_seedsbag", fn, assets, prefabs)