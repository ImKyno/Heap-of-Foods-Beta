require("constants")
require("componentutil")

local HOF_FOODTYPES      = {}
local HOF_NAUGHTY_VALUE  = {}
local HOF_PICKABLE_FOODS = {}

-- New FOODTYPE just for showing the correct string on Cookbook.
HOF_FOODTYPES    = 
{
	PREPAREDSOUL = "PREPAREDSOUL",
	PREPAREDPOOP = "PREPAREDPOOP",
	ALCOHOLIC    = "ALCOHOLIC",
}

-- New NAUGHTINESS values for innocent creatures.
HOF_NAUGHTY_VALUE                    =
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
HOF_PICKABLE_FOODS          =
{
	kyno_white_cap      = true,
	kyno_pineapple      = true,
	kyno_limpets        = true,
	kyno_spotspice_leaf = true,
	kyno_coffeebeans    = true,
	kyno_wheat          = true,
	kyno_kokonut        = true,
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