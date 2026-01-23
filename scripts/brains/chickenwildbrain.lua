require("behaviours/wander")
require("behaviours/leash")
require("behaviours/runaway")
require("behaviours/doaction")
require("behaviours/panic")

local BrainCommon = require("brains/braincommon")

local SEE_BAIT_DIST   = 15
local MAX_LEASH_DIST  = 10
local MAX_WANDER_DIST = 15
local STOP_RUN_DIST   = 7
local SEE_PLAYER_DIST = 10
local RUN_TIME_OUT    = 7

local ChickenWildBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local FINDFOOD_CANT_TAGS = { "outofreach" }

local function FindFoodAction(inst)
	if inst.sg:HasStateTag("busy") then
		return
	end

	if inst.components.inventory ~= nil and inst.components.eater ~= nil then
		local target = inst.components.inventory:FindItem(function(item)
			return inst.components.eater:CanEat(item)
		end)
		
		if target ~= nil then
			return BufferedAction(inst, target, ACTIONS.EAT)
		end
	end

	local time_since_eat = inst.components.eater:TimeSinceLastEating()
	
	if time_since_eat ~= nil and time_since_eat <= TUNING.KYNO_CHICKEN_EAT_COOLDOWN * 2 then
		return
	end

	local noveggie = time_since_eat ~= nil and time_since_eat < TUNING.KYNO_CHICKEN_EAT_COOLDOWN * 4

	local target = FindEntity(inst, SEE_BAIT_DIST, function(item)
		return item:GetTimeAlive() >= 3
		and item.components.edible ~= nil
		and (not noveggie or item:HasTag("chickenfood"))
		and item:IsOnPassablePoint()
		and inst.components.eater:CanEat(item)
		end, nil, FINDFOOD_CANT_TAGS)
		
	if target ~= nil then
		return BufferedAction(inst, target, ACTIONS.EAT)
	end
end

local RUN_AWAY_PARAMS =
{
	tags = { "_combat", "_health" },
	notags = { "chicken", "playerghost", "notarget", "INLIMBO" },
	
	fn = function(guy)
		return not guy.components.health:IsDead()
		and (guy.components.combat.target ~= nil 
		and guy.components.combat.target:HasTag("chicken"))
	end,
}

local function GoHomeAction(inst)
	if inst.components.homeseeker and
		inst.components.homeseeker.home and
		inst.components.homeseeker.home:IsValid() and
		inst.sg:HasStateTag("trapped") == false then
		return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
	end
end

function ChickenWildBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		-- WhileNode(function() return self.inst.components.health:GetPercent() < .50 end, "LowHealth",
			-- RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST)),	
		
		-- WhileNode(function() return not TheWorld.state.iscaveday end, "CaveNightness",
			-- DoAction(self.inst, GoHomeAction, "GoHome", true)),
			
		WhileNode(function() return GetTime() - self.inst.components.combat:GetLastAttackedTime() <= RUN_TIME_OUT end, "Attacked",
			RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST)),
			
		RunAway(self.inst, RUN_AWAY_PARAMS, SEE_PLAYER_DIST, STOP_RUN_DIST),
		RunAway(self.inst, "OnFire", SEE_PLAYER_DIST, STOP_RUN_DIST),
		
		EventNode(self.inst, "GoHome",
			DoAction(self.inst, GoHomeAction, "GoHome", true)),
		
		DoAction(self.inst, FindFoodAction),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
	}, .25)

	self.bt = BT(self.inst, root)
end

function ChickenWildBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition())
end

return ChickenWildBrain