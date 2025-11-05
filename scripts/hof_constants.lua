require("constants")
require("componentutil")

local HOF_FOODTYPES      = {}
local HOF_FUELTYPES      = {}
local HOF_NAUGHTY_VALUE  = {}
local HOF_PICKABLE_FOODS = {}
local HOF_PICKUP_SOUNDS  = {}

-- New FOODTYPE just for showing the correct string on Cookbook.
HOF_FOODTYPES    = 
{
	PREPAREDSOUL = "PREPAREDSOUL",
	PREPAREDPOOP = "PREPAREDPOOP",
	ALCOHOLIC    = "ALCOHOLIC",
}

-- New FUELTYPE for Fish Hatchery.
HOF_FUELTYPES =
{
	FISHFOOD  = "FISHFOOD",
}

-- New NAUGHTINESS values for innocent creatures.
HOF_NAUGHTY_VALUE                    =
{
	-- Mod creatures.
	["toucan"]                       = 1,
	["quagmire_pigeon"]              = 1,
	["kyno_sugarfly"]                = 1,
	["kyno_chicken2"]                = 1,
	["kyno_jellyfish_ocean"]         = 1,
	["kyno_jellyfish"]               = 1,
	["kyno_piko"]                    = 1,
	["kingfisher"]                   = 2,
	["kyno_dogfish"]                 = 2,
	["kyno_piko_orange"]             = 2,
	["kyno_jellyfish_rainbow_ocean"] = 2,
	["kyno_jellyfish_rainbow"]       = 2,
	["kyno_pebblecrab"]              = 2,
	["kyno_meadowisland_mermfisher"] = 3,
	["kyno_swordfish"]               = 4,
	["kyno_whale_white_ocean"]       = 6,
	["kyno_whale_blue_ocean"]        = 7,
	["kyno_meadowisland_seller"]     = 50, -- Wait, how did you kill Sammy?
}

-- New PICKABLE for Woby foraging.
HOF_PICKABLE_FOODS      =
{
	kyno_white_cap      = true,
	kyno_pineapple      = true,
	kyno_limpets        = true,
	kyno_spotspice_leaf = true,
	kyno_coffeebeans    = true,
	kyno_wheat          = true,
	kyno_kokonut        = true,
	kyno_banana         = true,
	kyno_truffles       = true,
}

HOF_PICKUP_SOUNDS =
{
	["item_gold"] = "dontstarve/wilson/equip_item_gold",
}

for k, v in pairs(HOF_FOODTYPES) do
	FOODTYPE[k] = v
end

for k, v in pairs(HOF_FUELTYPES) do
	FUELTYPE[k] = v
end

for k, v in pairs(HOF_NAUGHTY_VALUE) do
	NAUGHTY_VALUE[k] = v
end
	
for k, v in pairs(HOF_PICKABLE_FOODS) do
	PICKABLE_FOOD_PRODUCTS[k] = v
end

for k, v in pairs(HOF_PICKUP_SOUNDS) do
	PICKUPSOUNDS[k] = v
end