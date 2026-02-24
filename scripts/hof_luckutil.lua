--[[-------------------------------------------------------------------------------------------------------------------------------------------------

	[ Some content of the Mod are now affected by the Player's Luck ]
	
	[ Good Luck ]
	
	* Increased Chance for Sammy to sell rare items.
	* Increased Chance to get rare items from Sammy's Wagon.
	* Increased Chance to get good fortune from Fortune Cookies.
	* Increased Chance to get Bottle Cap from Nuka-Colas.
	* Increased Chance to get extra fish from Sea Pudding's Side Effect.
	* Increased Chance to get Oversized Crops from Wickerbottom's Horticulture, Mastered.

	[ Bad Luck ]
	
	* Increased Chance to die by eating Pufferfish.
	* Increased Chance to get kicked when milking animals.
	* Increased Chance to get bad fortune from Fortune Cookies.
	* Increased Chance to get alternate beasts from Ocean Hunts.
	* Increased Chance for enemies to spawn when a Whale Carcass explodes.
	* Increased Chance for falling Coconuts when chopping Palm Trees.
	* Increased Chance for Pirate Ghosts when breaking Ocean Wrecks.
	* Increased Chance for Sugar Bombs? to explode when eaten. -- People aren't supposed to know this is an actual thing...

	[ Good Luck Items ]
	
	* Sturgeon           | +0.25
	* Rainbow Jellyfish  | +0.25
	* Caramel Cube       | +0.15
	* Jawsbreaker        | +0.15
	* Anniversary Hat    | +0.10
	* Rice Sake          | +0.10
	* Bottle Cap         | +0.05
	* Large Chicken Egg  | +0.03
	* Anniversary Cheer  | +0.01
	* Sugar Bombs        | +0.01

	[ Unlucky Items ]
	
	* Chilled Swordfish  | -0.25
	* Deadly Feast       | -0.25
	* Long Pig           | -0.20
	* Shark Nigiri       | -0.15
	* Shark Fin Soup     | -0.15
	* Shark Fin          | -0.10
	* Slaughter Tools    | -0.10
	* Pirate Rum         | -0.10
	* Tartar Sauce       | -0.10
	* Sugar Bombs?       | -0.01

--]]-------------------------------------------------------------------------------------------------------------------------------------------------

local TWOTHIRDS = 2 / 3

local function CommonChanceLuckAdditive(mult)
	return function(inst, chance, luck)
		return luck > 0 and chance + ( luck * mult )
	end
end

local function CommonChanceUnluckMultAndLuckHyperbolic(reciprocal, mult)
	mult = mult or 1
	
	return function(inst, chance, luck)
		return luck < 0 and chance * (1 + math.abs(luck) * mult)
		or luck > 0 and chance * (reciprocal / (reciprocal + luck) + .5) * TWOTHIRDS
	end
end

local function CommonChanceLuckHyperbolic(mult_max, asymptote, subtract)
	subtract = subtract or 0
	
	return function(inst, chance, luck)
		return luck > 0 and chance * (mult_max - asymptote / ( asymptote + (luck - subtract) ))
	end
end

local function CommonChanceUnluckHyperbolicAndLuckMult(reciprocal, mult)
	mult = mult or 1
	
	return function(inst, chance, luck)
		return luck < 0 and chance * (reciprocal / (reciprocal - luck) + .5) * TWOTHIRDS
		or luck > 0 and chance * (1 + math.abs(luck) * mult)
	end
end

local function CommonChanceUnluckHyperbolicAndLuckAdditive(reciprocal, mult)
	mult = mult or 1
	
	return function(inst, chance, luck)
		return luck < 0 and chance * (reciprocal / (reciprocal - luck) + .5) * TWOTHIRDS
		or luck > 0 and chance + ( luck * mult )
	end
end

local function CommonChanceUnluckHyperbolicAndLuckHyperbolic(mult_max, asymptote, subtract, reciprocal)
	subtract = subtract or 0
	
	return function(inst, chance, luck)
		return luck < 0 and chance * (mult_max - asymptote / ( asymptote + (luck - subtract) ))
		or luck > 0 and chance * (reciprocal / (reciprocal + luck) + .5) * TWOTHIRDS
	end
end

local function CommonChanceLuckHyperbolicLower(reciprocal)
	return function(inst, chance, luck)
		return luck > 0 and chance * (reciprocal / (reciprocal + luck) + .5) * TWOTHIRDS
	end
end

HofLuckFormulas =
{
	SammyInventory = CommonChanceLuckHyperbolic(1.5, 1, -2), -- This takes into account every player.
	FoodFortuneGood = CommonChanceUnluckHyperbolicAndLuckMult(1),
	NukaColaBottleCap = CommonChanceLuckAdditive(0.1),
	PufferfishPoison = CommonChanceUnluckMultAndLuckHyperbolic(8, 0.15),
	SkilledFisherman = CommonChanceLuckAdditive(0.2),
	MilkableAnimalKick = CommonChanceUnluckMultAndLuckHyperbolic(10, 0.1),
	OceanHuntAlternateBeast = CommonChanceUnluckMultAndLuckHyperbolic(3, 0.5),
	WhaleCarcassEnemies = CommonChanceUnluckMultAndLuckHyperbolic(4, 0.35),
	HorticultureOversizedCrop = CommonChanceLuckAdditive(0.2),
	DropCoconutFromTree = CommonChanceUnluckMultAndLuckHyperbolic(6, 2),
	OceanWreckPirateGhost = CommonChanceUnluckMultAndLuckHyperbolic(5),
	SugarBombsExplosion = CommonChanceUnluckMultAndLuckHyperbolic(3, 5),
}