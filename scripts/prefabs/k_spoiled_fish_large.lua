local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

local assets =
{
	Asset("ANIM", "anim/kyno_spoiled_fish_large.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"boneshard",
	"spoiled_food",
	"gridplacer_farmablesoil",
}

local function GetFertilizerKey(inst)
	return inst.prefab
end

local function fertilizerresearchfn(inst)
	return inst:GetFertilizerKey()
end

local function OnHit(inst, worker, workleft, workdone)
	local num_loots = math.floor(math.clamp(workdone / TUNING.SPOILED_FISH_WORK_REQUIRED, 1, TUNING.SPOILED_FISH_LOOT.WORK_MAX_SPAWNS))
	num_loots = math.min(num_loots, inst.components.stackable:StackSize())

	if inst.components.stackable:StackSize() > num_loots then
		if num_loots == TUNING.SPOILED_FISH_LOOT.WORK_MAX_SPAWNS then
			LaunchAt(inst, inst, worker, TUNING.SPOILED_FISH_LOOT.LAUNCH_SPEED, TUNING.SPOILED_FISH_LOOT.LAUNCH_HEIGHT, nil, TUNING.SPOILED_FISH_LOOT.LAUNCH_ANGLE)
		end
	end

	for _ = 1, num_loots do
		inst.components.lootdropper:DropLoot()
	end

	local top_stack_item = inst.components.stackable:Get(num_loots)
	top_stack_item:Remove()
end

local function OnStackSizeChange(inst, data)
	if data ~= nil and data.stacksize ~= nil and inst.components.workable ~= nil then
		inst.components.workable:SetWorkLeft(data.stacksize * TUNING.SPOILED_FISH_WORK_REQUIRED)
	end
end

local function IsExposedToRain(inst, israining)
	if israining == nil then
		israining = TheWorld.state.israining
	end

	return israining and inst.components.rainimmunity == nil and not inst.components.inventoryitem:IsHeld()
end

local function OnIsRaining(inst, israining)
	if IsExposedToRain(inst, israining) then
		inst.components.disappears:PrepareDisappear()
	else
		inst.components.disappears:StopDisappear()
	end
end

local function OnRainImmunity(inst)
	inst.components.disappears:StopDisappear()
end

local function OnDropped(inst)
	OnIsRaining(inst, TheWorld.state.israining)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	MakeDeployableFertilizerPristine(inst)

	inst.AnimState:SetBank("kyno_spoiled_fish_large")
	inst.AnimState:SetBuild("kyno_spoiled_fish_large")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("icebox_valid")
	inst:AddTag("saltbox_valid")
	inst:AddTag("show_spoiled")
	inst:AddTag("selfstacker")
	inst:AddTag("spoiled_fish")
	inst:AddTag("fertilizerresearchable")

	inst.GetFertilizerKey = GetFertilizerKey

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("smotherer")
	inst:AddComponent("selfstacker")
	inst:AddComponent("tradable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_FUEL

	inst:AddComponent("fertilizerresearchable")
	inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"boneshard", "boneshard", "spoiled_food"})
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnRainImmunity)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_spoiled_fish_large"
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.SPOILED_HEALTH
	inst.components.edible.hungervalue = TUNING.SPOILED_HUNGER
	inst.components.edible.sanityvalue = 0
	
	inst:AddComponent("disappears")
	inst.components.disappears.sound = "dontstarve/common/dust_blowaway"
	inst.components.disappears.anim = "dissolve"

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(inst.components.stackable.stacksize * TUNING.SPOILED_FISH_WORK_REQUIRED)
	inst.components.workable:SetOnWorkCallback(OnHit)

	inst:AddComponent("fertilizer")
	inst.components.fertilizer.fertilizervalue = TUNING.KYNO_FLOATILIZER_FERTILIZE
	inst.components.fertilizer.soil_cycles = TUNING.KYNO_FLOATILIZER_SOILCYCLES
	inst.components.fertilizer.withered_cycles = TUNING.KYNO_FLOATILIZER_WITHEREDCYCLES
	inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.kyno_floatilizer.nutrients)
	
	inst:ListenForEvent("gainrainimmunity", OnRainImmunity)
	inst:ListenForEvent("loserainimmunity", OnDropped)
	inst:ListenForEvent("ondropped", OnDropped)
	inst:ListenForEvent("stacksizechange", OnStackSizeChange)
	
	inst:WatchWorldState("israining", OnIsRaining)
	OnIsRaining(inst, TheWorld.state.israining)

	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeSmallPropagator(inst)
	
	MakeDeployableFertilizer(inst)
	MakeHauntableLaunchAndIgnite(inst)

	return inst
end

return Prefab("kyno_spoiled_fish_large", fn, assets, prefabs)