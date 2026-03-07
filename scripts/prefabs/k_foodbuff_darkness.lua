local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    
	if target.components.grue ~= nil then
		target.components.grue:AddImmunity("kyno_darknessbuff")
	end
	
	if target.components.sanity ~= nil then
		target.components.sanity:SetLightDrainImmune(true, "kyno_darknessbuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_DARKNESSBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_darknessbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if target.components.grue ~= nil then
		target.components.grue:RemoveImmunity("kyno_darknessbuff")
	end
	
	if target.components.sanity ~= nil then
		target.components.sanity:SetLightDrainImmune(false, "kyno_darknessbuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_DARKNESSBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_darknessbuff")
    inst.components.timer:StartTimer("kyno_darknessbuff", TUNING.KYNO_DARKNESSBUFF_DURATION)
	
	if target.components.grue ~= nil then
		target.components.grue:AddImmunity("kyno_darknessbuff")
	end
	
	if target.components.sanity ~= nil then
		target.components.sanity:SetLightDrainImmune(true, "kyno_darknessbuff")
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
    inst.components.timer:StartTimer("kyno_darknessbuff", TUNING.KYNO_DARKNESSBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_darknessbuff", fn)