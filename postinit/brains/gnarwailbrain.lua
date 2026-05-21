local _G      = GLOBAL
local require = _G.require
local ACTIONS = _G.ACTIONS

require("behaviours/doaction")

local GnarwailBrain = require("brains/gnarwailbrain")
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
		act.validfn = function()
			return target.components.inventoryitem == nil or
			(target.components.inventoryitem.is_landed and not target.components.inventoryitem:IsHeld())
		end

		return act
	end
end

local function GnarwailBrainPostInit(self)
	local jawsbreaker = WhileNode(function() return end, "JawsbreakerBait",
	DoAction(self.inst, Gnarwail_EatJawsbreakerAction, "EatJawsbreaker", true))

	jawsbreaker.parent = self.bt.root
	table.insert(self.bt.root.children, 1, jawsbreaker)
end

AddBrainPostInit("gnarwailbrain", GnarwailBrainPostInit)