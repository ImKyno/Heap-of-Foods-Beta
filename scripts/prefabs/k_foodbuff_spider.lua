-- Webber doesn't benefit from this buff.
local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    
	if not target:HasTag("spiderwhisperer") then
		target:AddTag("spiderdisguise")
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_SPIDERBUFF_START"))
		end
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_spiderbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if not target:HasTag("spiderwhisperer") then
		target:RemoveTag("spiderdisguise")
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_SPIDERBUFF_END"))
		end
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_spiderbuff")
    inst.components.timer:StartTimer("kyno_spiderbuff", TUNING.KYNO_SPIDERBUFF_DURATION)
	
	if not target:HasTag("spiderwhisperer") then
		target:RemoveTag("spiderdisguise")
		target:AddTag("spiderdisguise")
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
    inst.components.timer:StartTimer("kyno_spiderbuff", TUNING.KYNO_SPIDERBUFF_DURATION)
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_spiderbuff", fn)