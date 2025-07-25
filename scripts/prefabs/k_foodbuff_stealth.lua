local CS = 
{
	r = 0.4, 
	g = 0.4, 
	b = 0.6, 
	a = 0.5,
}

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)
	
	local fx = SpawnPrefab("beeswax_spray_fx")
	fx.entity:SetParent(target.entity)
    
	-- Not good idea apply this to mobs...
	if target:HasTag("player") then
		target:AddTag("notarget")
		target:AddTag("notraptrigger")
		target:RemoveTag("scarytoprey")
		
		target.AnimState:SetMultColour(CS.r, CS.g, CS.b, CS.a)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_STEALTHBUFF_START"))
	end
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnTimerDone(inst, data)
    if data.name == "kyno_stealthbuff" then
        inst.components.debuff:Stop()
    end
end

local function OnDetached(inst, target)
	local fx = SpawnPrefab("beeswax_spray_fx")
	fx.entity:SetParent(target.entity)

	if target:HasTag("player") then
		target:RemoveTag("notarget")
		target:RemoveTag("notraptrigger")
		target:AddTag("scarytoprey")
		
		target.AnimState:SetMultColour(1, 1, 1, 1)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_STEALTHBUFF_END"))
	end
	
    inst:Remove()
end

local function OnExtended(inst, target)
    inst.components.timer:StopTimer("kyno_stealthbuff")
    inst.components.timer:StartTimer("kyno_stealthbuff", TUNING.KYNO_STEALTHBUFF_DURATION)
	
	local fx = SpawnPrefab("beeswax_spray_fx")
	fx.entity:SetParent(target.entity)
	
	if target:HasTag("player") then
		target:AddTag("notarget")
		target:AddTag("notraptrigger")
		target:RemoveTag("scarytoprey")
		
		target.AnimState:SetMultColour(CS.r, CS.g, CS.b, CS.a)
	end
	
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_STEALTHBUFF_START"))
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
    inst.components.timer:StartTimer("kyno_stealthbuff", TUNING.KYNO_STEALTHBUFF_DURATION)
	
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("kyno_stealthbuff", fn)