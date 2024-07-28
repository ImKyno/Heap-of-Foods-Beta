-- Same as "nightvision_buff" but with custom duration and easier call.
local ANCIENTFRUIT_NIGHTVISION_COLOURCUBES =
{
    day = "images/colour_cubes/nightvision_fruit_cc.tex",
    dusk = "images/colour_cubes/nightvision_fruit_cc.tex",
    night = "images/colour_cubes/nightvision_fruit_cc.tex",
    full_moon = "images/colour_cubes/nightvision_fruit_cc.tex",

    nightvision_fruit = true,
}

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
	
	if target.components.playervision ~= nil then
        target.components.playervision:PushForcedNightVision(inst, 1, ANCIENTFRUIT_NIGHTVISION_COLOURCUBES, true)
        inst._enabled:set(true)
    end
	
	if target.components.sanity ~= nil then
        target.components.sanity.externalmodifiers:SetModifier(inst, -TUNING.DAPPERNESS_TINY)
    end
end

local function OnDetached(inst, target)
	if target ~= nil and target:IsValid() then
        if target.components.playervision ~= nil then
            target.components.playervision:PopForcedNightVision(inst)
            inst._enabled:set(false)
        end

        if target.components.sanity ~= nil then
            target.components.sanity.externalmodifiers:RemoveModifier(inst)
        end
    end

    inst:DoTaskInTime(10 * FRAMES, inst.Remove)
end

local function OnExpire(inst)
    if inst.components.debuff ~= nil then
        inst.components.debuff:Stop()
    end
end

local function OnExtended(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end

    inst.task = inst:DoTaskInTime(TUNING.KYNO_NIGHTVISIONBUFF_DURATION, OnExpire)
end

local function OnSave(inst, data)
    if inst.task ~= nil then
        data.remaining = GetTaskRemaining(inst.task)
    end
end

local function OnLoad(inst, data)
    if data == nil then
        return
    end

    if data.remaining then
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end

        inst.task = inst:DoTaskInTime(data.remaining, OnExpire)
    end
end

local function OnLongUpdate(inst, dt)
    if inst.task == nil then
        return
    end

    local remaining = GetTaskRemaining(inst.task) - dt

    inst.task:Cancel()

    if remaining > 0 then
        inst.task = inst:DoTaskInTime(remaining, OnExpire)
    else
        OnExpire(inst)
    end
end

local function OnEnabledDirty(inst)
    if ThePlayer ~= nil and inst.entity:GetParent() == ThePlayer and ThePlayer.components.playervision ~= nil then
        if inst._enabled:value() then
            ThePlayer.components.playervision:PushForcedNightVision(inst, 1, ANCIENTFRUIT_NIGHTVISION_COLOURCUBES, true)
        else
            ThePlayer.components.playervision:PopForcedNightVision(inst)
        end
    end
end

local function fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")

    inst._enabled = net_bool(inst.GUID, "kyno_nightvisionbuff._enabled", "enableddirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("enableddirty", OnEnabledDirty)

        return inst
    end

    inst.entity:Hide()
    inst.persists = false

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    OnExtended(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLongUpdate = OnLongUpdate

    return inst
end

return Prefab("kyno_nightvisionbuff", fn)