local assets =
{
	Asset("ANIM", "anim/kyno_cutlassblue.zip"),
	Asset("ANIM", "anim/swap_cutlassblue.zip"),
}

local MIN_HIT_COUNT = TUNING.KYNO_CUTLASSBLUE_HIT_THRESHOLD
local MIN_HIT_RESET = TUNING.KYNO_CUTLASSBLUE_HIT_RESET_THRESHOLD

local function OnCooldown(inst)
	inst._cdtask = nil
end

local function OnReset(inst)
	inst._combotask = nil
	inst._hitcount = 0
	inst._lasttarget = nil
end

local function DoIceFlock(inst, owner, target)
	inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)
	
	if inst._hitcount then
		inst._hitcount = 0
	end

	local fx = SpawnPrefab("kyno_cutlassblue_fx")

	if fx ~= nil and target ~= nil then
		fx.Transform:SetPosition(target.Transform:GetWorldPosition())
		fx:SetFXTarget(owner, target)

		if target.SoundEmitter ~= nil then
			target.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/freeze")
		end
	end
end

local function OnAttackOther(owner, data, inst)
	if inst._cdtask ~= nil then
		return
	end

	local target = data.target

	if inst._lasttarget ~= target.GUID then
		inst._lasttarget = target.GUID
		inst._hitcount = 1
	else
		inst._hitcount = inst._hitcount + 1
	end

	if inst._combotask then
		inst._combotask:Cancel()
	end

	inst._combotask = inst:DoTaskInTime(MIN_HIT_RESET, OnReset)

	if inst._hitcount >= MIN_HIT_COUNT then
		DoIceFlock(inst, owner, data.target)
	end
end

local function OnEquip(inst, owner)
	if owner ~= nil then
		if inst.components.heater ~= nil then
			inst.components.heater:SetThermics(false, true)
		end

		owner.AnimState:OverrideSymbol("swap_object", "swap_cutlassblue", "swap_cutlassblue")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")

		inst:ListenForEvent("onattackother", inst._onattackother, owner)

		inst._hitcount = 0
		inst._lasttarget = nil
	end
end

local function OnUnequip(inst, owner)
	if owner ~= nil then
		if inst.components.heater ~= nil then
			inst.components.heater:SetThermics(false, false)
		end

		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")

		inst:RemoveEventCallback("onattackother", inst._onattackother, owner)

		inst._hitcount = nil
		inst._lasttarget = nil
	end
end

local function OnGetDamage(inst)
	local freshness = inst.components.perishable:GetPercent()

	local damage = TUNING.KYNO_CUTLASSBLUE_MAX_DAMAGE
	- (TUNING.KYNO_CUTLASSBLUE_MAX_DAMAGE - TUNING.KYNO_CUTLASSBLUE_MIN_DAMAGE) * freshness

	if TheWorld.state.iswinter then
		damage = damage * TUNING.KYNO_CUTLASSBLUE_WINTER_DAMAGE_MULT
	end

	return damage
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	local swap_data = { sym_build = "swap_cutlassblue", bank = "kyno_cutlassblue" }
	MakeInventoryFloatable(inst, "med", nil, { 1.0, 0.5, 1.0 }, true, -13, swap_data)

	inst.AnimState:SetBank("kyno_cutlassblue")
	inst.AnimState:SetBuild("kyno_cutlassblue")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sharp")
	inst:AddTag("weapon")
	inst:AddTag("cutlassblue")
	inst:AddTag("show_spoilage")
	inst:AddTag("icebox_valid")
	inst:AddTag("HASHEATER")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(OnGetDamage)

	inst:AddComponent("forcecompostable")
	inst.components.forcecompostable.green = true

	inst:AddComponent("heater")
	inst.components.heater.equippedheat = TUNING.KYNO_CUTLASSBLUE_HEAT

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "kyno_spoiled_fish_large"

	inst._hitcount = nil
	inst._lasttarget = nil

	inst._onattackother = function(owner, data)
		OnAttackOther(owner, data, inst)
	end

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_cutlassblue", fn, assets)