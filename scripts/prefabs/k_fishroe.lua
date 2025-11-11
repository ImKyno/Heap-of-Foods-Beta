local function MakeRoe(data)
	local assets = 
	{
		Asset("ANIM", "anim/kyno_roe.zip"),
		
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
		MakeInventoryFloatable(inst)
		
		inst.AnimState:SetScale(data.scale or 1, data.scale or 1, data.scale or 1)
	
		inst.AnimState:SetBank("kyno_roe")
		inst.AnimState:SetBuild("kyno_roe")
		inst.AnimState:PlayAnimation("idle_"..data.name)
	
		inst:AddTag("roe")
		inst:AddTag("cookable")
		inst:AddTag("saltbox_valid")
		
		if data.veggie ~= nil then
			inst:AddTag("veggie")
		else
			inst:AddTag("meat")
		end
	
		if data.firerpoof ~= nil then
			inst:AddTag("firerpoof_roe")
		end
	
		if data.tags ~= nil then
			for i, v in pairs(data.tags) do
				inst:AddTag(v)
			end
		end
	
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("bait")
		inst:AddComponent("selfstacker")
		
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = data.goldvalue or TUNING.GOLD_VALUES.MEAT
		inst.components.tradable.octopusvalue = data.octopusvalue or TUNING.OCTOPUS_VALUES.SEAFOOD
	
		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = "KYNO_ROE"
	
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = data.stacksize or TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = data.healthvalue or TUNING.KYNO_ROE_HEALTH
		inst.components.edible.hungervalue = data.hungervalue or TUNING.KYNO_ROE_HUNGER
		inst.components.edible.sanityvalue = data.sanityvalue or TUNING.KYNO_ROE_SANITY
		inst.components.edible.foodtype = data.foodtype or FOODTYPE.MEAT
		inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
		inst.components.edible.temperaturedelta = data.temperature or 0
		inst.components.edible.temperatureduration = data.temperatureduration or 0
		inst.components.edible.nochill = data.nochill or nil
		
		inst:AddComponent("cookable")
		inst.components.cookable.product = data.cookable_product or "kyno_roe_cooked"
	
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(data.perishtime or TUNING.PERISH_FAST)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
	
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = "kyno_roe_"..data.name
	
		if data.fireproof ~= nil then
			MakeHauntableLaunch(inst)
		else
			MakeSmallBurnable(inst)
			MakeSmallPropagator(inst)
			MakeHauntableLaunchAndIgnite(inst)
		end
	
		return inst
	end
	
	return Prefab("kyno_roe_"..data.name, fn, assets)
end

local fishroes =
{
	{
		name                = "pondfish",
	},
	
	{
		name                = "pondeel",
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		goldvalue           = 2,
	},
	
	{
		name                = "wobster",
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		goldvalue           = 2,
	},

	{
		name                = "wobster_monkeyisland",
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		goldvalue           = 3,
	},
	
	{
		name                = "wobster_moonglass",
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		goldvalue           = 3,
	},
	
	{
		name                = "neonfish",
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		goldvalue           = 3,
	},
	
	{
		name                = "pierrotfish",
		goldvalue           = 3,
	},
	
	{
		name                = "grouper",
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		goldvalue           = 3,
	},
	
	{
		name                = "tropicalfish",
		goldvalue           = 2,
	},
	
	{
		name                = "jellyfish",
		perishtime          = TUNING.PERISH_ONE_DAY,
	},
	
	{
		name                = "jellyfish_rainbow",
		perishtime          = TUNING.PERISH_ONE_DAY,
		goldvalue           = 3,
	},
	
	{
		name                = "salmonfish",
		goldvalue           = 3,
	},
	
	{
		name                = "koi",
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		goldvalue           = 2,
	},
	
	{
		name                = "antchovy",
		stacksize           = TUNING.STACK_SIZE_TINYITEM,
		goldvalue           = 1,
	},
	
	{
		name                = "swordfish_blue",
		stacksize           = TUNING.STACK_SIZE_LARGEITEM,
		goldvalue           = 4,
	},
	
	{
		name                = "oceanfish_small_1",
		goldvalue           = 2,
	},
	
	{
		name                = "oceanfish_small_2",
		goldvalue           = 2,
	},
	
	{
		name                = "oceanfish_small_3",
		goldvalue           = 2,
	},
	
	{
		name                = "oceanfish_small_4",
		goldvalue           = 2,
	},
	
	{
		name                = "oceanfish_small_5",
		goldvalue           = 2,
		foodtype            = FOODTYPE.VEGGIE,
		veggie              = true,
	},
	
	{
		name                = "oceanfish_small_6",
		goldvalue           = 2,
	},
	
	{
		name                = "oceanfish_small_7",
		goldvalue           = 2,
	},
	
	{
		name                = "oceanfish_small_8",
		goldvalue           = 2,
		temperature         = TUNING.KYNO_ROE_TEMPERATURE_HOT,
		temperatureduration = TUNING.KYNO_ROE_TEMPERATURE_DURATION,
		fireproof           = true,
	},
	
	{
		name                = "oceanfish_small_9",
		goldvalue           = 2,
	},
	
	{
		name                = "oceanfish_medium_1",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
	
	{
		name                = "oceanfish_medium_2",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
	
	{
		name                = "oceanfish_medium_3",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
	
	{
		name                = "oceanfish_medium_4",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
	
	{
		name                = "oceanfish_medium_5",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		foodtype            = FOODTYPE.VEGGIE,
		veggie              = true,
	},
	
	{
		name                = "oceanfish_medium_6",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
	
	{
		name                = "oceanfish_medium_7",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
	
	{
		name                = "oceanfish_medium_8",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
		temperature         = TUNING.KYNO_ROE_TEMPERATURE_COLD,
		temperatureduration = TUNING.KYNO_ROE_TEMPERATURE_DURATION,
	},
	
	{
		name                = "oceanfish_medium_9",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
	
	{
		name                = "oceanfish_pufferfish",
		goldvalue           = 2,
		healthvalue         = TUNING.KYNO_ROE_OCEANFISH_PUFFERFISH_HEALTH,
		hungervalue         = TUNING.KYNO_ROE_OCEANFISH_PUFFERFISH_HUNGER,
		sanityvalue         = TUNING.KYNO_ROE_OCEANFISH_PUFFERFISH_SANITY,
	},
	
	{
		name                = "oceanfish_sturgeon",
		goldvalue           = 3,
		stacksize           = TUNING.STACK_SIZE_MEDITEM,
	},
}

local prefabs = {}

for i, v in ipairs(fishroes) do
	table.insert(prefabs, MakeRoe(v))
end

return unpack(prefabs)