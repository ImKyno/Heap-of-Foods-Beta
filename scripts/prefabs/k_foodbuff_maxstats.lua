-- Yes, they stack with the anniversary cake slices. A bonus for you. :)
---------------------------------------------------------------------------
-- Max Health
---------------------------------------------------------------------------
local function ApplyHealthBuff(inst, bonus)
	if inst._bonusmaxhealth then
		return false
	end
	
	inst._bonusmaxhealth = bonus

	if inst.components.health ~= nil then
		local current_health = inst.health_percent or inst.components.health:GetPercent()
		inst.health_percent = nil
	
		inst.components.health:SetMaxHealth(inst.components.health.maxhealth + bonus)
		inst.components.health:SetPercent(current_health)
	end
    
    return true
end

local function RemoveHealthBuff(inst)	
	if not inst._bonusmaxhealth then
		return
	end
    
	if inst.components.health ~= nil then
		local current_health = inst.health_percent or inst.components.health:GetPercent()
		inst.health_percent = nil
	
		inst.components.health:SetMaxHealth(inst.components.health.maxhealth - inst._bonusmaxhealth)
		inst.components.health:SetPercent(current_health)
	end
	
	inst._bonusmaxhealth = nil
end

local function OnAttachedHealth(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end

	if target:HasTag("player") then
		ApplyHealthBuff(target, TUNING.KYNO_MAXHEALTHBUFF_BONUS)
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetachedHealth(inst, target)
	if target:HasTag("player") then
		RemoveHealthBuff(target)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_END"))
	end
	
	inst:Remove()
end

local function OnExtendedHealth(inst, target)
	inst.components.timer:StopTimer("kyno_maxhealthbuff")
	inst.components.timer:StartTimer("kyno_maxhealthbuff", TUNING.KYNO_MAXHEALTHBUFF_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end
end

local function OnTimerDoneHealth(inst, data)
	if data.name == "kyno_maxhealthbuff" then
		inst.components.debuff:Stop()
	end
end

local function healthfn()
	if not TheWorld.ismastersim then 
		return 
	end

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
  
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedHealth)
	inst.components.debuff:SetDetachedFn(OnDetachedHealth)
	inst.components.debuff:SetExtendedFn(OnExtendedHealth)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_maxhealthbuff", TUNING.KYNO_MAXHEALTHBUFF_DURATION)
	
	inst:ListenForEvent("timerdone", OnTimerDoneHealth)

	return inst
end
---------------------------------------------------------------------------
-- Max Hunger
---------------------------------------------------------------------------
local function ApplyHungerBuff(inst, bonus)
	if inst._bonusmaxhunger then
		return false
	end
	
	inst._bonusmaxhunger = bonus

	if inst.components.hunger ~= nil then
		local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
		inst.hunger_percent = nil
	
		inst.components.hunger:SetMax(inst.components.hunger.max + bonus)
		inst.components.hunger:SetPercent(current_hunger)
	end
    
	return true
end

local function RemoveHungerBuff(inst)
	if not inst._bonusmaxhunger then
		return
	end
    
	if inst.components.hunger ~= nil then
		local current_hunger = inst.hunger_percent or inst.components.hunger:GetPercent()
		inst.hunger_percent = nil
	
		inst.components.hunger:SetMax(inst.components.hunger.max - inst._bonusmaxhunger)
		inst.components.hunger:SetPercent(current_hunger)
	end
	
	inst._bonusmaxhunger = nil
end

local function OnAttachedHunger(inst, target)	
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_START"))
	end

	if target:HasTag("player") then
		ApplyHungerBuff(target, TUNING.KYNO_MAXHUNGERBUFF_BONUS)
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetachedHunger(inst, target)
	if target:HasTag("player") then
		RemoveHungerBuff(target)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_END"))
	end
	
	inst:Remove()
end

local function OnExtendedHunger(inst, target)
	inst.components.timer:StopTimer("kyno_maxhungerbuff")
	inst.components.timer:StartTimer("kyno_maxhungerbuff", TUNING.KYNO_MAXHUNGERBUFF_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_START"))
	end
end

local function OnTimerDoneHunger(inst, data)
	if data.name == "kyno_maxhungerbuff" then
		inst.components.debuff:Stop()
	end
end

local function hungerfn()
	if not TheWorld.ismastersim then 
		return
	end
	
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
  
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedHunger)
	inst.components.debuff:SetDetachedFn(OnDetachedHunger)
	inst.components.debuff:SetExtendedFn(OnExtendedHunger)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_maxhungerbuff", TUNING.KYNO_MAXHUNGERBUFF_DURATION)
	
	inst:ListenForEvent("timerdone", OnTimerDoneHunger)
	
	return inst
end
---------------------------------------------------------------------------
-- Max Sanity
---------------------------------------------------------------------------
local function ApplySanityBuff(inst, bonus)
	if inst._bonusmaxsanity then
		return false
	end
	
	inst._bonusmaxsanity = bonus

	if inst.components.sanity ~= nil then
		local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
		inst.sanity_percent = nil
	
		inst.components.sanity:SetMax(inst.components.sanity.max + bonus)
		inst.components.sanity:SetPercent(current_sanity)
	end
    
	return true
end

local function RemoveSanityBuff(inst)
	if not inst._bonusmaxsanity then
		return
	end
    
	if inst.components.sanity ~= nil then
		local current_sanity = inst.sanity_percent or inst.components.sanity:GetPercent()
		inst.sanity_percent = nil
		
		inst.components.sanity:SetMax(inst.components.sanity.max - inst._bonusmaxsanity)
		inst.components.sanity:SetPercent(current_sanity)
	end
	
	inst._bonusmaxsanity = nil
end

local function OnAttachedSanity(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0) 
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_START"))
	end
	
	if target:HasTag("player") then
		ApplySanityBuff(target, TUNING.KYNO_MAXSANITYBUFF_BONUS)
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetachedSanity(inst, target)
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_END"))
	end

	if target:HasTag("player") then
		RemoveSanityBuff(target)
	end
	
	inst:Remove()
end

local function OnExtendedSanity(inst, target)
	inst.components.timer:StopTimer("kyno_maxsanitybuff")
	inst.components.timer:StartTimer("kyno_maxsanitybuff", TUNING.KYNO_MAXSANITYBUFF_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_START"))
	end
end

local function OnTimerDoneSanity(inst, data)
    if data.name == "kyno_maxsanitybuff" then
		inst.components.debuff:Stop()
	end
end

local function sanityfn()
	if not TheWorld.ismastersim then
		return inst
	end

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
	
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedSanity)
	inst.components.debuff:SetDetachedFn(OnDetachedSanity)
	inst.components.debuff:SetExtendedFn(OnExtendedSanity)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_maxsanitybuff", TUNING.KYNO_MAXSANITYBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneSanity)

    return inst
end
---------------------------------------------------------------------------
-- Max Health + Hunger + Sanity
---------------------------------------------------------------------------
local function OnAttachedOmni(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end

	if target:HasTag("player") then
		ApplyHealthBuff(target, TUNING.KYNO_MAXOMNIBUFF_BONUS)
		ApplyHungerBuff(target, TUNING.KYNO_MAXOMNIBUFF_BONUS)
		ApplySanityBuff(target, TUNING.KYNO_MAXOMNIBUFF_BONUS)
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetachedOmni(inst, target)
	if target:HasTag("player") then
		RemoveHealthBuff(target)
		RemoveHungerBuff(target)
		RemoveSanityBuff(target)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_END"))
	end
	
	inst:Remove()
end

local function OnExtendedOmni(inst, target)
	inst.components.timer:StopTimer("kyno_maxomnibuff")
	inst.components.timer:StartTimer("kyno_maxomnibuff", TUNING.KYNO_MAXOMNIBUFF_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end
end

local function OnTimerDoneOmni(inst, data)
	if data.name == "kyno_maxomnibuff" then
		inst.components.debuff:Stop()
	end
end

local function omnifn()
	if not TheWorld.ismastersim then 
		return 
	end

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
  
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedOmni)
	inst.components.debuff:SetDetachedFn(OnDetachedOmni)
	inst.components.debuff:SetExtendedFn(OnExtendedOmni)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_maxomnibuff", TUNING.KYNO_MAXOMNIBUFF_DURATION)
	
	inst:ListenForEvent("timerdone", OnTimerDoneOmni)

	return inst
end

return Prefab("kyno_maxhealthbuff", healthfn),
Prefab("kyno_maxhungerbuff", hungerfn),
Prefab("kyno_maxsanitybuff", sanityfn),
Prefab("kyno_maxomnibuff", omnifn)