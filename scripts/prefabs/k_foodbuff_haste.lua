local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 

	if not target:HasTag("fasthands") then
		target:AddTag("fasthands")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_HASTEBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_hastebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if target:HasTag("fasthands") then
		target:RemoveTag("fasthands")
	end
		
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_HASTEBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_hastebuff")
    inst.components.timer:StartTimer("kyno_hastebuff", TUNING.KYNO_HASTEBUFF_DURATION)
	
	if target:HasTag("fasthands") then
		target:RemoveTag("fasthands")
		target:AddTag("fasthands")
	else
		target:AddTag("fasthands")
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
    inst.components.timer:StartTimer("kyno_hastebuff", TUNING.KYNO_HASTEBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

local function OnAttachedEater(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 

	if not target:HasTag("fasteater") then
		target:AddTag("fasteater")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_EATERBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneEater(inst, data)
    if data.name == "kyno_eaterbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedEater(inst, target)
	if target:HasTag("fasteater") then
		target:RemoveTag("fasteater")
	end
		
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_EATERBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtendedEater(inst, target)
    inst.components.timer:StopTimer("kyno_eaterbuff")
    inst.components.timer:StartTimer("kyno_eaterbuff", TUNING.KYNO_EATERBUFF_DURATION)
	
	if target:HasTag("fasteater") then
		target:RemoveTag("fasteater")
		target:AddTag("fasteater")
	else
		target:AddTag("fasteater")
	end
end

local function eaterfn()
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
    inst.components.debuff:SetAttachedFn(OnAttachedEater)
    inst.components.debuff:SetDetachedFn(OnDetachedEater)
    inst.components.debuff:SetExtendedFn(OnExtendedEater)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_eaterbuff", TUNING.KYNO_EATERBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneEater)

    return inst
end

return Prefab("kyno_hastebuff", fn),
Prefab("kyno_eaterbuff", eaterfn)