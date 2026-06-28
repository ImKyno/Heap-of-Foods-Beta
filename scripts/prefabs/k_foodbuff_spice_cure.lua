local PRESERVER_RATE   = TUNING.KYNO_SPICE_CUREBUFF_PRESERVER_RATE
local DEBUFF_BLACKLIST = TUNING.KYNO_SPICE_CUREBUFF_DEBUFF_BLACKLIST
local DEBUFF_DURATION  = TUNING.KYNO_SPICE_CUREBUFF_DEBUFF_DURATION_MULT
local SPICE_DURATION   = TUNING.KYNO_SPICE_CUREBUFF_DURATION

-- In case the character already had another preserver rate.
-- This will store the original preserver and restore it when the buff ends.
-- The only problematic case is if another mod or the game runs SetPerishRateMultiplier again
-- when the buff is active. (Which I believe that does not happen).
local function GetPreserverRate(inst, item)
	local rate = 1
	local old = inst._old_preserver_rate

	if old ~= nil then
		if type(old) == "function" then
			rate = old(inst, item) or 1
		else
			rate = old or 1
		end
	end

	if inst._spice_curebuff_count ~= nil and inst._spice_curebuff_count > 0 then
		if item ~= nil and item.components.perishable ~= nil then
			rate = rate * PRESERVER_RATE
		end
	end

	return rate
end

local function SetPreserverRate(target)
	if target ~= nil then
		if target.components.preserver == nil then
			target:AddComponent("preserver") -- This doesn't get saved anyways.
		end

		if target.components.preserver ~= nil then
			if target._old_preserver_rate == nil then
				target._old_preserver_rate = target.components.preserver.perish_rate_multiplier
				target.components.preserver:SetPerishRateMultiplier(GetPreserverRate)
			end

			target._spice_curebuff_count = (target._spice_curebuff_count or 0) + 1
		end
	end
end

local function RemovePreserverRate(target)
	if target ~= nil then
		if target._spice_curebuff_count == nil then
			return
		end

		target._spice_curebuff_count = math.max(0, target._spice_curebuff_count - 1)

		if target._spice_curebuff_count <= 0 then
			target._spice_curebuff_count = nil

			if target.components.preserver ~= nil and target._old_preserver_rate ~= nil then
				target.components.preserver:SetPerishRateMultiplier(target._old_preserver_rate)
				target._old_preserver_rate = nil
			end
		end
	end
end

local function ExtendDebuffDuration(target)
	if target ~= nil then
		if target.components.debuffable == nil then
			return
		end

		for name, data in pairs(target.components.debuffable.debuffs) do
			if not DEBUFF_BLACKLIST[name] then
				local debuff = data.inst

				if debuff ~= nil and debuff.components.timer ~= nil then
					for timername in pairs(debuff.components.timer.timers) do
						local timeleft = debuff.components.timer:GetTimeLeft(timername)

						if timeleft ~= nil then
							debuff.components.timer:SetTimeLeft(timername, timeleft * DEBUFF_DURATION)
						end
					end
				end
			end
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target ~= nil then
		SetPreserverRate(target)

		target._spice_cure_debuff_duration_mult = DEBUFF_DURATION

		if not target._spice_cure_debuff_bonus then
			target._spice_cure_debuff_bonus = true
			ExtendDebuffDuration(target)
		end
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CUREBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target ~= nil then
		RemovePreserverRate(target)

		if target._spice_cure_debuff_duration_mult ~= nil then
			target._spice_cure_debuff_duration_mult = nil
		end

		if target._spice_cure_debuff_bonus ~= nil then
			target._spice_cure_debuff_bonus = nil
		end
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CUREBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_spice_curebuff")
	inst.components.timer:StartTimer("kyno_spice_curebuff", SPICE_DURATION)

	if target ~= nil then
		target._spice_cure_debuff_duration_mult = DEBUFF_DURATION
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CUREBUFF_START"))
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_spice_curebuff" then
		inst.components.debuff:Stop()
	end
end

local function fn()
	if not TheWorld.ismastersim then
		return
	end

	local inst = CreateEntity()
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
	inst.components.timer:StartTimer("kyno_spice_curebuff", SPICE_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_spice_curebuff", fn)