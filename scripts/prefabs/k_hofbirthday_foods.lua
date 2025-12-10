local function MakeBirthdayFoods(data)
	local assets =
	{
		Asset("ANIM", "anim/kyno_hofbirthday_foods.zip"),
	
		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst, "med", 0.65)

		inst.AnimState:SetBank("kyno_hofbirthday_foods")
		inst.AnimState:SetBuild("kyno_hofbirthday_foods")
		inst.AnimState:PlayAnimation(data.anim)

		inst:AddTag("masterfood")
		inst:AddTag("warly_caneat")
		inst:AddTag("saltbox_valid")
		inst:AddTag("foodsack_valid")
		inst:AddTag("itemshowcaser_valid")
		inst:AddTag("beargerfur_sack_valid")
		inst:AddTag("anniversaryfood")
		
		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("inspectable")
		inst:AddComponent("tradable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = data.imagename
	
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.healthvalue
		inst.components.edible.hungervalue = data.hungervalue
		inst.components.edible.sanityvalue = data.sanityvalue
		inst.components.edible.foodtype = FOODTYPE.GOODIES
		if data.oneaten then
			inst.components.edible:SetOnEatenFn(data.oneaten)
		end
	
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(data.perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
	
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndPerish(inst)

		return inst
	end
	
	return Prefab(data.name, fn, assets, prefabs)
end

local birthdayfoods =
{
	-- Anniversary Popcorn
	{
		name        = "kyno_hofbirthday_popcorn",
		anim        = "popcorn",
		imagename   = "kyno_hofbirthday_popcorn",
		tags        = { "popcorn" },
		healthvalue = TUNING.KYNO_HOFBIRTHDAY_POPCORN_HEALTH,
		hungervalue = TUNING.KYNO_HOFBIRTHDAY_POPCORN_HUNGER,
		sanityvalue = TUNING.KYNO_HOFBIRTHDAY_POPCORN_SANITY,
		perishtime  = TUNING.PERISH_MED,
	},
}

local prefabs = {}

for i, v in ipairs(birthdayfoods) do
	table.insert(prefabs, MakeBirthdayFoods(v))
end

return unpack(prefabs)