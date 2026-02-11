local function OnTick(inst, target)
	if target.components.sanity ~= nil then
		if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
			target.components.sanity:DoDelta(TUNING.KYNO_INSANITYBUFF_TICK_VALUE, nil, "kyno_insanitybuff")
		else
			inst.components.debuff:Stop()
		end
    end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
	
    inst.task = inst:DoPeriodicTask(2, OnTick, nil, target)
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", TUNING.JELLYBEAN_DURATION)
	
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(2, OnTick, nil, target)
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("regenover", TUNING.JELLYBEAN_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_insanitybuff", fn)