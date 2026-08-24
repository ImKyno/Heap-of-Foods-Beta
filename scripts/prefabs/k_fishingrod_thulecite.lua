local assets =
{
	Asset("ANIM", "anim/kyno_fishingrod_thulecite.zip"),
	Asset("ANIM", "anim/swap_fishingrod_thulecite.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local WAIT_MIN = TUNING.KYNO_FISHINGROD_THULECITE_WAIT_MIN
local WAIT_MAX = TUNING.KYNO_FISHINGROD_THULECITE_WAIT_MAX

local function OnEquip(inst, owner)
	if owner ~= nil then
		owner.AnimState:OverrideSymbol("swap_object", "swap_fishingrod_thulecite", "swap_fishingrod_thulecite")
		owner.AnimState:OverrideSymbol("fishingline", "swap_fishingrod_thulecite", "fishingline")
		owner.AnimState:OverrideSymbol("FX_fishing", "swap_fishingrod_thulecite", "FX_fishing")

		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
	end
end

local function OnUnequip(inst, owner)
	if owner ~= nil then
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")

		owner.AnimState:ClearOverrideSymbol("fishingline")
		owner.AnimState:ClearOverrideSymbol("FX_fishing")
	end
end

local function OnFished(inst)
	if inst.components.finiteuses ~= nil then
		inst.components.finiteuses:Use(1)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.05, {0.8, 0.4, 0.8}, true, -12, { sym_build = "swap_fishingrod_thulecite" })

	inst.AnimState:SetBank("kyno_fishingrod_thulecite")
	inst.AnimState:SetBuild("kyno_fishingrod_thulecite")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("weapon")
	inst:AddTag("fishingrod")
	inst:AddTag("allow_action_on_impassable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	inst:AddComponent("fishingrod")
	inst.components.fishingrod:SetWaitTimes(WAIT_MIN, WAIT_MAX)
	inst.components.fishingrod:SetStrainTimes(0, 5)

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.KYNO_FISHINGROD_THULECITE_DAMAGE)
	inst.components.weapon.attackwear = 4
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_FISHINGROD_THULECITE_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_FISHINGROD_THULECITE_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)

	inst:ListenForEvent("fishingcollect", OnFished)

	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("kyno_fishingrod_thulecite", fn, assets)