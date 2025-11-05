require("behaviours/wander")
require("behaviours/panic")

local BrainCommon     = require("brains/braincommon")
local MAX_WANDER_DIST = 40
local SEE_BAIT_DIST   = 10

local JellyfishRainbowOceanBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

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

function JellyfishRainbowOceanBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		-- DoAction(self.inst, EatFoodAction),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
	}, 1)
	
	self.bt = BT(self.inst, root)
end

function JellyfishRainbowOceanBrain:OnInitializationComplete()
	-- self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return JellyfishRainbowOceanBrain