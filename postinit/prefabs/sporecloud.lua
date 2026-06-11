local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Immunity to Sporeclouds.
local function SporecloudPostInit(inst)
	local AURA_EXCLUDE_TAGS = UpvalueHacker.GetUpvalue(_G.Prefabs.sporecloud.fn, "AURA_EXCLUDE_TAGS")
	table.insert(AURA_EXCLUDE_TAGS, "sporecloudimmune")
end

AddPrefabPostInit("sporecloud", SporecloudPostInit)