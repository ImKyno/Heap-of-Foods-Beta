local assets =
{
	Asset("ANIM", "anim/bramblefx.zip"),
}

local prefabs =
{
	"kyno_bramblefx",
}

local function DoThorns(inst, owner)
	inst._cdtask = inst:DoTaskInTime(.3, function()
		inst._cdtask = nil
	end)

	SpawnPrefab("kyno_bramblefx"):SetFXOwner(owner)

	if owner.SoundEmitter ~= nil then
		owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
	end
end

local function OnBlocked(owner, data, inst)
	if inst._cdtask == nil and data ~= nil and not data.redirected then
		DoThorns(inst, owner)
	end
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_THORNSBUFF_START"))
	end

	if inst._onblocked == nil then
		inst._onblocked = function(owner, data)
			OnBlocked(owner, data, inst)
		end

		inst:ListenForEvent("blocked", inst._onblocked, target)
		inst:ListenForEvent("attacked", inst._onblocked, target)
	end

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnDetached(inst, target)
	if inst._onblocked ~= nil then
		inst:RemoveEventCallback("blocked", inst._onblocked, target)
		inst:RemoveEventCallback("attacked", inst._onblocked, target)
		inst._onblocked = nil
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_THORNSBUFF_END"))
	end

	inst:Remove()
end

local function OnExtended(inst, target)
	inst.components.timer:StopTimer("kyno_thornsbuff")
	inst.components.timer:StartTimer("kyno_thornsbuff", TUNING.KYNO_THORNSBUFF_DURATION)

	if inst._onblocked ~= nil then
		inst:RemoveEventCallback("blocked", inst._onblocked, target)
		inst:RemoveEventCallback("attacked", inst._onblocked, target)
		inst._onblocked = nil
	end

	if inst._onblocked == nil then
		inst._onblocked = function(owner, data)
			OnBlocked(owner, data, inst)
		end

		inst:ListenForEvent("blocked", inst._onblocked, target)
		inst:ListenForEvent("attacked", inst._onblocked, target)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_THORNSBUFF_START"))
	end
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_thornsbuff" then
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
	inst.components.timer:StartTimer("kyno_thornsbuff", TUNING.KYNO_THORNSBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_thornsbuff", fn, assets, prefabs)