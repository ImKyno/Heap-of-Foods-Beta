local assets =
{	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local ANCIENTFRUIT_NIGHTVISION_COLOURCUBES =
{
    day = "images/colour_cubes/nightvision_fruit_cc.tex",
    dusk = "images/colour_cubes/nightvision_fruit_cc.tex",
    night = "images/colour_cubes/nightvision_fruit_cc.tex",
    full_moon = "images/colour_cubes/nightvision_fruit_cc.tex",

    nightvision_fruit = true,
}

local function GetRandomPosition(caster, teleportee, target_in_ocean)
	if target_in_ocean then
		local pt = TheWorld.Map:FindRandomPointInOcean(20)
		
		if pt ~= nil then
			return pt
		end

		local from_pt = teleportee:GetPosition()
		local offset = FindSwimmableOffset(from_pt, math.random() * 2 * PI, 90, 16)
		or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 60, 16)
		or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 30, 16)
		or FindSwimmableOffset(from_pt, math.random() * 2 * PI, 15, 16)
		
		if offset ~= nil then
			return from_pt + offset
		end
			
		return teleportee:GetPosition()
	else
		local centers = {}

		for i, node in ipairs(TheWorld.topology.nodes) do
			if TheWorld.Map:IsPassableAtPoint(node.x, 0, node.y) and node.type ~= NODE_TYPE.SeparatedRoom then
				table.insert(centers, {x = node.x, z = node.y})
			end
		end
				
		if #centers > 0 then
			local pos = centers[math.random(#centers)]
			return Point(pos.x, 0, pos.z)
		else
			return target:GetPosition()
		end
	end
end

local function TeleportEnd(teleportee, locpos, loctarget, target)
	if loctarget ~= nil and loctarget:IsValid() and loctarget.onteleto ~= nil then
		loctarget:onteleto()
	end

	local teleportfx = SpawnPrefab("explode_reskin")
	teleportfx.Transform:SetPosition(teleportee.Transform:GetWorldPosition())

	if teleportee.components.talker ~= nil then
		teleportee.components.talker:Say(GetString(teleportee, "ANNOUNCE_TOWNPORTALTELEPORT"))
	end

	if teleportee:HasTag("player") then
		teleportee.sg.statemem.teleport_task = nil
		teleportee.sg:GoToState(teleportee:HasTag("playerghost") and "appear" or "wakeup")
	else
		teleportee:Show()
		
		if teleportee.DynamicShadow ~= nil then
			teleportee.DynamicShadow:Enable(true)
		end
		
		if teleportee.components.health ~= nil then
			teleportee.components.health:SetInvincible(false)
		end
		
		teleportee:PushEvent("teleported")
	end
end

local function TeleportContinue(teleportee, locpos, loctarget, target)
	if teleportee.Physics ~= nil then
		teleportee.Physics:Teleport(locpos.x, 0, locpos.z)
	else
		teleportee.Transform:SetPosition(locpos.x, 0, locpos.z)
	end

	if teleportee:HasTag("player") then
		teleportee:SnapCamera()
		teleportee:ScreenFade(true, 1)
		teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(1, TeleportEnd, locpos, loctarget)
	else
		TeleportEnd(teleportee, locpos, loctarget)
	end
end

local function TeleportStart(teleportee, target, caster, loctarget, target_in_ocean)
	local ground = TheWorld

	local locpos = teleportee.components.teleportedoverride ~= nil and teleportee.components.teleportedoverride:GetDestPosition()
	or loctarget == nil and GetRandomPosition(target, teleportee, target_in_ocean)
	or loctarget.teletopos ~= nil and loctarget:teletopos()
	or loctarget:GetPosition()

	if teleportee.components.locomotor ~= nil then
		teleportee.components.locomotor:StopMoving()
	end

	local teleportfx = SpawnPrefab("explode_reskin")
	teleportfx.Transform:SetPosition(teleportee.Transform:GetWorldPosition())

	local isplayer = teleportee:HasTag("player")
	
	if isplayer then
		teleportee.sg:GoToState("forcetele")
	else
		if teleportee.components.health ~= nil then
			teleportee.components.health:SetInvincible(true)
		end
		
		if teleportee.DynamicShadow ~= nil then
			teleportee.DynamicShadow:Enable(false)
		end
		
		teleportee:Hide()
	end

	if isplayer then
		teleportee.sg.statemem.teleport_task = teleportee:DoTaskInTime(3, TeleportContinue, locpos, loctarget)
	else
		TeleportContinue(teleportee, locpos, loctarget)
	end
end

local TELEPORT_MUST_TAGS = { "locomotor" }
local TELEPORT_CANT_TAGS = { "playerghost", "INLIMBO" }

local function DoNukashineBlackout(inst, target)
	local caster = target
	
	if target == nil then
		target = caster
	end

	local x, y, z = target.Transform:GetWorldPosition()
	local target_in_ocean = target.components.locomotor ~= nil and target.components.locomotor:IsAquatic()
	local loctarget = target.components.minigame_participator ~= nil and target.components.minigame_participator:GetMinigame()
	or target.components.teleportedoverride ~= nil and target.components.teleportedoverride:GetDestTarget()
	or target.components.hitchable ~= nil and target:HasTag("hitched") and target.components.hitchable.hitched or nil

	if target:HasTag("player") then
		TeleportStart(target, inst, caster, loctarget, target_in_ocean)
	end
end

local function OnAttached(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
	
	-- Play a nice and distant jukebox melody...
	target:PushEvent("playnukashine")

	if target.components.playervision ~= nil then
        target.components.playervision:PushForcedNightVision(inst, 1, ANCIENTFRUIT_NIGHTVISION_COLOURCUBES, true)
        inst._enabled:set(true)
    end
	
	if target.components.sanity ~= nil then
        target.components.sanity.externalmodifiers:SetModifier(inst, -TUNING.DAPPERNESS_TINY)
    end
	
	-- From Strength Buff.
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
	
	if target.components.locomotor ~= nil and target:HasTag("player") then
		target:AddTag("groggy")
		
		target.components.locomotor:SetExternalSpeedMultiplier(target, "kyno_nukashinebuff", TUNING.KYNO_ALCOHOL_SPEED)
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.KYNO_ALCOHOL_STRENGTH_MEDSMALL, "kyno_nukashinebuff")
	end
end

local function OnDetached(inst, target)
	if target ~= nil and target:IsValid() then
		target:PushEvent("stopnukashine")
	
        if target.components.playervision ~= nil then
            target.components.playervision:PopForcedNightVision(inst)
            inst._enabled:set(false)
        end

        if target.components.sanity ~= nil then
            target.components.sanity.externalmodifiers:RemoveModifier(inst)
        end
		
		-- From Strength Buff.
		if target.components.locomotor ~= nil and target:HasTag("player") then
			target:RemoveTag("groggy")
		
			target.components.locomotor:RemoveExternalSpeedMultiplier(target, "kyno_nukashinebuff")
		end
	
		if target.components.combat ~= nil and target:HasTag("player") then
			target.components.combat.externaldamagemultipliers:RemoveModifier(inst, "kyno_nukashinebuff")
		end
		
		-- Will not say anything when buff ends, because they already do when teleported.
		
		DoNukashineBlackout(inst, target)		
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

    inst.task = inst:DoTaskInTime(TUNING.KYNO_NUKASHINE_BLACKOUT, OnExpire)
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
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")

    inst._enabled = net_bool(inst.GUID, "kyno_nukashinebuff._enabled", "enableddirty")

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

------------------------------------------------------------------------------------
-- SUGAR-FREE BUFF
------------------------------------------------------------------------------------
local function OnAttachedSugarFree(inst, target)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) 
	
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
	
	target:PushEvent("playnukashine")

	if target.components.playervision ~= nil then
        target.components.playervision:PushForcedNightVision(inst, 1, ANCIENTFRUIT_NIGHTVISION_COLOURCUBES, true)
        inst._enabled2:set(true)
    end
	
	if target.components.sanity ~= nil then
        target.components.sanity.externalmodifiers:SetModifier(inst, -TUNING.DAPPERNESS_TINY)
    end
	
	-- From Strength Buff.
	if target.components.talker and target:HasTag("player") then 
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_START"))
	end
	
	if target.components.combat ~= nil and target:HasTag("player") then
		target.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.KYNO_ALCOHOL_STRENGTH_MEDSMALL, "kyno_nukashinesugarfreebuff")
	end
end

local function OnDetachedSugarFree(inst, target)
	if target ~= nil and target:IsValid() then
		target:PushEvent("stopnukashine")
	
        if target.components.playervision ~= nil then
            target.components.playervision:PopForcedNightVision(inst)
            inst._enabled2:set(false)
        end

        if target.components.sanity ~= nil then
            target.components.sanity.externalmodifiers:RemoveModifier(inst)
        end
		
		-- From Strength Buff.
		if target.components.talker and target:HasTag("player") then 
			target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_POPBUFF_END"))
		end
		
		if target.components.combat ~= nil and target:HasTag("player") then
			target.components.combat.externaldamagemultipliers:RemoveModifier(inst, "kyno_nukashinesugarfreebuff")
		end
    end

    inst:DoTaskInTime(10 * FRAMES, inst.Remove)
end

local function OnExpireSugarFree(inst)
    if inst.components.debuff ~= nil then
        inst.components.debuff:Stop()
    end
end

local function OnExtendedSugarFree(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end

    inst.task = inst:DoTaskInTime(TUNING.KYNO_NUKASHINE_BLACKOUT, OnExpireSugarFree)
end

local function OnSaveSugarFree(inst, data)
    if inst.task ~= nil then
        data.remaining = GetTaskRemaining(inst.task)
    end
end

local function OnLoadSugarFree(inst, data)
    if data == nil then
        return
    end

    if data.remaining then
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end

        inst.task = inst:DoTaskInTime(data.remaining, OnExpireSugarFree)
    end
end

local function OnLongUpdateSugarFree(inst, dt)
    if inst.task == nil then
        return
    end

    local remaining = GetTaskRemaining(inst.task) - dt

    inst.task:Cancel()

    if remaining > 0 then
        inst.task = inst:DoTaskInTime(remaining, OnExpireSugarFree)
    else
        OnExpireSugarFree(inst)
    end
end

local function OnEnabledDirtySugarFree(inst)
    if ThePlayer ~= nil and inst.entity:GetParent() == ThePlayer and ThePlayer.components.playervision ~= nil then
        if inst._enabled2:value() then
            ThePlayer.components.playervision:PushForcedNightVision(inst, 1, ANCIENTFRUIT_NIGHTVISION_COLOURCUBES, true)
        else
            ThePlayer.components.playervision:PopForcedNightVision(inst)
        end
    end
end

local function sugarfreefn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")

    inst._enabled2 = net_bool(inst.GUID, "kyno_nukashinesugarfreebuff._enabled", "enableddirty")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("enableddirty", OnEnabledDirtySugarFree)

        return inst
    end

    inst.entity:Hide()
    inst.persists = false

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttachedSugarFree)
    inst.components.debuff:SetDetachedFn(OnDetachedSugarFree)
    inst.components.debuff:SetExtendedFn(OnExtendedSugarFree)
    inst.components.debuff.keepondespawn = true

    OnExtendedSugarFree(inst)

    inst.OnSave = OnSaveSugarFree
    inst.OnLoad = OnLoadSugarFree
    inst.OnLongUpdate = OnLongUpdateSugarFree

    return inst
end

return Prefab("kyno_nukashinebuff", fn, assets),
Prefab("kyno_nukashinesugarfreebuff", sugarfreefn, assets)