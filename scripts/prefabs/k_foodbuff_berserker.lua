local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_BERSERKERBUFF_START"))
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_BERSERKERBUFF_STRENGTH, "kyno_strengthbuff")
	end
	
	if target.components.health ~= nil and target:HasTag("player") then
		target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.KYNO_BERSERKERBUFF_DAMAGEMOD, "kyno_berserkerbuff")
	end
	
	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:RemoveModifier(target, "kyno_strengthbuff")
	end
	
	if target.components.health ~= nil and target:HasTag("player") then
		target.components.health.externalabsorbmodifiers:RemoveModifier(target, "kyno_berserkerbuff")
	end

	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_BERSERKERBUFF_END"))
	end
	
	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_berserkerbuff")
	inst.components.timer:StartTimer("kyno_berserkerbuff", TUNING.KYNO_BERSERKERBUFF_DURATION)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_BERSERKERBUFF_START"))
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(target, TUNING.KYNO_BERSERKERBUFF_STRENGTH, "kyno_strengthbuff")
	end
	
	if target.components.health ~= nil and target:HasTag("player") then
		target.components.health.externalabsorbmodifiers:SetModifier(target, TUNING.KYNO_BERSERKERBUFF_DAMAGEMOD, "kyno_berserkerbuff")
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_berserkerbuff" then
		inst.components.debuff:Stop()
	end
end

local function fn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then 
		return
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
	inst.components.timer:StartTimer("kyno_berserkerbuff", TUNING.KYNO_BERSERKERBUFF_DURATION)
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end

return Prefab("kyno_berserkerbuff", fn)