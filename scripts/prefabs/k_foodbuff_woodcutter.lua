local function GetBuffDuration(target)
	if target ~= nil and target.prefab == "woodie" then
		return TUNING.KYNO_WOODCUTTERBUFF_DURATION * 2 -- Woodie gets to keep this buff for longer.
	end

	return TUNING.KYNO_WOODCUTTERBUFF_DURATION
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	inst.components.timer:StartTimer("kyno_woodcutterbuff", GetBuffDuration(target))

	if target ~= nil and target:HasTag("player") then
		target.tagvar_luckywoodcutter = true
	end

	if target.components.talker and target:HasTag("player") and not target:HasTag("wereplayer") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WOODCUTTERBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_woodcutterbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetached(inst, target)
	if target.tagvar_luckywoodcutter ~= nil then
		target.tagvar_luckywoodcutter = false
	end

	if target.components.talker and target:HasTag("player") and not target:HasTag("wereplayer") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WOODCUTTERBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_woodcutterbuff")
	inst.components.timer:StartTimer("kyno_woodcutterbuff", GetBuffDuration(target))

	if target ~= nil and target:HasTag("player") then
		target.tagvar_luckywoodcutter = true
	end

	if target.components.talker and target:HasTag("player") and not target:HasTag("wereplayer") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WOODCUTTERBUFF_START"))
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
	-- inst.components.timer:StartTimer("kyno_woodcutterbuff", TUNING.KYNO_WOODCUTTERBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_woodcutterbuff", fn)