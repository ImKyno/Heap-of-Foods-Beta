---------------------------------------------------------------------------
-- Pirate Buff
---------------------------------------------------------------------------
local function ApplyPirateBonusDamage(inst, target, damage, weapon)
    return (target:HasTag("pirate") and TUNING.KYNO_PIRATEBUFF_EXTRADAMAGE) or 0
end

local function ClearPirateBonusDamage(inst, target, damage, weapon)
	return 0
end

local function OnAttachedPirate(inst, target)
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

local function OnTimerDonePirate(inst, data)
    if data.name == "kyno_piratebuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedPirate(inst, target)
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = nil
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_PIRATEBUFF_END"))
		end
	end
	
    inst:Remove()
end

local function OnExtendedPirate(inst, target)
    inst.components.timer:StopTimer("kyno_piratebuff")
    inst.components.timer:StartTimer("kyno_piratebuff", TUNING.KYNO_PIRATEBUFF_DURATION)
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = ApplyPirateBonusDamage
	end
end

local function piratefn()
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
    inst.components.debuff:SetAttachedFn(OnAttachedPirate)
    inst.components.debuff:SetDetachedFn(OnDetachedPirate)
    inst.components.debuff:SetExtendedFn(OnExtendedPirate)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_piratebuff", TUNING.KYNO_PIRATEBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDonePirate)

    return inst
end

---------------------------------------------------------------------------
-- Worm Buff
---------------------------------------------------------------------------
local function ApplyWormBonusDamage(inst, target, damage, weapon)
	local WORM_TAGS = {"worm", "worm_boss_piece"}

    return (target:HasOneOfTags(WORM_TAGS) and TUNING.KYNO_WORMBUFF_EXTRADAMAGE) or 0
end

local function ClearWormBonusDamage(inst, target, damage, weapon)
	return 0
end

local function OnAttachedWorm(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    
	if target.components.combat ~= nil and target:HasTag("player") then	
		target.components.combat.bonusdamagefn = ApplyWormBonusDamage
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WORMBUFF_START"))
		end
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneWorm(inst, data)
    if data.name == "kyno_wormbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedWorm(inst, target)
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = nil
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_WORMBUFF_END"))
		end
	end
	
    inst:Remove()
end

local function OnExtendedWorm(inst, target)
    inst.components.timer:StopTimer("kyno_wormbuff")
    inst.components.timer:StartTimer("kyno_wormbuff", TUNING.KYNO_WORMBUFF_DURATION)
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = ApplyWormBonusDamage
	end
end

local function wormfn()
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
    inst.components.debuff:SetAttachedFn(OnAttachedWorm)
    inst.components.debuff:SetDetachedFn(OnDetachedWorm)
    inst.components.debuff:SetExtendedFn(OnExtendedWorm)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_wormbuff", TUNING.KYNO_WORMBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDoneWorm)

    return inst
end

---------------------------------------------------------------------------
-- Crab Buff
---------------------------------------------------------------------------
local function ApplyCrabBonusDamage(inst, target, damage, weapon)
	local CRAB_TAGS = {"crabking", "crabking_ally", "crab_mob"}

    return (target:HasOneOfTags(CRAB_TAGS) and TUNING.KYNO_CRABBUFF_EXTRADAMAGE) or 0
end

local function ClearCrabBonusDamage(inst, target, damage, weapon)
	return 0
end

local function OnAttachedCrab(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
    
	if target.components.combat ~= nil and target:HasTag("player") then	
		target.components.combat.bonusdamagefn = ApplyCrabBonusDamage
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRABBUFF_START"))
		end
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDoneCrab(inst, data)
    if data.name == "kyno_crabbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetachedCrab(inst, target)
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = nil
		
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_CRABBUFF_END"))
		end
	end
	
    inst:Remove()
end

local function OnExtendedCrab(inst, target)
    inst.components.timer:StopTimer("kyno_crabbuff")
    inst.components.timer:StartTimer("kyno_crabbuff", TUNING.KYNO_CRABBUFF_DURATION)
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.bonusdamagefn = ApplyCrabBonusDamage
	end
end

local function crabfn()
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
    inst.components.debuff:SetAttachedFn(OnAttachedCrab)
    inst.components.debuff:SetDetachedFn(OnDetachedCrab)
    inst.components.debuff:SetExtendedFn(OnExtendedCrab)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("kyno_crabbuff", TUNING.KYNO_CRABBUFF_DURATION)
    
	inst:ListenForEvent("timerdone", OnTimerDoneCrab)

    return inst
end

return Prefab("kyno_piratebuff", piratefn),
Prefab("kyno_wormbuff", wormfn),
Prefab("kyno_crabbuff", crabfn)