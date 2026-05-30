local function OnKilled(target, data)
	local victim = data ~= nil and data.victim or nil

	if victim ~= nil and not victim:HasAnyTag(NON_LIFEFORM_TARGET_TAGS) or victim:HasTag("lifedrainable") then
		if target ~= nil and target.components.health ~= nil then
			target.components.health:DoDelta(TUNING.KYNO_LIFESTEALBUFF_AMOUNT, true, "kyno_lifestealbuff")
		end
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end

	target:ListenForEvent("killed", OnKilled)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	target:RemoveEventCallback("killed", OnKilled)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_lifestealbuff")
	inst.components.timer:StartTimer("kyno_lifestealbuff", TUNING.KYNO_LIFESTEALBUFF_DURATION)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end

	target:RemoveEventCallback("killed", OnKilled)

	inst:DoTaskInTime(1, function()
		target:ListenForEvent("killed", OnKilled)
	end)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_lifestealbuff" then
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
	inst.components.timer:StartTimer("kyno_lifestealbuff", TUNING.KYNO_LIFESTEALBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_lifestealbuff", fn)