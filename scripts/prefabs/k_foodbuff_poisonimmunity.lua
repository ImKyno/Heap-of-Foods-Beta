local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if not target:HasTag("sporecloudimmune") then
		target:AddTag("sporecloudimmune")
	end
	
	if not target:HasTag("spoiler") then
		target:AddTag("spoiler")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POISONIMMUNITYBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if target:HasTag("sporecloudimmune") then
		target:RemoveTag("sporecloudimmune")
	end
	
	if target:HasTag("spoiler") then
		target:RemoveTag("spoiler")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POISONIMMUNITYBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_poisonimmunitybuff")
    inst.components.timer:StartTimer("kyno_poisonimmunitybuff", TUNING.KYNO_POISONIMMUNITYBUFF_DURATION)

	if target:HasTag("sporecloudimmune") then
		target:RemoveTag("sporecloudimmune")
		target:AddTag("sporecloudimmune")
	else
		target:AddTag("sporecloudimmune")
	end
	
	if target:HasTag("spoiler") then
		target:RemoveTag("spoiler")
		target:AddTag("spoiler")
	else
		target:AddTag("spoiler")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POISONIMMUNITYBUFF_START"))
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_poisonimmunitybuff" then
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
	inst.components.timer:StartTimer("kyno_poisonimmunitybuff", TUNING.KYNO_POISONIMMUNITYBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end
---------------------------------------------------------------------------
-- No Spoiler Version
---------------------------------------------------------------------------
local function OnAttachedAlt(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if not target:HasTag("sporecloudimmune") then
		target:AddTag("sporecloudimmune")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POISONIMMUNITYBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetachedAlt(inst, target)
	if target:HasTag("sporecloudimmune") then
		target:RemoveTag("sporecloudimmune")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POISONIMMUNITYBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtendedAlt(inst, target)
	inst.components.timer:StopTimer("kyno_poisonimmunityaltbuff")
    inst.components.timer:StartTimer("kyno_poisonimmunityaltbuff", TUNING.KYNO_POISONIMMUNITYALTBUFF_DURATION)

	if target:HasTag("sporecloudimmune") then
		target:RemoveTag("sporecloudimmune")
		target:AddTag("sporecloudimmune")
	else
		target:AddTag("sporecloudimmune")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POISONIMMUNITYBUFF_START"))
	end
end

local function OnTimerDoneAlt(inst, data)
    if data.name == "kyno_poisonimmunityaltbuff" then
        inst.components.debuff:Stop()
    end
end

local function altfn()
    if not TheWorld.ismastersim then 
		return 
	end

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:Hide()
  
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttachedAlt)
    inst.components.debuff:SetDetachedFn(OnDetachedAlt)
    inst.components.debuff:SetExtendedFn(OnExtendedAlt)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_poisonimmunityaltbuff", TUNING.KYNO_POISONIMMUNITYALTBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneAlt)

    return inst
end

return Prefab("kyno_poisonimmunitybuff", fn),
Prefab("kyno_poisonimmunityaltbuff", altfn)