local assets =
{
	Asset("ANIM", "anim/quagmire_crate.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{	
	"kyno_cookware_hanger_item",
	"kyno_cookware_big_pot",
	"kyno_cookware_small_pot",
	"kyno_cookware_syrup_pot",
	
	"kyno_cookware_grill_item",
	"kyno_cookware_small_grill_item",
}

local KIT_LOOT =
{
    [1] =
    {
        "kyno_cookware_hanger_item",
		"kyno_cookware_hanger_item",
        "kyno_cookware_small_pot",
		"kyno_cookware_big_pot",
    },
    [2] =
    {
        "kyno_cookware_hanger_item",
        "kyno_cookware_syrup_pot",
    },
	[3] =
	{
		"kyno_cookware_oven",
		"kyno_cookware_oven",
		"kyno_cookware_small_casserole",
		"kyno_cookware_casserole",
	},
	[4] =
	{
		"kyno_cookware_small_grill_item",
	},
	[5] =
	{
		"kyno_cookware_grill_item",
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
		doer.SoundEmitter:PlaySound("dontstarve/common/together/crate_open")
	end

	inst:ListenForEvent("animover", inst.Remove)
end

local function cookingpotkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_crate")
	inst.AnimState:SetBuild("quagmire_crate")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:OverrideSymbol("swap_logo", "quagmire_crate", "logo_pot_hanger")

	inst:AddTag("cookingpot_kit")
	inst:AddTag("bundle")
	inst:AddTag("unwrappable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_COOKWARE_KIT"
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cookware_kit_hanger"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(1, KIT_LOOT)

	return inst
end

local function syruppotkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_crate")
	inst.AnimState:SetBuild("quagmire_crate")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:OverrideSymbol("swap_logo", "quagmire_crate", "logo_pot_hanger")

	inst:AddTag("syruppot_kit")
	inst:AddTag("bundle")
	inst:AddTag("unwrappable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_COOKWARE_KIT"
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cookware_kit_syrup"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(2, KIT_LOOT)

	return inst
end

local function grillsmallkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_crate")
	inst.AnimState:SetBuild("quagmire_crate")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:OverrideSymbol("swap_logo", "quagmire_crate", "logo_grill_small")

	inst:AddTag("small_grill_kit")
	inst:AddTag("bundle")
	inst:AddTag("unwrappable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_COOKWARE_KIT"
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cookware_kit_small_grill"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(4, KIT_LOOT)

	return inst
end

local function grillkitfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_crate")
	inst.AnimState:SetBuild("quagmire_crate")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:OverrideSymbol("swap_logo", "quagmire_crate", "logo_grill")

	inst:AddTag("grill_kit")
	inst:AddTag("bundle")
	inst:AddTag("unwrappable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_COOKWARE_KIT"
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_cookware_kit_grill"
	
	inst:AddComponent("unwrappable")
	inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)
	inst.components.unwrappable.itemdata = GetItemData(5, KIT_LOOT)

	return inst
end

return Prefab("kyno_cookware_kit_hanger", cookingpotkitfn, assets, prefabs),
Prefab("kyno_cookware_kit_syrup", syruppotkitfn, assets, prefabs),
Prefab("kyno_cookware_kit_small_grill", grillsmallkitfn, assets, prefabs),
Prefab("kyno_cookware_kit_grill", grillkitfn, assets, prefabs)