require("behaviours/wander")
require("behaviours/panic")
require("behaviours/chaseandattack")

local BrainCommon = require("brains/braincommon")

local SEE_BAIT_DIST = 10
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

local function EatFoodAction(inst)
	local target = FindEntity(inst, SEE_BAIT_DIST, function(item) return inst.components.eater:CanEat(item) 
	and item.components.bait and not item:HasTag("planted") 
	and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end)
	
	if target then
		local act = BufferedAction(inst, target, ACTIONS.EAT)
		act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
		return act
	end
end

function PufferMonsterBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		DoAction(self.inst, EatFoodAction),
		ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, WANDER_DIST)
	}, .25)
	self.bt = BT(self.inst, root)
end

function PufferMonsterBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return PufferMonsterBrain