local assets =
{
    Asset("ANIM", "anim/swap_foodsack.zip"),
    Asset("ANIM", "anim/ui_piggyback_2x6.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"ash",
}

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_foodsack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_foodsack", "swap_body")
	
    inst.components.container:Open(owner)
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
	
    inst.components.container:Close(owner)
end

local function OnEquipToModel(inst, owner)
    inst.components.container:Close(owner)
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

    inst:AddComponent("inspectable")
	
	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0)
	
	inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_FOODSACK_PERISH_RATE)

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

	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("kyno_foodsack", fn, assets, prefabs)
