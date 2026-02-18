local chicken_wild_brain = require("brains/chickenwildbrain")
local chicken_coop_brain = require("brains/chickencoopbrain")

local assets =
{
	Asset("ANIM", "anim/chicken.zip"),
	Asset("ANIM", "anim/chicken_coop_1_build.zip"),
	Asset("ANIM", "anim/chicken_coop_2_build.zip"),
	Asset("ANIM", "anim/chicken_coop_3_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"drumstick",
	"drumstick_cooked",
	"goose_feather",
}

local ChickenSounds = 
{
	scream 	= "dontstarve_DLC001/creatures/buzzard/hurt",
	hurt 	= "dontstarve_DLC001/creatures/buzzard/hurt",
	hit     = "dontstarve_DLC001/creatures/buzzard/hurt",
}

SetSharedLootTable("kyno_chicken2",
{
	{ "drumstick",     1.00 },
	{ "drumstick",     0.50 },
	{ "goose_feather", 1.00 },
	{ "goose_feather", 0.33 },
})

SetSharedLootTable("kyno_chicken_coop",
{
	{ "drumstick",     1.00 },
	{ "drumstick",     1.00 },
	{ "goose_feather", 1.00 },
	{ "goose_feather", 0.50 },
})

local CHICKEN_COOP_VARIANTS =
{
	{
		build = "chicken",
		icon  = "kyno_chicken2",
	},
	{
		build = "chicken_coop_1_build",
		icon  = "kyno_chicken_coop_1",
	},
	
	{
		build = "chicken_coop_2_build",
		icon  = "kyno_chicken_coop_2",
	},
	
	{
		build = "chicken_coop_3_build",
		icon  = "kyno_chicken_coop_3",
	},
}

local function PickRandomChickenCoopVariant()
	return CHICKEN_COOP_VARIANTS[math.random(#CHICKEN_COOP_VARIANTS)]
end

local function ApplyChickenCoopVariant(inst, variant)
	inst.AnimState:AddOverrideBuild(variant.build)

	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:ChangeImageName(variant.icon)
	end

	inst._color_build = variant.build
	inst._icon_name = variant.icon
end

local function SetHome(inst)
	inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
end

local function OnCooked(inst, cooker, chef)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")
end

local function OnPickUp(inst)
	inst:ClearBufferedAction()
	
	if inst._color_build and inst._icon_name then
		ApplyChickenCoopVariant(inst,
		{
			build = inst._color_build,
			icon = inst._icon_name,
		})
	end

	if inst:HasTag("chicken_wild") then
		inst:PushEvent("detachchild") -- No longer part of the spawner.
	end
end

local function OnDropped(inst)
	if inst._color_build and inst._icon_name then
		ApplyChickenCoopVariant(inst,
		{
			build = inst._color_build,
			icon = inst._icon_name,
		})
	end

	if not TheWorld.state.iscaveday and inst.components.sleeper ~= nil then
		inst.components.sleeper:GoToSleep()
	end
end

local function OnSleep(inst)
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem.canbepickedup = true 
	end
end

local function OnWakeUp(inst)
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem.canbepickedup = false
	end
end

local function OnDeath(inst, data)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	
	if inst.components.lootdropper ~= nil and owner ~= nil then
		local loots = inst.components.lootdropper:GenerateLoot()
		inst:Remove()
			
		for k, v in pairs(loots) do
			local loot = SpawnPrefab(v)
			
			if owner.components.inventory ~= nil then
				owner.components.inventory:GiveItem(loot)
			end
		end
	end
end

local function CanSleep(inst)
	return DefaultSleepTest(inst)
end

local function CanSpawnEgg(inst)
	if inst.components.inventoryitem:IsHeld() 
	or inst.components.sleeper:IsAsleep() 
	or inst.components.freezable:IsFrozen() then
		return false
	else
		return true
	end
end

local function OnEat(inst, food)
	if inst:HasTag("chicken_coop") then
		if inst._has_eaten_today then
			return
		end

		if food ~= nil and food.components.edible ~= nil then
			if food.components.edible.foodtype == FOODTYPE.SEEDS or food:HasTag("chickenfood") then
				inst._has_eaten_today = true
			end
		end
	elseif inst:HasTag("chicken_wild") and math.random() < TUNING.KYNO_CHICKEN_LAYEGG_CHANCE then
		if food ~= nil and food.components.edible ~= nil then
			if food.components.edible.foodtype == FOODTYPE.SEEDS or food:HasTag("chickenfood") then
				if inst.components.playerprox ~= nil and inst.components.playerprox:IsPlayerClose() then -- Only lay egg if someone is nearby.
					inst:PushEvent("lay_egg")
				end
			end
		end
	end
end

local function SetTrapData(inst)
	local data = {}

	if inst.components.named ~= nil then
		data.named = { name = inst.components.named.name }
	end
	
	if inst:HasTag("chicken_coop") then
		data.chicken_variant =
		{
			build = inst._color_build,
			icon = inst._icon_name,
		}
		
		if inst._has_eaten_today then
			data.has_eaten_today = true
		end
	end

	return data
end

local function RestoreDataFromTrap(inst, data)
	if data == nil then
		return
	end

	if data.named ~= nil and inst.components.named ~= nil then
		inst.components.named:SetName(data.named.name)
	end
	
	if inst:HasTag("chicken_coop") then
		if data.chicken_variant ~= nil then
			inst._color_build = data.chicken_variant.build
			inst._icon_name = data.chicken_variant.icon

			inst:DoTaskInTime(0, function()
				ApplyChickenCoopVariant(inst, data.chicken_variant)
			end)
		end
		
		inst._has_eaten_today = data.has_eaten_today or false
	end
end

local function GetStatus(inst, viewer)
	return (inst:HasTag("chicken_coop") and "COOP")
	or "GENERIC"
end

local function OnSave(inst, data)	
	data.chicken_variant =
	{
		build = inst._color_build,
		icon = inst._icon_name,
	}
	
	if inst._has_eaten_today then
		data.has_eaten_today = true
	end
end

local function OnLoad(inst, data)
	if data ~= nil then
		if data.chicken_variant then
			ApplyChickenCoopVariant(inst, data.chicken_variant)
		end
		
		inst._has_eaten_today = data.has_eaten_today or false
	end
end

local function commonfn(bank, build, loottable)
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
	
	inst.AnimState:SetScale(.9, .9, .9)

	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("prey")
	inst:AddTag("animal")
	inst:AddTag("chicken")
	inst:AddTag("cookable")
	inst:AddTag("canbetrapped")
	inst:AddTag("smallcreature")
	inst:AddTag("slaughterable")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sounds = ChickenSounds
	inst.settrapdata = SetTrapData
	inst.restoredatafromtrap = RestoreDataFromTrap
	
	inst:AddComponent("embarker")
	inst:AddComponent("inventory")
	inst:AddComponent("knownlocations")
	inst:AddComponent("homeseeker")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetSleepTest(CanSleep)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable(loottable)
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "chest"
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "drumstick_cooked"
	inst.components.cookable:SetOnCookedFn(OnCooked)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_CHICKEN_HEALTH)
	inst.components.health:StartRegen(5, 8)
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.KYNO_CHICKEN_RUNSPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.SEEDS }, { FOODTYPE.SEEDS })
	inst.components.eater:SetCanEatRaw()
	
	inst:AddComponent("slaughterable")
	inst.components.slaughterable:SetExtraLoot({"drumstick", "goose_feather"})
	inst.components.slaughterable:MakeFearable()
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.longpickup = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem:SetSinks(true)

	inst:ListenForEvent("onputininventory", OnPickUp)
	inst:ListenForEvent("ondropped", OnDropped)
	inst:ListenForEvent("gotosleep", OnSleep)
	inst:ListenForEvent("onwakeup", OnWakeUp)
	inst:ListenForEvent("ondeath", OnDeath)

	MakeSmallBurnableCharacter(inst, "body")
	MakeTinyFreezableCharacter(inst, "chest")
	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, OnPickUp, OnDropped)

	return inst
end

local function chicken_wild(inst)
	local inst = commonfn("chicken", "chicken", "kyno_chicken2")
	
	inst:AddTag("chicken_wild")
	
	if not TheWorld.ismastersim then
		return inst
	end

	inst:SetBrain(chicken_wild_brain)
	inst:SetStateGraph("SGchickenwild")
	
	if inst.components.eater ~= nil then
		inst.components.eater:SetOnEatFn(OnEat)
	end
	
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem.imagename = "kyno_chicken2"
	end
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
	inst.components.playerprox:SetOnPlayerNear(CanSpawnEgg)
	inst.components.playerprox:SetDist(6, 40)
	
	inst:DoTaskInTime(0, SetHome)
	
	return inst
end

local function chicken_coop(inst)
	local inst = commonfn("chicken", "chicken", "kyno_chicken_coop")
	
	inst:AddTag("_named")
	inst:AddTag("chicken_coop")
	
	inst.scrapbook_proxy = "kyno_chicken2"
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:RemoveTag("_named")

	inst._has_eaten_today = false
	inst._has_food_buffered = false

	inst:SetBrain(chicken_coop_brain)
	inst:SetStateGraph("SGchickencoop")
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "KYNO_CHICKEN2"
	end
	
	if inst.components.eater ~= nil then
		inst.components.eater:SetOnEatFn(OnEat)
	end
	
	inst:AddComponent("named")
	inst.components.named.possiblenames = STRINGS.KYNO_CHICKEN_NAMES
	inst.components.named:PickNewName()
	
	inst:DoTaskInTime(0, function()
		if inst._color_build == nil or inst._icon_name == nil then
			local variant = PickRandomChickenCoopVariant()
			ApplyChickenCoopVariant(inst, variant)
		else
			ApplyChickenCoopVariant(inst,
			{
				build = inst._color_build,
				icon = inst._icon_name,
			})
		end
	end)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("kyno_chicken2", chicken_wild, assets, prefabs),
Prefab("kyno_chicken_coop", chicken_coop, assets, prefabs)