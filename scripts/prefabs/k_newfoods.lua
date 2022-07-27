local assets =
{
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"spoiled_food"
}

local function MakePreparedFood(data)
	local foodname = data.basename or data.name
	local foodassets = assets
	table.insert(foodassets, Asset("ANIM", "anim/"..foodname..".zip"))
	local spicename = data.spice ~= nil and string.lower(data.spice) or nil
	if spicename ~= nil then
		foodassets = shallowcopy(assets)
		table.insert(foodassets, Asset("ANIM", "anim/spices.zip"))
		table.insert(foodassets, Asset("ANIM", "anim/plate_food.zip"))
		table.insert(foodassets, Asset("INV_IMAGE", spicename.."_over"))
	end

	local function DisplayNameFn(inst)
		return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetScale(1.1, 1.1, 1.1) -- For foods on ground.

		if spicename ~= nil then
			inst.AnimState:SetBuild("plate_food")
			inst.AnimState:SetBank("plate_food")
			inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicename)

			inst:AddTag("spicedfood")

			inst.drawnameoverride = STRINGS.NAMES[string.upper(data.basename)]
			inst.inv_image_bg = { atlas = "images/inventoryimages/hof_inventoryimages.xml", image = foodname..".tex" }
		else
			inst.AnimState:SetBank(data.name)
			inst.AnimState:SetBuild(data.name)
		end
		
		inst.AnimState:PlayAnimation("idle", false)
		inst.AnimState:OverrideSymbol("swap_food", foodname, foodname)

		inst:AddTag("preparedfood")
		inst:AddTag("preparedfood_hof")
		
		if data.tags ~= nil then
			for i,v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end

		if data.basename ~= nil then
			inst:SetPrefabNameOverride(data.basename)
			if data.spice ~= nil then
				inst.displaynamefn = DisplayNameFn
			end
		end
	
		MakeInventoryFloatable(inst)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.health
		inst.components.edible.hungervalue = data.hunger
		inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
		inst.components.edible.sanityvalue = data.sanity or 0
		inst.components.edible.temperaturedelta = data.temperature or 0
		inst.components.edible.temperatureduration = data.temperatureduration or 0
		inst.components.edible.nochill = data.nochill or nil
		inst.components.edible.spice = data.spice
		inst.components.edible:SetOnEatenFn(data.oneatenfn)

		inst:AddComponent("inspectable")
		inst.wet_prefix = data.wet_prefix

		inst:AddComponent("inventoryitem")

		if spicename ~= nil then
			inst.components.inventoryitem:ChangeImageName(spicename.."_over")
		elseif data.basename ~= nil then
			inst.components.inventoryitem:ChangeImageName(data.basename)
		else
			inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
			inst.components.inventoryitem.imagename = data.name
		end

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		if data.perishtime ~= nil and data.perishtime > 0 then
			inst:AddComponent("perishable")
			inst.components.perishable:SetPerishTime(data.perishtime)
			inst.components.perishable:StartPerishing()
			inst.components.perishable.onperishreplacement = "spoiled_food"
		end

		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndPerish(inst)

		inst:AddComponent("bait")

		inst:AddComponent("tradable")

		return inst
	end

	return Prefab(data.name, fn, foodassets, prefabs)
end

local prefs = {}

for k, v in pairs(require("hof_foodrecipes")) do
	table.insert(prefs, MakePreparedFood(v))
end
-- For the optional recipes.
for k, v in pairs(require("hof_foodrecipes_optional")) do
	table.insert(prefs, MakePreparedFood(v))
end

for k, v in pairs(require("hof_foodspicer")) do
	table.insert(prefs, MakePreparedFood(v))
end

for k, v in pairs(require("hof_foodspicer_optional")) do
	table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs)