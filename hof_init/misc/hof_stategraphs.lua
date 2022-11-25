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