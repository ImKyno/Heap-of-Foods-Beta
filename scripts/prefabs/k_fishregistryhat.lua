local assets = 
{
	Asset("ANIM", "anim/hat_fishregistry.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

require("screens/fishregistrypopupscreen")

local function StopUsingFishRegistry(inst, data)
	local hat = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
        
	if hat ~= nil and data.statename ~= "fishregistry_open" then
		hat.components.useableitem:StopUsingItem()
	end
end

local function OnUseFishRegistry(inst)
	local owner = inst.components.inventoryitem.owner
        
	if owner then
		if not CanEntitySeeTarget(owner, inst) then
			return false
		end
		
		owner.sg:GoToState("fishregistry_open")
		owner:ShowPopUp(POPUPS.FISHREGISTRY, true)
	end
end

local function OnEquip(inst, owner, from_ground)
	owner.AnimState:OverrideSymbol("swap_hat", "hat_fishregistry", "swap_hat")
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Show("HAIR_HAT")
	
	owner.AnimState:Hide("HAIR")
	owner.AnimState:Hide("HAIR_NOHAT")
	
	if owner.isplayer then
		owner.AnimState:Show("HEAD_HAT")
		owner.AnimState:Hide("HEAD")
	end
	
	inst:ListenForEvent("newstate", StopUsingFishRegistry, owner)
end

local function OnUnequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_hat")
	
	owner.AnimState:Hide("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	
	owner.AnimState:Show("HAIR")
	owner.AnimState:Show("HAIR_NOHAT")

	if owner.isplayer then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
	end
	
	inst:RemoveEventCallback("newstate", StopUsingFishRegistry, owner)
end

local function OnEquipVanity(inst, owner, from_ground)
	if owner ~= nil then
		inst:RemoveEventCallback("newstate", StopUsingFishRegistry, owner)
	end
end

local function OnUnequipVanity(inst, owner)
	if owner ~= nil then
		if inst.components.equippable ~= nil then
			inst.components.equippable:Unequip(owner)
		end
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("fishregistryhat")
	inst.AnimState:SetBuild("hat_fishregistry")
	inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
	inst:AddTag("waterproofer")
	inst:AddTag("fishinspector")
	
	inst.components.floater:SetSize("med")
	inst.components.floater:SetVerticalOffset(0.1)
	inst.components.floater:SetScale(0.6)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.onequipvanity = OnEquipVanity
	inst.onunequipvanity = OnUnequipVanity
		
	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	inst:AddComponent("snowmandecor")
	
	inst:AddComponent("useableitem")
	inst.components.useableitem:SetOnUseFn(OnUseFishRegistry)
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetSummer()
	inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_fishregistryhat"
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("kyno_fishregistryhat", fn, assets)