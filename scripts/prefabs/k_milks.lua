local assets =
{
    Asset("ANIM", "anim/kyno_milks.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_bucket_empty",
	
	"kyno_milk_beefalo",
	"kyno_milk_koalefant",
	-- "kyno_milk_deer",
	-- "kyno_milk_spat",
	
	"spoiled_food",
}

local s = .85

local function beefalofn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(s, s, s)

	inst.AnimState:SetBank("kyno_milks")
	inst.AnimState:SetBuild("kyno_milks")
	inst.AnimState:PlayAnimation("idle_beefalo")

	inst:AddTag("milk_raw")
	inst:AddTag("milk_beefalo")
	inst:AddTag("drinkable_food")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_MILK_BEEFALO_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_MILK_BEEFALO_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_MILK_BEEFALO_SANITY

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_milk_beefalo"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function koalefantfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
	
	inst.AnimState:SetScale(s, s, s)

	inst.AnimState:SetBank("kyno_milks")
	inst.AnimState:SetBuild("kyno_milks")
	inst.AnimState:PlayAnimation("idle_koalefant")
	
	inst:AddTag("milk_raw")
	inst:AddTag("milk_koalefant")
	inst:AddTag("drinkable_food")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_MILK_KOALEFANT_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_MILK_KOALEFANT_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_MILK_KOALEFANT_SANITY

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_milk_koalefant"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_milk_beefalo", beefalofn, assets, prefabs),
Prefab("kyno_milk_koalefant", koalefantfn, assets, prefabs)