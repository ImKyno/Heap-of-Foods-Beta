local assets =
{
	Asset("ANIM", "anim/quagmire_pot.zip"),
    Asset("ANIM", "anim/quagmire_pot_small.zip"),
    Asset("ANIM", "anim/quagmire_pot_syrup.zip"),
	Asset("ANIM", "anim/quagmire_pot_hanger.zip"),
	
	Asset("ANIM", "anim/quagmire_grill.zip"),
    Asset("ANIM", "anim/quagmire_grill_small.zip"),
	
	Asset("ANIM", "anim/quagmire_oven.zip"),
	Asset("ANIM", "anim/quagmire_casseroledish.zip"),
	Asset("ANIM", "anim/quagmire_casseroledish_small.zip"),
		
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{	
	"kyno_cookware_hanger_item",
	"kyno_cookware_big_pot",
	"kyno_cookware_small_pot",
	"kyno_cookware_syrup_pot",
}

local function hangerfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_pot_hanger")
	inst.AnimState:SetBuild("quagmire_pot_hanger")
	inst.AnimState:PlayAnimation("item")

	inst:AddTag("firepit_installer")
	inst:AddTag("pot_hanger_installer")
	inst:AddTag("serenity_installer")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_POT_HANGER_ITEM"
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	return inst
end

local function potsyrupfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_pot_syrup")
	inst.AnimState:SetBuild("quagmire_pot_syrup")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("pot_installer")
	inst:AddTag("pot_syrup_installer")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	return inst
end

local function potfn(small)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)
	
	if small then
		inst.AnimState:SetBank("quagmire_pot_small")
		inst.AnimState:SetBuild("quagmire_pot_small")
	else
		inst.AnimState:SetBank("quagmire_pot")
		inst.AnimState:SetBuild("quagmire_pot")
	end
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("pot_installer")
	if small then
		inst:AddTag("pot_small_installer")
	else
		inst:AddTag("pot_big_installer")
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	return inst
end

local function potbigfn()
	local inst = potfn(false)
	return inst
end

local function potsmallfn()
	local inst = potfn(true)
    return inst
end

local function grillfn(small)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)
	
	if small then
		inst.AnimState:SetBank("quagmire_grill_small")
		inst.AnimState:SetBuild("quagmire_grill_small")
	else
		inst.AnimState:SetBank("quagmire_grill")
		inst.AnimState:SetBuild("quagmire_grill")
	end
	inst.AnimState:PlayAnimation("item")

	inst:AddTag("firepit_installer")
	inst:AddTag("serenity_installer")
	if small then
		inst:AddTag("grill_small_installer")
	else
		inst:AddTag("grill_big_installer")
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	return inst
end

local function grillbigfn()
	local inst = grillfn(false)
	return inst
end

local function grillsmallfn()
	local inst = grillfn(true)
    return inst
end

local function ovenfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)

	inst.AnimState:SetBank("quagmire_oven")
	inst.AnimState:SetBuild("quagmire_oven")
	inst.AnimState:PlayAnimation("item")

	inst:AddTag("firepit_installer")
	inst:AddTag("oven_installer")
	inst:AddTag("serenity_installer")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	return inst
end

local function casserolefn(small)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.2, 0.95)
	
	if small then
		inst.AnimState:SetBank("quagmire_casseroledish_small")
		inst.AnimState:SetBuild("quagmire_casseroledish_small")
	else
		inst.AnimState:SetBank("quagmire_casseroledish")
		inst.AnimState:SetBuild("quagmire_casseroledish")
	end
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("casserole_installer")
	if small then
		inst:AddTag("casserole_small_installer")
	else
		inst:AddTag("casserole_big_installer")
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("tradable")
	inst:AddComponent("inspectable")
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"

	return inst
end

local function casserolebigfn()
	local inst = casserolefn(false)
	return inst
end

local function casserolesmallfn()
	local inst = casserolefn(true)
	return inst
end

return Prefab("kyno_cookware_hanger_item", hangerfn, assets, prefabs),
Prefab("kyno_cookware_syrup_pot", potsyrupfn, assets, prefabs),
Prefab("kyno_cookware_big_pot", potbigfn, assets, prefabs),
Prefab("kyno_cookware_small_pot", potsmallfn, assets, prefabs),
Prefab("kyno_cookware_grill_item", grillbigfn, assets, prefabs),
Prefab("kyno_cookware_small_grill_item", grillsmallfn, assets, prefabs),
Prefab("kyno_cookware_oven_item", ovenfn, assets, prefabs),
Prefab("kyno_cookware_casserole", casserolebigfn, assets, prefabs),
Prefab("kyno_cookware_small_casserole", casserolesmallfn, assets, prefabs)