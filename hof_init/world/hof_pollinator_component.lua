-- Common Dependencies.
local _G          = GLOBAL
local require     = _G.require
local SpawnPrefab = _G.SpawnPrefab
local Pollinator  = require("components/pollinator")

require("hof_util")

-- Pollinators will also target Sugar Flowers as well.	
local OldCanPollinate = Pollinator.CanPollinate
function Pollinator:CanPollinate(flower, ...)
	local FLOWER_TAGS = {"flower", "sugarflower"}

	if self.inst:HasTag("sugarflowerpollinator") then
		return flower ~= nil and flower:HasOneOfTags(FLOWER_TAGS) and not table.contains(self.flowers, flower)
	else
		return OldCanPollinate(self, flower, ...)
	end
end