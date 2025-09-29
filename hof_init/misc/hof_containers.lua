-- Common Dependencies.
local _G         = GLOBAL
local require    = _G.require
local Vector3    = _G.Vector3
local ACTIONS    = _G.ACTIONS
local STRINGS    = _G.STRINGS
local cooking    = require("cooking")
local brewing    = require("hof_brewing")
local containers = require("containers")
local params     = {}

require("hof_foodrecipes")
require("hof_foodrecipes_warly")
require("hof_foodrecipes_seasonal")
require("hof_brewrecipes_keg")
require("hof_brewrecipes_jar")

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

-- Small Cookwares.
params.cooking_pot_small	=
{
    widget 					=
    {
        slotpos 			=
        {
            Vector3(0, 64 + 8,    0),
            Vector3(0, 0,         0),
            Vector3(0, -(64 + 8), 0),
        },

        animbank 			= "quagmire_ui_pot_1x3",
        animbuild 			= "quagmire_ui_pot_1x3",
        pos 				= Vector3(200, 0, 0),
        side_align_tip 		= 100,
    },

    acceptsstacks 			= false,
    type 					= "cooker",
}

function params.cooking_pot_small.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

-- Large Cookwares.
params.cooking_pot			=
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
        pos 				= Vector3(200, 0, 0),
        side_align_tip 		= 100,
    },

    acceptsstacks 			= false,
    type 					= "cooker",
}

function params.cooking_pot.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

-- Wooden Keg and Preserves Jar. (They use the same).
params.brewer 				=
{
    widget 					=
    {
        slotpos 			=
        {
            Vector3(-1, 32 + 4, 0			 ),
            Vector3(-1, -(32 + 4), 0		 ),
			Vector3(-1, -(64 + 32 + 8 + 4), 0),
        },

        animbank 			= "ui_brewer_1x3",
        animbuild 			= "ui_brewer_1x3",
        pos 				= Vector3(150, 0, 0),
        side_align_tip 		= 100,
		buttoninfo =
        {
            text = STRINGS.ACTIONS.BREWER,
            position = Vector3(0, -170, 0),
        }
    },

    acceptsstacks 			= false,
    type 					= "brewer",
}

function params.brewer.itemtestfn(container, item, slot)
	-- return item:HasTag("brewer_ingredient") and not container.inst:HasTag("burnt")
	return brewing.IsBrewingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

function params.brewer.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        _G.BufferedAction(doer, inst, ACTIONS.BREWER):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        _G.SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.BREWER.code, inst, ACTIONS.BREWER.mod_name)
    end
end

function params.brewer.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

-- Honey Deposit.
params.honeydeposit =
{
    widget =
    {
        slotpos =
		{
			Vector3(-37.5, 74 + 4, 0),
            Vector3(37.5, 74 + 4, 0),

            Vector3(-(64 + 12), 3, 0),
            Vector3(0, 3, 0),
            Vector3(64 + 12, 3, 0),

			Vector3(-37.5, -(70 + 4), 0),
            Vector3(37.5, -(70 + 4), 0),
		},

        animbank = "ui_antchest_honeycomb",
        animbuild = "ui_antchest_honeycomb",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },

    type = "chest",
}

function params.honeydeposit.itemtestfn(container, item, slot)
    return item:HasTag("honeyed") and not container.inst:HasTag("burnt")
end

-- Potato Sack.
params.potatosack =
{
    widget =
    {
		slotpos = {},
        animbank = "ui_chest_3x2",
        animbuild = "ui_chest_3x2",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },

    type = "chest",
}

for y = 1, 0, -1 do
    for x = 0, 2 do
        table.insert(params.potatosack.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 120, 0))
    end
end

function params.potatosack.itemtestfn(container, item, slot)
	return item:HasTag("potatosack_valid") and not container.inst:HasTag("burnt")
end

-- Hack for portablespicer to not accept items with "nospice" tag.
function containers.params.portablespicer.itemtestfn(container, item, slot)
    return item.prefab ~= "wetgoop"
	and (
			(slot == 1 and item:HasTag("preparedfood") and not item:HasTag("spicedfood") and not item:HasTag("nospice")) or
			(slot == 2 and item:HasTag("spice")) or
			(slot == nil and (item:HasTag("spice") or (item:HasTag("preparedfood") and not item:HasTag("spicedfood") and not item:HasTag("nospice"))))
		)
	and not container.inst:HasTag("burnt")
end

-- Food Sack.
params.foodsack =
{
	widget =
	{
		slotbg = {},
		slotpos = {},
		animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-5, -80, 0),
	},
	
	issidewidget = true,
    type = "pack",
    openlimit = 1,
}

local foodsack_slotbg = { atlas = "images/hud.xml", image = "inv_slot_morsel.tex" }
for y = 0, 3 do
	table.insert(params.foodsack.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
	table.insert(params.foodsack.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
	table.insert(params.foodsack.widget.slotbg, foodsack_slotbg)
	table.insert(params.foodsack.widget.slotbg, foodsack_slotbg)
end
foodsack_slotbg = nil

function params.foodsack.itemtestfn(container, item, slot)
    for k, v in pairs(FOODGROUP.OMNI.types) do
        if item:HasTag("edible_"..v) or item:HasTag("foodsack_valid") and not item:HasTag("preparedfood") then
            return true
        end
    end
end

--[[
-- Not using because if using increased storage mods this will break.
if HOF_ICEBOXSTACKSIZE then
	containers.params.icebox.widget.animbank_upgraded = "ui_chest_upgraded_3x3"
	containers.params.icebox.widget.animbuild_upgraded = "ui_chest_upgraded_3x3"

	containers.params.saltbox.widget.animbank_upgraded = "ui_chest_upgraded_3x3"
	containers.params.saltbox.widget.animbuild_upgraded = "ui_chest_upgraded_3x3"
end
]]--