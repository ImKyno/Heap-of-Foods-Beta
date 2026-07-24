local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function WX78ScannerPostInit(inst)
	local SCAN_CAN = UpvalueHacker.GetUpvalue(_G.Prefabs.wx78_scanner_item.fn, "proximityscan", "SCAN_CAN")
	table.insert(SCAN_CAN, "critter")
end

AddPrefabPostInit("wx78_scanner_item", WX78ScannerPostInit)