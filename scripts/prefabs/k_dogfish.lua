local brain = require("brains/dogfishoceanbrain")

local assets =
{
	Asset("ANIM", "anim/kyno_dogfish.zip"),

	Asset("ANIM", "anim/kyno_meatrack_dogfish.zip"),
	Asset("ANIM", "anim/kyno_meatrack_fishmeat.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"fishmeat_cooked",

	"kyno_dogfish_dead",
	"kyno_fishmeat_dried",
	"kyno_spoiled_fish_large",
}

local SWIMMING_COLLISION_MASK = COLLISION.GROUND + COLLISION.LAND_OCEAN_LIMITS + COLLISION.OBSTACLES + COLLISION.SMALLOBSTACLES

local function SetAboveWater(inst, above)
	if above then
		inst.AnimState:SetLayer(LAYER_WORLD)
		inst.AnimState:SetSortOrder(0)
		
		inst.Physics:SetCollisionMask(COLLISION.WORLD)
	else
		inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
		inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)
		
		inst.Physics:SetCollisionMask(SWIMMING_COLLISION_MASK)
	end
end

local function SetLocoState(inst, state)
	inst.LocoState = string.lower(state)
	inst:SetAboveWater(inst.LocoState == "above")
end

local function IsLocoState(inst, state)
	return inst.LocoState == string.lower(state)
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

	MakeCharacterPhysics(inst, 100, 0.5)

	inst.AnimState:SetBank("kyno_dogfish")
	inst.AnimState:SetBuild("kyno_dogfish")
	inst.AnimState:PlayAnimation("shadow", true)
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst.no_wet_prefix = true

	inst:AddTag("animal")
	inst:AddTag("dogfish")
	inst:AddTag("largecreature")
	inst:AddTag("largeoceancreature")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")
	inst:AddComponent("combat")

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_DOGFISH_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.KYNO_DOGFISH_RUNSPEED
	inst.components.locomotor.pathcaps = {allowocean = true, ignoreLand = true}

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.KYNO_DOGFISH_HEALTH)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_dogfish_dead"})

	inst:AddComponent("sleeper")
	inst.components.sleeper.sleeptestfn = nil

	inst.SetLocoState = SetLocoState
	inst.IsLocoState = IsLocoState
	inst.SetAboveWater = SetAboveWater
	SetLocoState(inst, "below")

	inst:SetBrain(brain)
	inst:SetStateGraph("SGdogfishocean")
	
	inst:DoPeriodicTask(3, StuckDetection) -- Stupid? Yes, but it works.

	MakeHauntablePanic(inst)
	MakeMediumFreezableCharacter(inst, "dogfish_body")

	return inst
end

local function dogfish_dead()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "large", 0.05, {0.5, 0.35, 0.5})

	inst.AnimState:SetBank("kyno_dogfish")
	inst.AnimState:SetBuild("kyno_dogfish")
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
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "fishmeat_cooked"

   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable.onperishreplacement = "kyno_spoiled_fish_large"
    inst.components.perishable:StartPerishing()

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_dogfish_dead"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_DOGFISH_DEAD_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_DOGFISH_DEAD_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_DOGFISH_DEAD_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("meat_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst.components.dryable:SetBuildFile("kyno_meatrack_dogfish")
	inst.components.dryable:SetDriedBuildFile("meat_rack_food")

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_dogfish", fn, assets, prefabs),
Prefab("kyno_dogfish_dead", dogfish_dead, assets, prefabs)