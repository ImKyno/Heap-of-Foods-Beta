local assets =
{
	Asset("ANIM", "anim/spawnprotectionbuff.zip"),
	Asset("ANIM", "anim/kyno_amplified_fx.zip"),
}

local prefabs =
{
	"battlesong_instant_panic_fx",

	"kyno_amplified_fx",
	"kyno_healingsicknessbuff",
}

local function SpawnFx(target)
	local fx = SpawnPrefab("battlesong_instant_panic_fx")
	fx.Transform:SetNoFaced()

	target:AddChild(fx)

	return fx
end

local function SpawnAmplifiedFx(target)
	local fx = SpawnPrefab("kyno_amplified_fx")
	target:AddChild(fx)

	return fx
end

local function OnStopOwner(owner)
	if owner:IsValid() then
		owner:RemoveDebuff("kyno_invinciblebuff")
	end
end

local function OnStop(inst)
	inst.components.debuff:Stop()
end

local function OnExpiring(inst)
	inst.expire_task = inst:DoTaskInTime(TUNING.KYNO_INVINCIBLEBUFF_DURATION, OnStop)
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)

	inst.spawn_pt = target:GetPosition()

	inst.fx = SpawnFx(target)
	inst.amplified_fx = SpawnAmplifiedFx(target)

	inst.expire_task = inst:DoTaskInTime(TUNING.KYNO_INVINCIBLEBUFF_DURATION, OnExpiring)

	if target:HasTag("player") then
		inst:OnEnableProtectionFn(target, true)
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_INVINCIBLEBUFF_START"))
	end

	inst:ListenForEvent("death", OnStopOwner, target)
end

local function OnDetached(inst, target)
	if target:HasTag("player") then
		inst:OnEnableProtectionFn(target, false)
		target:AddDebuff("kyno_healingsicknessbuff", "kyno_healingsicknessbuff")
	end

	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_INVINCIBLEBUFF_END"))
	end

	if inst.amplified_fx ~= nil then
		inst.amplified_fx.AnimState:PushAnimation("level1_pst", false)
		inst.amplified_fx:ListenForEvent("animover", inst.Remove)
	end

	inst:DoTaskInTime(1, inst.Remove)
end

local function OnExtended(inst, target)
	if inst.expire_task ~= nil then
		inst.expire_task:Cancel()
		inst.expire_task = nil
	end

	inst.expire_task = inst:DoTaskInTime(TUNING.KYNO_INVINCIBLEBUFF_DURATION, OnExpiring)

	if target:HasTag("player") then
		inst:OnEnableProtectionFn(target, true)
	end
end

local function OnEnableProtection(inst, target, enable)
	if enable then
		if target.components.health ~= nil then
			target.components.health:SetInvincible(true)
		end

		target.AnimState:SetHaunted(true)
	else
		if target.components.health ~= nil then
			target.components.health:SetInvincible(false)
		end

		target.AnimState:SetHaunted(false)
		inst.AnimState:PushAnimation("buff_pst", false)
	end
end

local function fn(songdata, dodelta_fn)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("spawnprotectionbuff")
	inst.AnimState:SetBuild("spawnprotectionbuff")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:PlayAnimation("buff_pre")
	inst.AnimState:PushAnimation("buff_idle", true)
	inst.AnimState:SetMultColour(1, 1, 1, 0.25)

	inst:AddTag("DECOR")
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst.OnEnableProtectionFn = OnEnableProtection

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff:SetExtendedFn(OnExtended)
	inst.components.debuff.keepondespawn = true

	return inst
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_amplified_fx")
	inst.AnimState:SetBuild("kyno_amplified_fx")
	inst.AnimState:PlayAnimation("level1_pre")
	inst.AnimState:PushAnimation("level1_loop", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetMultColour(1, 1, 1, 0.50)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false
	
	return inst
end

return Prefab("kyno_invinciblebuff", fn, assets, prefabs),
Prefab("kyno_amplified_fx", fxfn, assets)