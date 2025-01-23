local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FIREBUFF_START"))
	end
	
	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
				if data.target.components.burnable ~= nil then
					data.target.components.burnable:Ignite(nil, attacker)
				end
			end
		end
		
		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FIREBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_firebuff")
    inst.components.timer:StartTimer("kyno_firebuff", TUNING.KYNO_FIREBUFF_DURATION)

	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end
	
	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
				if data.target.components.burnable ~= nil then
					data.target.components.burnable:Ignite(nil, attacker)
				end
			end
		end
		
		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_firebuff" then
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
	inst.components.timer:StartTimer("kyno_firebuff", TUNING.KYNO_FIREBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_firebuff", fn)