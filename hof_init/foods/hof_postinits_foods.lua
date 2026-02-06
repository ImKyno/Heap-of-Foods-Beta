-- Common Dependencies.
local _G                  = GLOBAL
local require             = _G.require
local resolvefilepath     = _G.resolvefilepath
local ACTIONS             = _G.ACTIONS
local STRINGS             = _G.STRINGS
local SpawnPrefab         = _G.SpawnPrefab

local HOF_ALCOHOLICDRINKS = GetModConfigData("ALCOHOLICDRINKS")

--[[
local HOF_FOODRECIPES     = {}

for k, v in pairs(_G.MergeMaps(require("hof_foodrecipes"), require("hof_foodrecipes_seasonal"), require("hof_foodrecipes_warly"))) do 
	HOF_FOODRECIPES[k]    = v
end

-- Fix for showing foods on Portable Seasoning Station.
local function PortbaleSpicerPostInit(inst)
	local function ShowProduct(inst)
		local product = inst.components.stewer.product
		local recipe = cooking.GetRecipe(inst.prefab, product)
			
		if recipe ~= nil then
			product = recipe.basename or product
		end

		local hofrecipe = HOF_FOODRECIPES[product]
		
		if hofrecipe ~= nil then
			local build = hofrecipe.overridebuild or product
			inst.AnimState:OverrideSymbol("swap_cooked", build, product)
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end
		
	local _continuedonefn = inst.components.stewer.oncontinuedone
	local _donecookfn = inst.components.stewer.ondonecooking
		
	inst.components.stewer.oncontinuedone = function(inst) _continuedonefn(inst) ShowProduct(inst) end
	inst.components.stewer.ondonecooking = function(inst) _donecookfn(inst) ShowProduct(inst) end
end

AddPrefabPostInit("portablespicer", PortbaleSpicerPostInit)
]]--

local spices =
{
	"chili",
	"garlic",
	"sugar",
	"salt",
	
	"cure",
	"cold",
	"fire",
	"fed",
	"mind",
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

for k, v in pairs(resize_items) do
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
	return names.butterflywings and not tags.meat and tags.veggie and tags.veggie >= 0.5
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

VanillaFood.waffles.test = function(cooker, names, tags)
	return tags.butter and (names.berries or names.berries_cooked or names.berries_juicy or names.berries_juicy_cooked) and tags.egg
end

VanillaFood.lobsterdinner.test = function(cooker, names, tags)
	return names.wobster_sheller_land and tags.butter and (tags.meat and tags.meat >= 1.0) and (tags.fish and tags.fish >= 1.0) and not tags.frozen
end

VanillaFood.lobsterdinner.oneat_desc = STRINGS.UI.COOKBOOK.FOOD_EFFECTS_EXQUISITE

VanillaFood.fishtacos.test = function(cooker, names, tags)
	return tags.fish and (names.corn or names.corn_cooked or names.oceanfish_small_5_inv or names.oceanfish_medium_5_inv) 
	and not (names.eel or names.pondeel or names.eel_cooked)
end

VanillaFood.unagi.test = function(cooker, names, tags)
	return (names.cutlichen or names.kelp or names.kelp_cooked or names.kelp_dried) and (names.eel or names.eel_cooked or names.pondeel) 
	and not (names.corn or names.corn_cooked or names.oceanfish_small_5_inv or names.oceanfish_medium_5_inv)
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

WarlyFood.freshfruitcrepes.test = function(cooker, names, tags)
	return tags.fruit and tags.fruit >= 1.5 and tags.butter and names.honey
end

-- For Preservation Powder Spice.
for k, v in pairs(_G.MergeMaps(VanillaFood, WarlyFood)) do
	AddPrefabPostInit(v, function(inst, data)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.edible ~= nil then
			inst.components.edible.degrades_with_spoilage = data.degrades_with_spoilage == nil or data.degrades_with_spoilage
		end
	end)
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

	for k, v in pairs(restricted_characters) do
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

for k, v in pairs(honeyed_foods) do
	AddPrefabPostInit(v, HoneyFoodsPostinit)

	for k, s in pairs(spices) do
		AddPrefabPostInit(v.."_spice_"..s, HoneyFoodsPostinit)
	end
end

local sliceable_foods =
{
	drumstick      =
	{
		product    = "smallmeat",
		slicesize  = 1,
	},
	
	fishmeat       =
	{
		product    = "fishmeat_small",
		slicesize  = 2,
	},
	
	fishmeat_dried =
	{
		product    = "fishmeat_small_dried",
		slicesize  = 2,
	},

	meat           =
	{
		product    = "smallmeat",
		slicesize  = 2,
	},
	
	meat_dried     =
	{
		product    = "smallmeat_dried",
		slicesize  = 2,
	},
}

local function SliceablePostInit(inst)
	inst:AddTag("sliceable")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("sliceable")
	
	entry = sliceable_foods[inst.prefab]
	if entry then
		inst.components.sliceable:SetProduct(entry.product)
		inst.components.sliceable:SetSliceSize(entry.slicesize)
	end
end

for k, v in pairs(sliceable_foods) do
	AddPrefabPostInit(k, SliceablePostInit)
end

-- Make dried foods valid for Salt Box and Polar Bearger Bin.
local dried_foods =
{
	"smallmeat_dried",
	"meat_dried",
	"monstermeat_dried",
	"kelp_dried",
	"humanmeat_dried",
	"fishmeat_small_dried",
	"fishmeat_dried",
}

local function DriedPostInit(inst)
	inst:AddTag("saltbox_valid")
	inst:AddTag("beargerfur_sack_valid")
end

for k, v in pairs(dried_foods) do
	AddPrefabPostInit(v, DriedPostInit)
end

local monkeyqueen_foods =
{
	"bananapop",
	"frozenbananadaiquiri",
	"bananajuice",
}

local function MonkeyQueenBribesPostInit(inst)
	inst:AddTag("monkeyqueenbribe")
end

for k, v in pairs(monkeyqueen_foods) do
	AddPrefabPostInit(v, MonkeyQueenBribesPostInit)
end

-- Invalid Birdcage foods.
local function BirdcagePostInit(inst)
	local invalid_foods = UpvalueHacker.GetUpvalue(_G.Prefabs.birdcage.fn, "ShouldAcceptItem", "invalid_foods")
	table.insert(invalid_foods, "kyno_chicken_egg")
	table.insert(invalid_foods, "kyno_chicken_egg_cooked")
end

AddPrefabPostInit("birdcage", BirdcagePostInit)

-- Valid Cooking Pots and Containers for the S0US-CH3F.
local cook_robot_pots =
{
	"cookpot",
	"archive_cookpot",
}

local cook_robot_containers =
{
	"icebox",
	"saltbox",
	"fish_box",
	"potatosack",
	"treasurechest",
	"dragonflychest",
}

local function CookRobotPotsPostInit(inst)
	inst:AddTag("cook_robot_cooker_valid")
end

local function CookRobotContainersPostInit(inst)
	inst:AddTag("cook_robot_storage_valid")
end

for k, v in pairs(cook_robot_pots) do
	AddPrefabPostInit(v, CookRobotPotsPostInit)
end

for k, v in pairs(cook_robot_containers) do
	AddPrefabPostInit(v, CookRobotContainersPostInit)
end

-- Make all seeds a valid fuel for Animal Trough.
local function SeedsPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.edible ~= nil then
		if inst.components.edible.foodtype == _G.FOODTYPE.SEEDS and not inst:HasTag("gourmet_ingredient") then
			if not inst.components.fuel then
				inst:AddComponent("fuel")
			end
	
			if inst.components.fuel ~= nil then
				inst.components.fuel.fueltype = _G.FUELTYPE.ANIMALFOOD
				inst.components.fuel.fuelvalue = TUNING.MED_FUEL
			end
		end
	end
end

AddPrefabPostInitAny(SeedsPostInit)

-- Valid Foods for the Display Stand.
local itemshowcaser_foods =
{
	"batnosehat",
	"dustmeringue",
	
	-- They're not Crock Pot foods...
	-- "carnivalfood_corntea",
	-- "yotp_food1",
	-- "yotp_food2",
	-- "yotp_food3",
	-- "yotr_food1",
	-- "yotr_food2",
	-- "yotr_food3",
	-- "yotr_food4",
}

local function ItemShowcaserItemsPostInit(inst)
	inst:AddTag("itemshowcaser_valid")
end

for k, v in pairs(itemshowcaser_foods) do
	AddPrefabPostInit(v, ItemShowcaserItemsPostInit)
end