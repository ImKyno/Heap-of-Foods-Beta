local SANITY_BLACKLIST      = TUNING.KYNO_SPICE_MINDBUFF_SANITY_BLACKLIST
local SANITY_AURA_MODIFIER  = TUNING.KYNO_SPICE_MINDBUFF_SANITY_AURA_MODIFIER
local SANITY_STAFF_MODIFIER = TUNING.KYNO_SPICE_MINDBUFF_SANITY_STAFF_MODIFIER
local SPICE_DURATION        = TUNING.KYNO_SPICE_MINDBUFF_DURATION

local function SetStaffSanity(target)
	if target ~= nil then
		if target.components.staffsanity == nil then
			target:AddComponent("staffsanity") -- This doesn't get saved anyways.
		end

		if target.components.staffsanity ~= nil then
			if target._old_staffsanity_mult == nil then
				target._old_staffsanity_mult = target.components.staffsanity.multiplier or 1
			end

			target._spice_mindbuff_count = (target._spice_mindbuff_count or 0) + 1
			target.components.staffsanity:SetMultiplier(SANITY_STAFF_MODIFIER)
		end
	end
end

local function RemoveStaffSanity(target)
	if target ~= nil then
		if target._spice_mindbuff_count == nil then
			return
		end

		target._spice_mindbuff_count = math.max(0, target._spice_mindbuff_count - 1)

		if target._spice_mindbuff_count <= 0 then
			target._spice_mindbuff_count = nil

			if target.components.staffsanity ~= nil and target._old_staffsanity_mult ~= nil then
				target.components.staffsanity:SetMultiplier(target._old_staffsanity_mult)
				target._old_staffsanity_mult = nil
			end
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_START"))
	end

	if target ~= nil then
		SetStaffSanity(target)
	end

	if target.components.sanity ~= nil then
		target.components.sanity.neg_aura_modifiers:SetModifier(inst, SANITY_AURA_MODIFIER)
	end

	if target.components.sanity ~= nil then
		target.components.sanity:SetLightDrainImmune(true, inst)
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target ~= nil then
		RemoveStaffSanity(target)
	end

	if target.components.sanity ~= nil then
		target.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
	end

	if target.components.sanity ~= nil then
		target.components.sanity:SetLightDrainImmune(false, inst)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_spice_mindbuff")
	inst.components.timer:StartTimer("kyno_spice_mindbuff", SPICE_DURATION)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_START"))
	end

	if target.components.sanity ~= nil then
		target.components.sanity.neg_aura_modifiers:SetModifier(inst, SANITY_AURA_MODIFIER)
	end

	if target.components.sanity ~= nil then
		target.components.sanity:SetLightDrainImmune(true, inst)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_spice_mindbuff" then
		inst.components.debuff:Stop()
	end
end

local function fn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		return
	end

	inst.entity:AddTransform()
	inst.entity:Hide()
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff:SetExtendedFn(OnExtended)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_spice_mindbuff", SPICE_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_spice_mindbuff", fn)