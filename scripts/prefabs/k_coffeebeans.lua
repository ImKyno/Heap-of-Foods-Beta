local assets =
{
	Asset("ANIM", "anim/coffeebeans.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_coffeebeans_cooked",
	"spoiled_food",
}

local HOF_COFFEESPEED = GetModConfigData("HOF_COFFEESPEED", KnownModIndex:GetModActualName("Heap of Foods"))

local function OnEatBeans(inst, eater)
    if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
        return
    elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
        eater.coffeebuff_duration = TUNING.KYNO_COFFEEBUFF_DURATION_SMALL
        eater.components.debuffable:AddDebuff("kyno_coffeebuff", "kyno_coffeebuff")
    else
        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
        eater:DoTaskInTime(TUNING.KYNO_COFFEEBUFF_DURATION_SMALL, function()
            eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
        end)
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("coffeebeans")
	inst.AnimState:SetBuild("coffeebeans")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("veggie")
	inst:AddTag("cookable")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_COFFEEBEANS_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_COFFEEBEANS_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_COFFEEBEANS_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_coffeebeans"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_coffeebeans_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function fn_cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("coffeebeans")
	inst.AnimState:SetBuild("coffeebeans")
	inst.AnimState:PlayAnimation("cooked")
	
	inst:AddTag("veggie")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_COFFEEBEANS_COOKED_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_COFFEEBEANS_COOKED_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_COFFEEBEANS_COOKED_SANITY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	if HOF_COFFEESPEED == 1 then
		inst.components.edible:SetOnEatenFn(OnEatBeans)
	end
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_coffeebeans_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_coffeebeans", fn, assets),
Prefab("kyno_coffeebeans_cooked", fn_cooked, assets)