local _G               = GLOBAL
local require          = _G.require
local VanillaFood      = require("preparedfoods")
local SpicedFood       = require("spicedfoods")
local HofSpicedFood    = require("hof_spicedfoods")
local PIG_COIN_ECONOMY = require("hof_pigcoineconomy")

-- Some changes for the Vanilla foods.
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

VanillaFood.mandrakesoup.test = function(cooker, names, tags)
	return names.mandrake and not tags.flour
end

local _shroombait_oneatenfn = VanillaFood.shroombait.oneatenfn
VanillaFood.shroombait.oneatenfn = function(inst, eater)
	if _shroombait_oneatenfn ~= nil then
		_shroombait_oneatenfn(inst, eater)
	end

	if eater ~= nil and eater:HasTag("playermonster") and
	not (eater.components.health ~= nil and eater.components.health:IsDead()) and
	not eater:HasTag("playerghost") then
		eater.components.health:DoDelta(20)
		eater.components.sanity:DoDelta(20)
	end
end

-- For Preservation Powder Spice.
for k, v in pairs(VanillaFood) do
	AddPrefabPostInit(v, function(inst, data)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.edible ~= nil then
			inst.components.edible.degrades_with_spoilage = data.degrades_with_spoilage == nil or data.degrades_with_spoilage
		end
	end)
end

-- Pig King Coin Economy System.
local PIG_COIN_VALUES       =
{
	butterflymuffin         = {2, 0, 0},
	frogglebunwich          = {4, 0, 0}, 
	taffy                   = {4, 0, 0},
	pumpkincookie           = {5, 0, 0},
	stuffedeggplant         = {5, 0, 0},
	fishsticks              = {4, 0, 0},
	honeynuggets            = {3, 0, 0},
	honeyham                = {7, 0, 0},
	dragonpie               = {7, 1, 0},
	kabobs                  = {4, 0, 0},
	mandrakesoup            = {10, 5, 1},
	baconeggs               = {6, 0, 0},
	meatballs               = {4, 0, 0},
	bonestew                = {7, 0, 0},
	perogies                = {6, 1, 0},
	turkeydinner            = {5, 0, 0},
	ratatouille             = {3, 0, 0},
	jammypreserves          = {2, 0, 0},
	fruitmedley             = {4, 1, 0},
	fishtacos               = {5, 0, 0},
	waffles                 = {3, 1, 1},
	monsterlasagna          = {2, 0, 0},
	powcake                 = {1, 2, 0},
	unagi                   = {2, 1, 0},
	flowersalad             = {3, 2, 0},
	icecream                = {5, 1, 0},
	watermelonicle          = {3, 1, 0},
	trailmix                = {3, 0, 0},
	hotchili                = {5, 0, 0},
	guacamole               = {5, 1, 0},
	jellybean               = {6, 3, 1},
	potatotornado           = {5, 0, 0},
	mashedpotatoes          = {5, 0, 0},
	asparagussoup           = {4, 0, 0},
	vegstinger              = {4, 0, 0},
	bananapop               = {4, 0, 0},
	frozenbananadaiquiri    = {6, 0, 0},
	bananajuice             = {4, 0, 0},
	ceviche                 = {5, 1, 0},
	salsa                   = {4, 1, 0},
	pepperpopper            = {4, 0, 0},
	californiaroll          = {6, 1, 0},
	seafoodgumbo            = {3, 2, 0},
	surfnturf               = {5, 3, 0},
	lobsterbisque           = {6, 1, 0},
	lobsterdinner           = {6, 1, 0},
	barnaclepita            = {5, 0, 1},
	barnaclesushi           = {5, 0, 1},
	barnaclinguine          = {7, 0, 1},
	barnaclestuffedfishhead = {7, 0, 1},
	leafloaf                = {5, 0, 0},
	leafymeatburger         = {6, 0, 0},
	leafymeatsouffle        = {6, 0, 0},
	meatysalad              = {5, 0, 0},
	shroomcake              = {0, 1, 0},
	sweettea                = {0, 3, 0},
	koalefig_trunk          = {2, 2, 1},
	figatoni                = {6, 2, 0},
	figkabab                = {4, 0, 0},
	frognewton              = {4, 1, 0},
	bunnystew               = {3, 0, 0},
	justeggs                = {2, 0, 0},
	veggieomlet             = {3, 0, 0},
	talleggs                = {8, 0, 0},
	shroombait              = {5, 0, 0},
}

for prefab, value in pairs(PIG_COIN_VALUES) do
	if VanillaFood[prefab] ~= nil then
		VanillaFood[prefab].pigcoinvalue = value
	end
end

for prefab, data in pairs(SpicedFood) do
	local value = data.basename and PIG_COIN_VALUES[data.basename]

	if value ~= nil then
		data.pigcoinvalue = value
	end
end

for prefab, data in pairs(HofSpicedFood) do
	local value = data.basename and PIG_COIN_VALUES[data.basename]

	if value ~= nil then
		data.pigcoinvalue = value
	end
end

PIG_COIN_ECONOMY.RegisterRecipes(VanillaFood)
PIG_COIN_ECONOMY.RegisterRecipes(SpicedFood)
PIG_COIN_ECONOMY.RegisterRecipes(HofSpicedFood)