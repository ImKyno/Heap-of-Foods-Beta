------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 					= GLOBAL
local require 				= _G.require
local Vector3    			= _G.Vector3
local ACTIONS    			= _G.ACTIONS
local cooking 				= require("cooking")
local containers 			= require("containers")
local params 				= {}

require("hof_foodrecipes")
require("hof_foodrecipes_optional")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Custom containers.
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Syrup Pot.
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
    },
    acceptsstacks 			= false,
    type 					= "cooker",
}

function params.syrup_pot.itemtestfn(container, item, slot)
    return item:HasTag("gourmet_sap") and not container.inst:HasTag("burnt")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Small and Large Pot. (They use the same).
params.cooking_pot 			=
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
    },
    acceptsstacks 			= false,
    type 					= "cooker",
}

function params.cooking_pot.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------