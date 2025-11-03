require("behaviours/wander")
require("behaviours/runaway")
require("behaviours/panic")
require("behaviours/doaction")

local BrainCommon = require("brains/braincommon")

local AVOID_PLAYER_DIST = TUNING.KYNO_DOGFISH_AVOID_DIST
local AVOID_PLAYER_STOP = TUNING.KYNO_DOGFISH_AVOID_DIST_STOP
local MAX_IDLE_WANDER_DIST = TUNING.KYNO_DOGFISH_WANDER_DIST
local SCARY_TAGS = { "scarytoprey", "scarytooceanprey" }

local DogfishOceanBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local wandertimes =
{
	minwalktime = 2,
	minwaittime = 0.1,
	
	randwalktime = 2,
	randwaittime = 0.1,
}

function DogfishOceanBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_IDLE_WANDER_DIST, wandertimes),
	}, .25)

	self.bt = BT(self.inst, root)
end

function DogfishOceanBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return DogfishOceanBrain