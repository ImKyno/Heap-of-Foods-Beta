local assets =
{
	Asset("ANIM", "anim/hermit_bundle.zip"),
	
    Asset("ANIM", "anim/koi.zip"),
	Asset("ANIM", "anim/koi02.zip"),
	Asset("ANIM", "anim/koi_cooked.zip"),
	
	Asset("ANIM", "anim/tropicalfish.zip"),
	Asset("ANIM", "anim/tropicalfish02.zip"),
	Asset("ANIM", "anim/tropicalfish_cooked.zip"),
	
	Asset("ANIM", "anim/neonfish.zip"),
	Asset("ANIM", "anim/neonfish02.zip"),
	Asset("ANIM", "anim/neonfish_cooked.zip"),
	
	Asset("ANIM", "anim/grouper.zip"),
	Asset("ANIM", "anim/grouper02.zip"),
	Asset("ANIM", "anim/grouper_cooked.zip"),
	
	Asset("ANIM", "anim/pierrotfish.zip"),
	Asset("ANIM", "anim/pierrotfish02.zip"),
	Asset("ANIM", "anim/pierrotfish_cooked.zip"),
	
	Asset("ANIM", "anim/salmonfish.zip"),
	Asset("ANIM", "anim/salmonfish02.zip"),
	Asset("ANIM", "anim/salmonfish_cooked.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs = 
{
	"kyno_koi",
	"kyno_grouper",
	"kyno_pierrotfish",
	"kyno_neonfish",
	"kyno_tropicalfish",
}

local fish_prefabs =
{
	"fishmeat_small",
    "fishmeat_small_cooked",
	
	"fishmeat",
	"fishmeat_cooked",
	
	"spoiled_fish_small",
    "spoiled_fish",
}

local ALL_PHASES     = { "day", "dusk", "night" }
local ALL_MOONPHASES = { "new", "quarter", "half", "threequarter", "full" }
local ALL_SEASONS    = { "autumn", "winter", "spring", "summer" }
local ALL_WORLDS     = { "forest", "cave" }

local function CalcNewSize()
	local p = 2 * math.random() - 1
	return (p*p*p + 1) * 0.5
end

local function flop(inst)
	local num = math.random(2)
	for i = 1, num do
		inst.AnimState:PushAnimation("idle", false)
	end

	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + num * 2, flop)
end

local function ondropped(inst)
    if inst.flop_task ~= nil then
        inst.flop_task:Cancel()
    end
	inst.AnimState:PlayAnimation("idle", false)
    inst.flop_task = inst:DoTaskInTime(math.random() * 3, flop)
end

local function ondroppedasloot(inst, data)
	if data ~= nil and data.dropper ~= nil then
		inst.components.weighable.prefab_override_owner = data.dropper.prefab
	end
end

local function onpickup(inst)
    if inst.flop_task ~= nil then
        inst.flop_task:Cancel()
        inst.flop_task = nil
    end
end

local function commonfn(bank, build, char_anim_build, data)
    local inst = CreateEntity()

	data = data or {}

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle", false)

	inst:AddTag("fish")
	inst:AddTag("pondfish")
    inst:AddTag("meat")
    inst:AddTag("catfood")
	inst:AddTag("smalloceancreature")
	
	if data.roe_time ~= nil and data.baby_time ~= nil then
		inst:AddTag("fishfarmable")
	end

	if data.weight_min ~= nil and data.weight_max ~= nil then
		inst:AddTag("weighable_fish")
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.build = char_anim_build -- This is used within SGwilson, sent from an event in fishingrod.lua

    inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	inst:AddComponent("murderable")

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(data.perish_time)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = data.perish_product

    inst:AddComponent("cookable")
    inst.components.cookable.product = data.cookable_product
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(data.loot)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(onpickup)
	inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
	inst.components.edible.healthvalue = data.healthvalue
	inst.components.edible.hungervalue = data.hungervalue
	inst.components.edible.sanityvalue = data.sanityvalue or 0
    inst.components.edible.foodtype = FOODTYPE.MEAT

	if data.weight_min ~= nil and data.weight_max ~= nil then
		inst:AddComponent("weighable")
		inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
		inst.components.weighable:Initialize(data.weight_min, data.weight_max)
		inst.components.weighable:SetWeight(Lerp(data.weight_min, data.weight_max, CalcNewSize()))
	end
	
	inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = data.goldvalue or TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = data.octopusvalue or TUNING.OCTOPUS_VALUES.SEAFOOD
	
	if data.roe_time ~= nil and data.baby_time ~= nil then
		inst:AddComponent("fishfarmable")
		inst.components.fishfarmable:SetTimes(data.roe_time, data.baby_time)
		inst.components.fishfarmable:SetProducts(data.roe_prefab, data.baby_prefab)
		inst.components.fishfarmable:SetPhases(data.phases)
		inst.components.fishfarmable:SetMoonPhases(data.moonphases)
		inst.components.fishfarmable:SetSeasons(data.seasons)
		inst.components.fishfarmable:SetWorlds(data.worlds)
	end
	
	inst.data = {}

	inst:ListenForEvent("on_loot_dropped", ondroppedasloot)
	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + 1, flop)
	
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function cookedfn(bank, build, anim, data)
	local inst = CreateEntity()

	data = data or {}

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation(anim, false)

	inst:AddTag("fish")
    inst:AddTag("meat")
    inst:AddTag("catfood")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = data.stacksize

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(data.perish_time)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = data.perish_product

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
	inst.components.edible.healthvalue = data.healthvalue
	inst.components.edible.hungervalue = data.hungervalue
	inst.components.edible.sanityvalue = data.sanityvalue or 0
    inst.components.edible.foodtype = FOODTYPE.MEAT

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = data.goldvalue or TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = data.octopusvalue or TUNING.OCTOPUS_VALUES.SEAFOOD
	
    inst.data = {}
	
	MakeHauntableLaunchAndPerish(inst)

    return inst
end

-- Large Fishes.
-- Why is the weight hardcoded in here? Whatever, don't think anyone will need it.
local koi_data          =
{
	weight_min          = 154.32,
	weight_max          = 420.69,
	
	perish_product      = "spoiled_fish",
	loot                = { "fishmeat" },
	cookable_product    = "kyno_koi_cooked",
	
	healthvalue         = TUNING.KYNO_FISH_LARGE_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_LARGE_HUNGER,
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	roe_prefab          = "kyno_roe_koi",
	baby_prefab         = "kyno_koi",
	
	roe_time            = TUNING.TROPICALKOI_ROETIME,
	baby_time           = TUNING.TROPICALKOI_BABYTIME,
	
	phases              = ALL_PHASES,
	moonphases          = ALL_MOONPHASES,
	seasons             = { "summer" },
	worlds              = ALL_WORLDS,
}

local neon_data         =
{
	weight_min          = 121.02,
	weight_max          = 243.74,
	
	perish_product      = "spoiled_fish",
	loot                = { "fishmeat" },
	cookable_product    = "kyno_neonfish_cooked",
	
	healthvalue         = TUNING.KYNO_FISH_LARGE_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_LARGE_HUNGER,
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	roe_prefab          = "kyno_roe_neonfish",
	baby_prefab         = "kyno_neonfish",
		
	roe_time            = TUNING.NEONFISH_ROETIME,
	baby_time           = TUNING.NEONFISH_BABYTIME,
		
	phases              = ALL_PHASES,
	moonphases          = ALL_MOONPHASES,
	seasons             = { "winter" },
	worlds              = ALL_WORLDS,
}

local purple_data       =
{
	weight_min          = 205.15,
	weight_max          = 362.87,
	
	perish_product      = "spoiled_fish",
	loot                = { "fishmeat" },
	cookable_product    = "kyno_grouper_cooked",
	
	healthvalue         = TUNING.KYNO_FISH_LARGE_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_LARGE_HUNGER,
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	roe_prefab          = "kyno_roe_grouper",
	baby_prefab         = "kyno_grouper",
		
	roe_time            = TUNING.GROUPER_ROETIME,
	baby_time           = TUNING.GROUPER_BABYTIME,
		
	phases              = { "dusk", "night" },
	moonphases          = ALL_MOONPHASES,
	seasons             = ALL_SEASONS,
	worlds              = ALL_WORLDS,
}

local large_cooked_data =
{
	perish_product      = "spoiled_fish",
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	healthvalue         = TUNING.KYNO_FISH_LARGE_COOKED_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_LARGE_COOKED_HUNGER,
	sanityvalue         = TUNING.KYNO_FISH_LARGE_COOKED_SANITY,
	
	stacksize           = TUNING.STACK_SIZE_MEDITEM,
}

-- Small Fishes.
local tropical_data     =
{
	weight_min          = 20.89,
	weight_max          = 47.32,
	
	perish_product      = "spoiled_fish_small",
	loot                = { "fishmeat_small" },
	cookable_product    = "kyno_tropicalfish_cooked",
	
	healthvalue         = TUNING.KYNO_FISH_SMALL_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_SMALL_HUNGER,
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	roe_prefab          = "kyno_roe_tropicalfish",
	baby_prefab         = "kyno_tropicalfish",
		
	roe_time            = TUNING.TROPICALFISH_ROETIME,
	baby_time           = TUNING.TROPICALFISH_BABYTIME,
		
	phases              = ALL_PHASES,
	moonphases          = ALL_MOONPHASES,
	seasons             = { "autumn" },
	worlds              = ALL_WORLDS,
}

local pierrot_data      =
{
	weight_min          = 60.23,
	weight_max          = 97.55,
	
	perish_product      = "spoiled_fish_small",
	loot                = { "fishmeat_small" },
	cookable_product    = "kyno_pierrotfish_cooked",
	
	healthvalue         = TUNING.KYNO_FISH_SMALL_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_SMALL_HUNGER,
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	roe_prefab          = "kyno_roe_pierrotfish",
	baby_prefab         = "kyno_pierrotfish",
		
	roe_time            = TUNING.PIERROTFISH_ROETIME,
	baby_time           = TUNING.PIERROTFISH_BABYTIME,
		
	phases              = ALL_PHASES,
	moonphases          = ALL_MOONPHASES,
	seasons             = { "spring" },
	worlds              = ALL_WORLDS,
}

local salmon_data       =
{
	weight_min          = 52.43,
	weight_max          = 110.85,
	
	perish_product      = "spoiled_fish_small",
	loot                = { "fishmeat_small" },
	cookable_product    = "kyno_salmonfish_cooked",
	
	healthvalue         = TUNING.KYNO_FISH_SMALL_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_SMALL_HUNGER,
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	roe_prefab          = "kyno_roe_salmonfish",
	baby_prefab         = "kyno_salmonfish",
		
	roe_time            = TUNING.SALMONFISH_ROETIME,
	baby_time           = TUNING.SALMONFISH_BABYTIME,
		
	phases              = { "day", "dusk" },
	moonphases          = ALL_MOONPHASES,
	seasons             = ALL_SEASONS,
	worlds              = ALL_WORLDS,
}

local small_cooked_data =
{
	perish_product      = "spoiled_fish_small",
	perish_time         = TUNING.PERISH_SUPERFAST,
	
	healthvalue         = TUNING.KYNO_FISH_SMALL_COOKED_HEALTH,
	hungervalue         = TUNING.KYNO_FISH_SMALL_COOKED_HUNGER,
	sanityvalue         = TUNING.KYNO_FISH_SMALL_COOKED_SANITY,
	
	stacksize           = TUNING.STACK_SIZE_SMALLITEM,
}

local function koifn()
	return commonfn("koi", "koi", "koi02", koi_data)
end

local function cooked_koifn()
	return cookedfn("koi_cooked", "koi_cooked", "cooked", large_cooked_data)
end

local function neonfn()
	return commonfn("neonfish", "neonfish", "neonfish02", neon_data)
end

local function cooked_neonfn()
	return cookedfn("neonfish_cooked", "neonfish_cooked", "cooked", large_cooked_data)
end

local function grouperfn()
	return commonfn("grouper", "grouper", "grouper02", purple_data)
end

local function cooked_grouperfn()
	return cookedfn("grouper_cooked", "grouper_cooked", "cooked", large_cooked_data)
end

local function tropicalfn()
	return commonfn("tropicalfish", "tropicalfish", "tropicalfish02", tropical_data)
end

local function cooked_tropicalfn()
	return cookedfn("tropicalfish_cooked", "tropicalfish_cooked", "cooked", large_cooked_data)
end

local function pierrotfn()
	return commonfn("pierrotfish", "pierrotfish", "pierrotfish02", pierrot_data)
end

local function cooked_pierrotfn()
	return cookedfn("pierrotfish_cooked", "pierrotfish_cooked", "cooked", small_cooked_data)
end

local function salmonfn()
	return commonfn("salmonfish", "salmonfish", "salmonfish02", salmon_data)
end

local function cooked_salmonfn()
	return cookedfn("salmonfish_cooked", "salmonfish_cooked", "cooked", small_cooked_data)
end

return Prefab("kyno_koi", koifn, assets, fish_prefabs),
Prefab("kyno_koi_cooked", cooked_koifn, assets, fish_prefabs),

Prefab("kyno_neonfish", neonfn, assets, fish_prefabs),
Prefab("kyno_neonfish_cooked", cooked_neonfn, assets, fish_prefabs),

Prefab("kyno_grouper", grouperfn, assets, fish_prefabs),
Prefab("kyno_grouper_cooked", cooked_grouperfn, assets, fish_prefabs),

Prefab("kyno_tropicalfish", tropicalfn, assets, fish_prefabs),
Prefab("kyno_tropicalfish_cooked", cooked_tropicalfn, assets, fish_prefabs),

Prefab("kyno_pierrotfish", pierrotfn, assets, fish_prefabs),
Prefab("kyno_pierrotfish_cooked", cooked_pierrotfn, assets, fish_prefabs),

Prefab("kyno_salmonfish", salmonfn, assets, fish_prefabs),
Prefab("kyno_salmonfish_cooked", cooked_salmonfn, assets, fish_prefabs)