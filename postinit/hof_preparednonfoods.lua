local _G               = GLOBAL
local require          = _G.require
local VanillaNonFood   = require("preparednonfoods")
local PIG_COIN_ECONOMY = require("hof_pigcoineconomy")

-- Pig King Coin Economy System.
local PIG_COIN_VALUES =
{
	batnosehat   = {5, 2, 0},
	dustmeringue = {0, 0, 0},
}

for prefab, value in pairs(PIG_COIN_VALUES) do
	if VanillaNonFood[prefab] ~= nil then
		VanillaNonFood[prefab].pigcoinvalue = value
	end
end

PIG_COIN_ECONOMY.RegisterRecipes(VanillaNonFood)