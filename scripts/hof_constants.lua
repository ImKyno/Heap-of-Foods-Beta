-- "New Foodtype" just for showing the correct string on Cookbook.
require("constants")

local NEW_CONSTANTS = {}

NEW_CONSTANTS 		= 
{
	PREPAREDSOUL 	= "PREPAREDSOUL",
	PREPAREDPOOP 	= "PREPAREDPOOP",
	ALCOHOLIC		= "ALCOHOLIC",
}
	
for k, v in pairs(NEW_CONSTANTS) do
	FOODTYPE[k] 	= v
end
