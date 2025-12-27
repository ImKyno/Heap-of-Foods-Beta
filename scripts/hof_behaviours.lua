-- Modified "findflower" behaviour for pollinators.
require("brains/braincommon")
require("behaviours/findflower")

local SEE_DIST                  = 30

local FLOWER_TAGS               = { "flower", "sugarflower" }
local FLOWER_NOT_TAGS           = { "_combat" }
local FINDFLOWER_MUST_TAGS      = { "pollinator", "sugarflowerpollinator" }

local SUGARFLOWER_TAGS          = { "sugarflower" }
local SUGARFLOWER_CANT_TAGS     = { "_combat", "flower" }
local FINDSUGARFLOWER_MUST_TAGS = { "sugarflowerpollinatoronly" }

local _PickFlower = FindFlower.PickTarget
function FindFlower:PickTarget(...)
	if self.inst:HasTag("sugarflowerpollinator") then -- Can pollinate both Flowers.
		local closestFlower = FindEntity(self.inst, SEE_DIST, nil, nil, FLOWER_NOT_TAGS, FLOWER_TAGS) -- FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags)
		
		if closestFlower ~= nil
		and self.inst.components.pollinator and self.inst.components.pollinator:CanPollinate(closestFlower) and not FindEntity(closestFlower, 2, function(guy)
			return guy.components.pollinator and guy.components.pollinator.target == closestFlower end, nil, nil, FINDFLOWER_MUST_TAGS) then
			self.inst.components.pollinator.target = closestFlower
		end
	elseif self.inst:HasTag("sugarflowerpollinatoronly") then -- Can only pollinate Sugar Flowers.
		local closestFlower = FindEntity(self.inst, SEE_DIST, nil, SUGARFLOWER_TAGS, SUGARFLOWER_CANT_TAGS)
		
		if closestFlower ~= nil
		and self.inst.components.pollinator and self.inst.components.pollinator:CanPollinate(closestFlower) and not FindEntity(closestFlower, 2, function(guy)
			return guy.components.pollinator and guy.components.pollinator.target == closestFlower end, nil, nil, FINDSUGARFLOWER_MUST_TAGS) then
			self.inst.components.pollinator.target = closestFlower
		end
	else
		_PickFlower(self, ...)
	end
end