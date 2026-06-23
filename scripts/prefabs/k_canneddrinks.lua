local assets =
{
	Asset("ANIM", "anim/kyno_pops.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

	Asset("SOUNDPACKAGE", "sound/hof_sounds.fev"),
	Asset("SOUND", "sound/hof_sfx.fsb"),
}

local prefabs =
{
	"kyno_sodacan",   -- Fanta.
	"kyno_cokecan",   -- Coke.
	"kyno_energycan", -- Monster.
}

local function OnDrink(inst, eater)
	if eater ~= nil and eater.SoundEmitter ~= nil then
		eater.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	else
		inst.SoundEmitter:PlaySound("hof_sounds/common/tunacan/open")
	end

	if eater:HasTag("player") then
		eater:PushEvent("drankcannedrink")
	end

	if inst:HasTag("energyfood") and eater.prefab == "wx78" then
		if eater ~= nil and eater.components.upgrademoduleowner ~= nil then
			eater.components.upgrademoduleowner:AddCharge(TUNING.KYNO_ENERGYCAN_CHARGE)
		end
	end
end

local function OnPutOnFurniture(inst)
	if TUNING.HOF_KEEPFOOD then
		if inst.components.perishable ~= nil then
			inst.components.perishable:StopPerishing()
		end
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

local function fn(bank, build, anim)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddFollower()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetScale(1.4, 1.4, 1.4)

	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation(anim)

	inst:AddTag("fooddrink")
	inst:AddTag("furnituredecor")
	inst:AddTag("foodsack_valid")
	inst:AddTag("pre-preparedfood") -- So warly can drink them.

	inst.pickupsound = "metal"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("edible")
	inst.components.edible:SetOnEatenFn(OnDrink)
	inst.components.edible.foodtype = FOODTYPE.GOODIES -- Everyone can drink.

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_POP"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
	inst.components.perishable:StartPerishing()

	inst:AddComponent("furnituredecor")
	inst.components.furnituredecor.onputonfurniture = OnPutOnFurniture
	inst.components.furnituredecor.ontakeofffurniture = OnTakeOffFurniture

	return inst
end

-- Soda Can.
local function soda_fn()
	local inst = fn("kyno_pops", "kyno_pops", "sodacan")

	if not TheWorld.ismastersim then
		return inst
	end

	inst.components.inventoryitem.imagename = "kyno_sodacan"

	inst.components.edible.healthvalue = TUNING.KYNO_SODACAN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_SODACAN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_SODACAN_SANITY

	return inst
end

local function coke_fn()
	local inst = fn("kyno_pops", "kyno_pops", "cokecan")

	if not TheWorld.ismastersim then
		return inst
	end

	inst.components.inventoryitem.imagename = "kyno_cokecan"

	inst.components.edible.healthvalue = TUNING.KYNO_COKECAN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_COKECAN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_COKECAN_SANITY

	return inst
end

local function energy_fn()
	local inst = fn("kyno_pops", "kyno_pops", "energycan")

	inst:AddTag("energyfood")

	if not TheWorld.ismastersim then
		return inst
	end

	inst.components.inventoryitem.imagename = "kyno_energycan"

	inst.components.edible.healthvalue = TUNING.KYNO_ENERGYCAN_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_ENERGYCAN_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_ENERGYCAN_SANITY

	return inst
end

return Prefab("kyno_sodacan", soda_fn, assets, prefabs),
Prefab("kyno_cokecan", coke_fn, assets, prefabs),
Prefab("kyno_energycan", energy_fn, assets, prefabs)
