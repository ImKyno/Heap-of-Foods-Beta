local function OnTick(inst, target)
	if target.components.hunger ~= nil then
		if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
			target.components.hunger:DoDelta(TUNING.JELLYBEAN_TICK_VALUE, nil, "jellybean")
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
-- HUNGERRATE BUFF
----------------------------------------------------------------------
local function OnAttachedHunger(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_HUNGERRATEBUFF_START"))
	end
	
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.KYNO_HUNGERRATEBUFF_MODIFIER, "kyno_hungerratebuff")
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneHunger(inst, data)
    if data.name == "kyno_hungerratebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnExtendedHunger(inst, target)
	inst.components.timer:StopTimer("kyno_hungerratebuff")
    inst.components.timer:StartTimer("kyno_hungerratebuff", TUNING.KYNO_HUNGERRATEBUFF_DURATION)
	
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.KYNO_HUNGERRATEBUFF_MODIFIER, "kyno_hungerratebuff")
	end
end

local function OnDetachedHunger(inst, target)	
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:RemoveModifier(inst, "kyno_hungerratebuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_HUNGERRATEBUFF_END"))
	end
	
    inst:Remove()
end

local function hungerfn()
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
    inst.components.debuff:SetAttachedFn(OnAttachedHunger)
    inst.components.debuff:SetDetachedFn(OnDetachedHunger)
    inst.components.debuff:SetExtendedFn(OnExtendedHunger)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_hungerratebuff", TUNING.KYNO_HUNGERRATEBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDoneHunger)

    return inst
end

return Prefab("kyno_hungerregenbuff", fn),
Prefab("kyno_hungerratebuff", hungerfn)