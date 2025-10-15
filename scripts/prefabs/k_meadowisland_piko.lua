local squirrelbrain = require("brains/squirrelbrain")

local assets =
{
	Asset("ANIM", "anim/ds_squirrel_basic.zip"),
	Asset("ANIM", "anim/squirrel_cheeks_build.zip"),
	Asset("ANIM", "anim/squirrel_build.zip"),

	Asset("ANIM", "anim/orange_squirrel_cheeks_build.zip"),
	Asset("ANIM", "anim/orange_squirrel_build.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"smallmeat",
	"cookedsmallmeat",
}

local squirrel_sounds = 
{
	scream = "hof_sounds/creatures/piko/steal",
	hurt = "hof_sounds/creatures/piko/attack",
	hit = "hof_sounds/creatures/piko/attack",
}

local function UpdateBuild(inst, cheeks)
	local build = "squirrel_build"

	if cheeks then
		build = "squirrel_cheeks_build"
	end

	if inst:HasTag("orange_piko") then
		build = "orange_"..build
	end

	inst.AnimState:SetBuild(build)
end

local function RefreshBuild(inst)
	if inst.components.inventory:NumItems() > 0 then
		inst.UpdateBuild(inst, true)
	else
		inst.UpdateBuild(inst, false)
	end
end

local function OnDrop(inst)
	RefreshBuild(inst)
	inst.sg:GoToState("stunned")
end

local function OnCooked(inst)
	inst.SoundEmitter:PlaySound("hof_sounds/creatures/piko/steal")
end

local function OnAttacked(inst, data)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 30, {"squirrel"})

	local num_friends = 0
	local maxnum = 5
	for k, v in pairs(ents) do
		v:PushEvent("gohome")
		num_friends = num_friends + 1

		if num_friends > maxnum then
			break
		end
	end
end

local function OnWentHome(inst)
    local tree = inst.components.homeseeker and inst.components.homeseeker.home or nil
	
    if not tree then 
		return 
	end
	
    if tree.components.inventory then
        inst.components.inventory:TransferInventory(tree)        
        inst.UpdateBuild(inst, false)        
    end
end

local function OnPickup(inst)
	RefreshBuild(inst)
	inst.UpdateBuild(inst, true)	
end

local function OnDrop(inst)
	RefreshBuild(inst)
end

local function Retarget(inst)
    local dist = TUNING.KYNO_PIKO_TARGET_DIST

    return FindEntity(inst, dist, function(guy) 
		return not guy:HasTag("squirrel") and inst.components.combat:CanTarget(guy) and guy.components.inventory and (guy.components.inventory:NumItems() > 0)
    end)
end

local function KeepTarget(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function OnEat(inst, food)
	if food ~= nil and food.components.edible ~= nil then
        if food:HasTag("honeyed") then
			if inst.components.inventoryitem:IsHeld() then
				local owner = inst.components.inventoryitem:GetGrandOnwer()
				owner.components.inventory:GiveItem("kyno_piko_orange")
				inst:Remove()
			else
				SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
				SpawnPrefab("kyno_piko_orange").Transform:SetPosition(inst.Transform:GetWorldPosition())
				inst:Remove()
			end
		end
	end
end

local function OnSave(inst, data)	
	if inst:HasTag("orange_piko") then
		data.orange = true
	end
end  

local function OnLoad(inst, data)
	if data ~= nil and data.orange then
		inst:AddTag("orange_piko")
	end

	if inst.spawntask then
		inst.spawntask:Cancel()
		inst.spawntask = nil
	end	

	RefreshBuild(inst)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1, 0.75)

	MakeCharacterPhysics(inst, 1, 0.12)
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("squirrel")
	inst.AnimState:SetBuild("squirrel_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("eye_red")
	inst.AnimState:Hide("eye2_red")
	
	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("squirrel")
	inst:AddTag("smallcreature")
	inst:AddTag("canbetrapped")
	inst:AddTag("cannotstealequipped") 
	inst:AddTag("cookable")
	
	MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.data = {}
	inst.sounds = squirrel_sounds
	inst.force_onwenthome_message = true
	
	inst:AddComponent("inventory")
	inst:AddComponent("sanityaura")
	inst:AddComponent("knownlocations")
	inst:AddComponent("cookwareinstallable")
	inst:AddComponent("inspectable")
	inst:AddComponent("sleeper")
	inst:AddComponent("thief")

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.KYNO_PIKO_RUN_SPEED

	inst:SetStateGraph("SGsquirrel")
	inst:SetBrain(squirrelbrain)

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
	inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetOnEatFn(OnEat)
	inst.components.eater.strongstomach = true
	inst.components.eater.foodprefs = {"SEEDS"}

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_piko"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "cookedsmallmeat"
	inst.components.cookable:SetOnCookedFn(OnCooked)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.KYNO_PIKO_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.KYNO_PIKO_ATTACK_PERIOD)
    inst.components.combat:SetRange(0.7)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat.hiteffectsymbol = "chest"
	inst.components.combat.onhitotherfn = function(inst, other, damage) inst.components.thief:StealItem(other) end

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_PIKO_HEALTH)
	inst.components.health.murdersound = "hof_sounds/creatures/piko/attack"
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"smallmeat"})
	
	MakeSmallBurnableCharacter(inst, "chest")
	MakeTinyFreezableCharacter(inst, "chest") 

	inst.UpdateBuild = UpdateBuild

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onwenthome", OnWentHome)
	inst:ListenForEvent("onpickupitem", OnPickup)
	inst:ListenForEvent("dropitem", OnDrop)

	MakeFeedableSmallLivestock(inst, TUNING.KYNO_PIKO_PERISH_TIME, nil, OnDrop)

	return inst
end

local function orangefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1, 0.75)

	MakeCharacterPhysics(inst, 1, 0.12)
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("squirrel")
	inst.AnimState:SetBuild("orange_squirrel_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("eye_red")
	inst.AnimState:Hide("eye2_red")
	
	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("squirrel")
	inst:AddTag("smallcreature")
	inst:AddTag("canbetrapped")
	inst:AddTag("cannotstealequipped") 
	inst:AddTag("cookable")
	inst:AddTag("orange_piko")
	
	MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.data = {}
	inst.sounds = squirrel_sounds
	inst.force_onwenthome_message = true
	
	inst:AddComponent("inventory")
	inst:AddComponent("sanityaura")
	inst:AddComponent("knownlocations")
	inst:AddComponent("cookwareinstallable")
	inst:AddComponent("inspectable")
	inst:AddComponent("sleeper")
	inst:AddComponent("thief")

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.KYNO_PIKO_RUN_SPEED

	inst:SetStateGraph("SGsquirrel")
	inst:SetBrain(squirrelbrain)

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
	inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
	inst.components.eater:SetOnEatFn(OnEat)
	inst.components.eater.strongstomach = true
	inst.components.eater.foodprefs = {"SEEDS"}

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_piko_orange"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "cookedsmallmeat"
	inst.components.cookable:SetOnCookedFn(OnCooked)
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.KYNO_PIKO_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.KYNO_PIKO_ATTACK_PERIOD)
    inst.components.combat:SetRange(0.7)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat.hiteffectsymbol = "chest"
	inst.components.combat.onhitotherfn = function(inst, other, damage) inst.components.thief:StealItem(other) end

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_PIKO_HEALTH)
	inst.components.health.murdersound = "hof_sounds/creatures/piko/attack"
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"smallmeat"})
	
	MakeSmallBurnableCharacter(inst, "chest")
	MakeTinyFreezableCharacter(inst, "chest") 

	inst.UpdateBuild = UpdateBuild

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onwenthome", OnWentHome)
	inst:ListenForEvent("onpickupitem", OnPickup)
	inst:ListenForEvent("dropitem", OnDrop)

	MakeFeedableSmallLivestock(inst, TUNING.KYNO_PIKO_PERISH_TIME, nil, OnDrop)

	return inst
end

return Prefab("kyno_piko", fn, assets, prefabs),
Prefab("kyno_piko_orange", orangefn, assets, prefabs)