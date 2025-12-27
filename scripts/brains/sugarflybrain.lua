require("behaviours/runaway")
require("behaviours/wander")
require("behaviours/doaction")
require("behaviours/findflower")
require("behaviours/panic")

local BrainCommon = require("brains/braincommon")

local RUN_AWAY_DIST              = 5
local STOP_RUN_AWAY_DIST         = 10
local POLLINATE_SUGARFLOWER_DIST = 10
local SEE_SUGARFLOWER_DIST       = 30
local MAX_WANDER_DIST            = 20
local SUGARFLOWER_TAGS           = { "sugarflower" }

local function NearestFlowerPos(inst)
	local flower = GetClosestInstWithTag(SUGARFLOWER_TAGS, inst, SEE_SUGARFLOWER_DIST)
	
	if flower and flower:IsValid() then
		return Vector3(flower.Transform:GetWorldPosition())
	end
end

local function GoHomeAction(inst)
	local flower = GetClosestInstWithTag(SUGARFLOWER_TAGS, inst, SEE_SUGARFLOWER_DIST)
	
	if flower and flower:IsValid() then
		return BufferedAction(inst, flower, ACTIONS.GOHOME, nil, Vector3(flower.Transform:GetWorldPosition()))
	end
end

local RUN_AWAY_PARAMS =
{
	tags = { "scarytoprey" },
	fn = function(guy)
		return not (guy.components.skilltreeupdater
		and guy.components.skilltreeupdater:IsActivated("wormwood_bugs"))
	end,
}

local SugarflyBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function SugarflyBrain:OnStart()
	local root =
		PriorityNode(
		{
			BrainCommon.PanicTrigger(self.inst),
			BrainCommon.ElectricFencePanicTrigger(self.inst),
			
			RunAway(self.inst, RUN_AWAY_PARAMS, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
			
			IfNode(function() return not TheWorld.state.isday end, "IsNight",
				DoAction(self.inst, GoHomeAction, "GoHome", true)),
			IfNode(function() return self.inst.components.pollinator:HasCollectedEnough() end, "IsFullOfPollen",
				DoAction(self.inst, GoHomeAction, "GoHome", true)),
				
			FindFlower(self.inst),
			Wander(self.inst, NearestFlowerPos, MAX_WANDER_DIST)
		},1)

	self.bt = BT(self.inst, root)
end

return SugarflyBrain