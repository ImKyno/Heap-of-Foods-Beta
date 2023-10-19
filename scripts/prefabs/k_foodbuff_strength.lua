local function OnAttached(inst, target)	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
	
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff", TUNING.KYNO_ALCOHOL_SPEED)
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.KYNO_ALCOHOL_STRENGTH_SMALL, "kyno_strengthbuff")
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:RemoveTag("groggy")
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_strengthbuff")
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:RemoveModifier(inst, "kyno_strengthbuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_strengthbuff")
    inst.components.timer:StartTimer("kyno_strengthbuff", TUNING.KYNO_ALCOHOL_DURATION_SMALL)
	
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff", TUNING.KYNO_ALCOHOL_SPEED)
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.KYNO_ALCOHOL_STRENGTH_SMALL, "kyno_strengthbuff")
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_strengthbuff" then
        inst.components.debuff:Stop()
    end
end

---------------------------
-- Med Buff.
---------------------------

local function OnAttachedMed(inst, target)	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
	
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff_med", TUNING.KYNO_ALCOHOL_SPEED)
	end	
		
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.KYNO_ALCOHOL_STRENGTH_MEDSMALL, "kyno_strengthbuff_med")
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetachedMed(inst, target)
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:RemoveTag("groggy")
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_strengthbuff_med")
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:RemoveModifier(inst, "kyno_strengthbuff_med")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtendedMed(inst, target)
    inst.components.timer:StopTimer("kyno_strengthbuff_med")
    inst.components.timer:StartTimer("kyno_strengthbuff_med", TUNING.KYNO_ALCOHOL_DURATION_MEDSMALL)
	
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_strengthbuff_med", TUNING.KYNO_ALCOHOL_SPEED)
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.KYNO_ALCOHOL_STRENGTH_MEDSMALL, "kyno_strengthbuff_med")
	end
end

local function OnTimerDoneMed(inst, data)
    if data.name == "kyno_strengthbuff_med" then
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
	inst.components.timer:StartTimer("kyno_strengthbuff", TUNING.KYNO_ALCOHOL_DURATION_SMALL)
	
    inst:ListenForEvent("timerdone", OnTimerDone)
	
    return inst
end

local function medfn()
	local inst = CreateEntity()

    if not TheWorld.ismastersim then 
		return 
	end

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