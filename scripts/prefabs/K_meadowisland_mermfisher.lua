local brain = require("brains/mermfisherbrain")

local assets =
{
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("ANIM", "anim/merm_fishing.zip"),
	Asset("ANIM", "anim/merm_fisherman_build.zip"),
	
	Asset("SOUND", "sound/merm.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
    "pondfish",
	"froglegs",
}

local sounds = 
{
    attack = "dontstarve/creatures/merm/attack",
    hit    = "dontstarve/creatures/merm/hurt",
    death  = "dontstarve/creatures/merm/death",
    talk   = "dontstarve/creatures/merm/idle",
    buff   = "dontstarve/characters/wurt/merm/warrior/yell",
}

local function OnTalk(inst, script)
    inst.SoundEmitter:PlaySound(inst.sounds.talk)
end

local function FindInvaderFn(guy, inst)
    local leader = inst.components.follower and inst.components.follower.leader

    local leader_guy = guy.components.follower and guy.components.follower.leader
    if leader_guy and leader_guy.components.inventoryitem then
        leader_guy = leader_guy.components.inventoryitem:GetGrandOwner()
    end

    return not (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:HasKingAnywhere()) and
	not (leader and leader:HasTag("player")) and
	not (leader_guy and leader_guy:HasTag("merm") and not guy:HasTag("pig"))
end

local RETARGET_CANT_TAGS = {"merm", "playermerm"}
local RETARGET_ONEOF_TAGS = {"player", "monster", "character"}

local function RetargetFn(inst)
    return FindEntity(inst, SpringCombatMod(8), FindInvaderFn, nil, RETARGET_CANT_TAGS, RETARGET_ONEOF_TAGS)
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target) and target:GetPosition():DistSq(inst:GetPosition()) < 25 * 25
end

local DECIDROOTTARGET_MUST_TAGS = { "_combat", "_health", "merm" }
local DECIDROOTTARGET_CANT_TAGS = { "INLIMBO" }

local function OnAttackedByDecidRoot(inst, attacker)
    local share_target_dist = TUNING.MERM_SHARE_TARGET_DIST
    local max_target_shares = TUNING.MERM_MAX_TARGET_SHARES

    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, SpringCombatMod(share_target_dist) * .5, DECIDROOTTARGET_MUST_TAGS, DECIDROOTTARGET_CANT_TAGS)
    local num_helpers = 0

    for i, v in ipairs(ents) do
        if v ~= inst and not v.components.health:IsDead() then
            v:PushEvent("suggest_tree_target", { tree = attacker })
            num_helpers = num_helpers + 1
            if num_helpers >= max_target_shares then
                break
            end
        end
    end
end

local NO_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO"}
local HOUSE_TAGS = {"mermhouse", "tropical_mermhouse"}

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
	
    if attacker and attacker.prefab == "deciduous_root" and attacker.owner ~= nil then
        OnAttackedByDecidRoot(inst, attacker.owner)

    elseif attacker and inst.components.combat:CanTarget(attacker) and attacker.prefab ~= "deciduous_root" then

        local share_target_dist = TUNING.MERM_SHARE_TARGET_DIST
        local max_target_shares = TUNING.MERM_MAX_TARGET_SHARES

        inst.components.combat:SetTarget(attacker)

        local pt = inst:GetPosition()
        local homes = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, HOUSE_TAGS, NO_TAGS)

        for k,v in pairs(homes) do
            if v and v.components.childspawner then
                v.components.childspawner:ReleaseAllChildren(attacker)
            end
        end

        inst.components.combat:ShareTarget(attacker, share_target_dist, function(dude)
            return (dude:HasTag("mermfighter") and not
                (dude.components.follower and dude.components.follower.leader and dude.components.follower.leader:HasTag("player")))
        end, max_target_shares)
    end
end

local function RoyalUpgrade(inst)
    if inst.components.health:IsDead() then
        return
    end
	
	inst.components.health:SetMaxHealth(TUNING.KYNO_MERMFISHER_ROYAL_HEALTH)

    inst.fishtimer_mult = 0.75

    if inst.components.timer:TimerExists("fish") then
        inst.components.timer:SetTimeLeft("fish", inst.components.timer:GetTimeLeft("fish") * 0.75)
    end

    inst.Transform:SetScale(1.05, 1.05, 1.05)
end

local function RoyalDowngrade(inst)
    if inst.components.health:IsDead() then
        return
    end
	
	inst.components.health:SetMaxHealth(TUNING.KYNO_MERMFISHER_HEALTH)

    inst.fishtimer_mult = 1

    if inst.components.timer:TimerExists("fish") then
        inst.components.timer:SetTimeLeft("fish", inst.components.timer:GetTimeLeft("fish") / 0.75)
    end

    inst.Transform:SetScale(1, 1, 1)
end

local function ResolveMermChatter(inst, strid, strtbl)
    local stringtable = STRINGS[strtbl:value()]
	
    if stringtable then
        local table_at_id = stringtable[strid:value()]
        if table_at_id ~= nil then
            local fluency_id = (ThePlayer ~= nil and ThePlayer:HasTag("mermfluent") and 1)
                or 2
            return table_at_id[fluency_id]
        end
    end
end

local function ShouldSleep(inst)
    return NocturnalSleepTest(inst)
	and not (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst))
end

local function ShouldWake(inst)
    return NocturnalWakeTest(inst) or (TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst))
end

local function OnTimerDone(inst, data)
    if data.name == "fish" then
        inst.CanFish = true
    end
end

local function OnCollect(inst)
    inst.CanFish = false

    if inst.components.timer:TimerExists("fish") then
        inst.components.timer:StopTimer("fish")
    end

    inst.components.timer:StartTimer("fish", TUNING.KYNO_MERMFISHER_TIMER * inst.fishtimer_mult)
end

local function IsAbleToAccept(inst, item, giver)
    if inst.components.health ~= nil and inst.components.health:IsDead() then
        return false, "DEAD"
    elseif inst.sg ~= nil and inst.sg:HasStateTag("busy") then
        if inst.sg:HasStateTag("sleeping") then
            return true
        else
            return false, "BUSY"
        end
    else
        return true
    end
end

local function ShouldAcceptItem(inst, item, giver)
    if inst.king ~= nil then
        return false
    end

    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end

    return (giver:HasTag("merm") and not (inst:HasTag("mermguard") and giver:HasTag("mermdisguise"))) and
	(item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD) or
	((item.components.edible and inst.components.eater and inst.components.eater:CanEat(item)) and
	(TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst)))
end

local function OnGetItemFromPlayer(inst, giver, item)
    local mermkingmanager = TheWorld.components.mermkingmanager

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

    if inst.components.sleeper and inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnEat(inst, data)
    if data.food and data.food.components.edible then
        if TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:IsCandidate(inst) then
            inst.components.mermcandidate:AddCalories(data.food)
        end
    end
end

local function TestForLunarMutation(inst,item)

end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
    
	inst.Transform:SetFourFaced()
    MakeCharacterPhysics(inst, 50, .5)
	
	inst.sounds = sounds

    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("merm_fisherman_build")
	inst.AnimState:Hide("hat")
	
	inst:AddTag("character")
    inst:AddTag("merm")
    inst:AddTag("mermfisher")
    inst:AddTag("wet")
	
	inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)
	inst.components.talker.resolvechatterfn = ResolveMermChatter
	inst.components.talker:MakeChatter()
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
	end
	
	inst.components.talker.ontalk = OnTalk
	
	inst:AddComponent("inventory")
    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
	inst:AddComponent("timer")

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = TUNING.KYNO_MERMFISHER_RUNSPEED
    inst.components.locomotor.walkspeed = TUNING.KYNO_MERMFISHER_WALKSPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)
	
	inst:AddComponent("embarker")
    inst:AddComponent("drownable")

    inst:SetStateGraph("SGmermfisher")
	inst:SetBrain(brain)

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.VEGETARIAN }, { FOODGROUP.VEGETARIAN })

    inst:AddComponent("sleeper")
	inst.components.sleeper:SetNocturnal(true)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
	
	inst:AddComponent("foodaffinity")
    inst.components.foodaffinity:AddFoodtypeAffinity(FOODTYPE.VEGGIE, 1)
    inst.components.foodaffinity:AddPrefabAffinity  ("kelp",          1)
    inst.components.foodaffinity:AddPrefabAffinity  ("kelp_cooked",   1)
    inst.components.foodaffinity:AddPrefabAffinity  ("boatpatch_kelp",1)
    inst.components.foodaffinity:AddPrefabAffinity  ("durian",        1)
    inst.components.foodaffinity:AddPrefabAffinity  ("durian_cooked", 1)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(3, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.KYNO_MERMFISHER_HEALTH)
	inst.components.health:StartRegen(30, 10)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"pondfish", "froglegs"})

    inst:AddComponent("fishingrod")
	inst.components.fishingrod:SetWaitTimes(4, 10)
    inst.components.fishingrod:SetStrainTimes(0, 3)
    inst.components.fishingrod.basenibbletime = 2
    inst.components.fishingrod.nibbletimevariance = 2
    inst.components.fishingrod.nibblestealchance = 0
	
	inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader:SetAbleToAcceptTest(IsAbleToAccept)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.MERMNAMES
    inst.components.named:PickNewName()

    inst.CanFish = true
	inst.fishtimer_mult = 1
	
	MakeHauntablePanic(inst)
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")
	
	inst:ListenForEvent("onmermkingcreated_anywhere", function()
        inst:DoTaskInTime(math.random() * 1, function()
            RoyalUpgrade(inst)
            inst:PushEvent("onmermkingcreated")
        end)
    end, TheWorld)
	
    inst:ListenForEvent("onmermkingdestroyed_anywhere", function()
        inst:DoTaskInTime(math.random() * 1, function()
            RoyalDowngrade(inst)
            inst:PushEvent("onmermkingdestroyed")
        end)
    end, TheWorld)

    inst.TestForLunarMutation = TestForLunarMutation

    if TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:HasKingAnywhere() then
        RoyalUpgrade(inst)
    end
	
	inst:ListenForEvent("oneat", OnEat)
	inst:ListenForEvent("timerdone", OnTimerDone)
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("fishingcollect", OnCollect)

    return inst
end

return Prefab("kyno_meadowisland_mermfisher", fn, assets, prefabs)