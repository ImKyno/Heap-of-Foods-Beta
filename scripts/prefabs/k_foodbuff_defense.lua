local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
	
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_dmgreductionbuff", TUNING.KYNO_DMGREDUCTIONBUFF_SPEED)
	end
	
	if target.components.health ~= nil then
		target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.BUFF_PLAYERABSORPTION_MODIFIER, "kyno_dmgreductionbuff")
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:RemoveTag("groggy")
		
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_dmgreductionbuff")
	end
	
	if target.components.health ~= nil then
		target.components.health.externalabsorbmodifiers:RemoveModifier(target, "kyno_dmgreductionbuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_dmgreductionbuff")
    inst.components.timer:StartTimer("kyno_dmgreductionbuff", TUNING.KYNO_ALCOHOL_DURATION_SMALL)
	
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_dmgreductionbuff", TUNING.KYNO_DMGREDUCTIONBUFF_SPEED)
	end
	
	if target.components.health ~= nil then
		target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.BUFF_PLAYERABSORPTION_MODIFIER, "kyno_dmgreductionbuff")
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_dmgreductionbuff" then
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
    inst.components.timer:StartTimer("kyno_dmgreductionbuff", TUNING.KYNO_ALCOHOL_DURATION_SMALL)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_dmgreductionbuff", fn)