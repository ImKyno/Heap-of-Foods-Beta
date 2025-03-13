local function OnAttachedCold(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target:HasTag("player") and target.components.temperature ~= nil then
		target.components.temperature:SetFreezingHurtRate(TUNING.WILSON_HEALTH / 180)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneCold(inst, data)
    if data.name == "kyno_coldbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedCold(inst, target)
	if target:HasTag("player") and target.components.temperature ~= nil then
		target.components.temperature:SetFreezingHurtRate(TUNING.WILSON_HEALTH / TUNING.FREEZING_KILL_TIME)
	elseif target:HasTag("bernieowner") and target.components.temperature ~= nil then
		target.components.temperature:SetFreezingHurtRate(TUNING.WILSON_HEALTH / TUNING.WILLOW_FREEZING_KILL_TIME)
	end
	
    inst:Remove()
end

local function OnExtendedCold(inst, target)
	inst.components.timer:StopTimer("kyno_coldbuff")
    inst.components.timer:StartTimer("kyno_coldbuff", TUNING.KYNO_COLDBUFF_DURATION)

	if target:HasTag("player") and target.components.temperature ~= nil then
		target.components.temperature:SetFreezingHurtRate(TUNING.WILSON_HEALTH / 180)
	end
end

local function coldfn()
    if not TheWorld.ismastersim then 
		return 
	end

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:Hide()
  
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttachedCold)
    inst.components.debuff:SetDetachedFn(OnDetachedCold)
    inst.components.debuff:SetExtendedFn(OnExtendedCold)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_coldbuff", TUNING.KYNO_COLDBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneCold)

    return inst
end

local function OnAttachedHeat(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target:HasTag("player") and target.components.temperature ~= nil then
		target.components.temperature:SetOverheatHurtRate(TUNING.WILSON_HEALTH / 180)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneHeat(inst, data)
    if data.name == "kyno_heatbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedHeat(inst, target)
	if target:HasTag("player") and target.components.temperature ~= nil then
		target.components.temperature:SetOverheatHurtRate(TUNING.WILSON_HEALTH / TUNING.FREEZING_KILL_TIME)
	elseif target:HasTag("bernieowner") and target.components.temperature ~= nil then
		target.components.temperature:SetOverheatHurtRate(TUNING.WILSON_HEALTH / TUNING.WILLOW_OVERHEAT_KILL_TIME)
	end
	
    inst:Remove()
end

local function OnExtendedHeat(inst, target)
	inst.components.timer:StopTimer("kyno_heatbuff")
    inst.components.timer:StartTimer("kyno_heatbuff", TUNING.KYNO_HEATBUFF_DURATION)

	if target:HasTag("player") and target.components.temperature ~= nil then
		target.components.temperature:SetOverheatHurtRate(TUNING.WILSON_HEALTH / 180)
	end
end

local function heatfn()
    if not TheWorld.ismastersim then 
		return 
	end

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:Hide()
  
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttachedHeat)
    inst.components.debuff:SetDetachedFn(OnDetachedHeat)
    inst.components.debuff:SetExtendedFn(OnExtendedHeat)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_heatbuff", TUNING.KYNO_HEATBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneHeat)

    return inst
end

return Prefab("kyno_coldbuff", coldfn),
Prefab("kyno_heatbuff", heatfn)