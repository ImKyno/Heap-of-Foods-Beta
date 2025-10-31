local assets = 
{
	Asset("ANIM", "anim/kyno_jellyfish_rainbow.zip"),
	Asset("ANIM", "anim/kyno_meatrack_jellyfish.zip"),
	
	Asset("ANIM", "anim/trophyscale_fish_kyno_jellyfish_rainbow.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs = 
{
	"kyno_jellyfish_rainbow",
	"kyno_jellyfish_rainbow_dead",
	"kyno_jellyfish_rainbow_cooked",
	"kyno_jellyfish_dried",
	
	"kyno_jellyfish_rainbow_light",
	"kyno_jellyfish_rainbow_light_fx",
	"kyno_jellyfish_rainbow_light_greater",
	"kyno_jellyfish_rainbow_light_fx_greater",
	
	"spoiled_food",
}

local brain = require("brains/jellyfishrainbowoceanbrain")

local MIN_WEIGHT = TUNING.KYNO_JELLYFISH_RAINBOW_MIN_WEIGHT
local MAX_WEIGHT = TUNING.KYNO_JELLYFISH_RAINBOW_MAX_WEIGHT
local INTENSITY = 0.65

local function SwapColor(inst, light)
	if inst.ispink then
		inst.ispink = false
		inst.isgreen = true
		inst.components.lighttweener:StartTween(light, nil, nil, nil, { 0/255,   180/255, 255/255 }, 4, SwapColor)
	elseif inst.isgreen then
		inst.isgreen = false
		inst.components.lighttweener:StartTween(light, nil, nil, nil, { 240/255, 230/255, 100/255 }, 4, SwapColor)
	else
		inst.ispink = true
		inst.components.lighttweener:StartTween(light, nil, nil, nil, { 251/255, 30/255,  30/255  }, 4, SwapColor)
	end
end

local function TurnOn(inst)
	inst._switchlightstate:push()
	
	if inst.Light and not inst.hidden then
		inst.Light:Enable(true)
		
		local secs = 1 + math.random()
		inst.components.lighttweener:StartTween(inst.Light, 0, nil, nil, nil, 0)
		inst.components.lighttweener:StartTween(inst.Light, INTENSITY, nil, nil, nil, secs, SwapColor)
	end
end

local function TurnOff(inst)
	if inst.Light then
		inst.Light:Enable(false)
	end
end

local function FadeIn(inst)
	inst.hidden = false
	
	inst.AnimState:PlayAnimation("idle")
    
	inst:Show()
	inst:RemoveTag("NOCLICK")
end

local function FadeOut(inst)
	inst.hidden = true
    
	inst:AddTag("NOCLICK")
	inst:Hide()
end

local function OnWake(inst)
	if not TheWorld.state.isday then
		FadeIn(inst)
		TurnOn(inst)
	else
		TurnOff(inst)
	end
end

local function OnSleep(inst)
	if TheWorld.state.isday then
		FadeOut(inst)
		TurnOff(inst)
	end
end

local function OnDeath(inst)
	if inst.Light then
		local secs = .25
		inst.components.lighttweener:StartTween(inst.Light, 0, nil, nil, nil, secs, TurnOff)
	end
end

local function OnWorked(inst, worker)
	if not worker.components.explosive then
		if worker.components.inventory ~= nil then
			local jellyfish = SpawnPrefab("kyno_jellyfish_rainbow")
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

local function OnDay(inst, isday)
	if isday then
		if inst.Light then
			local secs = 1.5 + math.random()
			inst.components.lighttweener:StartTween(inst.Light, 0, nil, nil, nil, secs, TurnOff)
		end
	end
end

local function OnDusk(inst, isdusk)
	if isdusk then
		TurnOn(inst)
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
	local replacement = SpawnPrefab(onland and "kyno_jellyfish_rainbow_dead" or "kyno_jellyfish_rainbow_ocean")
	
	replacement.Transform:SetPosition(x, y, z)
	replacement:DoTaskInTime(1, SetNewHome)
	
	inst:Remove()
	
	if onland then
		replacement.components.inventoryitem.canbepickedup = false
		replacement.AnimState:PlayAnimation("stunned_loop", true)
		replacement:DoTaskInTime(1, PlayDeadAnim)
    end
end

local function OnDroppedDead(inst)
	inst.AnimState:PlayAnimation("idle_ground", true)
end

local function CreateLight(eater, lightprefab)
	if eater.wormlight ~= nil then
		if eater.wormlight.prefab == lightprefab then
			eater.wormlight.components.spell.lifetime = 0
			eater.wormlight.components.spell:ResumeSpell()
			return
		else
			eater.wormlight.components.spell:OnFinish()
		end
	end

	local light = SpawnPrefab(lightprefab)
	light.components.spell:SetTarget(eater)
	
	if light:IsValid() then
		if light.components.spell.target == nil then
			light:Remove()
		else
			light.components.spell:StartSpell()
		end
	end
end

local function OnEaten(inst, eater)
    CreateLight(eater, "kyno_jellyfish_rainbow_light")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetColour(251/255, 30/255, 30/255)
	inst.Light:Enable(false)
	inst.Light:EnableClientModulation(true)
	inst.Light:SetIntensity(0.65)
	inst.Light:SetRadius(2)
	inst.Light:SetFalloff(.45)
	
	inst.Transform:SetFourFaced()
	
	MakeCharacterPhysics(inst, 1, 0.5)
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_jellyfish_rainbow")
	inst.AnimState:SetBuild("kyno_jellyfish_rainbow")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("smallcreature")
	inst:AddTag("smalloceancreature")
	
	inst:SetPrefabNameOverride("KYNO_JELLYFISH_RAINBOW")
	
	inst.ispink = true
	inst._switchlightstate = net_event(inst.GUID, "kyno_jellyfishrainbow_planted._switchlightstate")
	
	inst:AddComponent("lighttweener")
	inst.components.lighttweener:StartTween(inst.Light, nil, nil, nil, { 0/255, 180/255, 255/255 }, 4, SwapColor)

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst:ListenForEvent("kyno_jellyfishrainbow_planted._switchlightstate", function(inst, data)
			if inst.Light and not inst:HasTag("NOCLICK") then
				local secs = 1 + math.random()
				
				inst.components.lighttweener:StartTween(inst.Light, 0, nil, nil, nil, 0)
				inst.components.lighttweener:StartTween(inst.Light, INTENSITY, nil, nil, nil, secs, SwapColor)
			end
		end)

		return inst
	end
	
	inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
	inst:AddComponent("homeseeker")
	inst:AddComponent("combat")
	inst:AddComponent("fader")

    inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.KYNO_JELLYFISH_RAINBOW_WALKSPEED
	inst.components.locomotor.pathcaps = { allowocean = true, ignoreLand = true }

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.KYNO_JELLYFISH_RAINBOW_OCEAN_HEALTH)
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODGROUP.VEGETARIAN }, { FOODGROUP.VEGETARIAN })

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"kyno_jellyfish_rainbow_dead"})

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetSleepTest(SleepTest)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.NET)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:SetStateGraph("SGjellyfishrainbowocean")
	inst:SetBrain(brain)
	
	-- inst.OnEntityWake = OnWake
	-- inst.OnEntitySleep = OnSleep

	inst:WatchWorldState("isday", OnDay)
	inst:WatchWorldState("isdusk", OnDusk)

	inst:ListenForEvent("death", OnDeath)

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
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_jellyfish_rainbow")
	inst.AnimState:SetBuild("kyno_jellyfish_rainbow")
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
	
	inst.scrapbook_proxy = "kyno_jellyfish_rainbow_ocean"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("murderable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_jellyfish_rainbow_cooked"
	
	inst:AddComponent("health")
	inst.components.health.murdersound = "hof_sounds/creatures/jellyfish/murder"
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_jellyfish_rainbow_dead"})

   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable.onperishreplacement = "kyno_jellyfish_rainbow_dead"
    inst.components.perishable:StartPerishing()
	
	inst:AddComponent("weighable")
	inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
	inst.components.weighable:Initialize(MIN_WEIGHT, MAX_WEIGHT)
	inst.components.weighable:SetWeight(Lerp(MIN_WEIGHT, MAX_WEIGHT, CalcNewSize()))

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_rainbow_jellyfish"
	
	inst:AddComponent("fishfarmable")
	inst.components.fishfarmable:SetTimes(TUNING.JELLYFISH_RAINBOW_ROETIME, TUNING.JELLYFISH_RAINBOW_BABYTIME)
	inst.components.fishfarmable:SetProducts("kyno_roe_jellyfish_rainbow", "kyno_jellyfish_rainbow")
	inst.components.fishfarmable:SetPhases({ "dusk", "night" })
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
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_jellyfish_rainbow")
	inst.AnimState:SetBuild("kyno_jellyfish_rainbow")
	inst.AnimState:PlayAnimation("idle_ground", true)
	inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("meat")
	inst:AddTag("fish")
	inst:AddTag("fishmeat")
	inst:AddTag("catfood")
	inst:AddTag("dryable")
	inst:AddTag("cookable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_jellyfish_rainbow_cooked"
	
   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst.components.perishable:StartPerishing()
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_JELLYFISH_RAINBOW_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_JELLYFISH_RAINBOW_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_JELLYFISH_RAINBOW_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
	inst.components.edible:SetOnEatenFn(OnEaten)
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("kyno_jellyfish_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst.components.dryable:SetBuildFile("kyno_meatrack_jellyfish")
	inst.components.dryable:SetDriedBuildFile("kyno_meatrack_jellyfish")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDroppedDead)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_jellyfish_rainbow_dead"

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
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_jellyfish_rainbow")
	inst.AnimState:SetBuild("kyno_jellyfish_rainbow")
	inst.AnimState:PlayAnimation("cooked")
	inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("meat")
	inst:AddTag("fish")
	inst:AddTag("fishmeat")
	inst:AddTag("catfood")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	
   	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
    inst.components.perishable.onperishreplacement = "spoiled_food"
    inst.components.perishable:StartPerishing()
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_JELLYFISH_RAINBOW_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_JELLYFISH_RAINBOW_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_JELLYFISH_RAINBOW_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.secondaryfoodtype = FOODTYPE.MONSTER
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_jellyfish_rainbow_cooked"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_jellyfish_rainbow_ocean", fn, assets, prefabs),
Prefab("kyno_jellyfish_rainbow", jellyfish, assets, prefabs),
Prefab("kyno_jellyfish_rainbow_dead", jellyfish_dead, assets, prefabs),
Prefab("kyno_jellyfish_rainbow_cooked", jellyfish_cooked, assets, prefabs)