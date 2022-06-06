------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require
local ACTIONS 		= _G.ACTIONS
local EQUIPSLOTS 	= _G.EQUIPSLOTS
local EventHandler 	= _G.EventHandler
local FRAMES 		= _G.FRAMES
local State 		= _G.State
local TimeEvent 	= _G.TimeEvent
local POPUPS 		= _G.POPUPS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- New Stategraphs.
AddStategraphState("wilson",
	State{
        name = "brewbook_open",
        tags = { "doing" },

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:OverrideSymbol("book_brew", "kyno_brewbook", "book_brew")
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------