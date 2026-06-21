local HUNGER_RATE_MODIFIER = TUNING.KYNO_SPICE_FEDBUFF_HUNGER_RATE_MODIFIER
local SLEEP_HEALTH_MULT    = TUNING.KYNO_SPICE_FEDBUFF_SLEEP_HEALTH_MULT
local SLEEP_HUNGER_MULT    = TUNING.KYNO_SPICE_FEDBUFF_SLEEP_HUNGER_MULT
local SLEEP_SANITY_MULT    = TUNING.KYNO_SPICE_FEDBUFF_SLEEP_SANITY_MULT
local SPICE_DURATION       = TUNING.KYNO_SPICE_FEDBUFF_DURATION

local function SetSleepingBagBonus(target)
	if target ~= nil then
		if target.components.sleepingbaguser == nil then
			return
		end

		if target._old_sleepingbag_bonus == nil then
			target._old_sleepingbag_bonus =
			{
				health = target.components.sleepingbaguser.health_bonus_mult,
				hunger = target.components.sleepingbaguser.hunger_bonus_mult,
				sanity = target.components.sleepingbaguser.sanity_bonus_mult,
			}
		end

		target._spice_sleep_bonus_count = (target._spice_sleep_bonus_count or 0) + 1

		target.components.sleepingbaguser:SetHealthBonusMult(target._old_sleepingbag_bonus.health * SLEEP_HEALTH_MULT)
		target.components.sleepingbaguser:SetHungerBonusMult(target._old_sleepingbag_bonus.hunger * SLEEP_HUNGER_MULT)
		target.components.sleepingbaguser:SetSanityBonusMult(target._old_sleepingbag_bonus.sanity * SLEEP_SANITY_MULT)
	end
end

local function RemoveSleepingBagBonus(target)
	if target ~= nil then
		if target.components.sleepingbaguser == nil then
			return
		end

		if target._spice_sleep_bonus_count == nil then
			return
		end

		target._spice_sleep_bonus_count = math.max(0, target._spice_sleep_bonus_count - 1)

		if target._spice_sleep_bonus_count <= 0 then
			target._spice_sleep_bonus_count = nil

			if target._old_sleepingbag_bonus ~= nil then
				target.components.sleepingbaguser:SetHealthBonusMult(target._old_sleepingbag_bonus.health)
				target.components.sleepingbaguser:SetHungerBonusMult(target._old_sleepingbag_bonus.hunger)
				target.components.sleepingbaguser:SetSanityBonusMult(target._old_sleepingbag_bonus.sanity)
				target._old_sleepingbag_bonus = nil
			end
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_START"))
	end

	if target ~= nil then
		SetSleepingBagBonus(target)
	end

	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, HUNGER_RATE_MODIFIER, "kyno_spice_fedbuff")
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target ~= nil then
		RemoveSleepingBagBonus(target)
	end

	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:RemoveModifier(inst, "kyno_spice_fedbuff")
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_spice_fedbuff")
	inst.components.timer:StartTimer("kyno_spice_fedbuff", SPICE_DURATION)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_START"))
	end

	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, HUNGER_RATE_MODIFIER, "kyno_spice_fedbuff")
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_spice_fedbuff" then
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
	inst.components.timer:StartTimer("kyno_spice_fedbuff", SPICE_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_spice_fedbuff", fn)