local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_COFFEEBUFF_START"))
	end
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
	end
	
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddResistanceSource(target, TUNING.SLEEPRESISTBUFF_VALUE)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_coffeebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnAttachedMocha(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_COFFEEBUFF_START"))
	end
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_hungerratebuff", TUNING.KYNO_MOCHABUFF_SPEED)
	end
	
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddResistanceSource(target, TUNING.SLEEPRESISTBUFF_VALUE)
	end
	
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.HUNGERRATEBUFF_MODIFIER)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneMocha(inst, data)
    if data.name == "kyno_hungerratebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if target.components.locomotor ~= nil then
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_coffeebuff")
	end

	if target.components.grogginess ~= nil then
        target.components.grogginess:RemoveResistanceSource(target, "kyno_coffeebuff")
    end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_COFFEEBUFF_END"))
	end
	
    inst:Remove()
end

local function OnDetachedMocha(inst, target)	
	if target.components.locomotor ~= nil then
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_hungerratebuff")
	end
	
	if target.components.grogginess ~= nil then
        target.components.grogginess:RemoveResistanceSource(target, "kyno_hungerratebuff")
    end

	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:RemoveModifier(target, "kyno_hungerratebuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_COFFEEBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_coffeebuff")
    inst.components.timer:StartTimer("kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_DURATION_MED)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
	end
	
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddResistanceSource(target, TUNING.SLEEPRESISTBUFF_VALUE)
	end
end

local function OnExtendedMocha(inst, target)
    inst.components.timer:StopTimer("kyno_hungerratebuff")
    inst.components.timer:StartTimer("kyno_hungerratebuff", TUNING.KYNO_HUNGERRATEBUFF_DURATION)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_hungerratebuff", TUNING.KYNO_MOCHABUFF_SPEED)
	end
	
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddResistanceSource(target, TUNING.SLEEPRESISTBUFF_VALUE)
	end
	
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.HUNGERRATEBUFF_MODIFIER)
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
	inst.components.timer:StartTimer("kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_DURATION_MED)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

local function mochafn()
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
    inst.components.debuff:SetAttachedFn(OnAttachedMocha)
    inst.components.debuff:SetDetachedFn(OnDetachedMocha)
    inst.components.debuff:SetExtendedFn(OnExtendedMocha)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_hungerratebuff", TUNING.KYNO_HUNGERRATEBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDoneMocha)

    return inst
end

return Prefab("kyno_coffeebuff", fn),
Prefab("kyno_hungerratebuff", mochafn)