local assets = 
{
	Asset("ANIM", "anim/hat_sammy.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function OnEquip(inst, owner, from_ground)
	owner.AnimState:OverrideSymbol("swap_hat", "hat_sammy", "swap_hat")
	
	owner.AnimState:Show("HAT")
	owner.AnimState:Show("HAIR_HAT")
	
	owner.AnimState:Hide("HAIR")
	owner.AnimState:Hide("HAIR_NOHAT")
	
	if owner.isplayer then
		owner.AnimState:Show("HEAD_HAT")
		owner.AnimState:Hide("HEAD")
	end
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:StartConsuming()
	end
	
	if owner.components.hunger ~= nil then
		owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.KYNO_SAMMYHAT_HUNGERRATE, "sammyhat")
	end
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
	
	if inst.components.fueled ~= nil then
		inst.components.fueled:StopConsuming()
	end
	
	if owner.components.hunger ~= nil then
		owner.components.hunger.burnratemodifiers:RemoveModifier(inst, "sammyhat")
	end
end

local function OnEquipToModel(inst, owner, from_ground)
	if inst.components.fueled ~= nil then
		inst.components.fueled:StopConsuming()
	end
	
	if owner.components.hunger ~= nil then
		owner.components.hunger.burnratemodifiers:RemoveModifier(inst, "sammyhat")
	end
end

local function OnEquipVanity(inst, owner, from_ground)
	if owner ~= nil then
		if inst.components.fueled ~= nil then
			inst.components.fueled:StopConsuming()
		
			if inst.components.fueled.no_sewing ~= nil then
				inst.components.fueled.__no_sewing = inst.components.fueled.no_sewing
				inst.components.fueled.no_sewing = true
			end
		end
	
		if owner.components.hunger ~= nil then
			owner.components.hunger.burnratemodifiers:RemoveModifier(inst, "sammyhat")
		end
	end
end

local function OnUnequipVanity(inst, owner)
	if owner ~= nil then
		if inst.components.equippable ~= nil then
			inst.components.equippable:Unequip(owner)
		end
		
		if inst.components.fueled ~= nil then
			if inst.components.fueled.no_sewing ~= nil then
				inst.components.fueled.no_sewing = inst.components.fueled.__no_sewing
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

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("sammyhat")
	inst.AnimState:SetBuild("hat_sammy")
	inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
	inst:AddTag("waterproofer")
	inst:AddTag("sammyhat")
	
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
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	inst.components.insulator:SetSummer()
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.KYNO_SAMMYHAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)
	inst.components.fueled.no_sewing = false
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_sammyhat"
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("kyno_sammyhat", fn, assets)