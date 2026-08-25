-- These buffs are penalties applied by other buffs.
-- Such as Food Healing Sickness from Enchanted Shimmer Apple where players cannot heal from foods.
-- Food Healing Sickness affects both health and sanity heal from food.
local assets =
{
	Asset("ANIM", "anim/kyno_healingsickness_fx.zip"),
}

local function OnAttached(inst, target)
	inst.entity:SetParent(target.entity)
	inst.Transform:SetPosition(0, 0, 0)

	inst:ListenForEvent("death", function()
		inst.components.debuff:Stop()
	end, target)
end

local function OnTimerDone(inst, data)
	if data.name == "kyno_healingsicknessbuff" then
		inst.components.debuff:Stop()
	end
end

local function OnDetached(inst, target)
	if target.components.talker and target:HasTag("player") then
		target.components.talker:Say(GetString(target, "ANNOUNCE_KYNO_SICKNESSBUFF_END")) -- Generic announcement.
	end

	inst.AnimState:PushAnimation("level1_pst", false)
	inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("kyno_healingsickness_fx")
	inst.AnimState:SetBuild("kyno_healingsickness_fx")
	inst.AnimState:PlayAnimation("level1_pre")
	inst.AnimState:PushAnimation("level1_loop", true)

	inst:AddTag("DECOR")
	inst:AddTag("NOCLICK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst:AddTag("CLASSIFIED")

	inst:AddComponent("debuff")
	inst.components.debuff:SetAttachedFn(OnAttached)
	inst.components.debuff:SetDetachedFn(OnDetached)
	inst.components.debuff.keepondespawn = true

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("kyno_healingsicknessbuff", TUNING.KYNO_HEALINGSICKNESSBUFF_DURATION)

	inst:ListenForEvent("timerdone", OnTimerDone)

	return inst
end

return Prefab("kyno_healingsicknessbuff", fn, assets)