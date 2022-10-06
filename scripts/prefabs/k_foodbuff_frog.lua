local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
   
	target:AddTag("frogimmunity")
		
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FROGBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_frogbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	target:RemoveTag("frogimmunity")
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FROGBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_frogbuff")
    inst.components.timer:StartTimer("kyno_frogbuff", TUNING.KYNO_FROGBUFF_DURATION)
			
	target:RemoveTag("frogimmunity")
	target:AddTag("frogimmunity")
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
    inst.components.timer:StartTimer("kyno_frogbuff", TUNING.KYNO_FROGBUFF_DURATION)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_frogbuff", fn)