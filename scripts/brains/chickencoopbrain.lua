require("behaviours/wander")
require("behaviours/leash")
require("behaviours/runaway")
require("behaviours/doaction")
require("behaviours/panic")

local BrainCommon = require("brains/braincommon")

local SEE_FOOD_DIST   = 15
local MAX_LEASH_DIST  = 10
local MAX_WANDER_DIST = 15
local STOP_RUN_DIST   = 7
local SEE_PLAYER_DIST = 10
local SEE_HOME_DIST   = 10 * 10
local RUN_TIME_OUT    = 7

local ChickenCoopBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function FindFeeder(inst)
	return FindEntity(inst.components.homeseeker and inst.components.homeseeker.home or inst, SEE_FOOD_DIST, function(ent)
		return ent:HasTag("animalfeeder") and ent.components.fueled ~= nil and ent.components.fueled:GetPercent() > 0 
	end)
end

local function FindPickableFood(inst)
	return FindEntity(inst.components.homeseeker and inst.components.homeseeker.home or inst, SEE_FOOD_DIST, function(ent)
		return ent.components.pickable and ent.components.pickable:CanBePicked() and ent:HasTag("pickablechickenfood")
	end)
end

local function FindGroundFood(inst)
	return FindEntity(inst.components.homeseeker and inst.components.homeseeker.home or inst, SEE_FOOD_DIST, function(ent)
		return ent.components.edible and ent.components.edible.foodtype == FOODTYPE.SEEDS or ent:HasTag("chickenfood") 
		and not ent:HasTag("planted") and not (ent.components.inventoryitem and ent.components.inventoryitem:IsHeld())
	end)
end

-- PRIORITY:
-- 1. Food inside inventory. Foods from pickables or given.
-- 2. Animal Trough.
-- 3. Pickables. This means the chicken will pick and store food inside its inventory.
-- 4. Food on ground.
local function FindFoodAction(inst)
	if inst._has_eaten_today then
		return
	end
	
	if inst._has_food_buffered then
		if inst.components.inventory ~= nil and inst.components.eater ~= nil then
			local food = inst.components.inventory:FindItem(function(item)
				return inst.components.eater:CanEat(item)
			end)

			if food ~= nil then
				return BufferedAction(inst, food, ACTIONS.EAT)
			end
		end
	end
	
	local feeder = FindFeeder(inst)
	
	if feeder ~= nil then
		return BufferedAction(inst, feeder, ACTIONS.EATFROM)
	end

	local pickable = FindPickableFood(inst)
	
	if pickable ~= nil then
		return BufferedAction(inst, pickable, ACTIONS.PICK)
	end

	local groundfood = FindGroundFood(inst)
	
	if groundfood ~= nil then
		return BufferedAction(inst, groundfood, ACTIONS.EAT)
	end
end

local RUN_AWAY_PARAMS =
{
	tags = { "_combat", "_health", },
	notags = { "chicken", "playerghost", "notarget", "INLIMBO" },
	
	fn = function(guy)
		return not guy.components.health:IsDead()
		and (guy.components.combat.target ~= nil 
		and guy.components.combat.target:HasTag("chicken"))
	end,
}

local function GoHomeAction(inst)
	if inst.components.homeseeker 
	and inst.components.homeseeker.home 
	and inst.components.homeseeker.home:IsValid()
	and inst.sg:HasStateTag("trapped") == false 
	and inst.components.homeseeker.home.components.burnable
	and not inst.components.homeseeker.home.components.burnable:IsBurning() then
		return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
	end
end

local function IsHomeOnFire(inst)
	return inst.components.homeseeker
	and inst.components.homeseeker.home
	and inst.components.homeseeker.home.components.burnable
	and inst.components.homeseeker.home.components.burnable:IsBurning()
	and inst:GetDistanceSqToInst(inst.components.homeseeker.home) < SEE_HOME_DIST
end

function ChickenCoopBrain:OnStart()
	local root = PriorityNode(
	{
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		WhileNode(function() return self.inst.components.health.takingfiredamage end, "On Fire",
			Panic(self.inst)),
		WhileNode(function() return IsHomeOnFire(self.inst) end, "On Fire",
			Panic(self.inst)),
		
		WhileNode(function() return not TheWorld.state.iscaveday end, "Cave Nightness",
			DoAction(self.inst, GoHomeAction, "GoHome", true)),
		WhileNode(function() return TheWorld.state.iswinter end, "Is Winter",
			DoAction(self.inst, GoHomeAction, "GoHome", true)),
			
		WhileNode(function() return self.inst:HasTag("butcher_fearable") end, "Fear Butcher", 
			RunAway(self.inst, "recent_butcher", SEE_PLAYER_DIST, STOP_RUN_DIST)),
			
		WhileNode(function() return GetTime() - self.inst.components.combat:GetLastAttackedTime() <= RUN_TIME_OUT end, "Attacked",
			RunAway(self.inst, RUN_AWAY_PARAMS, SEE_PLAYER_DIST, STOP_RUN_DIST)),
		
		RunAway(self.inst, RUN_AWAY_PARAMS, SEE_PLAYER_DIST, STOP_RUN_DIST),		
		RunAway(self.inst, "On Fire", SEE_PLAYER_DIST, STOP_RUN_DIST),
		
		DoAction(self.inst, FindFoodAction),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
	}, .25)

	self.bt = BT(self.inst, root)
end

function ChickenCoopBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition())

	self.inst._has_eaten_today = false
	self.inst._has_food_buffered = false
end

return ChickenCoopBrain