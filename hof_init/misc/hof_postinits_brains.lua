-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require
local ACTIONS = _G.ACTIONS

require("hof_upvaluehacker")
require("behaviours/doaction")
require("behaviours/runaway")

-- Hack to lure Rockjaws and Gnarwails to Jawsbreaker food. 
-- Thanks DiogoW for the help.
SharkBrain = require("brains/sharkbrain")

local SHARK_SEE_FOOD_DIST = 15
local SHARK_FINDFOOD_CANT_TAGS = { "INLIMBO", "outofreach" }

local function Shark_IsOnWater(inst)
	return not inst:GetCurrentPlatform() and not _G.TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition())
end

-- Reminder: Sharks don't actually eat foods, they just remove it from the scene.
-- Check hof_stategraphs.lua for how we handle that.
local function Shark_EatJawsbreakerAction(inst)
	local target = FindEntity(inst, SHARK_SEE_FOOD_DIST, function(food)
	return _G.TheWorld.Map:IsOceanAtPoint(inst.Transform:GetWorldPosition())
	end, {"jawsbreaker"}, SHARK_FINDFOOD_CANT_TAGS)

	if target ~= nil then
		inst.foodtarget = target
		local targetpos = Vector3(target.Transform:GetWorldPosition())

		local act = _G.BufferedAction(inst, target, ACTIONS.EAT)
		act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
		return act
	end
end

local function SharkBrainPostInit(self)
	local jawsbreaker = WhileNode(function() return Shark_IsOnWater(self.inst) end, "JawsbreakerBait", 
	DoAction(self.inst, Shark_EatJawsbreakerAction, "EatJawsbreaker", true))
    
	jawsbreaker.parent = self.bt.root.children[1].children[2]
	table.insert(self.bt.root.children[1].children[2].children, 3, jawsbreaker)
end

AddBrainPostInit("sharkbrain", SharkBrainPostInit)
-----------------------------------------------------------------------------------------------------
GnarwailBrain = require("brains/gnarwailbrain")

local GNARWAIL_SEE_FOOD_DIST = 15
local GNARWAIL_FINDFOOD_CANT_TAGS = { "INLIMBO", "outofreach" }

local function Gnarwail_EatJawsbreakerAction(inst)
	if inst.sg:HasStateTag("busy") then
		return
	end

	local target = FindEntity(inst, GNARWAIL_SEE_FOOD_DIST, function(item)
	return inst.components.eater:CanEat(item) and not item:IsOnPassablePoint() 
	end, {"jawsbreaker"}, GNARWAIL_FINDFOOD_CANT_TAGS)
		
	if target ~= nil then
		local act = _G.BufferedAction(inst, target, ACTIONS.EAT)
		act.validfn = function() return target.components.inventoryitem == nil or 
		(target.components.inventoryitem.is_landed and not target.components.inventoryitem:IsHeld()) end
		return act
	end
end

local function GnarwailPostInit(self)
	local jawsbreaker = WhileNode(function() return end, "JawsbreakerBait", 
	DoAction(self.inst, Gnarwail_EatJawsbreakerAction, "EatJawsbreaker", true))
    
	jawsbreaker.parent = self.bt.root
	table.insert(self.bt.root.children, 1, jawsbreaker)
end

AddBrainPostInit("gnarwailbrain", GnarwailPostInit)
-----------------------------------------------------------------------------------------------------
-- Flee from players who have recently used Slaughter Tools.
local slaughterable_brains =
{
	"beefalobrain",
	"deerbrain",
}

local AVOID_BUTCHER_DIST = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_DIST
local AVOID_BUTCHER_STOP = TUNING.KYNO_SLAUGHTERTOOLS_AVOID_STOP

local function SlaughterablePostInit(self)
	local inst = self.inst

	local runaway = RunAway(inst, "recent_butcher", AVOID_BUTCHER_DIST, AVOID_BUTCHER_STOP)
	local conditional = WhileNode(function() return inst:HasTag("butcher_fearable") and not inst:HasTag("domesticated") end, "Fear Butcher", runaway)

	conditional.parent = self.bt.root
	table.insert(self.bt.root.children, 1, conditional)
end

for _, brain in ipairs(slaughterable_brains) do
	AddBrainPostInit(brain, SlaughterablePostInit)
end