
local assets =
{
	Asset("ANIM", "anim/spawnprotectionbuff.zip"),
}

local prefabs =
{
	"battlesong_instant_panic_fx",
}

local function SpawnFx(target)
	local fx = SpawnPrefab("battlesong_instant_panic_fx")
	fx.Transform:SetNoFaced()

	target:AddChild(fx)

	return fx
end

local function OnStopOwner(owner)
	if owner:IsValid() then
		owner:RemoveDebuff("kyno_reviveprotectionbuff")
	end
end

local function OnStop(inst)
	inst.components.debuff:Stop()
end

local function OnExpiring(inst)
	inst.expire_task = inst:DoTaskInTime(10, OnStop)
end

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)

	inst.spawn_pt = target:GetPosition()

	inst.fx = SpawnFx(target)

	inst.expire_task = inst:DoTaskInTime(10, OnExpiring)

	inst:OnEnableProtectionFn(target, true)

	inst:ListenForEvent("death",              OnStopOwner, target)
	inst:ListenForEvent("doattack",           OnStopOwner, target)
	inst:ListenForEvent("onattackother",      OnStopOwner, target)
	inst:ListenForEvent("onmissother",        OnStopOwner, target)
	inst:ListenForEvent("onthrown",           OnStopOwner, target)
	inst:ListenForEvent("buildstructure",     OnStopOwner, target)
	inst:ListenForEvent("builditem",          OnStopOwner, target)
	inst:ListenForEvent("on_enter_might_gym", OnStopOwner, target)
end

local function OnDetached(inst, target)
	inst:OnEnableProtectionFn(target, false)
	inst:DoTaskInTime(1, inst.Remove)
end

local function OnEnableProtection(inst, target, enable)
	if enable then
		target:AddTag("notarget")
		target:AddTag("spawnprotection")

		target.Physics:ClearCollidesWith(bit.bor(
			COLLISION.OBSTACLES,
			COLLISION.SMALLOBSTACLES,
			COLLISION.CHARACTERS,
			COLLISION.FLYERS
		))
		target.AnimState:SetHaunted(true)
	else
		target:RemoveTag("notarget")
		target:RemoveTag("spawnprotection")

		target.Physics:CollidesWith(bit.bor(
			COLLISION.OBSTACLES,
			COLLISION.SMALLOBSTACLES,
			COLLISION.CHARACTERS,
			COLLISION.FLYERS
		))
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

	return inst
end

return Prefab("kyno_reviveprotectionbuff", fn, assets, prefabs)