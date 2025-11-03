require("behaviours/wander")
require("behaviours/panic")
require("behaviours/chaseandattack")

local BrainCommon = require("brains/braincommon")

local CHASE_TIME = 20
local CHASE_DIST = 10
local WANDER_DIST = 40

local PufferMonsterBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local wandertimes =
{
	minwalktime = 2,
	minwaittime = 0.1,
	
	randwalktime = 2,
	randwaittime = 0.1,
}

function PufferMonsterBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, WANDER_DIST, wandertimes)
	}, .25)
	self.bt = BT(self.inst, root)
end

function PufferMonsterBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return PufferMonsterBrain