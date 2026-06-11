local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if inst._onhitother == nil then
		inst._onhitother = SetupInstakillOnHit({
			chance          = TUNING.KYNO_NIGHTKILLBUFF_INSTAKILL_CHANCE,
			blocked_tags    = TUNING.KYNO_INSTAKILL_BLACKLIST_TAGS,
			blocked_prefabs = TUNING.KYNO_INSTAKILL_BLACKLIST_PREFABS,
			require_night   = true,
			fx_prefab       = "planar_hit_fx",
		})

		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_NIGHTKILLBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_nightkillbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetached(inst, target)
	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_NIGHTKILLBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_nightkillbuff")
	inst.components.timer:StartTimer("kyno_nightkillbuff", TUNING.KYNO_NIGHTKILLBUFF_DURATION)

	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if inst._onhitother == nil then
		inst._onhitother = SetupInstakillOnHit({
			chance          = TUNING.KYNO_NIGHTKILLBUFF_INSTAKILL_CHANCE,
			blocked_tags    = TUNING.KYNO_INSTAKILL_BLACKLIST_TAGS,
			blocked_prefabs = TUNING.KYNO_INSTAKILL_BLACKLIST_PREFABS,
			require_night   = true,
			fx_prefab       = "planar_hit_fx",
		})

		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_NIGHTKILLBUFF_START"))
	end
end

local function fn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		return inst
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
	inst.components.timer:StartTimer("kyno_nightkillbuff", TUNING.KYNO_NIGHTKILLBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_nightkillbuff", fn)