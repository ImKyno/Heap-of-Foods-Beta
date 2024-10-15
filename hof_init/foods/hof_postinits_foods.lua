-- Common Dependencies.
local _G              = GLOBAL
local require         = _G.require
local resolvefilepath = _G.resolvefilepath
local ACTIONS         = _G.ACTIONS
local STRINGS         = _G.STRINGS
local SpawnPrefab     = _G.SpawnPrefab

local HOF_ALCOHOLICDRINKS = GetModConfigData("ALCOHOLICDRINKS")

local spices =
{
	"chili",
	"garlic",
	"sugar",
	"salt",
}

-- Foliage can be cooked into Cooked Foliage.
AddPrefabPostInit("foliage", function(inst)
    inst:AddTag("cookable")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("cookable")
    inst.components.cookable.product = "kyno_foliage_cooked"
end)

-- Some items are a bit huge when dropped...
local function ResizeThisItem(inst)
    inst.AnimState:SetScale(.75, .75, .75)
end

local resize_items =
{
	"kyno_cucumber",
	"kyno_cucumber_cooked",
    "kyno_parznip_cooked",
}

for k,v in pairs(resize_items) do
    AddPrefabPostInit(v, ResizeThisItem)
end

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

VanillaFood.monsterlasagna.oneatenfn = function(inst, eater)
	if eater ~= nil and eater:HasTag("playermonster") and
	not (eater.components.health ~= nil and eater.components.health:IsDead()) and
	not eater:HasTag("playerghost") then
		eater.components.health:DoDelta(20)
		eater.components.sanity:DoDelta(20)
	end
end

-- Tweaks for Warly's foods.
local WarlyFood = require("preparedfoods_warly")
WarlyFood.monstertartare.test = function(cooker, names, tags)
	return tags.monster and tags.monster >= 2 and not tags.inedible and not tags.fruit
end
WarlyFood.monstertartare.health = -20
WarlyFood.monstertartare.hunger = 62.5
WarlyFood.monstertartare.sanity = -20
WarlyFood.monstertartare.cooktime = 2
WarlyFood.monstertartare.oneatenfn = function(inst, eater)
	if eater ~= nil and eater:HasTag("playermonster") and
	not (eater.components.health ~= nil and eater.components.health:IsDead()) and
	not eater:HasTag("playerghost") then
		eater.components.health:DoDelta(20)
		eater.components.sanity:DoDelta(20)
	end
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

-- This will prevent some characters from drinking Alcoholic-like drinks.
if HOF_ALCOHOLICDRINKS then
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
			oldPrefersToEat(self, inst)
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