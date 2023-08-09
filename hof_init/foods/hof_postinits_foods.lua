-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab

local spices = 
{
	"chili",
	"garlic",
	"sugar",
	"salt",
}

-- Theorically Tea Cool Down and Turns into Iced Tea.
AddPrefabPostInit("tea", function(inst)
    if inst.components.perishable ~= nil then
        inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "icedtea"
    end
end)

-- Foliage can be cooked into Cooked Foliage.
AddPrefabPostInit("foliage", function(inst)
    inst:AddTag("cookable")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("cookable")
    inst.components.cookable.product = "kyno_foliage_cooked"
end)

-- Wigfrid Can't Drink Coffee. Deprecated.
--[[
local FRIDA_COFFEE = GetModConfigData("HOF_COFFEEGOODIES")
if FRIDA_COFFEE == 0 then
    local coffee_wathgrithr = 
	{
        "coffee",
    }

    for k,v in pairs(coffee_wathgrithr) do
        AddPrefabPostInit(v, function(inst)
            if inst.components.edible ~= nil then
                inst.components.edible.foodtype = FOODTYPE.VEGGIE
            end
        end)
		
		for k,s in pairs(spices) do 
			AddPrefabPostInit(v.."_spice_"..s, function(inst)
				if inst.components.edible ~= nil then
					inst.components.edible.foodtype = FOODTYPE.VEGGIE
				end
			end
		end)
    end
end
]]--

-- Some items are a bit huge when dropped...
local function ResizeThisItem(inst)
    inst.AnimState:SetScale(.75, .75, .75)
end

local resize_items = 
{
    "kyno_radish_cooked",
    "kyno_cucumber",
    "kyno_parznip_cooked",
    "kyno_turnip_cooked",
    "kyno_turnip_ground",
	"friesfrench",
}

for k,v in pairs(resize_items) do
    AddPrefabPostInit(v, ResizeThisItem)
end

AddPrefabPostInit("cucumbersalad", function(inst)
    inst.AnimState:SetScale(1.5, 1.5, 1.5)
end)

-- The Sea Cucumber doesn't have a proper "cooked" animation, so I'll just make it non cookable.
AddPrefabPostInit("kyno_cucumber", function(inst)
    inst:RemoveTag("cookable")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.cookable ~= nil then
        inst:RemoveComponent("cookable")
    end
end)

-- Parsnip will not be entirely consumed when the player eats it. Instead it will become a eaten version!
local function ParznipPostinit(inst)
	local function OnEatenParznip(inst, eater)
		local parsnipeaten = SpawnPrefab("kyno_parznip_eaten")
		if eater.components.inventory and eater:HasTag("player") and not eater.components.health:IsDead()
			and not eater:HasTag("playerghost") then eater.components.inventory:GiveItem(parsnipeaten) 
		end
	end
	
	if inst.components.edible ~= nil then
        inst.components.edible:SetOnEatenFn(OnEatenParznip)
	end
end

AddPrefabPostInit("kyno_parznip", ParznipPostinit)

-- Strings and lazy fix for the Winter's Feast foods.
local FS = 1.4
AddPrefabPostInit("festive_berrysauce", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "BERRYSAUCE"
    end
end)

AddPrefabPostInit("festive_bibingka", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "BIBINGKA"
    end
end)

AddPrefabPostInit("festive_cabbagerolls", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "CABBAGEROLLS"
    end
end)

AddPrefabPostInit("festive_fishdish", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "FESTIVEFISH"
    end
end)

AddPrefabPostInit("festive_goodgravy", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "GRAVY"
    end
end)

AddPrefabPostInit("festive_latkes", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "LATKES"
    end
end)

AddPrefabPostInit("festive_lutefisk", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "LUTEFISK"
    end
end)

AddPrefabPostInit("festive_mulledpunch", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "MULLEDDRINK"
    end
end)

AddPrefabPostInit("festive_panettone", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "PANETTONE"
    end
end)

AddPrefabPostInit("festive_pavlova", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "PAVLOVA"
    end
end)

AddPrefabPostInit("festive_pickledherring", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "PICKLEDHERRING"
    end
end)

AddPrefabPostInit("festive_polishcookies", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "POLISHCOOKIE"
    end
end)

AddPrefabPostInit("festive_pumpkinpie", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "PUMPKINPIE"
    end
end)

AddPrefabPostInit("festive_roastedturkey", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "ROASTTURKEY"
    end
end)

AddPrefabPostInit("festive_stuffing", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "STUFFING"
    end
end)

AddPrefabPostInit("festive_sweetpotato", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "SWEETPOTATO"
    end
end)

AddPrefabPostInit("festive_tamales", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "TAMALES"
    end
end)

AddPrefabPostInit("festive_tourtiere", function(inst)
    inst.AnimState:SetScale(FS, FS, FS)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.inspectable ~= nil then
        inst.components.inspectable.nameoverride = "TOURTIERE"
    end
end)

-- Some changes for the Vanilla foods.
local VanillaFood = require("preparedfoods")
VanillaFood.bananapop.test = function(cooker, names, tags)
    return tags.banana and tags.frozen and names.twigs and not tags.meat and not tags.fish
end

VanillaFood.frozenbananadaiquiri.test = function(cooker, names, tags)
    return tags.banana and (tags.frozen and tags.frozen >= 1) and not tags.meat and not tags.fish
end

VanillaFood.bananajuice.test = function(cooker, names, tags)
    return (tags.banana and tags.banana >= 2) and not tags.meat and not tags.fish and not tags.monster
end

VanillaFood.butterflymuffin.test = function(cooker, names, tags)
	return (names.butterflywings or names.moonbutterflywings or names.kyno_sugarflywings) and not tags.meat and tags.veggie and tags.veggie >= 0.5
end 

VanillaFood.leafloaf.test = function(cooker, names, tags)
	return ((names.plantmeat or 0) + (names.plantmeat_cooked or 0) + (names.kyno_plantmeat_dried or 0) >= 2)
end

VanillaFood.leafymeatburger.test = function(cooker, names, tags)
	return (names.plantmeat or names.plantmeat_cooked or names.kyno_plantmeat_dried) and (names.onion or names.onion_cooked) 
	and tags.veggie and tags.veggie >= 2
end

VanillaFood.leafymeatsouffle.test = function(cooker, names, tags)
	return ((names.plantmeat or 0) + (names.plantmeat_cooked or 0) + (names.kyno_plantmeat_dried or 0) >= 2) and tags.sweetener and tags.sweetener >= 2
end

VanillaFood.meatysalad.test = function(cooker, names, tags)
	return (names.plantmeat or names.plantmeat_cooked or names.kyno_plantmeat_dried) and tags.veggie and tags.veggie >= 3
end

VanillaFood.icecream.test = function(cooker, names, tags)
	return tags.frozen and tags.dairy and tags.sweetener and not tags.meat and not tags.veggie and not tags.inedible and not tags.egg
	and not names.kyno_syrup
end 

-- Foods that will have their action "Eat" replaced to "Drink".
local drinkable_foods = 
{
    "winter_food8",
    "goatmilk",
}

for k,v in pairs(drinkable_foods) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("drinkable_food")
    end)
end

-- New foods that can be dried on Drying Racks.
local dryable_foods = 
{
	"red_cap",
	"green_cap",
	"blue_cap",
	"moon_cap",
	"plantmeat",
}

local function DryablePostinit(inst)
	inst:AddTag("dryable")
	
	if not _G.TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("kyno_".. inst.prefab .."_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_MED)
end

for k,v in pairs(dryable_foods) do 
	AddPrefabPostInit(v, DryablePostinit)	
end

-- Make every "same" recipe has the same quotes.
local jelly_foods = 
{
    "jelly_berries",
    "jelly_berries_juicy",
    "jelly_pomegranate",
    "jelly_dragonfruit",
    "jelly_cave_banana",
    "jelly_durian",
    "jelly_watermelon",
    "jelly_fig",
    "jelly_banana",
    "jelly_kokonut",
    "jelly_glowberry",
}

local mayo_foods = 
{
    "mayonnaise",
    "mayonnaise_chicken",
    "mayonnaise_tallbird",
    "mayonnaise_nightmare",
}

local pickles_foods = 
{
    "pickles_carrot",
    "pickles_corn",
    "pickles_eggplant",
    "pickles_pumpkin",
    "pickles_lichen",
    "pickles_cactus",
    "pickles_garlic",
    "pickles_asparagus",
    "pickles_onion",
    "pickles_tomato",
    "pickles_potato",
    "pickles_pepper",
    "pickles_redcap",
    "pickles_greencap",
    "pickles_bluecap",
    "pickles_mooncap",
    "pickles_kelp",
    "pickles_avocado",
    "pickles_whitecap",
    "pickles_aloe",
    "pickles_radish",
    "pickles_sweetpotato",
    "pickles_lotus",
    "pickles_seaweeds",
    "pickles_taroroot",
    "pickles_waterycress",
    "pickles_cucumber",
    "pickles_parznip",
    "pickles_turnip",
    "pickles_fennel",
}

local juice_foods = 
{
    "juice_carrot",
    "juice_corn",
    "juice_eggplant",
    "juice_pumpkin",
    "juice_lichen",
    "juice_cactus",
    "juice_garlic",
    "juice_asparagus",
    "juice_onion",
    "juice_tomato",
    "juice_potato",
    "juice_pepper",
    "juice_redcap",
    "juice_greencap",
    "juice_bluecap",
    "juice_mooncap",
    "juice_kelp",
    "juice_avocado",
    "juice_whitecap",
    "juice_aloe",
    "juice_radish",
    "juice_sweetpotato",
    "juice_lotus",
    "juice_seaweeds",
    "juice_taroroot",
    "juice_waterycress",
    "juice_cucumber",
    "juice_parznip",
    "juice_turnip",
    "juice_fennel",
}

for k,v in pairs(jelly_foods) do
    AddPrefabPostInit(v, function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        if inst.components.inspectable ~= nil then
            inst.components.inspectable.nameoverride = "KYNO_JELLY"
        end
    end)
end

for k,v in pairs(mayo_foods) do
    AddPrefabPostInit(v, function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        if inst.components.inspectable ~= nil then
            inst.components.inspectable.nameoverride = "KYNO_MAYONNAISE"
        end
    end)
end

for k,v in pairs(pickles_foods) do
    AddPrefabPostInit(v, function(inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        if inst.components.inspectable ~= nil then
            inst.components.inspectable.nameoverride = "KYNO_PICKLES"
        end
    end)
end

for k,v in pairs(juice_foods) do
    AddPrefabPostInit(v, function(inst)
		inst.AnimState:SetScale(1.20, 1.20, 1.20)
	
        if not _G.TheWorld.ismastersim then
            return inst
        end

        if inst.components.inspectable ~= nil then
            inst.components.inspectable.nameoverride = "KYNO_JUICE"
        end
    end)
end

-- This will prevent some characters from drinking Alcoholic-like drinks.
local ALCOHOLIC_DRINKS = GetModConfigData("HOF_ALCOHOLICDRINKS")
if ALCOHOLIC_DRINKS == 1 then
	local restricted_characters = 
	{
		"wendy",
		"webber",
		"wurt",
		"walter",
		"wilba", -- What? Yeah, modded characters be like.
	}
	
	for k,v in pairs(restricted_characters) do
		AddPrefabPostInit(v, function(inst)
			inst:AddTag("no_alcoholic_drinker")
		end)
	end
	
	AddComponentPostInit("eater", function(self)
		local oldPrefersToEat = self.PrefersToEat
		function self:PrefersToEat(inst)
			-- print("Heap of Foods: Changing PrefersToEat Eater component function")
			oldPrefersToEat(self, inst)
			-- print("Heap of Foods: PrefersToEat changed")
			if inst.prefab == "winter_food4" and self.inst:HasTag("player") then
				return false
			elseif inst:HasTag("alcoholic_drink") and self.inst:HasTag("no_alcoholic_drinker") then
				return false
			elseif self.preferseatingtags ~= nil then
				local preferred = false
				for i, v in ipairs(self.preferseatingtags) do
					if inst:HasTag(v) then
						preferred = true
						break
					end
				end
				if not preferred then
					return false
				end
			end
			return self:TestFood(inst, self.preferseating)
		end
	end)
end

-- Honey and Honey-based foods do not spoil inside Honey Deposits.
local honeyed_foods = 
{
	"bandage",
	"honey",
	"royal_jelly",
	"spice_sugar",
    "honeynuggets",
	"honeyham",
	"powcake",
	"freshfruitcrepes",
	"taffy",
	"icecream",
	"leafymeatsouffle",
	"voltgoatjelly",
	"sweettea",
	"pumpkincookie",
	"leafymeatsouffle",
	"beeswax",
	"bee",
	"killerbee",
	"beemine",
	"hivehat",
}

local function HoneyFoodsPostinit(inst)
	if not inst:HasTag("honeyed") then -- Just in case if they already have.
		inst:AddTag("honeyed")
	end
end

for k,v in pairs(honeyed_foods) do
	AddPrefabPostInit(v, HoneyFoodsPostinit)
	
	for k,s in pairs(spices) do 
		AddPrefabPostInit(v.."_spice_"..s, HoneyFoodsPostinit)
	end
end

-- Tweaks for Warly's foods.
local WarlyFood = require("preparedfoods_warly")
WarlyFood.monstertartare.health = 3
WarlyFood.monstertartare.hunger = 37.5
WarlyFood.monstertartare.sanity = 10
WarlyFood.monstertartare.cooktime = 2

-- Easter Egg for Pretzel. @Pep drew 2 sprites for it, would be a waste to not utilize both.
-- Basically Pretzel has a chance to be with a different sprite.
local function PretzelHeartPostinit(inst)
	local function ChangePretzelImage(inst)
		inst.AnimState:PlayAnimation("idle2")
		inst.AnimState:PushAnimation("idle2")
	
		if inst.components.inventoryitem ~= nil then 
			inst.components.inventoryitem:ChangeImageName("pretzel_heart")
		end
	end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if math.random() < 0.20 then 
		inst:DoTaskInTime(0, ChangePretzelImage)
	end
end

AddPrefabPostInit("pretzel", PretzelHeartPostinit)

for k,s in pairs(spices) do 
	AddPrefabPostInit("pretzel_spice_"..s, PretzelHeartPostinit)
end

local function LivingSandwichPostinit(inst)
	local function FuelTaken(inst, taker)
		if taker ~= nil and taker.SoundEmitter ~= nil then
			taker.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
		end
	end
	
	inst.pickupsound = "wood"
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    inst.components.fuel:SetOnTakenFn(FuelTaken)
end

AddPrefabPostInit("livingsandwich", LivingSandwichPostinit)