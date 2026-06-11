local function MakePlantBooster(data)
	local assets =
	{
		Asset("ANIM", "anim/kyno_plantbooster.zip"),

		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}

	local function OnIgnite(inst)
		inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
		DefaultBurnFn(inst)
	end

	local function OnExtinguish(inst)
		inst.SoundEmitter:KillSound("hiss")
		DefaultExtinguishFn(inst)
	end

	local function OnExplode(inst)
		inst.SoundEmitter:KillSound("hiss")
		SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end

	local function OnPutInInventory(inst, owner)
		if owner.prefab == "mole" then
			if inst.components.explosive ~= nil then
				inst.components.explosive:OnBurnt()
			end
		end
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)

		inst.AnimState:SetBank("kyno_plantbooster")
		inst.AnimState:SetBuild("kyno_plantbooster")
		inst.AnimState:PlayAnimation("idle")
		inst.AnimState:OverrideSymbol("swap_type", "kyno_plantbooster", data.type)

		inst:AddTag("molebait")
		inst:AddTag("explosive")
		inst:AddTag("plantbooster")

		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end

		if data.type ~= nil then
			inst:AddTag("plantbooster_type_"..data.type) -- plantbooster_type_growth
		end

		inst.pickupsound = "grainy"

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("bait")
		inst:AddComponent("inspectable")
		inst:AddComponent("plantbooster")

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = data.stacksize or TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = data.fuelvalue or TUNING.SMALL_FUEL

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = data.inventoryimage

		inst:AddComponent("explosive")
		inst.components.explosive:SetOnExplodeFn(OnExplode)
		inst.components.explosive.explosivedamage = data.explosivedamage

		MakeSmallBurnable(inst, 3 + math.random() * 3)
		MakeSmallPropagator(inst)
		MakeHauntableLaunchAndIgnite(inst)

		inst.components.burnable:SetOnBurntFn(nil)
		inst.components.burnable:SetOnIgniteFn(OnIgnite)
		inst.components.burnable:SetOnExtinguishFn(OnExtinguish)

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
		name            = "plantbooster_growth",
		type            = "growth",
		tags            = { "growthbooster" },
		inventoryimage  = "kyno_plantbooster_growth",
		explosivedamage = TUNING.KYNO_PLANTBOOSTER_GROWTH_EXPLOSIVE_DAMAGE,
	},

	-- Vitality Booster
	-- Fertilizes and instantly grows normal plants.
	-- Normal plants doesn't get barren anymore and are not affected by brightshades.
	{
		name            = "plantbooster_vitality",
		type            = "vitality",
		tags            = { "growthbooster", "farmplantbooster", "vitalitybooster" },
		inventoryimage  = "kyno_plantbooster_vitality",
		fuelvalue       = TUNING.MED_FUEL,
		explosivedamage = TUNING.KYNO_PLANTBOOSTER_VITALITY_EXPLOSIVE_DAMAGE,
	},

	-- Yield Booster
	-- Fertilizes and instantly grows regular plants.
	-- Normal plants yield +1 of their product when picked.
	{
		name            = "plantbooster_yield",
		type            = "yield",
		tags            = { "growthbooster", "farmplantbooster", "yieldbooster" },
		inventoryimage  = "kyno_plantbooster_yield",
		stacksize       = TUNING.STACK_SIZE_MEDITEM,
		fuelvalue       = TUNING.LARGE_FUEL,
		explosivedamage = TUNING.KYNO_PLANTBOOSTER_YIELD_EXPLOSIVE_DAMAGE,
	},

	-- Super Growth Booster
	-- Fertilizes and instantly grows regular plants.
	-- Advances farm plants to their final stage.
	-- Has a chance to turn farm plants into Oversized version.
	{
		name            = "plantbooster_supergrowth",
		type            = "supergrowth",
		tags            = { "growthbooster", "farmplantbooster", "supergrowthbooster" },
		inventoryimage  = "kyno_plantbooster_supergrowth",
		stacksize       = TUNING.STACK_SIZE_MEDITEM,
		fuelvalue       = TUNING.HUGE_FUEL,
		explosivedamage = TUNING.KYNO_PLANTBOOSTER_SUPERGROWTH_EXPLOSIVE_DAMAGE,
	},
}

local prefabs = {}

for i, v in ipairs(boosters) do
	table.insert(prefabs, MakePlantBooster(v))
end

return unpack(prefabs)