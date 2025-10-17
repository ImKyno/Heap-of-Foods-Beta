local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FIREBUFF_START"))
	end
	
	if not target:HasTag("bernieowner") then
		if target.components.health ~= nil then
			target.components.health.fire_damage_scale = 0
		end
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnDetached(inst, target)
	if not target:HasTag("bernieowner") then
		if target.components.health ~= nil then
			target.components.health.fire_damage_scale = 1
		end
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FIREBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_fireimmunitybuff")
    inst.components.timer:StartTimer("kyno_fireimmunitybuff", TUNING.KYNO_FIREIMMUNITYBUFF_DURATION)

	if not target:HasTag("bernieowner") then
		if target.components.health ~= nil then
			target.components.health.fire_damage_scale = 0
		end
	end
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_fireimmunitybuff" then
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
	inst.components.timer:StartTimer("kyno_fireimmunitybuff", TUNING.KYNO_FIREIMMUNITYBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_fireimmunitybuff", fn)