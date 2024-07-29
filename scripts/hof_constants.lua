require("constants")

local NEW_CONSTANTS      = {}
local NEW_SCRAPBOOK_CATS = {}

-- "New Foodtype" just for showing the correct string on Cookbook.
NEW_CONSTANTS 		     = 
{
	PREPAREDSOUL 	     = "PREPAREDSOUL",
	PREPAREDPOOP 	     = "PREPAREDPOOP",
	ALCOHOLIC		     = "ALCOHOLIC",
}

-- "New Category" for showing button on Scrapbook.
NEW_SCRAPBOOK_CATS       =
{
	"artisangood",
}
	
for k, v in pairs(NEW_CONSTANTS) do
	FOODTYPE[k] 	     = v
end

--[[
for k, v in pairs(NEW_SCRAPBOOK_CATS) do
	SCRAPBOOK_CATS[k]    = v
end
]]--