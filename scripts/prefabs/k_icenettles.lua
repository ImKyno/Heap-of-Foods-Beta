local assets =
{
	Asset("ANIM", "anim/kyno_icenettles.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_icenettle_toxin",
}

local function OnEaten(inst, eater)
	if not eater:HasTag("plantkin") then
		eater:AddDebuff("kyno_icenettle_toxin", "kyno_icenettle_toxin")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.0, 0.7)

	inst.AnimState:SetBank("kyno_icenettles")
	inst.AnimState:SetBuild("kyno_icenettles")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("frozen")
	inst:AddTag("dryable")
	inst:AddTag("icenettle")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_icenettles"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_ICENETTLES_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_ICENETTLES_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_ICENETTLES_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	inst.components.edible:SetOnEatenFn(OnEaten)

	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("kyno_icenettles_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst.components.dryable:SetBuildFile("kyno_meatrack_icenettles")
	inst.components.dryable:SetDriedBuildFile("kyno_meatrack_icenettles")

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_icenettles", fn, assets, prefabs)