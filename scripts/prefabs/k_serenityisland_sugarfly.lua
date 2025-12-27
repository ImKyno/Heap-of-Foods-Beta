require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/butterfly_basic.zip"),
	Asset("ANIM", "anim/kyno_sugarfly.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"butter",

	"kyno_sugarflywings",
	"kyno_sugartree_flower_planted",
}

local function OnDropped(inst)
	inst.sg:GoToState("idle")
	
	if inst.sugarflyspawner ~= nil then
		inst.sugarflyspawner:StartTracking(inst)
	end
	
	if inst.components.workable ~= nil then
		inst.components.workable:SetWorkLeft(1)
	end
	
	if inst.components.stackable ~= nil then
		while inst.components.stackable:StackSize() > 1 do
			local item = inst.components.stackable:Get()
			
			if item ~= nil then
				if item.components.inventoryitem ~= nil then
					item.components.inventoryitem:OnDropped()
				end
				
				item.Physics:Teleport(inst.Transform:GetWorldPosition())
			end
		end
	end
end

local function OnPicked(inst)
	if inst.sugarflyspawner ~= nil then
		inst.sugarflyspawner:StopTracking(inst)
	end
end

local function OnWorked(inst, worker)
	if worker.components.inventory ~= nil then
		if inst.sugarflyspawner ~= nil then
			inst.sugarflyspawner:StopTracking(inst)
		end
		
		worker.components.inventory:GiveItem(inst, nil, inst:GetPosition())
		worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
	end
end

local function CanDeploy(inst)
	return true
end

local function OnDeploy(inst, pt, deployer)
	local flower = SpawnPrefab("kyno_sugartree_flower_planted")
	
	if flower then
		flower:PushEvent("growfrombutterfly")
		flower.Transform:SetPosition(pt:Get())
		
		if inst.components.stackable ~= nil then
			inst.components.stackable:Get():Remove()
		end
        
		TheWorld:PushEvent("CHEVO_growfrombutterfly", { target = flower, doer = deployer })
		
		if deployer and deployer.SoundEmitter then
			deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
		end
	end
end

local function OnMutate(inst, transformed_inst)
	if transformed_inst ~= nil then
		transformed_inst.sg:GoToState("idle")
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(.8, .5)

	MakeTinyFlyingCharacterPhysics(inst, 1, .5)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("butterfly") -- Use butterfly because we don't have electrocute state.
	inst.AnimState:SetBuild("kyno_sugarfly")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("sugarfly")
	inst:AddTag("flying")
	inst:AddTag("ignorewalkableplatformdrowning")
	inst:AddTag("insect")
	inst:AddTag("noember")
	inst:AddTag("smallcreature")
	inst:AddTag("cattoyairborne")
	inst:AddTag("wildfireprotected")
	inst:AddTag("deployedplant")
	inst:AddTag("sugarflowerpollinatoronly")
	inst:AddTag("_named")
	
	MakeFeedableSmallLivestockPristine(inst)
	
	inst.scrapbook_proxy = "wendy_sugarfly"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("stackable")
	inst:AddComponent("pollinator")
	inst:AddComponent("knownlocations")
	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")
	
	inst:AddComponent("named")
	inst.components.named.possiblenames = STRINGS.KYNO_SUGARFLY_NAMES
	inst.components.named:PickNewName()

	inst:AddComponent("locomotor")
	inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
	
	inst:SetStateGraph("SGsugarfly")
	inst.sg.mem.burn_on_electrocute = true

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.canbepickedupalive = true
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.pushlandedevents = false
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_sugarfly"

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.KYNO_SUGARFLY_HEALTH)

	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "butterfly_body"

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("butter", 0.1)
	inst.components.lootdropper:AddRandomLoot("kyno_sugarflywings", 5)
	inst.components.lootdropper.numrandomloot = 1

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.NET)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnWorked)

	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
	
	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("moonbutterfly")
	inst.components.halloweenmoonmutable:SetOnMutateFn(OnMutate)
	inst.components.halloweenmoonmutable.push_attacked_on_new_inst = false

	local brain = require("brains/sugarflybrain")
	inst:SetBrain(brain)

	inst.sugarflyspawner = TheWorld.components.sugarflyspawner
	
	if inst.sugarflyspawner ~= nil then
		inst.components.inventoryitem:SetOnPickupFn(inst.sugarflyspawner.StopTrackingFn)
		inst:ListenForEvent("onremove", inst.sugarflyspawner.StopTrackingFn)
		inst.sugarflyspawner:StartTracking(inst)
	end

	MakeSmallBurnableCharacter(inst, "butterfly_body")
	MakeTinyFreezableCharacter(inst, "butterfly_body")
	
	MakeHauntablePanicAndIgnite(inst)
	MakeFeedableSmallLivestock(inst, TUNING.BUTTERFLY_PERISH_TIME, OnPicked, OnDropped)

	return inst
end

return Prefab("kyno_sugarfly", fn, assets, prefabs),
MakePlacer("kyno_sugarfly_placer", "kyno_serenityisland_bud", "kyno_serenityisland_bud", "idle1")
