local prefabs =
{
	"spoiled_food",
}

local function OnPutOnFurniture(inst)
	if inst.components.inventoryitem ~= nil then
		inst.components.inventoryitem:OnDropped(0, 1)
	end

	inst:AddTag("outofreach")
end

local function OnTakeOffFurniture(inst)
	inst:RemoveTag("outofreach")
end

local function MakeFoodUpgrade(data)
	local foodassets =
	{
		Asset("ANIM", "anim/cook_pot_food.zip"),

		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}

	if data.overridebuild then
		table.insert(foodassets, Asset("ANIM", "anim/"..data.overridebuild..".zip"))
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddFollower()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		if data.scale ~= nil then
			inst.AnimState:SetScale(data.scale, data.scale, data.scale)
		else
			inst.AnimState:SetScale(1, 1, 1)
		end

		local food_symbol_build = nil

		inst.AnimState:SetBank("kyno_foodrecipes")
		inst.AnimState:SetBuild(data.overridebuild or "cook_pot_food")
		inst.AnimState:PlayAnimation(data.anim or data.name, false)

		inst.AnimState:OverrideSymbol("swap_food", data.overridebuild or "cook_pot_food", data.basename or data.name)

		if data.bloom ~= nil then
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
			inst.AnimState:SetLightOverride(.1)
			inst.lightcolour = data.bloomlight
		end

		inst:AddTag("nospice")
		inst:AddTag("foodupgrade")
		inst:AddTag("preparedfood")
		inst:AddTag("furnituredecor")

		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end

		if data.basename ~= nil then
			inst:SetPrefabNameOverride(data.basename)
		end

		if data.pickupsound ~= nil then
			inst.pickupsound = data.pickupsound
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.food_symbol_build = food_symbol_build or data.overridebuild
		inst.food_basename = data.basename
		inst.wet_prefix = data.wet_prefix

		-- For refunding Empty Bottles when harvesting.
		inst.bottlesize = data.bottlesize or 1

		inst:AddComponent("tradable")

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("inspectable")
		if data.nameoverride ~= nil then
			inst.components.inspectable.nameoverride = data.nameoverride
		end

		inst:AddComponent("inventoryitem")
		if data.basename ~= nil then
			inst.components.inventoryitem:ChangeImageName(data.basename)
		end

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.health or 0
		inst.components.edible.hungervalue = data.hunger or 0
		inst.components.edible.sanityvalue = data.sanity or 0
		inst.components.edible.foodtype = data.foodtype or FOODTYPE.FOODUPGRADE
		inst.components.edible.temperaturedelta = data.temperature or 0
		inst.components.edible.temperatureduration = data.temperatureduration or 0
		inst.components.edible:SetOnEatenFn(data.oneatenfn)

		inst:AddComponent("furnituredecor")
		inst.components.furnituredecor.onputonfurniture = OnPutOnFurniture
		inst.components.furnituredecor.ontakeofffurniture = OnTakeOffFurniture

		MakeHauntableLaunchAndPerish(inst)

		return inst
	end

	return Prefab(data.name, fn, foodassets, prefabs)
end

local prefs = {}

for k, v in pairs(require("hof_foodrecipes_ancient")) do
	table.insert(prefs, MakeFoodUpgrade(v))
end

return unpack(prefs)