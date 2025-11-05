local brain = require("brains/swordfishoceanbrain")

local assets =
{
	Asset("ANIM", "anim/fx_boat_pop.zip"),
	Asset("ANIM", "anim/kyno_swordfish.zip"),
	
	Asset("ANIM", "anim/meat_rack_food.zip"),
	Asset("ANIM", "anim/kyno_meatrack_swordfish.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"fishmeat_cooked",
	
	"kyno_swordfish_dead",
	"kyno_swordfish_damage_fx",
	"kyno_spoiled_fish_large",
}

local SWIMMING_COLLISION_MASK = COLLISION.GROUND + COLLISION.LAND_OCEAN_LIMITS + COLLISION.OBSTACLES + COLLISION.SMALLOBSTACLES

local SWORDFISH_MUST_TAGS = { "_combat" }
local SWORDFISH_CANT_TAGS = { "INLIMBO", "outofreach", "swordfish", "puffermonster", "ghost" }

local SWORDFISH_BOAT_MUST_TAGS = { "boat" }
local SWORDFISH_BOAT_CANT_TAGS = { "INLIMBO", "outofreach", "swordfish", "puffermonster", "ghost" }

local function Retarget(inst)
	local function CheckTarget(guy)
		return inst.components.combat:CanTarget(guy)
	end

	return FindEntity(inst, TUNING.KYNO_SWORDFISH_TARGET_DIST, CheckTarget, SWORDFISH_MUST_TAGS, SWORDFISH_CANT_TAGS) or nil
end

local function KeepTarget(inst, target)
	local x, y, z = target.Transform:GetWorldPosition()

	local home = inst.components.knownlocations:GetLocation("home")
	local isnearhome = not (home ~= nil and not (inst:GetDistanceSqToPoint(home) <= TUNING.KYNO_SWORDFISH_CHASE_DIST * TUNING.KYNO_SWORDFISH_CHASE_DIST))

	-- Don't keep target if we chased too far from our home.
	return isnearhome and inst.components.combat:CanTarget(target) and not TheWorld.Map:IsVisualGroundAtPoint(x, y, z)
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, TUNING.KYNO_SWORDFISH_SHARE_TARGET_DIST, function(dude)
		return not (dude.components.health ~= nil and dude.components.health:IsDead()) and dude:HasTag("swordfish")
	end, 5)
end

local function SetAboveWater(inst, above)
	if above then
		inst.AnimState:SetLayer(LAYER_WORLD)
		inst.AnimState:SetSortOrder(0)
		
		inst.Physics:SetCollisionMask(COLLISION.WORLD)
		-- inst:RemoveTag("ignorewalkableplatforms")
	else
		inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
		inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)
		
		inst.Physics:SetCollisionMask(SWIMMING_COLLISION_MASK)
		-- inst:AddTag("ignorewalkableplatforms")
	end
end

local function SetLocoState(inst, state)
	inst.LocoState = string.lower(state)
	inst:SetAboveWater(inst.LocoState == "above")
end

local function IsLocoState(inst, state)
	return inst.LocoState == string.lower(state)
end

local function SleepTest(inst, isday, isnight)
	if isday or isnight then
		return false
	end
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

-- Tihs means we are stuck outside water and need to get out.
-- Happens if we are underwater and emerge while something is above us.
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

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeCharacterPhysics(inst, 100, 1.25)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	
	inst.AnimState:SetScale(.85, .85, .85)

	inst.AnimState:SetBank("kyno_swordfish")
	inst.AnimState:SetBuild("kyno_swordfish")
	inst.AnimState:PlayAnimation("shadow", true)
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst:AddTag("animal")
	inst:AddTag("swordfish")
	inst:AddTag("scarytoprey")
	inst:AddTag("scarytooceanpreay")
	inst:AddTag("largecreature")
	inst:AddTag("largeoceancreature")

	inst.no_wet_prefix = true

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_SWORDFISH_HEALTH)
	inst.components.health:StartRegen(TUNING.BEEFALO_HEALTH_REGEN, TUNING.BEEFALO_HEALTH_REGEN_PERIOD)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_swordfish_dead"})

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(3)
	inst.components.sleeper.sleeptestfn = nil

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_SWORDFISH_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.KYNO_SWORDFISH_RUNSPEED
	inst.components.locomotor.pathcaps = { allowocean = true, ignoreLand = true }

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.KYNO_SWORDFISH_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.KYNO_SWORDFISH_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(2, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)

	inst.SetLocoState = SetLocoState
	inst.IsLocoState = IsLocoState
	inst.SetAboveWater = SetAboveWater
	inst:SetLocoState("below")

	inst:SetBrain(brain)
	inst:SetStateGraph("SGswordfishocean")
	
	inst:ListenForEvent("attacked", OnAttacked)
	
	inst:DoPeriodicTask(3, StuckDetection) -- Stupid? Yes, but it works.

	MakeMediumFreezableCharacter(inst, "swordfish_body")
	MakeHauntablePanic(inst)

	return inst
end

local function swordfish_dead()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "large", 0.05, {0.8, 0.35, 0.8})

	inst.AnimState:SetBank("kyno_swordfish")
	inst.AnimState:SetBuild("kyno_swordfish")
	inst.AnimState:PlayAnimation("dead")
	
	inst:AddTag("meat")
	inst:AddTag("fishmeat")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	inst:AddTag("dryable")
	inst:AddTag("icebox_valid")
	inst:AddTag("saltbox_valid")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT + 2
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "fishmeat_cooked"

   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable.onperishreplacement = "kyno_spoiled_fish_large"
    inst.components.perishable:StartPerishing()

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_swordfish_dead"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_SWORDFISH_DEAD_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_SWORDFISH_DEAD_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_SWORDFISH_DEAD_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("meat_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst.components.dryable:SetBuildFile("kyno_meatrack_swordfish")
	inst.components.dryable:SetDriedBuildFile("meat_rack_food")

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function fx()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.4, .4, .4)
	
	inst.AnimState:SetBank("fx_boat_pop")
	inst.AnimState:SetBuild("fx_boat_pop")
	inst.AnimState:PlayAnimation("pop")
	
	inst:AddTag("FX")
	inst.persists = false
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

return Prefab("kyno_swordfish", fn, assets, prefabs),
Prefab("kyno_swordfish_dead", swordfish_dead, assets, prefabs),
Prefab("kyno_swordfish_damage_fx", fx, assets, prefabs)