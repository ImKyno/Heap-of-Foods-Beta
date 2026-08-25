local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.luckuser ~= nil then
		target.components.luckuser:SetLuckSource(TUNING.KYNO_LUCKBUFF_AMOUNT, "kyno_luckbuff")
	end

	-- Don't say anything because we already do from dailyrecipeeaten event.

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_luckbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetached(inst, target)
	if target.components.luckuser ~= nil then
		target.components.luckuser:RemoveLuckSource("kyno_luckbuff")
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_LUCKBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_luckbuff")
	inst.components.timer:StartTimer("kyno_luckbuff", TUNING.KYNO_LUCKBUFF_DURATION)

	if target.components.luckuser ~= nil then
		target.components.luckuser:SetLuckSource(TUNING.KYNO_LUCKBUFF_AMOUNT, "kyno_luckbuff")
	end
end

local function fn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		inst:DoTaskInTime(0, inst.Remove)
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
	inst.components.timer:StartTimer("kyno_luckbuff", TUNING.KYNO_LUCKBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end
---------------------------------------------------------------------------
-- Bad Luck Buff
---------------------------------------------------------------------------
local function OnAttachedBad(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.luckuser ~= nil then
		target.components.luckuser:SetLuckSource(TUNING.KYNO_BADLUCKBUFF_AMOUNT, "kyno_badluckbuff")
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_BADLUCKBUFF_START"))
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDoneBad(inst, data)
	if data.name == "kyno_badluckbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetachedBad(inst, target)
	if target.components.luckuser ~= nil then
		target.components.luckuser:RemoveLuckSource("kyno_badluckbuff")
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_BADLUCKBUFF_END"))
	end

	inst:Remove()
end

local function OnExtendedBad(inst, target)
	inst.components.timer:StopTimer("kyno_badluckbuff")
	inst.components.timer:StartTimer("kyno_badluckbuff", TUNING.KYNO_BADLUCKBUFF_DURATION)

	if target.components.luckuser ~= nil then
		target.components.luckuser:SetLuckSource(TUNING.KYNO_BADLUCKBUFF_AMOUNT, "kyno_badluckbuff")
	end
end

local function badfn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		inst:DoTaskInTime(0, inst.Remove)
		return inst
	end

	inst.entity:AddTransform()
	inst.entity:Hide()
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedBad)
	inst.components.debuff:SetDetachedFn(OnDetachedBad)
	inst.components.debuff:SetExtendedFn(OnExtendedBad)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_badluckbuff", TUNING.KYNO_BADLUCKBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDoneBad)

	return inst
end

return Prefab("kyno_luckbuff", fn),
Prefab("kyno_badluckbuff", badfn)