local function MakeCakeSlice(data)
	local assets =
	{
		Asset("ANIM", "anim/kyno_hofbirthday_cake_slices.zip"),
	
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

		inst.AnimState:SetBank("kyno_hofbirthday_cake_slices")
		inst.AnimState:SetBuild("kyno_hofbirthday_cake_slices")
		inst.AnimState:PlayAnimation(data.anim)

		inst:AddTag("warly_caneat")
		inst:AddTag("saltbox_valid")
		inst:AddTag("foodsack_valid")
		inst:AddTag("itemshowcaser_valid")
		inst:AddTag("beargerfur_sack_valid")
		inst:AddTag("anniversarycake_slice")
		inst:AddTag("anniversaryfood")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("tradable")
	
		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = "KYNO_HOFBIRTHDAY_CAKE_SLICE"

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
		inst.components.edible:SetOnEatenFn(data.oneaten)
	
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
	
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndPerish(inst)

		return inst
	end
	
	return Prefab(data.name, fn, assets, prefabs)
end

local cakeslices =
{
	-- Slice 1 - Increased Max Hunger
	{
		name        = "kyno_hofbirthday_cake_slice1",
		anim        = "idle1",
		imagename   = "kyno_hofbirthday_cake_slice1",
		healthvalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE1_HEALTH,
		hungervalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE1_HUNGER,
		sanityvalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE1_SANITY,
		oneaten     = function(inst, eater)
			eater:AddDebuff("kyno_slice1birthdaybuff", "kyno_slice1birthdaybuff")
		end,
	},
	
	-- Slice 2 - Increased Max Health
	{
		name        = "kyno_hofbirthday_cake_slice2",
		anim        = "idle2",
		imagename   = "kyno_hofbirthday_cake_slice2",
		healthvalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE2_HEALTH,
		hungervalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE2_HUNGER,
		sanityvalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE2_SANITY,
		oneaten     = function(inst, eater)
			eater:AddDebuff("kyno_slice2birthdaybuff", "kyno_slice2birthdaybuff")
		end,
	},
	
	-- Slice 3 - Increased Max Sanity
	{
		name        = "kyno_hofbirthday_cake_slice3",
		anim        = "idle3",
		imagename   = "kyno_hofbirthday_cake_slice3",
		healthvalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE3_HEALTH,
		hungervalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE3_HUNGER,
		sanityvalue = TUNING.KYNO_HOFBIRTHDAY_CAKE_SLICE3_SANITY,
		oneaten     = function(inst, eater)
			eater:AddDebuff("kyno_slice3birthdaybuff", "kyno_slice3birthdaybuff")
		end,
	},
}

local prefabs = {}

for i, v in ipairs(cakeslices) do
	table.insert(prefabs, MakeCakeSlice(v))
end

return unpack(prefabs)