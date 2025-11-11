local assets =
{
	Asset("ANIM", "anim/ghost_build.zip"),
	Asset("ANIM", "anim/ghost_pirate_build.zip"),
	
	Asset("SOUND", "sound/ghost.fsb"),
}

local brain = require("brains/ghostbrain")
local GHOSTLYFRIEND_AURA_SAFE_TAGS = { "abigail", "ghostlyfriend", "ghost_ally", "swordfish" }

local function AbleToAcceptTest(inst, item)
	return false, (item:HasTag("reviver") and "GHOSTHEART") or nil
end

local function OnDeath(inst)
	inst.components.aura:Enable(false)
end

local function AuraTest(inst, target)
	if inst.components.combat:TargetIs(target) or (target.components.combat.target ~= nil and target.components.combat:TargetIs(inst)) then
		return true
	else
		return not target:HasAnyTag(GHOSTLYFRIEND_AURA_SAFE_TAGS)
	end
end

local function OnAttacked(inst, data)
	if not data.attacker then
		inst.components.combat:SetTarget(nil)
	elseif not data.attacker:HasTag("noauradamage") then
		inst.components.combat:SetTarget(data.attacker)
	end
end

local function KeepTargetFn(inst, target)
	if target and inst:GetDistanceSqToInst(target) < TUNING.GHOST_FOLLOW_DSQ then
		return true
	else
		inst.brain.followtarget = nil
		return false
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetIntensity(.6)
	inst.Light:SetRadius(.5)
	inst.Light:SetFalloff(.6)
	inst.Light:Enable(true)
	inst.Light:SetColour(180/255, 195/255, 225/255)

	MakeGhostPhysics(inst, .5, .5)
	
	inst.AnimState:SetScale(.9, .9, .9)

	inst.AnimState:SetBank("ghost")
	inst.AnimState:SetBuild("ghost_pirate_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim_bloom_ghost.ksh")
	inst.AnimState:SetLightOverride(TUNING.GHOST_LIGHT_OVERRIDE)

	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("ghost")
	inst:AddTag("flying")
	inst:AddTag("noauradamage")
	inst:AddTag("trader")

	inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:SetBrain(brain)
	
	inst:AddComponent("inspectable")

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.GHOST_SPEED
	inst.components.locomotor.runspeed = TUNING.GHOST_SPEED
	inst.components.locomotor.directdrive = true

	inst:SetStateGraph("SGghost")

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.GHOST_HEALTH)

	inst:AddComponent("combat")
	inst.components.combat.defaultdamage = TUNING.GHOST_DAMAGE
	inst.components.combat.playerdamagepercent = TUNING.GHOST_DMG_PLAYER_PERCENT
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

	inst:AddComponent("aura")
	inst.components.aura.radius = TUNING.GHOST_RADIUS
	inst.components.aura.tickperiod = TUNING.GHOST_DMG_PERIOD
    inst.components.aura.auratestfn = AuraTest

	inst:AddComponent("trader")
	inst.components.trader:SetAbleToAcceptTest(AbleToAcceptTest)

	inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("attacked", OnAttacked)

    return inst
end


return Prefab("kyno_ghost_pirate", fn, assets)