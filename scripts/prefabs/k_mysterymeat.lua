local assets =
{
	Asset("ANIM", "anim/mystery_meat.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"boneshard",
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)
	MakeDeployableFertilizerPristine(inst)

	inst.AnimState:SetBank("mysterymeat")
	inst.AnimState:SetBuild("mystery_meat")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("cattoy")
	inst:AddTag("mysterymeat")
	inst:AddTag("kittenchow")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_mysterymeat"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -1
	inst.components.edible.hungervalue = -10
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = FOODTYPE.HORRIBLE

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("kyno_mysterymeat", fn, assets, prefabs)