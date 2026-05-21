local _G          = GLOBAL
local require     = _G.require
local VanillaFood = require("preparedfoods")

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