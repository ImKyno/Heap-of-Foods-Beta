local _G      = GLOBAL
local require = _G.require
local ACTIONS = _G.ACTIONS

require("behaviours/doaction")

-- Hack to lure Rockjaws and Gnarwails to Jawsbreaker food.
-- Thanks DiogoW for the help.
local SharkBrain = require("brains/sharkbrain")
local SHARK_SEE_FOOD_DIST = 15
local SHARK_FINDFOOD_CANT_TAGS = { "INLIMBO", "outofreach" }

local function Shark_IsOnWater(inst)
	return not inst:GetCurrentPlatform() and not _G.TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition())
end

-- Reminder: Sharks don't actually eat foods, they just remove it from the scene.
-- Check main/hof_stategraphs.lua for how we handle that.
local function Shark_EatJawsbreakerAction(inst)
	local target = FindEntity(inst, SHARK_SEE_FOOD_DIST, function(food)
		return _G.TheWorld.Map:IsOceanAtPoint(inst.Transform:GetWorldPosition())
	end, {"jawsbreaker"}, SHARK_FINDFOOD_CANT_TAGS)

	if target ~= nil then
		inst.foodtarget = target
		local targetpos = Vector3(target.Transform:GetWorldPosition())

		local act = _G.BufferedAction(inst, target, ACTIONS.EAT)

		act.validfn = function()
			return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld())
		end

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