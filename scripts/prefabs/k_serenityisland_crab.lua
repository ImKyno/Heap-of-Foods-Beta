local brain = require("brains/serenitycrabbrain")

local assets =
{
	Asset("ANIM", "anim/quagmire_pebble_crab.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_crabmeat",
}

local sounds =
{
	walk 	= "dontstarve/quagmire/creature/pebble_crab/walk",
	burrow 	= "dontstarve/quagmire/creature/pebble_crab/burrow",
	emerge 	= "dontstarve/quagmire/creature/pebble_crab/emerge",
	hurt 	= "dontstarve/quagmire/creature/pebble_crab/scratch",
}

local function SetUnderPhysics(inst)
	if inst.isunder ~= true then
		inst.isunder = true
		inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:CollidesWith(COLLISION.OBSTACLES)
	end
end

local function SetAbovePhysics(inst)
	if inst.isunder ~= false then
		inst.isunder = false
		ChangeToCharacterPhysics(inst)
	end
end

local function SetHome(inst)
	inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
end

local function SetNewHome(inst)
	inst.components.knownlocations:ForgetLocation("home")
	inst:DoTaskInTime(1, SetHome) -- Set home again.
end

local function StartTimer(inst)
	if not inst.components.timer:TimerExists("hide") then
		inst.components.timer:StartTimer("hide", 10)
	end
end

local function OnNear(inst)
	if inst.components.inventoryitem ~= nil and not inst.components.inventoryitem:IsHeld() then
		if not inst.components.timer:TimerExists("hide") then
			inst.sg:GoToState("burrow")
			StartTimer(inst)
		end
	end
end

local function OnPickUp(inst)
	inst:PushEvent("detachchild") -- No longer part of the spawner.
end

local function OnDropped(inst)
	inst:DoTaskInTime(1, SetNewHome)
end

local function GetFishKey(inst)
	return inst.prefab
end

local function fishresearchfn(inst)
	return inst:GetFishKey()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.SetUnderPhysics = SetUnderPhysics
	inst.SetAbovePhysics = SetAbovePhysics

	MakeCharacterPhysics(inst, 1, .25)
	inst.Transform:SetSixFaced()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1, .75)

	inst.AnimState:SetBank("quagmire_pebble_crab")
	inst.AnimState:SetBuild("quagmire_pebble_crab")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("prey")
	inst:AddTag("animal")
	inst:AddTag("cattoy")
	inst:AddTag("crab_mob")
	inst:AddTag("serenitycrab")
	inst:AddTag("fishfarmable")
	inst:AddTag("smallcreature")
	inst:AddTag("fishresearchable")
	inst:AddTag("electricdamageimmune")

	inst.GetFishKey = GetFishKey

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.sounds = sounds

	inst:AddComponent("timer")
	inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")
	inst:AddComponent("homeseeker")
	inst:AddComponent("tradable")
	inst:AddComponent("murderable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.canbepickedupalive = true
	inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("fishresearchable")
	inst.components.fishresearchable:SetResearchFn(fishresearchfn)

	inst:AddComponent("fishfarmable")
	inst.components.fishfarmable:SetTimes(TUNING.PEBBLECRAB_ROETIME, TUNING.PEBBLECRAB_BABYTIME)
	inst.components.fishfarmable:SetProducts("barnacle", "kyno_pebblecrab")
	inst.components.fishfarmable:SetPhases({ "day", "dusk", "night" })
	inst.components.fishfarmable:SetMoonPhases({ "new", "quarter", "half", "threequarter", "full" })
	inst.components.fishfarmable:SetSeasons({ "autumn", "spring", "summer" })
	inst.components.fishfarmable:SetWorlds({ "forest", "cave" })

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_crabmeat"})

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.KYNO_PEBBLECRAB_RUNSPEED
	inst.components.locomotor.walkspeed = TUNING.KYNO_PEBBLECRAB_WALKSPEED

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT, FOODTYPE.FISH }, { FOODTYPE.MEAT, FOODTYPE.FISH })

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(3, 4)
	inst.components.playerprox:SetOnPlayerNear(OnNear)

	inst:SetStateGraph("SGserenitycrab")
	inst:SetBrain(brain)

	inst:DoTaskInTime(0, SetHome)
	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME)

	inst:ListenForEvent("onpickup", OnPickUp)
	inst:ListenForEvent("ondropped", OnDropped)

	inst:ListenForEvent("timerdone", function(inst, data)
		if inst.components.inventoryitem ~= nil and not inst.components.inventoryitem:IsHeld() then
			if data.name == "hide" then
				if FindClosestPlayerToInst(inst, 5) then
					StartTimer(inst)
				else
					inst.sg:GoToState("emerge")
				end
			end
		end
	end)

	return inst
end

return Prefab("kyno_pebblecrab", fn, assets, prefabs)
