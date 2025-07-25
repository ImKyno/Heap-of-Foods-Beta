local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.sanity ~= nil then 
		target.components.sanity:SetInducedLunacy(inst, true)
		target.components.sanity:EnableLunacy(true, "kyno_enlightenmentbuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ENLIGHTENMENTBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_enlightenmentbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if target.components.sanity ~= nil then 
		target.components.sanity:SetInducedLunacy(inst, false)
		target.components.sanity:EnableLunacy(false, "kyno_enlightenmentbuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ENLIGHTENMENTBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_enlightenmentbuff")
    inst.components.timer:StartTimer("kyno_enlightenmentbuff", TUNING.KYNO_ENLIGHTENMENTBUFF_DURATION)
	
	if target.components.sanity ~= nil then 
		target.components.sanity:SetInducedLunacy(inst, true)
		target.components.sanity:EnableLunacy(true, "kyno_enlightenmentbuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ENLIGHTENMENTBUFF_START"))
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
    inst.components.timer:StartTimer("kyno_enlightenmentbuff", TUNING.KYNO_ENLIGHTENMENTBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_enlightenmentbuff", fn)