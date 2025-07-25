local assets =
{
    Asset("ANIM", "anim/kyno_buckets.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_bucket_empty",
	"fertilizer",
}

local function emptyfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_empty")

	inst:AddTag("bucket")
	inst:AddTag("bucket_empty")
	
	inst.pickupsound = "wood"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("milker")
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.KYNO_BUCKET_EMPTY_USES)
	inst.components.finiteuses:SetUses(TUNING.KYNO_BUCKET_EMPTY_USES)
	inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1
	inst.components.tradable.tradefor = { "kyno_sapbucket_installer" }

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_empty"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

local function metalfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_buckets")
	inst.AnimState:SetBuild("kyno_buckets")
	inst.AnimState:PlayAnimation("idle_metal")

	inst:AddTag("bucket")
	inst:AddTag("bucket_metal")
	
	inst.pickupsound = "metal"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("milker")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1
	inst.components.tradable.tradefor = { "kyno_sapbucket_installer" }

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_bucket_metal"

	return inst
end

return Prefab("kyno_bucket_empty", emptyfn, assets, prefabs),
Prefab("kyno_bucket_metal", metalfn, assets, prefabs)