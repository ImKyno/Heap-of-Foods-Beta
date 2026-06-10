local function IsValidHeal(cause)
    return cause ~= nil and not TUNING.KYNO_HEALINGBUFF_BLACKLIST[cause]
end

local function OnHeal(inst, data)
	if inst.components.health ~= nil then
		if data and data.amount > 0 and IsValidHeal(data.cause) then
			inst.components.health:DoDelta(TUNING.KYNO_HEALINGBUFF_AMOUNT, nil, "kyno_healingbuff")
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end

	target:ListenForEvent("healthdelta", OnHeal)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	target:RemoveEventCallback("healthdelta", OnHeal)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_healingbuff")
	inst.components.timer:StartTimer("kyno_healingbuff", TUNING.KYNO_HEALINGBUFF_DURATION)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end

	target:RemoveEventCallback("healthdelta", OnHeal)

	inst:DoTaskInTime(1, function()
		target:ListenForEvent("healthdelta", OnHeal)
	end)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_healingbuff" then
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
	inst.components.timer:StartTimer("kyno_healingbuff", TUNING.KYNO_HEALINGBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_healingbuff", fn)