local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 

	if not target:HasTag("beefriendly") then
		target:AddTag("beefriendly")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_BEEFRIENDLYBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_beefriendlybuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if target:HasTag("beefriendly") then
		target:RemoveTag("beefriendly")
	end
		
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_BEEFRIENDLYBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_beefriendlybuff")
    inst.components.timer:StartTimer("kyno_beefriendlybuff", TUNING.KYNO_BEEFRIENDLYBUFF_DURATION)
	
	if target:HasTag("beefriendly") then
		target:RemoveTag("beefriendly")
		target:AddTag("beefriendly")
	else
		target:AddTag("beefriendly")
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
    inst.components.timer:StartTimer("kyno_beefriendlybuff", TUNING.KYNO_BEEFRIENDLYBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_beefriendlybuff", fn)