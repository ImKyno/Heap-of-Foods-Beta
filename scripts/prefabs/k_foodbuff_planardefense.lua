local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.planardefense ~= nil then 
		-- target.components.planardefense:AddMultiplier(target, TUNING.KYNO_PLANARDEFENSEBUFF_BONUS, "kyno_planardefensebuff")
		target.components.planardefense:AddBonus(target, TUNING.KYNO_PLANARDEFENSEBUFF_BONUS, "kyno_planardefensebuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PLANARDEFENSEBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_planardefensebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if target.components.planardefense ~= nil then
		-- target.components.planardefense:RemoveMultiplier(target, "kyno_planardefensebuff")
		target.components.planardefense:RemoveBonus(target, "kyno_planardefensebuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PLANARDEFENSEBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_planardefensebuff")
    inst.components.timer:StartTimer("kyno_planardefensebuff", TUNING.KYNO_PLANARDEFENSEBUFF_DURATION)
	
	if target.components.planardefense ~= nil then
		-- target.components.planardefense:AddMultiplier(target, TUNING.KYNO_PLANARDEFENSEBUFF_BONUS, "kyno_planardefensebuff")
		target.components.planardefense:AddBonus(target, TUNING.KYNO_PLANARDEFENSEBUFF_BONUS, "kyno_planardefensebuff")
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PLANARDEFENSEBUFF_START"))
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
    inst.components.timer:StartTimer("kyno_planardefensebuff", TUNING.KYNO_PLANARDEFENSEBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_planardefensebuff", fn)