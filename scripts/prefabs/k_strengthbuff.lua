local function OnAttached(inst, target)
    if target.strengthbuff_duration then
        inst.components.timer:StartTimer("kyno_strengthbuff_done", target.strengthbuff_duration)
    end
	
    if not inst.components.timer:TimerExists("kyno_strengthbuff_done") then
        inst.components.debuff:Stop()
        return
    end
	
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
    target:AddTag("groggy")
	target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff", .70)
	target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.BUFF_ATTACK_MULTIPLIER)
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	target:RemoveTag("groggy")
	target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_strengthbuff")
	target.components.combat.externaldamagemultipliers:RemoveModifier(inst)
	
    inst:Remove()
end

local function OnExtended(inst, target)
    local current_duration = inst.components.timer:GetTimeLeft("kyno_strengthbuff_done")
    local new_duration = math.max(current_duration, target.strengthbuff_duration)
	
    inst.components.timer:StopTimer("kyno_strengthbuff_done")
    inst.components.timer:StartTimer("kyno_strengthbuff_done", new_duration)
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
    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "kyno_strengthbuff_done" then
            inst.components.debuff:Stop()
        end
    end)

    return inst
end

return Prefab("kyno_strengthbuff", fn)