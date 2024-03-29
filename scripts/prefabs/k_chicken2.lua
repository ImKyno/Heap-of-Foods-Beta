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

local chickensounds = 
{
	scream 	= "dontstarve_DLC001/creatures/buzzard/hurt",
	hurt 	= "dontstarve_DLC001/creatures/buzzard/hurt",
}

SetSharedLootTable('kyno_chicken2',
{
    {'drumstick',             1.00},
	{'drumstick',             0.50},
	{'goose_feather',         1.00},
	{'goose_feather',         0.33},
})

local function OnStartDay(inst)
    if inst.components.combat:HasTarget() ~= nil then
    	inst.components.combat:SetTarget(nil)
    end
end

local function CanShareTarget(dude)
    return not dude:IsInLimbo() and not dude.components.health:IsDead()
end

local function OnInventory(inst)
	inst:ClearBufferedAction()
	-- inst.components.periodicspawner:Stop()
end

local function OnDropped(inst)
	inst.components.sleeper:GoToSleep()
	-- inst.components.periodicspawner:Start()
end

local function CanSpawnEgg(inst)
	if inst.components.inventoryitem:IsHeld() or inst.components.sleeper:IsAsleep() then
		return false
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

local function OnCooked(inst, cooker, chef)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")
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
	inst:AddTag("smallcreature")
	inst:AddTag("herdmember")
	inst:AddTag("chicken2")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("knownlocations")
	inst:AddComponent("inspectable")
	inst:AddComponent("sleeper")
	inst:AddComponent("timer")
	inst:AddComponent("inventory")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "drumstick_cooked"
	inst.components.cookable:SetOnCookedFn(OnCooked)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('kyno_chicken2')

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.RABBIT_RUN_SPEED

	inst:SetBrain(brain)
	inst:SetStateGraph("SGchicken2")

	inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.SEEDS }, { FOODTYPE.SEEDS })
    inst.components.eater:SetCanEatRaw()

	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "chest"
	
	inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("kyno_chicken2_herd")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_CHICKEN2_HEALTH)
	inst.components.health:StartRegen(1, 8)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_chicken2"
	inst.components.inventoryitem.onputininventoryfn = OnInventory
	inst.components.inventoryitem.ondropfn = OnDropped
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.longpickup = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem:SetSinks(true)
	
	--[[
	inst:AddComponent("periodicspawner")
	inst.components.periodicspawner:SetPrefab("kyno_chicken_egg")
	inst.components.periodicspawner:SetRandomTimes(500, 60)
	inst.components.periodicspawner:SetDensityInRange(16, 4)
	inst.components.periodicspawner:SetMinimumSpacing(6)
	inst.components.periodicspawner:SetSpawnTestFn(CanSpawnEgg)
	]]--
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = 
	{ 
		"Drumstick", "Daisy", "Cah", "Noodles", "Potato",
		"Curry", "Dinner", "Garibalda", "Marta", "Marina",
		"Carrot", "Emilha", "Pintadinha", "Galinha", "Pipoca",
		"Ruiva", "Canjica", "Magricela", "Isolda", "Pedrita",
		"Isadora", "Ruivinha", "Karen", "Penosa", "Bicuda",
		"Mel", "Sol", "Lua", "Outono", "Milharina", "Lunch",
		"Clementina", "Rejane", "Morena", "Flor", "Girasol",
	}
    inst.components.named:PickNewName()

    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst:AddComponent("embarker")	

	inst.sounds = chickensounds
	MakeSmallBurnableCharacter(inst, "body")
	MakeTinyFreezableCharacter(inst, "chest")

	inst:WatchWorldState("startcaveday", OnStartDay)  
	
	inst:ListenForEvent("gotosleep", function(inst) 
		inst.components.inventoryitem.canbepickedup = true 
		-- inst.components.periodicspawner:Stop()
	end)
	
    inst:ListenForEvent("onwakeup", function(inst) 
    	inst.components.inventoryitem.canbepickedup = false
		-- inst.components.periodicspawner:Start()
    end)

    inst:ListenForEvent("death", function(inst, data) 
		local owner = inst.components.inventoryitem:GetGrandOwner()
		if inst.components.lootdropper and owner then
			local loots = inst.components.lootdropper:GenerateLoot()
			inst:Remove()
			for k, v in pairs(loots) do
				local loot = SpawnPrefab(v)
				owner.components.inventory:GiveItem(loot)
			end
		end
	end)

	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, OnInventory, OnDropped)

	return inst
end

return Prefab("kyno_chicken2", fn, assets, prefabs)