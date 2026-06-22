local function OnTick(inst, target)
	if target.components.talker and target.components.health ~= nil
	and not target.components.health:IsDead() and target:HasTag("idle") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ICENETTLE_TOXIN_START"))
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.temperature ~= nil then
		target.components.temperature:SetModifier("kyno_icenettle_toxin", TUNING.KYNO_ICENETTLE_TOXIN_TEMP_MODIFIER)
	end

	inst:DoPeriodicTask(10, OnTick, 5, target)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnExpire(inst)
	if inst.components.debuff ~= nil then
		inst.components.debuff:Stop()
	end
end

local function OnDetached(inst, target)
	if target ~= nil and target:IsValid() and target.components.temperature ~= nil then
		target.components.temperature:RemoveModifier("firenettle_toxin")

		if target.components.talker and target:HasTag("player") then
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ICENETTLE_TOXIN_END"))
		end
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	if inst.task ~= nil then
		inst.task:Cancel()
	end

	inst.task = inst:DoTaskInTime(TUNING.KYNO_ICENETTLE_TOXIN_DURATION, OnExpire)
end

local function OnSave(inst, data)
	if inst.task ~= nil then
		data.remaining = GetTaskRemaining(inst.task)
	end
end

local function OnLoad(inst, data)
	if data ~= nil and data.remaining then
		if inst.task ~= nil then
			inst.task:Cancel()
		end

		inst.task = inst:DoTaskInTime(data.remaining, OnExpire)
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

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff:SetExtendedFn(OnExtended)
	inst.components.debuff.keepondespawn = true

	OnExtended(inst)

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	return inst
end

return Prefab("kyno_icenettle_toxin", fn)