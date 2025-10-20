local CS = 
{
	r = 0.4, 
	g = 0.4, 
	b = 0.6, 
	a = 0.5,
}

local function MountedStealth(inst, data)
	local rider = inst.components.rider
	local mount = rider:GetMount()
	local saddle = mount.components.rideable.saddle
	
	if rider ~= nil and inst:HasTag("mimicmosa_stealthed") then
		if mount ~= nil and mount:HasTag("woby") then
			mount:AddTag("mimicmosa_stealthed")
		end
		
		if mount ~= nil and mount:HasTag("beefalo") then
			mount:AddTag("mimicmosa_stealthed")
		end
	end
end

local function DismountedStealth(inst, data)
	local mount = data ~= nil and data.target or nil
	
	if mount ~= nil and mount:HasTag("woby") then
		mount:RemoveTag("mimicmosa_stealthed")
	end
	
	if mount ~= nil and mount:HasTag("beefalo") then
		mount:RemoveTag("mimicmosa_stealthed")
	end
end

local function UpdateStealth(inst)
	if inst and inst:IsValid() then
		inst.AnimState:SetMultColour(CS.r, CS.g, CS.b, CS.a)
	end
end

local function DisableStealth(inst)
	if inst.stealthtask ~= nil then
		inst.stealthtask:Cancel()
		inst.stealthtask = nil
	end
	
	inst.AnimState:SetMultColour(1, 1, 1, 1)
	
	inst:RemoveEventCallback("mounted", MountedStealth)
	inst:RemoveEventCallback("dismounted", DismountedStealth)
end

local function EnableStealth(inst)
	inst.stealthtask = inst:DoPeriodicTask(0, UpdateStealth)
	
	inst:ListenForEvent("mounted", MountedStealth)
	inst:ListenForEvent("dismounted", DismountedStealth)
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0)

	local fx = SpawnPrefab("beeswax_spray_fx")
	fx.entity:SetParent(target.entity)
    
	-- Not good idea apply this to mobs...
	if target:HasTag("player") then
		target:AddTag("mimicmosa_stealthed")
	
		target:AddTag("notarget")
		target:AddTag("notraptrigger")
		target:RemoveTag("scarytoprey")
		
		EnableStealth(target)
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
		target:RemoveTag("mimicmosa_stealthed")

		target:RemoveTag("notarget")
		target:RemoveTag("notraptrigger")
		target:AddTag("scarytoprey")
		
		DisableStealth(target)
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
		target:RemoveTag("mimicmosa_stealthed")
		target:AddTag("mimicmosa_stealthed")
	
		target:RemoveTag("notarget")
		target:RemoveTag("notraptrigger")
	
		target:AddTag("notarget")
		target:AddTag("notraptrigger")
		target:RemoveTag("scarytoprey")
		
		EnableStealth(target)
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
	
	-- Mods.
	inst.MountedStealth = MountedStealth
	inst.DismountedStealth = DismountedStealth

    return inst
end

return Prefab("kyno_stealthbuff", fn)