local brain = require("brains/puffermonsterbrain")

local assets =
{
	Asset("ANIM", "anim/kyno_puffermonster.zip"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"monstermeat",
	"stinger",
	
	"kyno_swordfish_damage_fx",
}

SetSharedLootTable("kyno_puffermonster",
{
	{"monstermeat", 1.00},
	{"monstermeat", 1.00},
	{"monstermeat", 0.33},
	
	{"stinger",     1.00},
	{"stinger",     1.00},
	{"stinger",     0.50},
	{"stinger",     0.33},
})

local PUFFERMONSTER_MUST_TAGS = { "_combat" }
local PUFFERMONSTER_CANT_TAGS = { "INLIMBO", "outofreach", "puffermonster", "swordfish" }

local PUFFERMONSTER_BOAT_MUST_TAGS = { "boat" }
local PUFFERMONSTER_BOAT_CANT_TAGS = { "INLIMBO", "outofreach", "puffermonster", "swordfish" }

local function Retarget(inst)
	local function CheckTarget(guy)
		return inst.components.combat:CanTarget(guy)
	end

	return FindEntity(inst, TUNING.KYNO_PUFFERMONSTER_TARGET_DIST, CheckTarget, PUFFERMONSTER_MUST_TAGS, PUFFERMONSTER_CANT_TAGS) or nil
end

local function KeepTarget(inst, target)
	local x, y, z = target.Transform:GetWorldPosition()

	local home = inst.components.knownlocations:GetLocation("home")
	local isnearhome = not (home ~= nil and not (inst:GetDistanceSqToPoint(home) <= TUNING.KYNO_PUFFERMONSTER_CHASE_DIST * TUNING.KYNO_PUFFERMONSTER_CHASE_DIST))

	-- Don't keep target if we chased too far from our home.
	return isnearhome and inst.components.combat:CanTarget(target) and not TheWorld.Map:IsVisualGroundAtPoint(x, y, z)
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, TUNING.KYNO_PUFFERMONSTER_SHARE_TARGET_DIST, function(dude)
		return not (dude.components.health ~= nil and dude.components.health:IsDead()) and dude:HasTag("puffermonster")
	end, 5)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(data.target, TUNING.KYNO_PUFFERMONSTER_SHARE_TARGET_DIST, function(dude)
		return not (dude.components.health ~= nil and dude.components.health:IsDead()) and dude:HasTag("puffermonster")
	end, 5)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeCharacterPhysics(inst, 50, 1)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	
	inst.AnimState:SetScale(.85, .85, .85)

	inst.AnimState:SetBank("kyno_puffermonster")
	inst.AnimState:SetBuild("kyno_puffermonster")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("monster")
	inst:AddTag("puffermonster")
	inst:AddTag("scarytoprey")
	inst:AddTag("scarytooceanprey")
	inst:AddTag("smallcreature")
	inst:AddTag("smalloceancreature")
	
	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_PUFFERMONSTER_HEALTH)
	inst.components.health:StartRegen(TUNING.BEEFALO_HEALTH_REGEN, TUNING.BEEFALO_HEALTH_REGEN_PERIOD)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("kyno_puffermonster")

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(1)
	inst.components.sleeper.sleeptestfn = nil

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_PUFFERMONSTER_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.KYNO_PUFFERMONSTER_RUNSPEED
	inst.components.locomotor.pathcaps = { allowocean = true, ignoreLand = true }

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.KYNO_PUFFERMONSTER_DAMAGE)
	inst.components.combat:SetAreaDamage(TUNING.KYNO_PUFFERMONSTER_AOE_RANGE, TUNING.KYNO_PUFFERMONSTER_AOE_SCALE)
	inst.components.combat:SetAttackPeriod(TUNING.KYNO_PUFFERMONSTER_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.KYNO_PUFFERMONSTER_RANGE)
	inst.components.combat:SetRetargetFunction(1, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:SetBrain(brain)
	inst:SetStateGraph("SGpuffermonster")
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

	MakeHauntablePanic(inst)

	return inst
end

return Prefab("kyno_puffermonster", fn, assets, prefabs)