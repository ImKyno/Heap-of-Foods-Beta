local assets =
{
	Asset("ANIM", "anim/kyno_sporecap.zip"),
	Asset("ANIM", "anim/mushroom_farm_kyno_sporecap_build.zip"),
	
	Asset("ANIM", "anim/kyno_sporecap_dark.zip"),
	Asset("ANIM", "anim/mushroom_farm_kyno_sporecap_dark_build.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local function OnEaten(inst, eater)	
	if eater ~= nil then
		local cloud = SpawnPrefab("sporecloud")
		cloud.Transform:SetPosition(eater.Transform:GetWorldPosition())
	end
end

local function MakeSporecap(data)
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetBank(data.bank)
		inst.AnimState:SetBuild(data.build)
		inst.AnimState:PlayAnimation(data.anim)

		inst:AddTag("veggie")
		inst:AddTag("saltbox_valid")
		inst:AddTag("acidrainimmune")
		inst:AddTag("sporecloudimmune")
		
		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end
		
		inst.pickupsound = "vegetation_firm"

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("bait")
		inst:AddComponent("tradable")

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.healthvalue
		inst.components.edible.hungervalue = data.hungervalue
		inst.components.edible.sanityvalue = data.sanityvalue
		inst.components.edible.foodtype = FOODTYPE.VEGGIE
		
		if data.oneaten then
			inst.components.edible:SetOnEatenFn(OnEaten)
		end

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(data.perishtime)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = data.inventoryimage
		
		if data.fuel then
			inst:AddComponent("fuel")
			inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
		end

		if data.cookable then
			inst:AddComponent("cookable")
			inst.components.cookable.product = data.cookableproduct
		end

		if data.burnable then
			MakeSmallBurnable(inst)
			MakeSmallPropagator(inst)
			MakeHauntableLaunchAndPerish(inst)
		end

		return inst
	end
	
	return Prefab(data.name, fn, assets)
end

local sporecaps =
{
	-- Regular Toadstool.
	{
		name            = "kyno_sporecap",
		tags            = {"cookable", "mushroom", "toadstool_cap"},
		bank            = "kyno_sporecap",
		build           = "kyno_sporecap",
		anim            = "idle",
		inventoryimage  = "kyno_sporecap",
		cookableproduct = "kyno_sporecap_cooked",
		perishtime      = TUNING.PERISH_MED,
		healthvalue     = TUNING.KYNO_SPORECAP_HEALTH,
		hungervalue     = TUNING.KYNO_SPORECAP_HUNGER,
		sanityvalue     = TUNING.KYNO_SPORECAP_SANITY,
		oneaten         = true,
		cookable        = true,
		burnable        = true,
		fuel            = false,
	},
	
	{
		name            = "kyno_sporecap_cooked",
		tags            = {"toadstool_cap"},
		bank            = "kyno_sporecap",
		build           = "kyno_sporecap",
		anim            = "cooked",
		inventoryimage  = "kyno_sporecap_cooked",
		perishtime      = TUNING.PERISH_MED,
		healthvalue     = TUNING.KYNO_SPORECAP_COOKED_HEALTH,
		hungervalue     = TUNING.KYNO_SPORECAP_COOKED_HUNGER,
		sanityvalue     = TUNING.KYNO_SPORECAP_COOKED_SANITY,
		cookable        = false,
		burnable        = true,
		fuel            = true,
	},
	
	-- Misery Toadstool.
	{
		name            = "kyno_sporecap_dark",
		tags            = {"cookable", "mushroom", "toadstool_dark_cap"},
		bank            = "kyno_sporecap_dark",
		build           = "kyno_sporecap_dark",
		anim            = "idle",
		inventoryimage  = "kyno_sporecap_dark",
		cookableproduct = "kyno_sporecap_dark_cooked",
		perishtime      = TUNING.PERISH_MED,
		healthvalue     = TUNING.KYNO_SPORECAP_DARK_HEALTH,
		hungervalue     = TUNING.KYNO_SPORECAP_DARK_HUNGER,
		sanityvalue     = TUNING.KYNO_SPORECAP_DARK_SANITY,
		oneaten         = true,
		cookable        = true,
		burnable        = true,
		fuel            = false,
	},
	
	{
		name            = "kyno_sporecap_dark_cooked",
		tags            = {"toadstool_dark_cap"},
		bank            = "kyno_sporecap_dark",
		build           = "kyno_sporecap_dark",
		anim            = "cooked",
		inventoryimage  = "kyno_sporecap_dark_cooked",
		perishtime      = TUNING.PERISH_MED,
		healthvalue     = TUNING.KYNO_SPORECAP_DARK_COOKED_HEALTH,
		hungervalue     = TUNING.KYNO_SPORECAP_DARK_COOKED_HUNGER,
		sanityvalue     = TUNING.KYNO_SPORECAP_DARK_COOKED_SANITY,
		cookable        = false,
		burnable        = true,
		fuel            = true,
	},
}

local prefabs = {}

for i, v in ipairs(sporecaps) do
	table.insert(prefabs, MakeSporecap(v))
end

return unpack(prefabs)