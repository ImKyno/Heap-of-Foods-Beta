local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Anything with "fireproof" tag will be ignored by Ice Flingomatic.
local FireDetector = require("components/firedetector")

local FIRESUPRESSOR_IGNORE_TAGS = {"fireproof"}
local NOTAGS_FIRESUPPRESSOR = UpvalueHacker.GetUpvalue(FireDetector.ActivateEmergencyMode, "OnDetectEmergencyTargets", "NOTAGS")

for k, v in pairs(FIRESUPRESSOR_IGNORE_TAGS) do
	table.insert(NOTAGS_FIRESUPPRESSOR, v)
end