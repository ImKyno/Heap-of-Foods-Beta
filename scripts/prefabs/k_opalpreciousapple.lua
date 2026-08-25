local assets =
{
	Asset("ANIM", "anim/kyno_opalpreciousapple.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"kyno_opalpreciousapple_fx",
	"kyno_invinciblebuff",
}

-- Reutilizing some stuff from Enchanted Golden Apple.
local function OnEaten(inst, eater)
	if eater:HasTag("plantkin") then
		if eater.components.health ~= nil and not eater.components.health:IsDead() then
			if eater.components.debuffable ~= nil and not eater.components.debuffable:HasDebuff("kyno_healingsicknessbuff") then
				eater.components.health:DoDelta(TUNING.KYNO_OPALPRECIOUSAPPLE_HEALTH)
			end
		end
	end

	eater:AddDebuff("kyno_invinciblebuff", "kyno_invinciblebuff")
	eater:PushEvent("playgoldenapple")
end

local function OnDropped(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
end

local function OnPutOnFurniture(inst)
	if TUNING.HOF_KEEPFOOD then
		if inst.components.perishable ~= nil then
			inst.components.perishable:StopPerishing()
		end
	end

	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:OnDropped(0, 1)
	end

	inst:AddTag("outofreach")
end

local function OnTakeOffFurniture(inst)
	if TUNING.HOF_KEEPFOOD then
		if inst.components.perishable ~= nil then
			inst.components.perishable:StartPerishing()
		end
	end

	inst:RemoveTag("outofreach")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddFollower()
	inst.entity:AddNetwork()

	inst.Transform:SetScale(1.1, 1.1, 1.1)

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("kyno_opalpreciousapple")
	inst.AnimState:SetBuild("kyno_opalpreciousapple")
	inst.AnimState:PlayAnimation("idle", true)

	inst.AnimState:HideSymbol("glowpulse")

	inst:AddTag("nosteal")
	inst:AddTag("shimmerfood")
	inst:AddTag("opalpreciousapple")
	inst:AddTag("warly_caneat")
	inst:AddTag("furnituredecor")
	inst:AddTag("saltbox_valid")
	inst:AddTag("foodsack_valid")
	inst:AddTag("itemshowcaser_valid")
	inst:AddTag("beargerfur_sack_valid")
	inst:AddTag("_named")

	inst._opalpreciousapplefx = SpawnPrefab("kyno_opalpreciousapple_fx")
	inst._opalpreciousapplefx:AttachTo(inst)

	inst.pickupsound = "item_gold"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:RemoveTag("_named")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.KYNO_OPALPRECIOUSAPPLE_GOLD_VALUE

	inst:AddComponent("named")
	inst.components.named.possiblenames = STRINGS.KYNO_OPALPRECIOUSAPPLE_NAMES
	inst.components.named:PickNewName()

	inst:AddComponent("furnituredecor")
	inst.components.furnituredecor.onputonfurniture = OnPutOnFurniture
	inst.components.furnituredecor.ontakeofffurniture = OnTakeOffFurniture

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("edible")
	inst.components.edible:SetOnEatenFn(OnEaten)
	inst.components.edible.healthvalue = TUNING.KYNO_OPALPRECIOUSAPPLE_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_OPALPRECIOUSAPPLE_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_OPALPRECIOUSAPPLE_SANITY
	inst.components.edible.foodtype = FOODTYPE.GOODIES

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(9999999)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:ListenForEvent("ondropped", OnDropped)

	return inst
end

return Prefab("kyno_opalpreciousapple", fn, assets, prefabs)