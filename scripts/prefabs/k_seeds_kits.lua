local assets =
{
	Asset("ANIM", "anim/kyno_seeds_kit.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{	
	"kyno_aloe_seeds",
	"kyno_cucumber_seeds",
	"kyno_fennel_seeds",
	"kyno_parznip_seeds",
	"kyno_radish_seeds",
	"kyno_sweetpotato_seeds",
	"kyno_turnip_seeds",
	
	-- Exotic Seeds.
	-- "firenettles_seeds",
	-- "forgetmelots_seeds",
	-- "tillweed_seeds",
	-- "kyno_rice_seeds",
}

local KIT_LOOT =
{
    [1] =
    {
        "kyno_aloe_seeds",
		"kyno_aloe_seeds",
		"kyno_aloe_seeds",
    },
    [2] =
    {
        "kyno_cucumber_seeds",
        "kyno_cucumber_seeds",
		"kyno_cucumber_seeds",
    },
	[3] =
	{
		"kyno_fennel_seeds",
		"kyno_fennel_seeds",
		"kyno_fennel_seeds",
	},
	[4] =
	{
		"kyno_parznip_seeds",
		"kyno_parznip_seeds",
		"kyno_parznip_seeds",
	},
	[5] =
	{
		"kyno_radish_seeds",
		"kyno_radish_seeds",
		"kyno_radish_seeds",
	},
	[6] =
	{
		"kyno_sweetpotato_seeds",
		"kyno_sweetpotato_seeds",
		"kyno_sweetpotato_seeds",
	},
	[7] =
	{
		"kyno_turnip_seeds",
		"kyno_turnip_seeds",
		"kyno_turnip_seeds",
	},
}

local function GetItemData(id, KIT_LOOT)
	local data = {}
	
	for _, itemprefab in ipairs(KIT_LOOT[id]) do
		local item = SpawnPrefab(itemprefab)
		if item then
			local record = item:GetSaveRecord()
			table.insert(data, record)
			item:Remove()
		end
	end
	
	return data
end

local function OnUnwrapped(inst, pos, doer)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	if owner and owner.components.inventory then
		owner.components.inventory:DropItem(inst)
	end

	inst.components.inventoryitem.canbepickedup = false
	inst.components.unwrappable.canbeunwrapped = false
	
	inst.AnimState:PlayAnimation("unwrap")

	if doer ~= nil and doer.SoundEmitter ~= nil then
		doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
	end

	inst:ListenForEvent("animover", inst.Remove)
end

local function aloekitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("kyno_seeds_kit")
	inst.AnimState:SetBuild("kyno_seeds_kit")
	inst.AnimState:PlayAnimation("aloe")

	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
	inst:AddTag("seeds_kit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEEDS_KIT"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seeds_kit_aloe"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(1, KIT_LOOT)

	return inst
end

local function cucumberkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("kyno_seeds_kit")
	inst.AnimState:SetBuild("kyno_seeds_kit")
	inst.AnimState:PlayAnimation("cucumber")

	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
	inst:AddTag("seeds_kit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEEDS_KIT"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seeds_kit_cucumber"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(2, KIT_LOOT)

	return inst
end

local function fennelkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("kyno_seeds_kit")
	inst.AnimState:SetBuild("kyno_seeds_kit")
	inst.AnimState:PlayAnimation("fennel")

	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
	inst:AddTag("seeds_kit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEEDS_KIT"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seeds_kit_fennel"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(3, KIT_LOOT)

	return inst
end

local function parznipkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("kyno_seeds_kit")
	inst.AnimState:SetBuild("kyno_seeds_kit")
	inst.AnimState:PlayAnimation("parznip")

	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
	inst:AddTag("seeds_kit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEEDS_KIT"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seeds_kit_parznip"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(4, KIT_LOOT)

	return inst
end

local function radishkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("kyno_seeds_kit")
	inst.AnimState:SetBuild("kyno_seeds_kit")
	inst.AnimState:PlayAnimation("radish")

	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
	inst:AddTag("seeds_kit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEEDS_KIT"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seeds_kit_radish"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(5, KIT_LOOT)

	return inst
end

local function sweetpotatokitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("kyno_seeds_kit")
	inst.AnimState:SetBuild("kyno_seeds_kit")
	inst.AnimState:PlayAnimation("sweetpotato")

	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
	inst:AddTag("seeds_kit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEEDS_KIT"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seeds_kit_sweetpotato"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(6, KIT_LOOT)

	return inst
end

local function turnipkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("kyno_seeds_kit")
	inst.AnimState:SetBuild("kyno_seeds_kit")
	inst.AnimState:PlayAnimation("turnip")

	inst:AddTag("bundle")
	inst:AddTag("unwrappable")
	inst:AddTag("seeds_kit")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEEDS_KIT"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_seeds_kit_turnip"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(7, KIT_LOOT)

	return inst
end

return Prefab("kyno_seeds_kit_aloe", aloekitfn, assets, prefabs),
Prefab("kyno_seeds_kit_cucumber", cucumberkitfn, assets, prefabs),
Prefab("kyno_seeds_kit_fennel", fennelkitfn, assets, prefabs),
Prefab("kyno_seeds_kit_parznip", parznipkitfn, assets, prefabs),
Prefab("kyno_seeds_kit_radish", radishkitfn, assets, prefabs),
Prefab("kyno_seeds_kit_sweetpotato", sweetpotatokitfn, assets, prefabs),
Prefab("kyno_seeds_kit_turnip", turnipkitfn, assets, prefabs)