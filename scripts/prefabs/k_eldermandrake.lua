local brain = require("brains/eldermandrakebrain")
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local assets =
{
	Asset("ANIM", "anim/elderdrake_basic.zip"),
	Asset("ANIM", "anim/elderdrake_actions.zip"),
	Asset("ANIM", "anim/elderdrake_attacks.zip"),
	Asset("ANIM", "anim/elderdrake_build.zip"),

	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"plantmeat",
	"livinglog",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function OnPickRandomSeed()
	local season = TheWorld.state.season
	local weights = {}
	local season_mod = TUNING.SEED_WEIGHT_SEASON_MOD

	for k, v in pairs(VEGGIES) do
		weights[k] = v.seed_weight * ((PLANT_DEFS[k] and PLANT_DEFS[k].good_seasons[season]) and season_mod or 1)
	end

	return weighted_random_choice(weights).."_seeds"
end

local function OnPickExtraLoot()
	local choices =
	{
		twigs                = 1,
		cutgrass             = 1,
		succulent_picked     = 1,
		[OnPickRandomSeed()] = 1,
	}

	return weighted_random_choice(choices)
end

-- Can drop a random seed based on the current season.
local function OnSetLoot(lootdropper)
	lootdropper.chanceloot = nil

	lootdropper:AddChanceLoot("plantmeat",        1.00)
	lootdropper:AddChanceLoot("livinglog",        1.00)
	lootdropper:AddChanceLoot(OnPickExtraLoot(),  1.00)
end

local function OnTalk(inst, script)
	inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/talk")
end

local function CalcSanityAura(inst, observer)
	if inst.components.follower ~= nil and inst.components.follower.leader == observer then
		return TUNING.SANITYAURA_SMALL
	end

	return 0
end

-- I'm going to invert the papers here because the ones from hamlet are booooooring as hell.
-- Elder Mandrakes will now attack anyone holding veggie based items! Muhahahaha!
local function ShouldAcceptItem(inst, item)
	if inst:HasTag("grumpy") then
		return false
	end

	return(item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD) or
	(inst.components.eater:CanEat(item) and ((item.components.edible.foodtype == FOODTYPE.ROUGHAGE) or
	inst.components.follower:GetLeader() == nil or inst.components.follower:GetLoyaltyPercent() <= 0.90))
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.edible ~= nil then
		if (item.components.edible.foodtype == FOODTYPE.ROUGHAGE)
		and item.components.inventoryitem ~= nil
		and(item.components.inventoryitem:GetGrandOwner() == inst or
			(not item:IsValid() and inst.components.inventory:FindItem(function(obj)
			return obj.prefab == item.prefab and obj.components.stackable ~= nil
			and obj.components.stackable:IsStack() end) ~= nil)) then
				if inst.components.combat:TargetIs(giver) then
					inst.components.combat:SetTarget(nil)
			elseif giver.components.leader ~= nil then
				if giver.components.minigame_participator == nil then
					giver:PushEvent("makefriend")
					giver.components.leader:AddFollower(inst)
				end

				inst.components.follower:AddLoyaltyTime(giver:HasTag("polite")
				and TUNING.RABBIT_CARROT_LOYALTY + TUNING.RABBIT_POLITENESS_LOYALTY_BONUS or TUNING.RABBIT_CARROT_LOYALTY)
			end
		end

		if inst.components.sleeper ~= nil and inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end

	if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
		local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)

		if current ~= nil then
			inst.components.inventory:DropItem(current)
		end

		inst.components.inventory:Equip(item)
		inst.AnimState:Show("hat")
	end
end

local function OnRefuseItem(inst, item)
	inst.sg:GoToState("refuse")

	if inst.components.sleeper ~= nil then
		if inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		else
			inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/refuse")
		end
	end
end

local function IsHost(dude)
	return dude:HasTag("shadowthrall_parasite_hosted")
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)

	if inst:HasTag("shadowthrall_parasite_hosted") then
		inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, IsHost, MAX_TARGET_SHARES)
	else
		inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude)
			return dude.prefab == inst.prefab
		end, MAX_TARGET_SHARES)
	end
end

local function OnNewTarget(inst, data)
    if inst:HasTag("shadowthrall_parasite_hosted") then
        inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, IsHost, MAX_TARGET_SHARES)
    else
        inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude.prefab == inst.prefab end, MAX_TARGET_SHARES)
    end
end

local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_ONEOF_TAGS = { "monster", "player" }

local function NormalRetargetFn(inst)
	return not inst:IsInLimbo() and FindEntity(inst, TUNING.PIG_TARGET_DIST, function(guy)
	return inst.components.combat:CanTarget(guy)
	and (guy.components.inventory == nil or not guy.components.inventory:EquipHasTag("eldermandrakescarer"))
	and (guy:HasTag("monster")
	or (guy.components.inventory ~= nil and
		guy:IsNear(inst, TUNING.KYNO_ELDERMANDRAKE_SEE_VEGGIE_DIST) and HasVeggieInInventoryFor(guy)))
	end, RETARGET_MUST_TAGS, nil, RETARGET_ONEOF_TAGS) or nil
end

local function NormalKeepTargetFn(inst, target)
	return not (target.sg ~= nil and target.sg:HasStateTag("hiding")) and inst.components.combat:CanTarget(target)
end

local function GetGiveUpString(combatcmp, target)
	return STRINGS.KYNO_ELDERMANDRAKE_GIVEUP[math.random(#STRINGS.KYNO_ELDERMANDRAKE_GIVEUP)]
end

local function GetBattleCryString(combatcmp, target)
	if target and target.components.inventory then
		local item = target.components.inventory:FindItem(function(item)
			return item:HasTag("mandrake")
		end)

		if item then
			return STRINGS.KYNO_ELDERMANDRAKE_MANDRAKE_BATTLECRY[math.random(#STRINGS.KYNO_ELDERMANDRAKE_MANDRAKE_BATTLECRY)]
		end
	end

	return STRINGS.KYNO_ELDERMANDRAKE_BATTLECRY[math.random(#STRINGS.KYNO_ELDERMANDRAKE_BATTLECRY)]
end

local SLEEPTARGETS_CANT_TAGS = { "soundproof", "eldermandrake", "playerghost", "FX", "DECOR", "INLIMBO" }
local SLEEPTARGETS_ONEOF_TAGS = { "sleeper", "player" }

local function DoAreaEffect(inst, knockout)
	inst.SoundEmitter:PlaySound("hof_sounds/creatures/eldermandrake/death")

	local range = TUNING.KYNO_ELDERMANDRAKE_SLEEP_RANGE
	local duration = TUNING.KYNO_ELDERMANDRAKE_SLEEP_DURATION

	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, range, nil, SLEEPTARGETS_CANT_TAGS, SLEEPTARGETS_ONEOF_TAGS)

	for i, v in ipairs(ents) do
		if not (v.components.freezable ~= nil and v.components.freezable:IsFrozen())
		and not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck())
		and not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized()) then
			local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil

			if mount ~= nil then
				mount:PushEvent("ridersleep", { sleepiness = 7, sleeptime = duration })
			end

			if v:HasTag("player") then
				v:PushEvent("yawn", { grogginess = 4, knockoutduration = duration })
			elseif v.components.sleeper ~= nil then
				v.components.sleeper:AddSleepiness(7, duration)
			elseif v.components.grogginess ~= nil then
				v.components.grogginess:AddGrogginess(4, duration)
			else
				v:PushEvent("knockedout")
			end
		end
	end
end

local function DeathScream(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
	DoAreaEffect(inst)
end

local function UpdateMood(inst, grumpy)
	if grumpy then
		inst.AnimState:Show("head_angry")
		inst.AnimState:Hide("head_happy")

		inst:AddTag("grumpy")
	else
		inst.AnimState:Hide("head_angry")
		inst.AnimState:Show("head_happy")

		inst.sg:GoToState("happy")

		inst:RemoveTag("grumpy")
	end
end

-- Becomes grumpy when Nightmare Phase is at the Wild Phase or a Rift is active.
local function RefreshMood(inst)
	local shouldbegrumpy = TheWorld.state.isnightmarewild or (TheWorld.components.riftspawner ~= nil
	and TheWorld.components.riftspawner:IsShadowPortalActive() or TheWorld.components.riftspawner:IsLunarPortalActive())

	if shouldbegrumpy and not inst:HasTag("grumpy") then
		inst:DoTaskInTime(1 + math.random(), function()
			if inst:IsValid() then
				UpdateMood(inst, true)
			end
		end)
	elseif not shouldbegrumpy and inst:HasTag("grumpy") then
		inst:DoTaskInTime(1 + math.random(), function()
			if inst:IsValid() then
				UpdateMood(inst, false)
			end
		end)
	end
end

local function OnEntityWake(inst)
	RefreshMood(inst)
end

local function OnEntitySleep(inst)
	if inst.checktask ~= nil then
		inst.checktask:Cancel()
		inst.checktask = nil
	end
end

local function OnInit(inst)
	RefreshMood(inst)
end

local function GetStatus(inst, viewer)
	return (inst.components.follower ~= nil and inst.components.follower:GetLeader() and "FOLLOWER")
	or (inst:HasTag("grumpy") and "GRUMPY")
	or "GENERIC"
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)

	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1.25, 1.25, 1.25)

	MakeCharacterPhysics(inst, 50, .5)

	inst.AnimState:SetBank("elderdrake")
	inst.AnimState:SetBuild("elderdrake_build")
	-- inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:Hide("hat")
	inst.AnimState:Hide("ARM_carry")
	inst.AnimState:Hide("HAIR_HAT")

	inst:AddTag("trader")
	inst:AddTag("character")
	inst:AddTag("cavedweller")
    inst:AddTag("scarytoprey")
    inst:AddTag("eldermandrake")
	inst:AddTag("_named")

	inst:AddComponent("talker")
	inst.components.talker.fontsize = 35
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0, -450, 0)
	inst.components.talker:MakeChatter()

	inst:AddComponent("spawnfader")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:RemoveTag("_named")

	inst.components.talker.ontalk = OnTalk

	inst:AddComponent("embarker")
	inst:AddComponent("drownable")
	inst:AddComponent("bloomer")
	inst:AddComponent("inventory")
	inst:AddComponent("knownlocations")
	inst:AddComponent("timer")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(2)
	inst.components.sleeper.sleeptestfn = NocturnalSleepTest
	inst.components.sleeper.waketestfn = NocturnalWakeTest
	inst.components.sleeper.watchlight = true

	inst:AddComponent("follower")
	inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_ELDERMANDRAKE_HEALTH)
	inst.components.health:StartRegen(TUNING.KYNO_ELDERMANDRAKE_HEALTH_REGEN_AMOUNT, TUNING.KYNO_ELDERMANDRAKE_HEALTH_REGEN_PERIOD)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLootSetupFn(OnSetLoot)
    OnSetLoot(inst.components.lootdropper)

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = CalcSanityAura

	inst:AddComponent("named")
	inst.components.named.possiblenames = STRINGS.KYNO_ELDERMANDRAKE_NAMES
	inst.components.named:PickNewName()

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.KYNO_ELDERMANDRAKE_RUNSPEED
	inst.components.locomotor.walkspeed = TUNING.KYNO_ELDERMANDRAKE_WALKSPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.ROUGHAGE }, { FOODTYPE.ROUGHAGE })
	inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetStrongStomach(true)

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader.deleteitemonaccept = false

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.KYNO_ELDERMANDRAKE_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.KYNO_ELDERMANDRAKE_ATTACK_PERIOD)
	inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
	inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
	inst.components.combat.hiteffectsymbol = "elderdrake_torso"
	inst.components.combat.panic_thresh = TUNING.KYNO_ELDERMANDRAKE_PANIC_THRESHOLD
	inst.components.combat.GetBattleCryString = GetBattleCryString
	inst.components.combat.GetGiveUpString = GetGiveUpString

	inst:SetBrain(brain)
	inst:SetStateGraph("SGeldermandrake")

	inst:DoTaskInTime(0, OnInit)

	inst:ListenForEvent("death", DeathScream)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("newcombattarget", OnNewTarget)

	inst:WatchWorldState("isnightmarewild", RefreshMood)	

	inst:ListenForEvent("ms_riftaddedtopool", function()
		RefreshMood(inst)
	end, TheWorld)

	inst:ListenForEvent("ms_riftremovedfrompool", function()
		RefreshMood(inst)
	end, TheWorld)

	inst.OnEntityWake = OnEntityWake
	inst.OnEntitySleep = OnEntitySleep

	MakeHauntablePanic(inst)
	MakeMediumBurnableCharacter(inst, "elderdrake_torso")
	MakeMediumFreezableCharacter(inst, "pig_torso")

	return inst
end

return Prefab("kyno_eldermandrake", fn, assets, prefabs)