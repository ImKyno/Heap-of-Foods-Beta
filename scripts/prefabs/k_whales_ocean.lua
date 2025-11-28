local whale_blue_brain = require("brains/whaleblueoceanbrain")
local whale_white_brain = require("brains/whalewhiteoceanbrain")

local whale_blue_assets =
{
	Asset("ANIM", "anim/kyno_whale.zip"),
	Asset("ANIM", "anim/kyno_whale_blue_build.zip"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local whale_white_assets =
{
	Asset("ANIM", "anim/kyno_whale.zip"),
	Asset("ANIM", "anim/kyno_whale_white_build.zip"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local whale_blue_prefabs =
{
	"ocean_splash_med1",
	"ocean_splash_med2",

	"kyno_whale_blue_ocean_carcass",
	"kyno_whale_ocean_bubbles",
	"kyno_whale_ocean_track",
}

local whale_white_prefabs =
{
	"ocean_splash_med1",
	"ocean_splash_med2",

	"kyno_whale_white_ocean_carcass",
	"kyno_whale_ocean_bubbles",
	"kyno_whale_ocean_track",
}

local whale_blue_sounds =
{
	death       = "hof_sounds/creatures/whale_blue/death",
	hit         = "hof_sounds/creatures/whale_blue/hit",
	idle        = "hof_sounds/creatures/whale_blue/idle",
	breach_swim = "hof_sounds/creatures/whale_blue/breach_swim",
	sleep       = "hof_sounds/creatures/whale_blue/sleep",
	rear_attack = "hof_sounds/creatures/whale_blue/rear_attack",
	mouth_open  = "hof_sounds/creatures/whale_blue/mouth_open",
	bite_chomp  = "hof_sounds/creatures/whale_blue/bite_chomp",
	bite        = "hof_sounds/creatures/whale_blue/bite",
}

local whale_white_sounds =
{
	death       = "hof_sounds/creatures/whale_white/death",
	hit         = "hof_sounds/creatures/whale_white/hit",
	idle        = "hof_sounds/creatures/whale_white/idle",
	breach_swim = "hof_sounds/creatures/whale_white/breach_swim",
	sleep       = "hof_sounds/creatures/whale_white/sleep",
	rear_attack = "hof_sounds/creatures/whale_white/rear_attack",
	mouth_open  = "hof_sounds/creatures/whale_white/mouth_open",
	bite_chomp  = "hof_sounds/creatures/whale_white/bite_chomp",
	bite        = "hof_sounds/creatures/whale_white/bite",
}

local WAKE_TO_RUN_DISTANCE = TUNING.KYNO_WHALE_WAKE_TO_RUN_DISTANCE
local SLEEP_NEAR_ENEMY_DISTANCE = TUNING.KYNO_WHALE_SLEEP_NEAR_ENEMY_DISTANCE

local function ShouldWakeUp(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	return DefaultWakeTest(inst) or IsAnyPlayerInRange(x, y, z, WAKE_TO_RUN_DISTANCE)
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
		return dude:HasTag("whale") and not dude:HasTag("player") and not dude.components.health:IsDead()
	end, 5)
end

local function KeepTargetBlue(inst, target)
	return inst:IsNear(target, TUNING.KYNO_WHALE_BLUE_CHASE_DIST)
end

local function KeepTargetWhite(inst, target)
	return inst:IsNear(target, TUNING.KYNO_WHALE_WHITE_CHASE_DIST)
end

local WHALE_WHITE_MUST_TAGS = { "_combat" }
local WHALE_WHITE_CANT_TAGS = { "INLIMBO", "outofreach", "bird" } -- Only friendly to birds.

local function RetargetWhite(inst)
    local function CheckTarget(guy)
		return inst.components.combat:CanTarget(guy)
	end

	return FindEntity(inst, TUNING.KYNO_WHALE_WHITE_TARGET_DIST, CheckTarget, WHALE_WHITE_MUST_TAGS, WHALE_WHITE_CANT_TAGS) or nil
end

local function SpawnWhaleWaves(inst, numWaves, totalAngle, waveSpeed, wavePrefab, initialOffset, idleTime, instantActivate, random_angle)
	SpawnAttackWaves(
		inst:GetPosition(),
		(not random_angle and inst.Transform:GetRotation()) or nil,
		initialOffset or (inst.Physics and inst.Physics:GetRadius()) or nil,
		numWaves,
		totalAngle,
		waveSpeed,
		wavePrefab,
		idleTime,
		instantActivate
	)
end

local function FindWater(inst)
	local foundwater = false
	
	local position = Vector3(inst.Transform:GetWorldPosition())
	local start_angle = inst.Transform:GetRotation() * DEGREES

	local foundwater = false
	local radius = 6.5

	local test_fn = function(offset)
		local x = position.x + offset.x
		local z = position.z + offset.z
		return not TheWorld.Map:IsVisualGroundAtPoint(x, 0, z)
	end

	local offset = nil

	while foundwater == false do
		offset = FindValidPositionByFan(start_angle, radius, 10, test_fn)
		
		if offset and offset.x and offset.z then
			foundwater = true
		else
			radius = radius + 4
		end
	end

	return offset
end

local function StuckDetection(inst)
	local platform = inst:GetCurrentPlatform()

	if platform then
		local spawnPos = inst:GetPosition()
		local offset = FindWater(inst)
		spawnPos = spawnPos + offset
				
		if inst.Physics ~= nil then
			inst.Physics:Teleport(spawnPos:Get())
			
			local splash = SpawnPrefab("ocean_splash_med1")
			splash.Transform:SetPosition(inst.Transform:GetWorldPosition())
		else
			inst.Transform:SetPosition(spawnPos:Get())
			
			local splash = SpawnPrefab("ocean_splash_med2")
			splash.Transform:SetPosition(inst.Transform:GetWorldPosition())
		end
	end
end

local function common()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()

	MakeCharacterPhysics(inst, 1000, 1.25)

	inst.AnimState:SetBank("kyno_whale")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("wet")
	inst:AddTag("whale")
	inst:AddTag("animal")
	inst:AddTag("largecreature")
	inst:AddTag("largeoceancreature")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("combat")
	inst:AddComponent("health")
	inst:AddComponent("knownlocations")
	inst:AddComponent("inspectable")

	inst:AddComponent("locomotor")
	inst.components.locomotor.pathcaps = { allowocean = true, ignoreLand = true }

    inst:AddComponent("sleeper")
	inst.components.sleeper.sleeptestfn = nil
	inst.components.sleeper:SetWakeTest(ShouldWakeUp)
	
	inst.SpawnWhaleWaves = SpawnWhaleWaves
	
	inst:DoPeriodicTask(3, StuckDetection)

	inst:SetStateGraph("SGwhaleocean")

	inst:ListenForEvent("attacked", OnAttacked)

	MakeHauntablePanic(inst)
	MakeLargeFreezableCharacter(inst)

	return inst
end

local function whale_blue()
    local inst = common()

	inst.AnimState:SetBuild("kyno_whale_blue_build")
	
	inst.carcass = "kyno_whale_blue_ocean_carcass"
	inst.sounds = whale_blue_sounds

	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.hull_damage = -TUNING.KYNO_WHALE_BLUE_HULLDAMAGE
	
	inst.components.health:SetMaxHealth(TUNING.KYNO_WHALE_BLUE_HEALTH)

	inst.components.combat:SetHurtSound(inst.sounds.hit)
	inst.components.combat:SetKeepTargetFunction(KeepTargetBlue)
	inst.components.combat:SetDefaultDamage(TUNING.KYNO_WHALE_BLUE_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.KYNO_WHALE_ATTACK_PERIOD)
	
	inst.components.locomotor.walkspeed = TUNING.KYNO_WHALE_BLUE_WALKSPEED
    inst.components.locomotor.runspeed = TUNING.KYNO_WHALE_BLUE_RUNSPEED

	inst.components.sleeper:SetResistance(3)

	inst:SetBrain(whale_blue_brain)

    return inst
end

local function whale_white()
	local inst = common()

    inst.Transform:SetScale(1.25, 1.25, 1.25)

	inst.AnimState:SetBuild("kyno_whale_white_build")
	
	inst:AddTag("scarytoprey")
	inst:AddTag("scarytooceanprey")
	inst:AddTag("_named")
	
	inst.carcass = "kyno_whale_white_ocean_carcass"
	inst.sounds = whale_white_sounds

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.hull_damage = -TUNING.KYNO_WHALE_WHITE_HULLDAMAGE
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("named")
	inst.components.named.possiblenames = STRINGS.KYNO_WHALE_WHITE_OCEAN_NAMES
	inst.components.named:PickNewName()
	
	inst.components.health:SetMaxHealth(TUNING.KYNO_WHALE_WHITE_HEALTH)

	inst.components.combat:SetHurtSound(inst.sounds.hit)
	inst.components.combat:SetKeepTargetFunction(KeepTargetWhite)
	inst.components.combat:SetDefaultDamage(TUNING.KYNO_WHALE_WHITE_DAMAGE)
	inst.components.combat:SetRetargetFunction(1, RetargetWhite)
	inst.components.combat:SetAttackPeriod(3)

	inst.components.locomotor.walkspeed = TUNING.KYNO_WHALE_WHITE_WALKSPEED * 0.5
	inst.components.locomotor.runspeed = TUNING.KYNO_WHALE_WHITE_RUNSPEED

	inst.components.sleeper:SetResistance(5)

	inst:SetBrain(whale_white_brain)

	return inst
end

return Prefab("kyno_whale_blue_ocean", whale_blue, whale_blue_assets, whale_blue_prefabs),
Prefab("kyno_whale_white_ocean", whale_white, whale_white_assets, whale_white_prefabs)