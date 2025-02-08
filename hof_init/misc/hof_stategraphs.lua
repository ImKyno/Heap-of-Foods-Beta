-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require
local ACTIONS 		= _G.ACTIONS
local ActionHandler = _G.ActionHandler
local EQUIPSLOTS 	= _G.EQUIPSLOTS
local EventHandler 	= _G.EventHandler
local FRAMES 		= _G.FRAMES
local State 		= _G.State
local TimeEvent 	= _G.TimeEvent
local POPUPS 		= _G.POPUPS

require("hof_upvaluehacker")

-- New Stategraphs.
AddStategraphState("wilson",
	State{
        name = "brewbook_open",
        tags = { "doing" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:OverrideSymbol("book_cook", "kyno_brewbook", "book_brew")
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("reading_in", false)
            inst.AnimState:PushAnimation("reading_loop", true)
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

		onupdate = function(inst)
			if not CanEntitySeeTarget(inst, inst) then
                inst.sg:GoToState("brewbook_close")
			end
		end,

        events =
        {
            EventHandler("ms_closepopup", function(inst, data)
                if data.popup == POPUPS.BREWBOOK then
                    inst.sg:GoToState("brewbook_close")
                end
            end),
        },

        onexit = function(inst)
		    inst:ShowPopUp(POPUPS.BREWBOOK, false)
        end
    }
)

AddStategraphState("wilson",
	State{
        name = "brewbook_close",
        tags = { "idle", "nodangle" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("reading_pst")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
					inst.sg:GoToState(inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and "item_out" or "idle")
                end
            end),
        },
    }
)

AddStategraphState("wilson_client",
	State{
		name = "brewbook_open",
		tags = { "doing" },

		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("action_uniqueitem_pre")
			inst.AnimState:PushAnimation("action_uniqueitem_lag", false)

			inst:PerformPreviewBufferedAction()
			inst.sg:SetTimeout(2)
		end,

		onupdate = function(inst)
			if inst:HasTag("doing") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle")
			end
		end,

		ontimeout = function(inst)
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle")
		end,
	}
)

AddStategraphState("wilson",
	State{
        name = "pickable_tall",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
			
            if timeout ~= nil then
                inst.sg:SetTimeout(timeout)
                inst.sg.statemem.delayed = true
                inst.AnimState:PlayAnimation("build_pre")
                inst.AnimState:PushAnimation("build_loop", true)
            else
                inst.sg:SetTimeout(.5)
                inst.AnimState:PlayAnimation("construct_pre")
                inst.AnimState:PushAnimation("construct_loop", true)
            end
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
                if inst.sg.statemem.delayed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(6 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
			TimeEvent(9 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
        },

        ontimeout = function(inst)
            if not inst.sg.statemem.delayed then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("construct_pst")
            elseif not inst:PerformBufferedAction() then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("build_pst")
            end
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.constructing then
                inst.SoundEmitter:KillSound("make")
            end
        end,
	}
)

AddStategraphState("wilson_client",
	State{
        name = "pickable_tall",
        tags = { "doing", "busy", "nodangle" },

        onenter = function(inst, timeout)
            inst.components.locomotor:Stop()
            inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
			
            if timeout ~= nil then
                inst.sg:SetTimeout(timeout)
                inst.sg.statemem.delayed = true
                inst.AnimState:PlayAnimation("build_pre")
                inst.AnimState:PushAnimation("build_loop", true)
            else
                inst.sg:SetTimeout(.5)
                inst.AnimState:PlayAnimation("construct_pre")
                inst.AnimState:PushAnimation("construct_loop", true)
            end
        end,

        timeline =
        {
            TimeEvent(3 * FRAMES, function(inst)
                if inst.sg.statemem.delayed then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
            TimeEvent(6 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
			TimeEvent(9 * FRAMES, function(inst)
                if not (inst.sg.statemem.delayed or inst:PerformBufferedAction()) then
                    inst.sg:RemoveStateTag("busy")
                end
            end),
        },

        ontimeout = function(inst)
            if not inst.sg.statemem.delayed then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("construct_pst")
            elseif not inst:PerformBufferedAction() then
                inst.SoundEmitter:KillSound("make")
                inst.AnimState:PlayAnimation("build_pst")
            end
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.constructing then
                inst.SoundEmitter:KillSound("make")
            end
        end,
	}
)

-- Change the animations of some things.
AddStategraphPostInit("wilson", function(self)
    local _givehandler = self.actionhandlers[ACTIONS.GIVE].deststate
	local _pickhandler = self.actionhandlers[ACTIONS.PICK].deststate

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
		
		return _pickhandler(inst, action, ...)
	end
end)

-- Brewbook Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.READBREWBOOK, function(inst, action)
	-- return (action.invobject ~= nil and action.invobject.components.brewbook ~= nil and "brewbook_open")
	return "brewbook_open"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.READBREWBOOK, function(inst, action)
	-- return (action.invobject ~= nil and action.invobject:HasTag("brewbook")) and "brewbook_open"
	return "brewbook_open"
end))

-- Brewing Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.BREWER, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.BREWER, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))

-- Milking Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PULLMILK, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PULLMILK, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))

-- Slaughter Tools Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FLAY, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FLAY, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))

-- Store Soul Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.STORESOUL, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.STORESOUL, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))

-- Heal Sugarwood Tree Action Stategraph.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SAPHEAL, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SAPHEAL, function(inst, action)
	return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
end))

-- Quick open Canned Items.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.UNWRAP, function(inst, action)
	local target = action.target or action.invobject
	
	if target.components.unwrappable and target:HasTag("canned_food") then
		return "doshortaction"
	else
		return "dolongaction"
	end
end))

-- Install Cookwares and Tools.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.INSTALLCOOKWARE, function(inst, action)
	local target = action.target or action.invobject
	
	if target:HasTag("cookware_installable") then
		return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
	end
		
	if target:HasTag("cookware_post_installable") then
		return "give"
	end
	
	if target:HasTag("cookware_other_installable") then
		return "give"
	end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.INSTALLCOOKWARE, function(inst, action)
	local target = action.target or action.invobject
	
	if target:HasTag("cookware_installable") then
		return inst:HasTag("fastbuilder") and "domediumaction" or "dolongaction"
	end
		
	if target:HasTag("cookware_post_installable") then
		return "give"
	end
	
	if target:HasTag("cookware_other_installable") then
		return "give"
	end
end))

-- Slice Items.
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.SLICE, function(inst, action)
	local target = action.target or action.invobject
	
	if target:HasTag("sliceable") then
		return "domediumaction"
	end
end))

AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.SLICE, function(inst, action)
	local target = action.target or action.invobject
	
	if target:HasTag("sliceable") then
		return "domediumaction"
	end
end))