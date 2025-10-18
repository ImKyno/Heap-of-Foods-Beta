local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if not target:HasTag("acidrainimmune") then
		target:AddTag("acidrainimmune")
	end
	
	if not target:HasTag("spoiler") then
		target:AddTag("spoiler")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ACIDIMMUNITYBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if target:HasTag("acidrainimmune") then
		target:RemoveTag("acidrainimmune")
	end
	
	if target:HasTag("spoiler") then
		target:RemoveTag("spoiler")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_HEALINGSALVE_ACIDBUFF_DONE"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_acidimmunitybuff")
    inst.components.timer:StartTimer("kyno_acidimmunitybuff", TUNING.KYNO_ACIDIMMUNITYBUFF_DURATION)

	if target:HasTag("acidrainimmune") then
		target:RemoveTag("acidrainimmune")
		target:AddTag("acidrainimmune")
	else
		target:AddTag("acidrainimmune")
	end
	
	if target:HasTag("spoiler") then
		target:RemoveTag("spoiler")
		target:AddTag("spoiler")
	else
		target:AddTag("spoiler")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ACIDIMMUNITYBUFF_START"))
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_acidimmunitybuff" then
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
	inst.components.timer:StartTimer("kyno_acidimmunitybuff", TUNING.KYNO_ACIDIMMUNITYBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end
---------------------------------------------------------------------------
-- No Spoiler Version
---------------------------------------------------------------------------
local function OnAttachedAlt(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if not target:HasTag("acidrainimmune") then
		target:AddTag("acidrainimmune")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ACIDIMMUNITYBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetachedAlt(inst, target)
	if target:HasTag("acidrainimmune") then
		target:RemoveTag("acidrainimmune")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_HEALINGSALVE_ACIDBUFF_DONE"))
	end
	
    inst:Remove()
end

local function OnExtendedAlt(inst, target)
	inst.components.timer:StopTimer("kyno_acidimmunityaltbuff")
    inst.components.timer:StartTimer("kyno_acidimmunityaltbuff", TUNING.KYNO_ACIDIMMUNITYALTBUFF_DURATION)

	if target:HasTag("acidrainimmune") then
		target:RemoveTag("acidrainimmune")
		target:AddTag("acidrainimmune")
	else
		target:AddTag("acidrainimmune")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_ACIDIMMUNITYBUFF_START"))
	end
end

local function OnTimerDoneAlt(inst, data)
    if data.name == "kyno_acidimmunityaltbuff" then
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
	inst.components.timer:StartTimer("kyno_acidimmunityaltbuff", TUNING.KYNO_ACIDIMMUNITYALTBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneAlt)

    return inst
end

return Prefab("kyno_acidimmunitybuff", fn),
Prefab("kyno_acidimmunityaltbuff", altfn)