-- I have no clue if this works for modded characters...
-- If you have a modded character and this is not working please consider making postinits.
---------------------------------------------------------------------------
-- Cake Slice Chocolate
---------------------------------------------------------------------------
local function ApplyChocolateBuff(inst, bonus)
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

local function RemoveChocolateBuff(inst)
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

local function OnAttachedChocolate(inst, target)	
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_START"))
	end

	if target:HasTag("player") then
		ApplyChocolateBuff(target, TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE1_BONUS)
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetachedChocolate(inst, target)
	if target:HasTag("player") then
		RemoveChocolateBuff(target)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_END"))
	end
	
	inst:Remove()
end

local function OnExtendedChocolate(inst, target)
	inst.components.timer:StopTimer("kyno_slice1birthdaybuff")
	inst.components.timer:StartTimer("kyno_slice1birthdaybuff", TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE1_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHUNGERBUFF_START"))
	end
end

local function OnTimerDoneChocolate(inst, data)
	if data.name == "kyno_slice1birthdaybuff" then
		inst.components.debuff:Stop()
	end
end

local function slice1fn()
	if not TheWorld.ismastersim then 
		return
	end
	
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
  
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedChocolate)
	inst.components.debuff:SetDetachedFn(OnDetachedChocolate)
	inst.components.debuff:SetExtendedFn(OnExtendedChocolate)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_slice1birthdaybuff", TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE1_DURATION)
	
	inst:ListenForEvent("timerdone", OnTimerDoneChocolate)
	
	return inst
end

---------------------------------------------------------------------------
-- Cake Slice Pineapple
---------------------------------------------------------------------------
local function ApplyPineappleBuff(inst, bonus)
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

local function RemovePineappleBuff(inst)	
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

local function OnAttachedPineapple(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end

	if target:HasTag("player") then
		ApplyPineappleBuff(target, TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE2_BONUS)
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetachedPineapple(inst, target)
	if target:HasTag("player") then
		RemovePineappleBuff(target)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_END"))
	end
	
	inst:Remove()
end

local function OnExtendedPineapple(inst, target)
	inst.components.timer:StopTimer("kyno_slice2birthdaybuff")
	inst.components.timer:StartTimer("kyno_slice2birthdaybuff", TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE2_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXHEALTHBUFF_START"))
	end
end

local function OnTimerDonePineapple(inst, data)
	if data.name == "kyno_slice2birthdaybuff" then
		inst.components.debuff:Stop()
	end
end

local function slice2fn()
	if not TheWorld.ismastersim then 
		return 
	end

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
  
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedPineapple)
	inst.components.debuff:SetDetachedFn(OnDetachedPineapple)
	inst.components.debuff:SetExtendedFn(OnExtendedPineapple)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_slice2birthdaybuff", TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE2_DURATION)
	
	inst:ListenForEvent("timerdone", OnTimerDonePineapple)

	return inst
end

---------------------------------------------------------------------------
-- Cake Slice Sweet Flower
---------------------------------------------------------------------------
local function ApplySweetFlowerBuff(inst, bonus)
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

local function RemoveSweetFlowerBuff(inst)
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

local function OnAttachedSweetFlower(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0) 
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_START"))
	end
	
	if target:HasTag("player") then
		ApplySweetFlowerBuff(target, TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE3_BONUS)
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetachedSweetFlower(inst, target)
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_END"))
	end

	if target:HasTag("player") then
		RemoveSweetFlowerBuff(target)
	end
	
	inst:Remove()
end

local function OnExtendedSweetFlower(inst, target)
	inst.components.timer:StopTimer("kyno_slice3birthdaybuff")
	inst.components.timer:StartTimer("kyno_slice3birthdaybuff", TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE3_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_MAXSANITYBUFF_START"))
	end
end

local function OnTimerDoneSweetFlower(inst, data)
    if data.name == "kyno_slice3birthdaybuff" then
		inst.components.debuff:Stop()
	end
end

local function slice3fn()
	if not TheWorld.ismastersim then
		return inst
	end

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:Hide()
	
	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttachedSweetFlower)
	inst.components.debuff:SetDetachedFn(OnDetachedSweetFlower)
	inst.components.debuff:SetExtendedFn(OnExtendedSweetFlower)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_slice3birthdaybuff", TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE3_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDoneSweetFlower)

    return inst
end

return Prefab("kyno_slice1birthdaybuff", slice1fn),
Prefab("kyno_slice2birthdaybuff", slice2fn),
Prefab("kyno_slice3birthdaybuff", slice3fn)