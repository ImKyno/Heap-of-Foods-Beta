local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function DustMothPostInit(inst)
	local BLUEPRINT_LOOTS = UpvalueHacker.GetUpvalue(_G.Prefabs.dustmoth.fn, "TryToDropBlueprint", "BLUEPRINT_LOOTS")

	if BLUEPRINT_LOOTS ~= nil then
		table.insert(BLUEPRINT_LOOTS, "kyno_fishingrod_thulecite")
	end
end

AddPrefabPostInit("dustmoth", DustMothPostInit)