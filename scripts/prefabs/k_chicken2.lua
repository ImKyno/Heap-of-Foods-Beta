local brain = require("brains/chicken2brain")

local assets =
{
	Asset("ANIM", "anim/chicken.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"drumstick",
	"drumstick_cooked",
	"bird_egg",
	"goose_feather",
}

local ChickenSounds = 
{
	scream 	= "dontstarve_DLC001/creatures/buzzard/hurt",
	hurt 	= "dontstarve_DLC001/creatures/buzzard/hurt",
}

SetSharedLootTable("kyno_chicken2",
{
    {"drumstick",             1.00},
	{"drumstick",             0.50},
	{"goose_feather",         1.00},
	{"goose_feather",         0.33},
})

local function SetHome(inst)
	inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
end

local function SetNewHome(inst)
	inst.components.knownlocations:ForgetLocation("home")
	inst:DoTaskInTime(1, SetHome) -- Set home again.
end

local function OnStartDay(inst)
    if inst.components.combat:HasTarget() ~= nil then
    	inst.components.combat:SetTarget(nil)
    end
end

local function CanShareTarget(dude)
    return not dude:IsInLimbo() and not dude.components.health:IsDead()
end

local function OnCooked(inst, cooker, chef)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")
end

local function OnInventory(inst)
	inst:ClearBufferedAction()
end

local function OnPickUp(inst)
	inst:PushEvent("detachchild") -- No longer part of the spawner.
end

local function OnDropped(inst)
	inst:DoTaskInTime(1, SetNewHome)
	inst.components.sleeper:GoToSleep()
end

local function OnSleep(inst)
	inst.components.inventoryitem.canbepickedup = true 
end

local function OnWakeUp(inst)
	inst.components.inventoryitem.canbepickedup = false
end

local function OnDeath(inst, data)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	
	if inst.components.lootdropper and owner then
		local loots = inst.components.lootdropper:GenerateLoot()
		inst:Remove()
			
		for k, v in pairs(loots) do
			local loot = SpawnPrefab(v)
			owner.components.inventory:GiveItem(loot)
		end
	end
end

local function CanSleep(inst)
	return DefaultSleepTest(inst)
end

local function CanSpawnEgg(inst)
	if inst.components.inventoryitem:IsHeld() or inst.components.sleeper:IsAsleep() then
		return false
	else
		return true
	end
end

local function TestItem(inst, item, giver)
	if item.components.edible and item.components.edible.foodtype == FOODTYPE.SEEDS 
	and not inst.components.timer:TimerExists("kyno_chicken_egg_cooldown") then
		return true
	else
		inst.sg:GoToState("honk")
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.edible and item.components.edible.foodtype == FOODTYPE.SEEDS 
	and not inst.components.timer:TimerExists("kyno_chicken_egg_cooldown") then
		inst.sg:GoToState("eat_seeds")
		inst.components.timer:StartTimer("kyno_chicken_egg_cooldown", 480)
	end
end

local function settrapdata(inst, data)
    local lootdata = {}
    local named = inst.components.named
	
	if named then
		lootdata.named = {name = named.name}
	end
	
    return lootdata
end

local function restoredatafromtrap(inst, data)
    if data.named then
		if inst.components.named then
			inst.components.named:SetName(data.named.name)
		end
    end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1, 0.75)
	
	inst.Transform:SetFourFaced()
	MakeCharacterPhysics(inst, 100, .5)

	inst.AnimState:SetBank("chicken")
	inst.AnimState:SetBuild("chicken")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("cookable")
	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("canbetrapped")
	inst:AddTag("smallcreature")
	inst:AddTag("chicken2")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("timer")
	inst:AddComponent("embarker")
	inst:AddComponent("inventory")
	inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")
	inst:AddComponent("homeseeker")
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetSleepTest(CanSleep)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "drumstick_cooked"
	inst.components.cookable:SetOnCookedFn(OnCooked)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("kyno_chicken2")

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.RABBIT_RUN_SPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)

	inst:SetBrain(brain)
	inst:SetStateGraph("SGchicken2")

	inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.SEEDS }, { FOODTYPE.SEEDS })
    inst.components.eater:SetCanEatRaw()

	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "chest"

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_CHICKEN2_HEALTH)
	inst.components.health:StartRegen(5, 8)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken2"
	inst.components.inventoryitem.onputininventoryfn = OnInventory
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.longpickup = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.KYNO_CHICKEN_NAMES
    inst.components.named:PickNewName()
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
	inst.components.playerprox:SetOnPlayerNear(CanSpawnEgg)
	inst.components.playerprox:SetDist(6, 40)

	inst.sounds = ChickenSounds
	inst:DoTaskInTime(0, SetHome)
	
	inst.settrapdata = settrapdata
	inst.restoredatafromtrap = restoredatafromtrap
	
	MakeSmallBurnableCharacter(inst, "body")
	MakeTinyFreezableCharacter(inst, "chest")

	inst:WatchWorldState("startcaveday", OnStartDay)  
	
	inst:ListenForEvent("onpickup", OnPickUp)
	inst:ListenForEvent("ondropped", OnDropped)
	inst:ListenForEvent("gotosleep", OnSleep)
	inst:ListenForEvent("onwakeup", OnWakeUp)
	inst:ListenForEvent("ondeath", OnDeath)

	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, OnInventory, OnDropped)

	return inst
end

return Prefab("kyno_chicken2", fn, assets, prefabs)