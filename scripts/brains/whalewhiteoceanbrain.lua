require("behaviours/wander")
require("behaviours/panic")
require("behaviours/chaseandattack")

local BrainCommon = require("brains/braincommon")

local LEASH_RETURN_DIST = 5
local LEASH_MAX_DIST = 10
local CHASE_TIME = TUNING.KYNO_WHALE_WHITE_FOLLOW_TIME
local CHASE_DIST = TUNING.KYNO_WHALE_WHITE_TARGET_DIST

local wander_times =
{
	minwalktime = 4,
	minwaittime = 4,
	
	randwalktime = 4,
	randwaittime = 3,
}

local WhaleWhiteOceanBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function WhaleWhiteOceanBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		SequenceNode{
			ParallelNodeAny{
				WaitNode(15 + math.random() * 2),
				Leash(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, LEASH_MAX_DIST, LEASH_RETURN_DIST),
			},
		},
		
		ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),
		Wander(self.inst, nil, nil, wander_times)
	}, .25)

	self.bt = BT(self.inst, root)
end

function WhaleWhiteOceanBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return WhaleWhiteOceanBrain