local _G      = GLOBAL
local ACTIONS = _G.ACTIONS

require("stategraphs/commonstates")

-- Change the animations of some things.
AddStategraphPostInit("wilson", function(self)
	local _givehandler       = self.actionhandlers[ACTIONS.GIVE].deststate
	local _pickhandler       = self.actionhandlers[ACTIONS.PICK].deststate
	local _harvesthandler    = self.actionhandlers[ACTIONS.HARVEST].deststate
	local _buildhandler      = self.actionhandlers[ACTIONS.BUILD].deststate
	local _dismantlehandler  = self.actionhandlers[ACTIONS.DISMANTLE].deststate
	local _takeitemhandler   = self.actionhandlers[ACTIONS.TAKEITEM].deststate
	local _takesinglehandler = self.actionhandlers[ACTIONS.TAKESINGLEITEM].deststate
	local _eathandler        = self.actionhandlers[ACTIONS.EAT].deststate

	-- More sofisticated animation for repairing things.
	self.actionhandlers[ACTIONS.GIVE].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if target and target:HasTags({"trader", "serenity_installable"}) then
			return "domediumaction"
		end

		return _givehandler(inst, action, ...)
	end

	-- Currently for Pineapple Bushes and Palm Trees.
	self.actionhandlers[ACTIONS.PICK].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if target and target:HasTags({"plant", "pickable_tall"}) and inst.components.rider ~= nil and not inst.components.rider:IsRiding() then
			return "pickable_tall" -- "construct"
		end

		-- Haste Buff.
		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _pickhandler(inst, action, ...)
	end

	self.actionhandlers[ACTIONS.HARVEST].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _harvesthandler(inst, action, ...)
	end

	self.actionhandlers[ACTIONS.BUILD].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "domediumaction" -- doshortaction is too fast, ruins the mood.
		end

		return _buildhandler(inst, action, ...)
	end

	self.actionhandlers[ACTIONS.DISMANTLE].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _dismantlehandler(inst, action, ...)
	end

	self.actionhandlers[ACTIONS.TAKEITEM].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _takeitemhandler(inst, action, ...)
	end

	self.actionhandlers[ACTIONS.TAKESINGLEITEM].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _takesinglehandler(inst, action, ...)
	end

	-- Makes eating faster with any food.
	self.actionhandlers[ACTIONS.EAT].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasteater") then
			return "quickeat"
		end

		return _eathandler(inst, action, ...)
	end
end)