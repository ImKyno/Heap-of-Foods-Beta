-- Modified "findflower" behaviour for pollinators.
require("brains/braincommon")
require("behaviours/findflower")

local SEE_DIST                  = 30
local FLOWER_TAGS               = {"flower", "sugarflower"}
local FLOWER_NOT_TAGS           = {"_combat"}
local FINDFLOWER_MUST_TAGS      = {"pollinator", "sugarflowerpollinator"}

local OldPickFlower = FindFlower.PickTarget
function FindFlower:PickTarget(...)
	if self.inst:HasTag("sugarflowerpollinator") then
		-- FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags)
		local closestFlower = FindEntity(self.inst, SEE_DIST, nil, nil, FLOWER_NOT_TAGS, FLOWER_TAGS)
		
		if closestFlower ~= nil
			and self.inst.components.pollinator and self.inst.components.pollinator:CanPollinate(closestFlower) and not FindEntity(closestFlower, 2, function(guy) 
			return guy.components.pollinator and guy.components.pollinator.target == closestFlower end, nil, nil, FINDFLOWER_MUST_TAGS) then
			self.inst.components.pollinator.target = closestFlower
		else
			OldPickFlower(self, ...)
		end
	end
end