------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 					= GLOBAL
local require 				= _G.require
local Vector3    			= _G.Vector3
local ACTIONS    			= _G.ACTIONS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Custom containers.
local containers 			= require("containers")
local params 				= {}

local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab, data, ...)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k]	= v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        containers_widgetsetup_base(container, prefab, data, ...)
    end
end

params.syrup_pot 			=
{
    widget 					=
    {
        slotpos 			=
        {
            Vector3(-1, 64 + 32 + 8 + 4, 0	 ),
            Vector3(-1, 32 + 4, 0			 ),
            Vector3(-1, -(32 + 4), 0		 ),
            Vector3(-1, -(64 + 32 + 8 + 4), 0),
        },
        animbank 			= "quagmire_ui_pot_1x4",
        animbuild 			= "quagmire_ui_pot_1x4",
        pos 				= Vector3(200, 0, 0), -- A bit closer!
        side_align_tip 		= 100,
		--[[
        buttoninfo =
        {
            text = _G.STRINGS.ACTIONS.COOK,
            position = Vector3(0, -165, 0),
        }
		]]--
    },
    acceptsstacks 			= false,
    type 					= "cooker",
}

function params.syrup_pot.itemtestfn(container, item, slot)
    return item:HasTag("gourmet_sap") and not container.inst:HasTag("burnt")
end
--[[
function params.syrup_pot.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        _G.BufferedAction(doer, inst, ACTIONS.COOK):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        _G.SendRPCToServer(_G.RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
    end
end

function params.syrup_pot.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------