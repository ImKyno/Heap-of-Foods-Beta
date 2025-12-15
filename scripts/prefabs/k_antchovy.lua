local assets =
{
	Asset("ANIM", "anim/kyno_antchovy.zip"),
	Asset("ANIM", "anim/kyno_antchovy01.zip"),
	
	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
}

local prefabs =
{

}

local MIN_WEIGHT = TUNING.KYNO_ANTCHOVY_MIN_WEIGHT
local MAX_WEIGHT = TUNING.KYNO_ANTCHOVY_MAX_WEIGHT

local function OnDroppedAsLoot(inst, data)
	if data ~= nil and data.dropper ~= nil then
		inst.components.weighable.prefab_override_owner = data.dropper.prefab
	end
end

local function CalcNewSize()
	local p = 2 * math.random() - 1
	return (p * p * p + 1) * 0.5
end

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
		inst.AnimState:PushAnimation("flop_loop", true)
	end

	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + num * 2, DoFlop)
end

local function OnDropped(inst)
	if inst.flop_task ~= nil then
		inst.flop_task:Cancel()
	end
	
	inst.AnimState:PlayAnimation("flop_loop", true)
	inst.flop_task = inst:DoTaskInTime(math.random() * 3, DoFlop)
end

local function OnPickup(inst)
    if inst.flop_task ~= nil then
        inst.flop_task:Cancel()
        inst.flop_task = nil
    end
end

local function OnSave(inst, data)
	data.setsinks = inst:HasTag("antchovy_sinkable")
end

local function OnLoad(inst, data)
	if data ~= nil and data.setsinks then
		inst.components.inventoryitem:SetSinks(true)
		inst:AddTag("antchovy_sinkable")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.entity:AddDynamicShadow()
	inst.DynamicShadow:SetSize(1, 1)
	
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("kyno_antchovy")
	inst.AnimState:SetBuild("kyno_antchovy")
	inst.AnimState:PlayAnimation("idle_alive", true)
	
	inst:AddTag("fish")
	inst:AddTag("fishfarmable")
	inst:AddTag("meat")
	inst:AddTag("catfood")
	inst:AddTag("smallcreature")
	inst:AddTag("smalloceancreature")
	inst:AddTag("antchovy")
	inst:AddTag("weighable_fish")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.build = "kyno_antchovy01"
	inst.flop_task = inst:DoTaskInTime(math.random() * 2 + 1, DoFlop)
	
	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_fish_small"

	inst:AddComponent("inventoryitem")
	-- inst.components.inventoryitem:SetSinks(true)
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickup)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_antchovy"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.KYNO_ANTCHOVY_HEALTH
	inst.components.edible.hungervalue = TUNING.KYNO_ANTCHOVY_HUNGER
	inst.components.edible.sanityvalue = TUNING.KYNO_ANTCHOVY_SANITY
	inst.components.edible.foodtype = FOODTYPE.MEAT
	
	inst:AddComponent("weighable")
	inst.components.weighable.type = TROPHYSCALE_TYPES.FISH
	inst.components.weighable:Initialize(MIN_WEIGHT, MAX_WEIGHT)
	inst.components.weighable:SetWeight(Lerp(MIN_WEIGHT, MAX_WEIGHT, CalcNewSize()))
	
	inst:AddComponent("fishfarmable")
	inst.components.fishfarmable:SetTimes(TUNING.ANTCHOVY_ROETIME, TUNING.ANTCHOVY_BABYTIME)
	inst.components.fishfarmable:SetProducts("kyno_roe_antchovy", "kyno_antchovy")
	inst.components.fishfarmable:SetPhases({ "day", "dusk", "night" })
	inst.components.fishfarmable:SetMoonPhases({ "new", "quarter", "half", "threequarter", "full" })
	inst.components.fishfarmable:SetSeasons({ "autumn", "winter", "spring", "summer" })
	inst.components.fishfarmable:SetWorlds({ "forest", "cave" })
	
	inst:ListenForEvent("on_loot_dropped", OnDroppedAsLoot)
	
	-- I am manually enabling SetSinks for reasons.
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("kyno_antchovy", fn, assets, prefabs)