local function ApplyPirateBonusDamage(inst, target, damage, weapon)
    return (target:HasTag("pirate") and TUNING.KYNO_PIRATEBUFF_EXTRADAMAGE) or 0
end

local function ClearPirateBonusDamage(inst, target, damage, weapon)
	return 0
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    
	if target.components.combat ~= nil and target:HasTag("player") then	
		target.components.combat.bonusdamagefn = ApplyPirateBonusDamage
	
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PIRATEBUFF_START"))
		end
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_piratebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = nil
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PIRATEBUFF_END"))
		end
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_piratebuff")
    inst.components.timer:StartTimer("kyno_piratebuff", TUNING.KYNO_PIRATEBUFF_DURATION)
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = ApplyPirateBonusDamage
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
    inst.components.timer:StartTimer("kyno_piratebuff", TUNING.KYNO_PIRATEBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_piratebuff", fn)