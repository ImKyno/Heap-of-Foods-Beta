-- Common Dependencies.
local _G         = GLOBAL
local require    = _G.require
local Vector3    = _G.Vector3
local ACTIONS    = _G.ACTIONS
local STRINGS    = _G.STRINGS
local cooking    = require("cooking")
local brewing    = require("hof_brewing")
local containers = require("containers")
local params     = containers.params

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
		slotpos = {},
		slotbg = {},
		animbank = "ui_piggyback_2x6",
        animbuild = "ui_piggyback_2x6",
        pos = Vector3(-5, -90, 0),
	},
	
	issidewidget = true,
    type = "pack",
    openlimit = 1,
}

local FOODSACK_SLOTBG = {image = "inv_slot_morsel.tex", atlas = "images/hud.xml"}
for y = 0, 5 do
    table.insert(params.foodsack.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
    table.insert(params.foodsack.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
	table.insert(params.foodsack.widget.slotbg, FOODSACK_SLOTBG)
end

-- Same as Wilson's beard.
function params.foodsack.itemtestfn(container, item, slot)
    for k, v in pairs(FOODGROUP.OMNI.types) do
        if item:HasTag("edible_"..v) then
            return true
        end
    end
end

params.icebox.widget.animbank_upgraded = "ui_chest_upgraded_3x3"
params.icebox.widget.animbuild_upgraded = "ui_chest_upgraded_3x3"

params.saltbox.widget.animbank_upgraded = "ui_chest_upgraded_3x3"
params.saltbox.widget.animbuild_upgraded = "ui_chest_upgraded_3x3"
