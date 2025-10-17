local assets =
{
    Asset("ANIM", "anim/kyno_goldenapple.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_goldenapple_fx",
	"kyno_goldenapplebuff",

	"spoiled_food",
}

-- Gives a lot of buffs!
local function OnEaten(inst, eater)
	if eater:HasTag("plantkin") then
		if eater.components.health ~= nil and not eater.components.health:IsDead() then
			eater.components.health:DoDelta(100)
		end
	end
	
	eater:AddDebuff("kyno_goldenapplebuff", "kyno_goldenapplebuff")
end

local function OnDropped(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_goldenapple")
	inst.AnimState:SetBuild("kyno_goldenapple")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("fruit")
	inst:AddTag("goldenapple")
	inst:AddTag("nosteal")
	inst:AddTag("_named")
	
	inst._goldenapplefx = SpawnPrefab("kyno_goldenapple_fx")
	inst._goldenapplefx:AttachTo(inst)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 100
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.KYNO_GOLDENAPPLE_NAMES
    inst.components.named:PickNewName()

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_goldenapple"
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("edible")
	inst.components.edible:SetOnEatenFn(OnEaten)
    inst.components.edible.healthvalue = TUNING.KYNO_GOLDENAPPLE_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_GOLDENAPPLE_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_GOLDENAPPLE_SANITY
	inst.components.edible.foodtype = FOODTYPE.GOODIES

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(9999999)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:ListenForEvent("ondropped", OnDropped)

	return inst
end

return Prefab("kyno_goldenapple", fn, assets, prefabs)