local assets =
{
	Asset("ANIM", "anim/swap_foodsack.zip"),
	Asset("ANIM", "anim/deer_ice_flakes.zip"),
	Asset("ANIM", "anim/ui_backpack_2x4.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("IMAGE", "images/minimapimages/hof_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapicons.xml"),
}

local prefabs =
{
	"kyno_foodsack_fx",
}

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_foodsack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_foodsack", "swap_body")
	
    inst.components.container:Open(owner)
	
	if not inst.fx then
		inst.fx = SpawnPrefab("kyno_foodsack_fx")
		
		local follower = inst.fx.entity:AddFollower()
		follower:FollowSymbol(owner.GUID, "swap_body", 0, 0, 0)
	end
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
	
    inst.components.container:Close(owner)
	
	if inst.fx ~= nil then
		inst.fx:Remove()
		inst.fx = nil
	end
end

local function OnEquipToModel(inst, owner)
    inst.components.container:Close(owner)
	
	if inst.fx ~= nil then
		inst.fx:Remove()
		inst.fx = nil
	end
end

local function OnPreEquipVanity(inst, owner, from_ground)
	inst.components.inventoryitem.__cangoincontainer = inst.components.inventoryitem.cangoincontainer
	inst.components.inventoryitem.cangoincontainer = true
end

local function OnEquipVanity(inst, owner, from_ground)
	inst:AddTag("vanity_equipped")
	
	if owner ~= nil then
		if inst.components.preserver ~= nil then
			inst.components.preserver:SetPerishRateMultiplier(1)
		end
	end
end

local function OnUnequipVanity(inst, owner)
	if owner ~= nil then
		if inst.components.equippable ~= nil then
			inst.components.equippable:Unequip(owner)
		end
	end
	
	inst:RemoveTag("vanity_equipped")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("kyno_foodsack.tex")

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.15)

    inst.AnimState:SetBank("kyno_foodsack")
    inst.AnimState:SetBuild("swap_foodsack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("backpack")
    inst:AddTag("fridge")
    inst:AddTag("nocool")
	inst:AddTag("waterproofer")

    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("foodsack")
		end
        return inst
    end
	
	inst.onpreequipvanity = OnPreEquipVanity
	inst.onequipvanity = OnEquipVanity
	inst.onunequipvanity = OnUnequipVanity

    inst:AddComponent("inspectable")
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
	
	inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_FOODSACK_PERISH_MULT)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_foodsack"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("foodsack")
	inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.25, .25, .25)

	inst.AnimState:SetBank("deer_ice_flakes")
	inst.AnimState:SetBuild("deer_ice_flakes")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetFinalOffset(0)

	inst:AddTag("FX")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

    inst.persists = false

    return inst
end

return Prefab("kyno_foodsack", fn, assets, prefabs),
Prefab("kyno_foodsack_fx", fxfn, assets, prefabs)