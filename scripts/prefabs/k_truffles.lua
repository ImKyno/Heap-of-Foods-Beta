local assets =
{
	Asset("ANIM", "anim/kyno_truffles.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_truffles",
	"kyno_truffles_cooked",
}

local function OnPicked(inst)
	if inst.growtask ~= nil then
		inst.growtask:Cancel()
		inst.growtask = nil
	end
	
	inst.AnimState:PlayAnimation("picked")
	inst.rain = 10 + math.random(10)
end

local function OnMakeEmpty(inst)
	inst.AnimState:PlayAnimation("picked")
end

local function OnRegen(inst)	
	inst.AnimState:PushAnimation("planted", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_down")
end

local function DigUp(inst, chopper)
	if inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
	end
	
	TheWorld:PushEvent("beginregrowth", inst)
	inst.components.lootdropper:SpawnLootPrefab("kyno_truffles")
	
	inst:Remove()
end

local function CheckGrow(inst)
	if inst.components.pickable ~= nil and not inst.components.pickable.canbepicked and TheWorld.state.israining then
		inst.rain = inst.rain - 1
		
		if inst.rain <= 0 then
			inst.components.pickable:Regen()
		end
	end
end

local function OnSave(inst, data)
	if inst.rain > 0 then
		data.rain = inst.rain
	end
end

local function OnLoad(inst, data)
	if data and data.rain then
		inst.rain = data.rain or inst.rain
	end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local s = .8
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:SetBank("kyno_truffles")
	inst.AnimState:SetBuild("kyno_truffles")
	inst.AnimState:PlayAnimation("planted", true)
	
	inst:AddTag("plant")
	inst:AddTag("renewable")
	inst:AddTag("truffles")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	-- inst:AddComponent("workable")
	-- inst.components.workable:SetWorkAction(ACTIONS.DIG)
	-- inst.components.workable:SetOnFinishCallback(DigUp)
	-- inst.components.workable:SetWorkLeft(1)

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("kyno_truffles", TUNING.KYNO_TRUFFLES_GROWTIME)
	inst.components.pickable.onregenfn = OnRegen
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.makeemptyfn = OnMakeEmpty
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableIgnite(inst)
	AddToRegrowthManager(inst)

	return inst
end

local function truffles()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	local s = 1.3
	inst.AnimState:SetScale(s, s, s)

	inst.AnimState:SetBank("kyno_truffles")
	inst.AnimState:SetBuild("kyno_truffles")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("truffles")
	inst:AddTag("veggie")
	inst:AddTag("cookable")
	inst:AddTag("saltbox_valid")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_TRUFFLES_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_TRUFFLES_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_TRUFFLES_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_truffles"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_truffles_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function truffles_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	local s = 1.5
	inst.AnimState:SetScale(s, s, s)

	inst.AnimState:SetBank("kyno_truffles")
	inst.AnimState:SetBuild("kyno_truffles")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("veggie")
	inst:AddTag("truffles")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_TRUFFLES_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_TRUFFLES_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_TRUFFLES_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_truffles_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_truffles_ground", fn, assets, prefabs),
Prefab("kyno_truffles", truffles, assets, prefabs),
Prefab("kyno_truffles_cooked", truffles_cooked, assets, prefabs)