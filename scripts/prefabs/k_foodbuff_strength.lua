local function OnAttached(inst, target)	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
	
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
    target:AddTag("groggy")
	target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff", TUNING.KYNO_ALCOHOL_SPEED)
	target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_ALCOHOL_STRENGTH_SMALL)
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	target:RemoveTag("groggy")
	target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_strengthbuff")
	target.components.combat.externaldamagemultipliers:RemoveModifier(target)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_strengthbuff")
    inst.components.timer:StartTimer("kyno_strengthbuff", TUNING.KYNO_ALCOHOL_DURATION_SMALL)
	
	target:AddTag("groggy")
	target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff", TUNING.KYNO_ALCOHOL_SPEED)
	target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_ALCOHOL_STRENGTH_SMALL)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_strengthbuff" then
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
	inst.components.timer:StartTimer("kyno_strengthbuff", TUNING.KYNO_ALCOHOL_DURATION_SMALL)
    inst:ListenForEvent("timerdone", OnTimerDone)
	
    return inst
end

local function OnAttachedMed(inst, target)	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
	
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
    target:AddTag("groggy")
	target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff_med", TUNING.KYNO_ALCOHOL_SPEED)
	target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_ALCOHOL_STRENGTH_MEDSMALL)
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetachedMed(inst, target)
	target:RemoveTag("groggy")
	target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_strengthbuff_med")
	target.components.combat.externaldamagemultipliers:RemoveModifier(target)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtendedMed(inst, target)
    inst.components.timer:StopTimer("kyno_strengthbuff_med")
    inst.components.timer:StartTimer("kyno_strengthbuff_med", TUNING.KYNO_ALCOHOL_DURATION_MEDSMALL)
	
	target:AddTag("groggy")
	target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff_med", TUNING.KYNO_ALCOHOL_SPEED)
	target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_ALCOHOL_STRENGTH_MEDSMALL)
end

local function OnTimerDoneMed(inst, data)
    if data.name == "kyno_strengthbuff_med" then
        inst.components.debuff:Stop()
    end
end

local function medfn()
    if not TheWorld.ismastersim then 
		return 
	end

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:Hide()
  
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttachedMed)
    inst.components.debuff:SetDetachedFn(OnDetachedMed)
    inst.components.debuff:SetExtendedFn(OnExtendedMed)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_strengthbuff_med", TUNING.KYNO_ALCOHOL_DURATION_MEDSMALL)
    inst:ListenForEvent("timerdone", OnTimerDoneMed)
	
    return inst
end

return Prefab("kyno_strengthbuff", fn),
Prefab("kyno_strengthbuff_med", medfn)