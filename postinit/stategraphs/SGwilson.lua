local _G      = GLOBAL
local ACTIONS = _G.ACTIONS

require("stategraphs/commonstates")

-- Change the animations of some things.
AddStategraphPostInit("wilson", function(sg)
	local _givehandler       = sg.actionhandlers[ACTIONS.GIVE].deststate
	local _pickhandler       = sg.actionhandlers[ACTIONS.PICK].deststate
	local _harvesthandler    = sg.actionhandlers[ACTIONS.HARVEST].deststate
	local _buildhandler      = sg.actionhandlers[ACTIONS.BUILD].deststate
	local _dismantlehandler  = sg.actionhandlers[ACTIONS.DISMANTLE].deststate
	local _takeitemhandler   = sg.actionhandlers[ACTIONS.TAKEITEM].deststate
	local _takesinglehandler = sg.actionhandlers[ACTIONS.TAKESINGLEITEM].deststate
	local _eathandler        = sg.actionhandlers[ACTIONS.EAT].deststate

	-- More sofisticated animation for repairing things.
	sg.actionhandlers[ACTIONS.GIVE].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if target and target:HasTags({"trader", "serenity_installable"}) then
			return "domediumaction"
		end

		return _givehandler(inst, action, ...)
	end

	-- Currently for Pineapple Bushes and Palm Trees.
	sg.actionhandlers[ACTIONS.PICK].deststate = function(inst, action, ...)
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

	sg.actionhandlers[ACTIONS.HARVEST].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _harvesthandler(inst, action, ...)
	end

	sg.actionhandlers[ACTIONS.BUILD].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "domediumaction" -- doshortaction is too fast, ruins the mood.
		end

		return _buildhandler(inst, action, ...)
	end

	sg.actionhandlers[ACTIONS.DISMANTLE].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _dismantlehandler(inst, action, ...)
	end

	sg.actionhandlers[ACTIONS.TAKEITEM].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _takeitemhandler(inst, action, ...)
	end

	sg.actionhandlers[ACTIONS.TAKESINGLEITEM].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasthands") then
			return "doshortaction"
		end

		return _takesinglehandler(inst, action, ...)
	end

	-- Makes eating faster with any food.
	sg.actionhandlers[ACTIONS.EAT].deststate = function(inst, action, ...)
		local target = action.target or action.invobject

		if inst:HasTag("fasteater") then
			return "quickeat"
		end

		return _eathandler(inst, action, ...)
	end

	-- Recoil when chopping Cave Tuber Trees.
	local _chop1 = sg.states["chop"].timeline[1].fn
	sg.states["chop"].timeline[1].fn = function(inst, ...)
		local invobj = inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil
		local target = inst.sg.statemem.action ~= nil and inst.sg.statemem.action:IsValid()
		and inst.sg.statemem.action.target ~= nil and inst.sg.statemem.action.target:HasTag("cavetubertree")

		if target ~= nil and invobj ~= nil and invobj.components.tool ~= nil
		and not invobj.components.tool:CanDoToughWork() then
			inst.sg.statemem.recoilstate = "attack_recoil"
			inst:PerformBufferedAction()
		else
			_chop1(inst, ...)
		end
	end
end)