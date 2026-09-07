local _G                  = GLOBAL
local require             = _G.require
local UpvalueHacker       = require("tools/hof_upvaluehacker")
local GetCreatureScanData = require("wx78_moduledefs").GetCreatureScanDataDefinition

local function WX78ScannerItemPostInit(inst)
	local SCAN_CAN = UpvalueHacker.GetUpvalue(_G.Prefabs.wx78_scanner_item.fn, "proximityscan", "SCAN_CAN")
	table.insert(SCAN_CAN, "critter")
end

-- Little easter egg when WX-78 tries to scan Willow for Combustion Circuit.
-- They learned this technique from the one and only master HIDEO KOJIMA!!!
local function WX78ScannerPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	local _OnTargetFound = UpvalueHacker.GetUpvalue(_G.Prefabs.wx78_scanner.fn, "TryFindTarget", "OnTargetFound")

	if _OnTargetFound ~= nil then
		local function OnTargetFound(scanner, target, ...)
			if target ~= nil and target:IsValid() and target.prefab == "willow" then
				local wx = scanner:OwnerFn()
				local scandata, scan_id = GetCreatureScanData(target)

				-- This is actually a cool thing to use in a future mod.
				-- Like, WX-78 says something for each creature scanned...
				target:PushEvent("wx78_scanner_start",
				{
					scanner  = scanner,
					wx       = wx,
					scan_id  = scan_id,
					scandata = scandata,
				})

				if wx ~= nil then
					wx:PushEvent("wx78_scanned_character", { target = target })
				end
			end

			return _OnTargetFound(scanner, target, ...)
		end

		UpvalueHacker.SetUpvalue(_G.Prefabs.wx78_scanner.fn, OnTargetFound, "TryFindTarget", "OnTargetFound")
	end
end

AddPrefabPostInit("wx78_scanner_item", WX78ScannerItemPostInit)
AddPrefabPostInit("wx78_scanner", WX78ScannerPostInit)