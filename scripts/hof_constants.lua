require("constants")

local HOF_FOODTYPES      = {}
local HOF_NAUGHTY_VALUE  = {}
local HOF_PICKABLE_FOODS = {}

-- New FOODTYPE just for showing the correct string on Cookbook.
NEW_FOODTYPES    = 
{
	PREPAREDSOUL = "PREPAREDSOUL",
	PREPAREDPOOP = "PREPAREDPOOP",
	ALCOHOLIC    = "ALCOHOLIC",
}

-- New NAUGHTINESS values for innocent creatures.
NEW_NAUGHTY_VALUE                    =
{
	-- Mod creatures.
	["kyno_chicken2"]                = 1,
	["kyno_piko"]                    = 1,
	["kyno_piko_orange"]             = 2,
	["kingfisher"]                   = 2,
	["toucan"]                       = 1,
	["quagmire_pigeon"]              = 1,
	["kyno_sugarfly"]                = 1,
	["kyno_pebblecrab"]              = 2,
	["kyno_meadowisland_mermfisher"] = 3,
	["kyno_meadowisland_trader"]     = 50, -- Wait, how did you kill Sammy?
}

-- New PICKABLE for Woby foraging.
HOF_PICKABLE_FOODS =
{
	kyno_aloe_ground        = true,
	kyno_radish_ground      = true,
	kyno_sweetpotato_ground = true,
	kyno_turnip_ground      = true,
	kyno_aspargos_ground    = true,
	kyno_mushstump_natural  = true,
	kyno_pineapplebush      = true,
	kyno_fennel_ground      = true,
	kyno_parznip_ground     = true,
}

for k, v in pairs(HOF_FOODTYPES) do
	FOODTYPE[k] = v
end

for k, v in pairs(HOF_NAUGHTY_VALUE) do
	NAUGHTY_VALUE[k] = v
end
	
for k, v in pairs(HOF_PICKABLE_FOODS) do
	PICKABLE_FOOD_PRODUCTS[k] = v
end

--[[
-- "New Category" for showing button on Scrapbook.
local HOF_SCRAPBOOK_CATS = {}
HOF_SCRAPBOOK_CATS =
{
	"artisangood",
}

for k, v in pairs(HOF_SCRAPBOOK_CATS) do
	SCRAPBOOK_CATS[k] = v
end
]]--