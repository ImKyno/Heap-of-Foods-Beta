require("stategraphs/SGwobster")
require("stategraphs/SGwobsterland")

local brain_water = require("brains/wobstermonkeyislandbrain")
local brain_land = require("brains/wobsterlandbrain")

local assets =
{
	Asset("ANIM", "anim/lobster.zip"),

	Asset("ANIM", "anim/kyno_lobster_monkeyisland.zip"),
	Asset("ANIM", "anim/kyno_lobster_monkeyisland_cooked.zip"),
	Asset("ANIM", "anim/trophyscale_fish_wobster_monkeyisland.zip"), -- Custom bank with hacky stuff.
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"spoiled_fish",
	"ocean_splash_small1",
	"wobster_monkeyisland_land",
	"wobster_monkeyisland_dead",
	"wobster_monkeyisland_dead_cooked",
	"kyno_wobster_den_monkeyisland",
}

local SWIMMING_COLLISION_MASK   = COLLISION.GROUND
                                + COLLISION.LAND_OCEAN_LIMITS
                                + COLLISION.OBSTACLES
                                + COLLISION.SMALLOBSTACLES
local PROJECTILE_COLLISION_MASK = COLLISION.GROUND

local MIN_WEIGHT = TUNING.KYNO_WOBSTER_MONKEYISLAND_MIN_WEIGHT
local MAX_WEIGHT = TUNING.KYNO_WOBSTER_MONKEYISLAND_MAX_WEIGHT

local function OnProjectileLanded(inst)
	local x, y, z = inst.Transform:GetWorldPosition()

	if TheWorld.Map:IsPassableAtPoint(x, y, z) then
		local wobster = SpawnPrefab(inst.fish_def.prefab.."_land")
		
		wobster.Transform:SetPosition(x, y, z)
		wobster.Transform:SetRotation(inst.Transform:GetRotation())
		wobster.components.inventoryitem:SetLanded(true, false)

		if inst.components.weighable ~= nil and wobster.components.weighable ~= nil then
			wobster.components.weighable:CopyWeighable(inst.components.weighable)
		end

		inst:Remove()
	else
		inst:RemoveComponent("complexprojectile")

		inst.Physics:SetCollisionMask(SWIMMING_COLLISION_MASK)
		inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
		inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)

		inst.sg:GoToState("idle", "jump_pst")
		inst:RestartBrain("wobster_out_of_water")

		SpawnPrefab("splash").Transform:SetPosition(x, y, z)

		if inst.components.weighable ~= nil then
			inst.components.weighable:SetPlayerAsOwner(nil)
		end
	end
end

local function OnMakeProjectile(inst)
	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetOnHit(OnProjectileLanded)

	inst:StopBrain("wobster_out_of_water")
	inst.sg:GoToState("launched_out_of_water")

	inst.Physics:SetCollisionMask(PROJECTILE_COLLISION_MASK)
	
	inst.AnimState:SetSortOrder(0)
	inst.AnimState:SetLayer(LAYER_WORLD)

	SpawnPrefab("splash").Transform:SetPosition(inst.Transform:GetWorldPosition())

	return inst
end

local function OnReelingIn(inst, doer, angle)
	if inst:HasTag("partiallyhooked") then
		inst:RemoveTag("partiallyhooked")
		inst.components.oceanfishable:ResetStruggling()
	end
end

local function SetOnRod(inst, rod)
	if rod ~= nil then
		inst:AddTag("partiallyhooked")
		inst:AddTag("scarytooceanprey")
	else
		inst:RemoveTag("partiallyhooked")
		inst:RemoveTag("scarytooceanprey")
	end
end

local function SetupWeighable(inst)
	inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
	inst.components.weighable:Initialize(inst.fish_def.weight_min, inst.fish_def.weight_max)

	local _weight_scale = math.random()
	inst.components.weighable:SetWeight(Lerp(inst.fish_def.weight_min, inst.fish_def.weight_max, _weight_scale*_weight_scale*_weight_scale))
end

local function OnGroundLanded(inst)
	if inst.components.inventoryitem:IsHeld() then
		return
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	
	if TheWorld.Map:IsPassableAtPoint(x, y, z) then
		inst.sg:GoToState("stunned", false)
	else
		local ocean_wobster = SpawnPrefab(inst.fish_def.prefab)
		ocean_wobster.Transform:SetPosition(x, y, z)
		ocean_wobster.Transform:SetRotation(inst.Transform:GetRotation())

		if inst.components.weighable ~= nil and ocean_wobster.components.weighable ~= nil then
			ocean_wobster.components.weighable:CopyWeighable(inst.components.weighable)
			inst.components.weighable:SetPlayerAsOwner(nil)
		end

		SpawnPrefab("splash").Transform:SetPosition(x, y, z)

		inst:Remove()
	end
end

local function EnterWater(inst)
	local ix, iy, iz = inst.Transform:GetWorldPosition()

	local ocean_wobster = SpawnPrefab(inst.fish_def.prefab)
	ocean_wobster.Transform:SetPosition(ix, iy, iz)
	ocean_wobster.sg:GoToState("hop_pst")

	if inst.components.weighable ~= nil and ocean_wobster.components.weighable ~= nil then
		ocean_wobster.components.weighable:CopyWeighable(inst.components.weighable)
		inst.components.weighable:SetPlayerAsOwner(nil)
	end

	inst:Remove()
end

local function PlayCookedSound(inst)
	inst.SoundEmitter:PlaySound(inst._hit_sound)
end

local function OnDroppedAsLoot(inst, data)
	if data ~= nil and data.dropper ~= nil then
		inst.components.weighable.prefab_override_owner = data.dropper.prefab
	end
end

local function water_wobster(build_name, fish_def)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()

	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(5)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:SetCollisionMask(SWIMMING_COLLISION_MASK)
	inst.Physics:SetCapsule(0.5, 1)

	inst.AnimState:SetBank("lobster_water")
	inst.AnimState:SetBuild(build_name)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetSortOrder(ANIM_SORT_ORDER_BELOW_GROUND.UNDERWATER)
	inst.AnimState:SetLayer(LAYER_WIP_BELOW_OCEAN)

    inst:AddTag("ediblefish_meat")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")
	inst:AddTag("oceanfishable")
	inst:AddTag("oceanfishable_creature")
	inst:AddTag("oceanfishinghookable")
	inst:AddTag("swimming")
	inst:AddTag("smalloceanfish")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.fish_def = fish_def
	
	inst:AddComponent("knownlocations")

	inst:AddComponent("weighable")
	SetupWeighable(inst)

	inst:AddComponent("locomotor")
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.runspeed = TUNING.WOBSTER.SPEED.SWIM
	inst.components.locomotor.pathcaps = { allowocean = true, ignoreLand = true }

	inst:AddComponent("oceanfishable")
	inst.components.oceanfishable.makeprojectilefn = OnMakeProjectile
	inst.components.oceanfishable.onreelinginfn = OnReelingIn
	inst.components.oceanfishable.onsetrodfn = SetOnRod
	inst.components.oceanfishable:StrugglingSetup(TUNING.WOBSTER.SPEED.SWIM, TUNING.WOBSTER.SPEED.GROUND, TUNING.WOBSTER.FISHABLE_STAMINA)
	inst.components.oceanfishable.catch_distance = TUNING.OCEAN_FISHING.FISHING_CATCH_DIST

	inst:SetStateGraph("SGwobster")
	inst:SetBrain(brain_water)

	return inst
end

local function land_wobster(build_name, nameoverride, fish_def, fadeout, cook_product)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()

	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(5)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:SetCollisionMask(TheWorld.has_ocean and COLLISION.GROUND or COLLISION.WORLD, COLLISION.OBSTACLES, COLLISION.SMALLOBSTACLES)
	inst.Physics:SetCapsule(0.5, 1)

	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("lobster")
	inst.AnimState:SetBuild(build_name)
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("prey")
	inst:AddTag("animal")
	inst:AddTag("canbetrapped")
	inst:AddTag("whackable")
	inst:AddTag("smallcreature")
	inst:AddTag("smalloceancreature")
	inst:AddTag("stunnedbybomb")
	inst:AddTag("weighable_fish")
	
	if cook_product ~= nil then
		inst:AddTag("cookable")
	end
	
	inst:SetPrefabNameOverride(nameoverride)

	MakeSmallPerishableCreaturePristine(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.fish_def = fish_def
	inst._fades_out = fadeout
	inst.override_combat_fx_height = "high"
	inst._hit_sound = "hookline_2/creatures/wobster/hit"
	
	inst:AddComponent("weighable")
	SetupWeighable(inst)

	inst:AddComponent("murderable")
	inst:AddComponent("sleeper")
	inst:AddComponent("combat")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = nameoverride
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD_RARE

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.WOBSTER.SPEED.GROUND
	inst.components.locomotor.pathcaps = { allowocean = true }

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.canbepickedupalive = true
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = fish_def.prefab.."_land"

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(inst.fish_def.loot)
	inst.components.lootdropper.forcewortoxsouls = true

	if cook_product ~= nil then
		inst:AddComponent("cookable")
		inst.components.cookable.product = cook_product
		inst.components.cookable:SetOnCookedFn(PlayCookedSound)
	end

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.WOBSTER.HEALTH)
	inst.components.health.murdersound = inst._hit_sound
	inst.components.health.nofadeout = not fadeout

    inst:ListenForEvent("on_landed", OnGroundLanded)
	inst:ListenForEvent("on_loot_dropped", OnDroppedAsLoot)

	inst._enter_water = EnterWater

	inst:SetStateGraph("SGwobsterland")
	inst:SetBrain(brain_land)

	MakeSmallBurnableCharacter(inst)
	MakeTinyFreezableCharacter(inst)
	MakeHauntableLaunchAndPerish(inst)
	MakeSmallPerishableCreature(inst, TUNING.WOBSTER.SURVIVE_TIME)

    return inst
end

local function dead_wobster()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("lobster")
	inst.AnimState:SetBuild("kyno_lobster_monkeyisland")
	inst.AnimState:PlayAnimation("idle_dead")

	inst:AddTag("fishmeat")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	inst:AddTag("wobster_monkeyisland")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "wobster_monkeyisland_dead_cooked"

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD_RARE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_fish"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "wobster_monkeyisland_dead"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WOBSTER_MONKEYISLAND_DEAD_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WOBSTER_MONKEYISLAND_DEAD_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WOBSTER_MONKEYISLAND_DEAD_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

    return inst
end

local function cooked_wobster()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_lobster_monkeyisland_cooked")
	inst.AnimState:SetBuild("kyno_lobster_monkeyisland_cooked")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("fishmeat")
	inst:AddTag("catfood")
	inst:AddTag("wobster_monkeyisland")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD_RARE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_fish"

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "wobster_monkeyisland_dead_cooked"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_WOBSTER_MONKEYISLAND_DEAD_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_WOBSTER_MONKEYISLAND_DEAD_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_WOBSTER_MONKEYISLAND_DEAD_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	return inst
end

local WOBSTER_MONKEYISLAND_FISH_DEF =
{
	prefab = "wobster_monkeyisland",
	
	loot = { "wobster_monkeyisland_dead" },
	lures = TUNING.OCEANFISH_LURE_PREFERENCE.WOBSTER,
	
	weight_min = MIN_WEIGHT,
	weight_max = MAX_WEIGHT,
}

local function wobster_monkeyisland_water()
	return water_wobster("kyno_lobster_monkeyisland", WOBSTER_MONKEYISLAND_FISH_DEF)
end

local function wobster_monkeyisland_land()
	local inst = land_wobster("kyno_lobster_monkeyisland", "WOBSTER_MONKEYISLAND", WOBSTER_MONKEYISLAND_FISH_DEF, false, "wobster_monkeyisland_dead_cooked")
	
	inst:AddTag("fishfarmable")
	inst:AddTag("wobster_monkeyisland")

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("wobster_moonglass_land")
	
	inst:AddComponent("fishfarmable")
	inst.components.fishfarmable:SetTimes(TUNING.WOBSTER_MONKEYISLAND_ROETIME, TUNING.WOBSTER_MONKEYISLAND_BABYTIME)
	inst.components.fishfarmable:SetProducts("kyno_roe_wobster_monkeyisland", "wobster_monkeyisland_land")
	inst.components.fishfarmable:SetPhases({ "day" })
	inst.components.fishfarmable:SetMoonPhases({ "new", "quarter", "half", "threequarter", "full" })
	inst.components.fishfarmable:SetSeasons({ "autumn", "summer" })
	inst.components.fishfarmable:SetWorlds({ "forest", "cave" })

	return inst
end

return Prefab("wobster_monkeyisland", wobster_monkeyisland_water, assets, prefabs),
Prefab("wobster_monkeyisland_land", wobster_monkeyisland_land, assets, prefabs),
Prefab("wobster_monkeyisland_dead", dead_wobster, assets, prefabs),
Prefab("wobster_monkeyisland_dead_cooked", cooked_wobster, assets, prefabs)