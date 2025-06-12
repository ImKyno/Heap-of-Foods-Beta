global("COOKINGPOTS")
COOKINGPOTS = COOKINGPOTS or {}

global("AddCookingPot")
AddCookingPot = function(cookpotname)
	COOKINGPOTS[cookpotname] = COOKINGPOTS[cookpotname] or {}
end

-- Vanilla Cooking Pots.
AddCookingPot("cookpot")
AddCookingPot("portablecookpot")

-- Other Known Modded Cooking Pots.
AddCookingPot("deluxpot")
AddCookingPot("medal_cookpot")

-- Heap of Foods Cooking Pots.
-- Currently Craft Pot does not support Cookwares because I coded them in a stupid way.
-- It would require the Craft Pot author to update the mod to make them compatible.

-- AddCookingPot("kyno_cookware_small")
-- AddCookingPot("kyno_cookware_big")
-- AddCookingPot("kyno_cookware_small_grill")
-- AddCookingPot("kyno_cookware_grill")
-- AddCookingPot("kyno_cookware_oven_small_casserole")
-- AddCookingPot("kyno_cookware_oven_casserole")
-- AddCookingPot("kyno_cookware_syrup")
-- AddCookingPot("kyno_cookware_elder")

-- Same goes for Brewers. 
-- AddCookingPot("kyno_preservesjar")
-- AddCookingPot("kyno_woodenkeg")