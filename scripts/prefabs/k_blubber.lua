local assets =
{
	Asset("ANIM", "anim/kyno_blubber.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"spoiled_food",
}

local function OnEaten(inst, eater)
	if eater.components.moisture ~= nil and not (eater.components.health ~= nil and eater.components.health:IsDead()) and
	not eater:HasTag("playerghost") then
		eater.components.moisture:DoDelta(TUNING.KYNO_BLUBBLER_MOISTURE)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_blubber")
	inst.AnimState:SetBuild("kyno_blubber")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("blubber")
	inst:AddTag("waterproofer")
	inst:AddTag("saltbox_valid")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 2

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_blubber"

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("edible")
	inst.components.edible:SetOnEatenFn(OnEaten)
	inst.components.edible.healthvalue = TUNING.KYNO_BLUBBLER_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_BLUBBLER_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_BLUBBLER_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab("kyno_blubber", fn, assets, prefabs)