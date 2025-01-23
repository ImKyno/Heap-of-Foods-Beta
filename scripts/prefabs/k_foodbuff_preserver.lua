local function PreserverRate(inst, item)
	return (item ~= nil and item.components.perishable) and TUNING.KYNO_PRESERVERBUFF_RATE or nil
end

local function FishPreserverRate(inst, item)
	return (item ~= nil and item:HasTag("fish")) and TUNING.WURT_FISH_PRESERVER_RATE or nil
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target ~= nil and target.components.inventory ~= nil and not target.components.preserver then
		target:AddComponent("preserver")
		target.components.preserver:SetPerishRateMultiplier(PreserverRate)
	else
		target.components.preserver:SetPerishRateMultiplier(PreserverRate)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if target ~= nil and target.components.inventory ~= nil then
		target:RemoveComponent("preserver")
		target.components.preserver:SetPerishRateMultiplier(nil)
	elseif target ~= nil and target.components.inventory ~= nil and target:HasTag("playermerm") then
		target.components.preserver:SetPerishRateMultiplier(FishPreserverRate)
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_preserverbuff")
    inst.components.timer:StartTimer("kyno_preserverbuff", TUNING.KYNO_PRESERVERBUFF_DURATION)

	if target ~= nil and target.components.inventory ~= nil and not target.components.preserver then
		target:AddComponent("preserver")
		target.components.preserver:SetPerishRateMultiplier(PreserverRate)
	else
		target.components.preserver:SetPerishRateMultiplier(PreserverRate)
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_preserverbuff" then
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
	inst.components.timer:StartTimer("kyno_preserverbuff", TUNING.KYNO_PRESERVERBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_preserverbuff", fn)