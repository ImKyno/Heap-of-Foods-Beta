local function MakePlantBooster(data)
	local assets =
	{
		Asset("ANIM", "anim/kyno_plantbooster.zip"),

		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)

		inst.AnimState:SetBank("kyno_plantbooster")
		inst.AnimState:SetBuild("kyno_plantbooster")
		inst.AnimState:PlayAnimation("idle")
		inst.AnimState:OverrideSymbol("swap_type", "kyno_plantbooster", "type_"..data.type)

		inst:AddTag("plantbooster")

		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end

		if data.type ~= nil then
			inst:AddTag("plantbooster_type_"..data.type) -- plantbooster_type_growth
		end

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("plantbooster")

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = data.stacksize or TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = data.fuelvalue or TUNING.SMALL_FUEL

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = data.inventoryimage

		MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndIgnite(inst)

		return inst
	end

	return Prefab("kyno_"..data.name, fn, assets)
end

local boosters =
{
	-- Boosters are not cumulative and override each other.

	-- Growth Booster
	-- Fertilizes and instantly grows normal plants.
	{
		name           = "plantbooster_growth",
		type           = "growth",
		tags           = { "growthbooster" },
		inventoryimage = "kyno_plantbooster_growth",
	},

	-- Vitality Booster
	-- Fertilizes and instantly grows normal plants.
	-- Normal plants doesn't get barren anymore and are not affected by brightshades.
	{
		name           = "plantbooster_vitality",
		type           = "vitality",
		tags           = { "growthbooster", "farmplantbooster", "vitalitybooster" },
		inventoryimage = "kyno_plantbooster_vitality",
		fuelvalue      = TUNING.MED_FUEL,
	},

	-- Yield Booster
	-- Fertilizes and instantly grows regular plants.
	-- Normal plants yield +1 of their product when picked.
	{
		name           = "plantbooster_yield",
		type           = "yield",
		tags           = { "growthbooster", "farmplantbooster", "yieldbooster" },
		inventoryimage = "kyno_plantbooster_yield",
		stacksize      = TUNING.STACK_SIZE_MEDITEM,
		fuelvalue      = TUNING.LARGE_FUEL,
	},

	-- Super Growth Booster
	-- Fertilizes and instantly grows regular plants.
	-- Advances farm plants to their final stage.
	-- Has a chance to turn farm plants into Oversized version.
	{
		name           = "plantbooster_supergrowth",
		type           = "supergrowth",
		tags           = { "growthbooster", "farmplantbooster", "supergrowthbooster" },
		inventoryimage = "kyno_plantbooster_supergrowth",
		stacksize      = TUNING.STACK_SIZE_MEDITEM,
		fuelvalue      = TUNING.HUGE_FUEL,
	},
}

local prefabs = {}

for i, v in ipairs(boosters) do
	table.insert(prefabs, MakePlantBooster(v))
end

return unpack(prefabs)