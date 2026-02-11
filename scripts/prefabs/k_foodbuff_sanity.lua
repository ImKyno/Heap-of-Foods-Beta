local function OnTick(inst, target)
	if target.components.sanity ~= nil then
		if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
			target.components.sanity:DoDelta(TUNING.JELLYBEAN_TICK_VALUE, nil, "jellybean")
		else
			inst.components.debuff:Stop()
		end
	end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
	
    inst.task = inst:DoPeriodicTask(TUNING.JELLYBEAN_TICK_RATE, OnTick, nil, target)
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "regenover" then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("regenover")
    inst.components.timer:StartTimer("regenover", TUNING.JELLYBEAN_DURATION)
	
    inst.task:Cancel()
    inst.task = inst:DoPeriodicTask(TUNING.JELLYBEAN_TICK_RATE, OnTick, nil, target)
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
    inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("regenover", TUNING.JELLYBEAN_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end
----------------------------------------------------------------------
-- SANITYRATE BUFF
----------------------------------------------------------------------
local function OnAttachedSanity(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_SANITYRATEBUFF_START"))
	end
	
	if target.components.sanity ~= nil then
		target.components.sanity.externalmodifiers:SetModifier(target, TUNING.KYNO_SANITYRATEBUFF_MODIFIER, "kyno_sanityratebuff")
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneSanity(inst, data)
    if data.name == "kyno_sanityratebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnExtendedSanity(inst, target)
	inst.components.timer:StopTimer("kyno_sanityratebuff")
    inst.components.timer:StartTimer("kyno_sanityratebuff", TUNING.KYNO_SANITYRATEBUFF_DURATION)
	
	if target.components.sanity ~= nil then
		target.components.sanity.externalmodifiers:SetModifier(target, TUNING.KYNO_SANITYRATEBUFF_MODIFIER, "kyno_sanityratebuff")
	end
end

local function OnDetachedSanity(inst, target)	
	if target.components.sanity ~= nil then
		target.components.sanity.externalmodifiers:RemoveModifier(target, "kyno_sanityratebuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_SANITYRATEBUFF_END"))
	end
	
    inst:Remove()
end

local function sanityfn()
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
    inst.components.debuff:SetAttachedFn(OnAttachedSanity)
    inst.components.debuff:SetDetachedFn(OnDetachedSanity)
    inst.components.debuff:SetExtendedFn(OnExtendedSanity)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_sanityratebuff", TUNING.KYNO_SANITYRATEBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDoneSanity)

    return inst
end

return Prefab("kyno_sanityregenbuff", fn),
Prefab("kyno_sanityratebuff", sanityfn)