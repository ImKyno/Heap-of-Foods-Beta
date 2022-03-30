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

local function StartTimer(inst)
	if not inst.components.timer:TimerExists("hide") then
		inst.components.timer:StartTimer("hide", 10)
	end
end

local function onnear(inst)
	if not inst.components.timer:TimerExists("hide") then
		inst.sg:GoToState("burrow")
		StartTimer(inst)
	end
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
	
	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("smallcreature")
    inst:AddTag("canbetrapped")
    inst:AddTag("cattoy")
	inst:AddTag("serenitycrab")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sounds = sounds
	
	inst:AddComponent("inspectable")
	inst:AddComponent("timer")
	inst:AddComponent("knownlocations")
	inst:AddComponent("homeseeker")
	inst:AddComponent("tradable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.canbepickedupalive = true
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(40)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"kyno_crabmeat"})

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = 6
	inst.components.locomotor.walkspeed = 1 
	
	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODTYPE.MEAT, FOODTYPE.FISH }, { FOODTYPE.MEAT, FOODTYPE.FISH })
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(3, 4)
	inst.components.playerprox:SetOnPlayerNear(onnear)

	inst:SetStateGraph("SGserenitycrab")
	
	local brain = require "brains/serenitycrabbrain"
	inst:SetBrain(brain)
	
	inst:DoTaskInTime(0, SetHome)
	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME)
	
	inst:ListenForEvent("timerdone", function(inst, data)
		if data.name == "hide" then
			if FindClosestPlayerToInst(inst, 5) then
				StartTimer(inst)
			else
				inst.sg:GoToState("emerge")
			end
		end
	end)
		
	--[[
	inst:ListenForEvent("timerdone", function(inst, data)
		if data.name == "hide" then
			if FindClosestPlayerToInst(inst, 4) then
				StartTimer(inst)
			else
				if inst.components.knownlocations:GetLocation("home") then
					inst.Physics:Teleport(inst.components.knownlocations:GetLocation("home"):Get())
				else
					local pos = inst:GetPosition()
					local offset, check_angle, deflected = FindWalkableOffset(pos, 2 * math.pi * math.random(), 10, 50, true, false,
						function(pt)
							local tile = TheWorld.Map:GetTileAtPoint(pt:Get())
							return tile == GROUND.ROAD or tile == GROUND.QUAGMIRE_CITYSTONE
						end)
						
						inst.Physics:Teleport(pos.x + offset.x, 0, pos.z + offset.z)
					end
					inst.sg:GoToState("emerge")
				end
			end
		end)
	]]--	
	
	return inst
end

return Prefab("kyno_pebblecrab", fn, assets, prefabs)
