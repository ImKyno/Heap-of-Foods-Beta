local assets = 
{
	Asset("ANIM", "anim/kyno_jellyfish.zip"),
	Asset("ANIM", "anim/kyno_meatrack_jellyfish.zip"),
	
	Asset("ANIM", "anim/trophyscale_fish_kyno_jellyfish.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs = 
{
	"kyno_jellyfish",
	"kyno_jellyfish_dead",
	"kyno_jellyfish_cooked",
	"kyno_jellyfish_dried",

	"spoiled_food",
}

local brain = require("brains/jellyfishoceanbrain")

local MIN_WEIGHT = TUNING.KYNO_JELLYFISH_MIN_WEIGHT
local MAX_WEIGHT = TUNING.KYNO_JELLYFISH_MAX_WEIGHT

local SWIMMING_COLLISION_MASK = COLLISION.GROUND + COLLISION.LAND_OCEAN_LIMITS + COLLISION.OBSTACLES + COLLISION.SMALLOBSTACLES

local function OnWorked(inst, worker)
	if not worker.components.explosive then
		if worker.components.inventory ~= nil then
			local jellyfish = SpawnPrefab("kyno_jellyfish")
			worker.components.inventory:GiveItem(jellyfish, nil, inst:GetPosition())
            worker.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")

			if jellyfish.components.weighable ~= nil then
				jellyfish.components.weighable:SetPlayerAsOwner(worker)
			end
		end
		
		inst:PushEvent("detachchild") -- No longer part of the spawner.
		inst:Remove()
	end
end

local function OnAttacked(inst, data)
	if data ~= nil and data.attacker ~= nil and data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead() and data.stimuli ~= "soul"
	and (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil))
	and not (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated())
	and not (data.attacker.sg ~= nil and data.attacker.sg:HasStateTag("dead")) then
		local damage_mult = 1
		
		if not IsEntityElectricImmune(data.attacker) then
			damage_mult = TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * data.attacker:GetWetMultiplier()
		end
		
		data.attacker.components.health:DoDelta(damage_mult * -TUNING.KYNO_JELLYFISH_DAMAGE, nil, inst.prefab, nil, inst)
		
		if data.attacker.sg ~= nil and data.attacker.sg:HasState("electrocute") then
			data.attacker.sg:GoToState("electrocute")
		end
	end
end

local function SetHome(inst)
	if inst.components.knownlocations ~= nil then
		inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
	end
end

local function SetNewHome(inst)
	if inst.components.knownlocations ~= nil then
		inst.components.knownlocations:ForgetLocation("home")
	end
	
	inst:DoTaskInTime(1, SetHome) -- Set home again.
end

local function SleepTest(inst, isday, isdusk, isnight)
	if isday or isnight then
		return false
	end
end

local function OnDroppedAsLoot(inst, data)
	if data ~= nil and data.dropper ~= nil then
		inst.components.weighable.prefab_override_owner = data.dropper.prefab
	end
end

local function CalcNewSize()
	local p = 2 * math.random() - 1
	return (p * p * p + 1) * 0.5
end

local function PlayShockAnim(inst)
	if inst.components.floater and inst.components.floater:IsFloating() then
		inst.AnimState:PlayAnimation("idle_water_shock")
		inst.AnimState:PushAnimation("idle_water", true)
		inst.SoundEmitter:PlaySound("hof_sounds/creatures/jellyfish/shock_water")
	else
		inst.AnimState:PlayAnimation("idle_ground_shock")
		inst.AnimState:PushAnimation("idle_ground", true)
		inst.SoundEmitter:PlaySound("hof_sounds/creatures/jellyfish/shock_land")
	end
end

local function PlayDeadAnim(inst)
	inst.AnimState:PlayAnimation("death_ground")
	inst.AnimState:PushAnimation("idle_ground", true)
	
	inst.components.inventoryitem.canbepickedup = true

	local x, y, z = inst.Transform:GetWorldPosition()
	local players = FindPlayersInRange(x, y, z, TUNING.WORTOX_SOULEXTRACT_RANGE, true)

	for _, player in ipairs(players) do
		if player:HasTag("soulstealer") then
			SpawnPrefab("wortox_soul_spawn").Transform:SetPosition(x, y, z)
			break
		end
	end
end

local function OnDropped(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local onland = TheWorld.Map:IsPassableAtPoint(x, y, z)
	local replacement = SpawnPrefab(onland and "kyno_jellyfish_dead" or "kyno_jellyfish_ocean")
	
	replacement.Transform:SetPosition(x, y, z)
	replacement:DoTaskInTime(1, SetNewHome)
	
	inst:Remove()
	
	if onland then
		replacement.components.inventoryitem.canbepickedup = false
		replacement.AnimState:PlayAnimation("stunned_loop", true)
		replacement:DoTaskInTime(1, PlayDeadAnim)
		replacement.shocktask = replacement:DoPeriodicTask(math.random() * 10 + 5, PlayShockAnim)
		replacement:AddTag("jellyfish_charged")
    end
end

local function OnDroppedDead(inst)
	inst:AddTag("jellyfish_charged")
	
	inst.shocktask = inst:DoPeriodicTask(math.random() * 10 + 5, PlayShockAnim)
	inst.AnimState:PlayAnimation("idle_ground", true)
end

local function OnPutInInventory(inst, guy)
	if inst:HasTag("jellyfish_charged") and guy.components.combat ~= nil and guy.components.inventory ~= nil and not guy:HasTag("shadowminion") then
		if not guy.components.inventory:IsInsulated() then
			guy.components.health:DoDelta(-TUNING.KYNO_JELLYFISH_DAMAGE, nil, inst.prefab, nil, inst)
			guy.sg:HandleEvent("electrocute")
        end

		inst:RemoveTag("jellyfish_charged")
	end

	if inst.shocktask then
		inst.shocktask:Cancel()
		inst.shocktask = nil
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	MakeCharacterPhysics(inst, 1, 1.25)

	inst.AnimState:SetBank("kyno_jellyfish")
	inst.AnimState:SetBuild("kyno_jellyfish")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_BOAT)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("smallcreature")
	inst:AddTag("smalloceancreature")
	inst:AddTag("electricdamageimmune")
	inst:AddTag("jellyfish")
	
	inst:SetPrefabNameOverride("KYNO_JELLYFISH")
	
	inst.no_wet_prefix = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
	inst:AddComponent("homeseeker")
	inst:AddComponent("combat")

    inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_JELLYFISH_WALKSPEED
	inst.components.locomotor.pathcaps = { allowocean = true, ignoreLand = true }

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.KYNO_JELLYFISH_OCEAN_HEALTH)
	
	-- inst:AddComponent("eater")
	-- inst.components.eater:SetDiet({ FOODGROUP.VEGETARIAN }, { FOODGROUP.VEGETARIAN })

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"kyno_jellyfish_dead"})

	inst:AddComponent("sleeper")
	inst.components.sleeper.sleeptestfn = nil

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.NET)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:SetStateGraph("SGjellyfishocean")
	inst:SetBrain(brain)
	
	inst:ListenForEvent("attacked", OnAttacked)

    MakeHauntablePanic(inst)
    MakeMediumFreezableCharacter(inst, "jelly")

    return inst
end

local function jellyfish()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("kyno_jellyfish")
	inst.AnimState:SetBuild("kyno_jellyfish")
	inst.AnimState:PlayAnimation("idle_ground", true)
	inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("meat")
	inst:AddTag("fish")
	inst:AddTag("fishfarmable")
	inst:AddTag("catfood")
	inst:AddTag("cookable")
	inst:AddTag("show_spoilage")
	inst:AddTag("weighable_fish")
	inst:AddTag("small_livestock")
	inst:AddTag("smallcreature")
	inst:AddTag("smalloceancreature")
	inst:AddTag("jellyfish")
	
	inst.scrapbook_proxy = "kyno_jellyfish_ocean"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("murderable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_jellyfish_cooked"
	
	inst:AddComponent("health")
	inst.components.health.murdersound = "hof_sounds/creatures/jellyfish/murder"
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_jellyfish_dead"})

   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable.onperishreplacement = "kyno_jellyfish_dead"
    inst.components.perishable:StartPerishing()
	
	inst:AddComponent("weighable")
	inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
	inst.components.weighable:Initialize(MIN_WEIGHT, MAX_WEIGHT)
	inst.components.weighable:SetWeight(Lerp(MIN_WEIGHT, MAX_WEIGHT, CalcNewSize()))

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_jellyfish"
	
	inst:AddComponent("fishfarmable")
	inst.components.fishfarmable:SetTimes(TUNING.JELLYFISH_ROETIME, TUNING.JELLYFISH_BABYTIME)
	inst.components.fishfarmable:SetProducts("kyno_roe_jellyfish", "kyno_jellyfish")
	inst.components.fishfarmable:SetPhases({ "day", "dusk", "night" })
	inst.components.fishfarmable:SetMoonPhases({ "new", "quarter", "half", "threequarter", "full" })
	inst.components.fishfarmable:SetSeasons({ "autumn", "winter", "spring", "summer" })
	inst.components.fishfarmable:SetWorlds({ "forest", "cave" })
	
	inst:ListenForEvent("on_landed", OnDropped)

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function jellyfish_dead()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_jellyfish")
	inst.AnimState:SetBuild("kyno_jellyfish")
	inst.AnimState:PlayAnimation("idle_ground", true)
	inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("meat")
	inst:AddTag("fish")
	inst:AddTag("fishmeat")
	inst:AddTag("catfood")
	inst:AddTag("dryable")
	inst:AddTag("cookable")
	inst:AddTag("jellyfish")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_jellyfish_cooked"
	
   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst.components.perishable:StartPerishing()
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_JELLYFISH_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_JELLYFISH_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_JELLYFISH_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("kyno_jellyfish_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst.components.dryable:SetBuildFile("kyno_meatrack_jellyfish")
	inst.components.dryable:SetDriedBuildFile("kyno_meatrack_jellyfish")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDroppedDead)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_jellyfish_dead"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function jellyfish_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_jellyfish")
	inst.AnimState:SetBuild("kyno_jellyfish")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("meat")
	inst:AddTag("fish")
	inst:AddTag("fishmeat")
	inst:AddTag("catfood")
	inst:AddTag("jellyfish")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	
   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst.components.perishable:StartPerishing()
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_JELLYFISH_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_JELLYFISH_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_JELLYFISH_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_jellyfish_cooked"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_jellyfish_ocean", fn, assets, prefabs),
Prefab("kyno_jellyfish", jellyfish, assets, prefabs),
Prefab("kyno_jellyfish_dead", jellyfish_dead, assets, prefabs),
Prefab("kyno_jellyfish_cooked", jellyfish_cooked, assets, prefabs)