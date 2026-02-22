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
	FortuneCookie = CommonChanceLuckHyperbolic(3, 6, 3),
	PufferfishPoison = CommonChanceUnluckMultAndLuckHyperbolic(8, 0.15),
	SkilledFisherman = CommonChanceLuckAdditive(0.2),
	MilkableAnimalKick = CommonChanceUnluckMultAndLuckHyperbolic(10, 0.1),
	OversizedCropSpawn = CommonChanceLuckAdditive(0.1),
}