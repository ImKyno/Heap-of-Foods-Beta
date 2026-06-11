local function OnCheckWetness(inst, target)
	if target == nil or target.components.sanity == nil then
		return false
	end

	if TheWorld.state.israining then
		return true
	end

	return target.components.moisture ~= nil
	and target.components.moisture:GetMoisture() >= TUNING.KYNO_WETNESSBUFF_THRESHOLD
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	inst._wetnesstask = inst:DoPeriodicTask(TUNING.KYNO_WETNESSBUFF_TICK_PERIOD, function()
		if OnCheckWetness(inst, target) then
			if target.components.sanity ~= nil then
				target.components.sanity:DoDelta(TUNING.KYNO_WETNESSBUFF_AMOUNT, false, "kyno_wetnessbuff")
			end
		end
	end)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WETNESSBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_wetnessbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetached(inst, target)
	if inst._wetnesstask ~= nil then
		inst._wetnesstask:Cancel()
		inst._wetnesstask = nil
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WETNESSBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_wetnessbuff")
	inst.components.timer:StartTimer("kyno_wetnessbuff", TUNING.KYNO_WETNESSBUFF_DURATION)

	if inst._wetnesstask ~= nil then
		inst._wetnesstask:Cancel()
		inst._wetnesstask = nil
	end

	inst._wetnesstask = inst:DoPeriodicTask(TUNING.KYNO_WETNESSBUFF_TICK_PERIOD, function()
		if OnCheckWetness(inst, target) then
			if target.components.sanity ~= nil then
				target.components.sanity:DoDelta(TUNING.KYNO_WETNESSBUFF_AMOUNT, false, "kyno_wetnessbuff")
			end
		end
	end)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WETNESSBUFF_START"))
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
	inst.components.timer:StartTimer("kyno_wetnessbuff", TUNING.KYNO_WETNESSBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_wetnessbuff", fn)