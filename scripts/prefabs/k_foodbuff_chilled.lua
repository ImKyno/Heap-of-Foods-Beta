local assets =
{

}

local prefabs =
{
	"kyno_chilled_shard",
}

local MIN_HIT_COUNT = TUNING.KYNO_CUTLASSBLUE_HIT_THRESHOLD
local MIN_HIT_RESET = TUNING.KYNO_CUTLASSBLUE_HIT_RESET_THRESHOLD

local function OnCooldown(inst)
	inst._cdtask = nil
end

local function OnReset(inst)
	inst._combotask = nil
	inst._hitcount = 0
	inst._lasttarget = nil
end

local function DoIceFlock(inst, owner, target)
	inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)
	
	if inst._hitcount then
		inst._hitcount = 0
	end

	local fx = SpawnPrefab("kyno_chilled_shard")

	if fx ~= nil and target ~= nil then
		fx.Transform:SetPosition(target.Transform:GetWorldPosition())
		fx:SetFXTarget(owner, target)

		if target.SoundEmitter ~= nil then
			target.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/freeze")
		end
	end
end

local function OnHitOther(inst, owner, data)
	if inst._cdtask ~= nil then
		return
	end

	local target = data.target

	if inst._lasttarget ~= target.GUID then
		inst._lasttarget = target.GUID
		inst._hitcount = 1
	else
		inst._hitcount = inst._hitcount + 1
	end

	if inst._combotask then
		inst._combotask:Cancel()
	end

	inst._combotask = inst:DoTaskInTime(MIN_HIT_RESET, OnReset)

	if inst._hitcount >= MIN_HIT_COUNT then
		DoIceFlock(inst, owner, data.target)
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FREEZEBUFF_START"))
	end

	inst._hitcount = 0
	inst._lasttarget = nil
	inst._cdtask = nil
	inst._combotask = nil

	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			OnHitOther(inst, target, data)
		end

		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if inst._cdtask ~= nil then
		inst._cdtask:Cancel()
		inst._cdtask = nil
	end

	if inst._combotask ~= nil then
		inst._combotask:Cancel()
		inst._combotask = nil
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_FREEZEBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_chilledbuff")
	inst.components.timer:StartTimer("kyno_chilledbuff", TUNING.KYNO_CHILLEDBUFF_DURATION)

	if inst._onhitother ~= nil then
		inst:RemoveEventCallback("onhitother", inst._onhitother, target)
		inst._onhitother = nil
	end

	if inst._onhitother == nil then
		inst._onhitother = function(attacker, data)
			OnHitOther(inst, target, data)
		end

		inst:ListenForEvent("onhitother", inst._onhitother, target)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_chilledbuff" then
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
	inst.components.timer:StartTimer("kyno_chilledbuff", TUNING.KYNO_CHILLEDBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_chilledbuff", fn, assets, prefabs)