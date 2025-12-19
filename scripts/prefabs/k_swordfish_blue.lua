local assets =
{
	Asset("ANIM", "anim/kyno_swordfish_blue.zip"),
	Asset("ANIM", "anim/kyno_swordfish_blue01.zip"),

	Asset("ANIM", "anim/kyno_meatrack_swordfish_blue.zip"),
	Asset("ANIM", "anim/kyno_meatrack_fishmeat.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{
	"ice",
	"kyno_fishmeat_dried",
}

local function DoFlop(inst)
	if not inst.components.inventoryitem.canbepickedup then
		if inst.flop_task ~= nil then
			inst.flop_task:Cancel()
			inst.flop_task = nil
		end

		return -- Don't flop if we can't be picked up, this likely means we're in a special place/state.
	end

	local num = math.random(2)
	
	for i = 1, num do
		inst.AnimState:PushAnimation("idle", false)
	end

	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + num * 2, DoFlop)
end

local function OnDropped(inst)
	if inst.flop_task ~= nil then
		inst.flop_task:Cancel()
	end
	
	inst.AnimState:PlayAnimation("idle", false)
	inst.flop_task = inst:DoTaskInTime(math.random() * 3, DoFlop)
end

local function OnPickup(inst)
    if inst.flop_task ~= nil then
        inst.flop_task:Cancel()
        inst.flop_task = nil
    end
end

local function GetFishKey(inst)
	return inst.prefab
end

local function fishresearchfn(inst)
	return inst:GetFishKey()
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize(5, 1)
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetScale(.8, .8, .8)

	inst.AnimState:SetBank("kyno_swordfish_blue")
	inst.AnimState:SetBuild("kyno_swordfish_blue")
	inst.AnimState:PlayAnimation("idle", false)
	
	inst:AddTag("fish")
	inst:AddTag("fishfarmable")
	inst:AddTag("pondfish")
	inst:AddTag("meat")
	inst:AddTag("catfood")
	inst:AddTag("largecreature")
	inst:AddTag("fishresearchable")

	inst.GetFishKey = GetFishKey

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.build = "kyno_swordfish_blue01"
	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + 1, DoFlop)
	
	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	inst:AddComponent("murderable")
	
	inst:AddComponent("fishresearchable")
	inst.components.fishresearchable:SetResearchFn(fishresearchfn)
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD_RARE
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "fishmeat_cooked"
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"fishmeat", "fishmeat", "ice"})
	
	-- I forgor live fishes can't be dried.
	-- inst:AddComponent("dryable")
	-- inst.components.dryable:SetDryTime(TUNING.DRY_MED)
	-- inst.components.dryable:SetProduct("kyno_fishmeat_dried")
	-- inst.components.dryable:SetBuildFile("kyno_meatrack_swordfish_blue")
	-- inst.components.dryable:SetDriedBuildFile("kyno_meatrack_fishmeat")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "kyno_spoiled_fish_large"

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickup)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_swordfish_blue"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_FISH_LARGE_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_FISH_LARGE_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_FISH_LARGE_SANITY
	inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
	inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("fishfarmable")
	inst.components.fishfarmable:SetTimes(TUNING.SWORDFISH_BLUE_ROETIME, TUNING.SWORDFISH_BLUE_BABYTIME)
	inst.components.fishfarmable:SetProducts("kyno_roe_swordfish_blue", "kyno_swordfish_blue")
	inst.components.fishfarmable:SetPhases({ "day", "dusk", "night" })
	inst.components.fishfarmable:SetMoonPhases({ "new", "quarter", "half", "threequarter", "full" })
	inst.components.fishfarmable:SetSeasons({ "winter" })
	inst.components.fishfarmable:SetWorlds({ "cave" })
	
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_swordfish_blue", fn, assets, prefabs)