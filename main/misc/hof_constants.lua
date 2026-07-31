local _G = GLOBAL

-- Moved from scripts/hof_constants.lua to here.
-- Foodtypes need to be created before our recipes are added.
_G.FOODTYPE.PREPAREDPOOP = "PREPAREDPOOP"
_G.FOODTYPE.PREPAREDSOUL = "PREPAREDSOUL"
_G.FOODTYPE.FOODUPGRADE  = "FOODUPGRADE"

-- Mosslings, Moose Goose and Bearger can now eat GOODIES.
table.insert(_G.FOODGROUP.MOOSE.types,   _G.FOODTYPE.GOODIES)
table.insert(_G.FOODGROUP.BEARGER.types, _G.FOODTYPE.GOODIES)