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

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_coffeebuff")
    inst.components.timer:StartTimer("kyno_coffeebuff", TUNING.HOF_COFFEEBUFF_DURATION)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
	end
	
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddResistanceSource(target, TUNING.SLEEPRESISTBUFF_VALUE)
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
	inst.components.timer:StartTimer("kyno_coffeebuff", TUNING.HOF_COFFEEBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end
----------------------------------------------------------------------
-- COFFEE GOLDENAPPLE BUFF
----------------------------------------------------------------------
local function OnAttachedAlt(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_coffeealtbuff", TUNING.KYNO_COFFEEBUFF_SPEED)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneAlt(inst, data)
    if data.name == "kyno_coffeealtbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedAlt(inst, target)
	if target.components.locomotor ~= nil then
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_coffeealtbuff")
	end
	
    inst:Remove()
end

local function OnExtendedAlt(inst, target)
    inst.components.timer:StopTimer("kyno_coffeealtbuff")
    inst.components.timer:StartTimer("kyno_coffeealtbuff", TUNING.KYNO_GOLDENAPPLEBUFF_DURATION)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_coffeealtbuff", TUNING.KYNO_COFFEEBUFF_SPEED)
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
	inst.components.timer:StartTimer("kyno_coffeealtbuff", TUNING.KYNO_GOLDENAPPLEBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneAlt)

    return inst
end
----------------------------------------------------------------------
-- MOCHA BUFF
----------------------------------------------------------------------
local function OnAttachedMocha(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_COFFEEBUFF_START"))
	end
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_mochabuff", TUNING.KYNO_MOCHABUFF_SPEED)
	end
	
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddResistanceSource(target, TUNING.SLEEPRESISTBUFF_VALUE)
	end
	
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.HUNGERRATEBUFF_MODIFIER, "kyno_mochabuff")
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneMocha(inst, data)
    if data.name == "kyno_mochabuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedMocha(inst, target)	
	if target.components.locomotor ~= nil then
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_mochabuff")
	end
	
	if target.components.grogginess ~= nil then
        target.components.grogginess:RemoveResistanceSource(target, "kyno_mochabuff")
    end

	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:RemoveModifier(target, "kyno_mochabuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_COFFEEBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtendedMocha(inst, target)
    inst.components.timer:StopTimer("kyno_mochabuff")
    inst.components.timer:StartTimer("kyno_mochabuff", TUNING.HOF_COFFEEBUFF_DURATION)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_mochabuff", TUNING.KYNO_MOCHABUFF_SPEED)
	end
	
	if target.components.grogginess ~= nil then
		target.components.grogginess:AddResistanceSource(target, TUNING.SLEEPRESISTBUFF_VALUE)
	end
	
	if target.components.hunger ~= nil then
		target.components.hunger.burnratemodifiers:SetModifier(target, TUNING.HUNGERRATEBUFF_MODIFIER, "kyno_mochabuff")
	end
end

local function mochafn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
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
    inst.components.timer:StartTimer("kyno_mochabuff", TUNING.HOF_COFFEEBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDoneMocha)

    return inst
end
----------------------------------------------------------------------
-- TIRAMISU BUFF
----------------------------------------------------------------------
local function OnAttachedTiramisu(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_tiramisubuff", TUNING.KYNO_TIRAMISUBUFF_SPEED)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneTiramisu(inst, data)
    if data.name == "kyno_tiramisubuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedTiramisu(inst, target)	
	if target.components.locomotor ~= nil then
		target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_tiramisubuff")
	end
	
    inst:Remove()
end

local function OnExtendedTiramisu(inst, target)
    inst.components.timer:StopTimer("kyno_tiramisubuff")
    inst.components.timer:StartTimer("kyno_tiramisubuff", TUNING.HOF_COFFEEBUFF_DURATION)
	
	if target.components.locomotor ~= nil then
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_tiramisubuff", TUNING.KYNO_TIRAMISUBUFF_SPEED)
	end
end

local function tiramisufn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:AddTransform()
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttachedTiramisu)
    inst.components.debuff:SetDetachedFn(OnDetachedTiramisu)
    inst.components.debuff:SetExtendedFn(OnExtendedTiramisu)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_tiramisubuff", TUNING.HOF_COFFEEBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDoneTiramisu)

    return inst
end

return Prefab("kyno_coffeebuff", fn),
Prefab("kyno_coffeealtbuff", altfn),
Prefab("kyno_mochabuff", mochafn),
Prefab("kyno_tiramisubuff", tiramisufn)