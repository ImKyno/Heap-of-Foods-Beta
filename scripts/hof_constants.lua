require("constants")

local NEW_CONSTANTS                  = {}
local NEW_SCRAPBOOK_CATS             = {}
local NEW_NAUGHTY_VALUE              = {}

-- New FOODTYPE just for showing the correct string on Cookbook.
NEW_CONSTANTS                        = 
{
	PREPAREDSOUL                     = "PREPAREDSOUL",
	PREPAREDPOOP                     = "PREPAREDPOOP",
	ALCOHOLIC                        = "ALCOHOLIC",
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

for k, v in pairs(NEW_NAUGHTY_VALUE) do
	NAUGHTY_VALUE[k]                 = v
end
	
for k, v in pairs(NEW_CONSTANTS) do
	FOODTYPE[k]                      = v
end

--[[
-- "New Category" for showing button on Scrapbook.
NEW_SCRAPBOOK_CATS       =
{
	"artisangood",
}

for k, v in pairs(NEW_SCRAPBOOK_CATS) do
	SCRAPBOOK_CATS[k]    = v
end
]]--