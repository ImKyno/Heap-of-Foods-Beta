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
params.syrup_pot =
{
    widget =
    {
        slotpos =
        {
            Vector3(-1, 64 + 32 + 8 + 4, 0	 ),
            Vector3(-1, 32 + 4, 0			 ),
            Vector3(-1, -(32 + 4), 0		 ),
            Vector3(-1, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "quagmire_ui_pot_1x4",
        animbuild = "quagmire_ui_pot_1x4",
		
        pos = Vector3(200, 0, 0), -- A bit closer!
        side_align_tip = 100,
    },

    acceptsstacks = false,
    type = "cooker",
}

function params.syrup_pot.itemtestfn(container, item, slot)
    return item:HasTag("gourmet_sap") and not container.inst:HasTag("burnt")
end

-- Small Cookwares.
params.cooking_pot_small =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 8,    0),
            Vector3(0, 0,         0),
            Vector3(0, -(64 + 8), 0),
        },

        animbank = "quagmire_ui_pot_1x3",
        animbuild = "quagmire_ui_pot_1x3",
		
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
    },

    acceptsstacks = false,
    type = "cooker",
}

function params.cooking_pot_small.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

-- Large Cookwares.
params.cooking_pot =
{
    widget =
    {
        slotpos =
        {
            Vector3(-1, 64 + 32 + 8 + 4, 0	 ),
            Vector3(-1, 32 + 4, 0			 ),
            Vector3(-1, -(32 + 4), 0		 ),
            Vector3(-1, -(64 + 32 + 8 + 4), 0),
        },

        animbank = "quagmire_ui_pot_1x4",
        animbuild = "quagmire_ui_pot_1x4",
		
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
    },

    acceptsstacks = false,
    type = "cooker",
}

function params.cooking_pot.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

-- Wooden Keg and Preserves Jar. (They use the same).
params.brewer =
{
    widget =
    {
        slotpos =
        {
            Vector3(-1, 32 + 4, 0			 ),
            Vector3(-1, -(32 + 4), 0		 ),
			Vector3(-1, -(64 + 32 + 8 + 4), 0),
        },

        animbank = "ui_brewer_1x3",
        animbuild = "ui_brewer_1x3",
		
        pos = Vector3(150, 0, 0),
        side_align_tip = 100,
		buttoninfo =
        {
            text = STRINGS.ACTIONS.BREWER,
            position = Vector3(0, -170, 0),
        }
    },

    acceptsstacks = false,
    type = "brewer",
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
    return item:HasAnyTag("honeyed", "honey", "nectar") and not container.inst:HasTag("burnt")
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
	if item:HasTag("preparedfood") then
		return false
	end
	
    for k, v in pairs(FOODGROUP.OMNI.types) do
        if item:HasTag("edible_"..v) or item:HasTag("foodsack_valid") then
            return true
        end
    end
end

params.popcornmachine = 
{
	widget =
	{
		slotpos =
		{
			Vector3(0,   30 + 4,  0),
			Vector3(0, -(36 + 4), 0),
		},
		
		slotbg =
		{
			{ image = "popcornmachine_slot_corn.tex",    atlas = "images/inventoryimages/hof_hudimages.xml" },
			{ image = "popcornmachine_slot_popcorn.tex", atlas = "images/inventoryimages/hof_hudimages.xml" },
		},
		
		animbank = "ui_popcornmachine_1x2",
		animbuild = "ui_popcornmachine_1x2",
		
		pos = Vector3(0, 140, 0),
		side_align_tip = 100,
    },

	acceptsstacks = true,
	usespecificslotsforitems = true,
	type = "cooker",
}

function params.popcornmachine.itemtestfn(container, item, slot)
	if slot == 1 then
		return item.prefab == "corn"
	elseif slot == 2 then
		return item:HasTag("popcorn") and item:GetTimeAlive() <= 0 or item.prefab == "corn_cooked" and item:GetTimeAlive() <= 0
	end
	
	if slot == nil then		
		return item.prefab == "corn" or container:GetItemInSlot(1) == nil and item.prefab == "corn"
	end
	
	return false
end

params.fishfarmplot = 
{
	widget = 
	{
		slotpos = {},
		
		slotbg =
		{
			{ image = "fishfarmplot_slot_fish.tex", atlas = "images/inventoryimages/hof_hudimages.xml" },
			{ image = "fishfarmplot_slot_roe.tex", atlas = "images/inventoryimages/hof_hudimages.xml" },
		},
		
		animbank = "ui_fishfarmplot_3x4",
		animbuild = "ui_fishfarmplot_3x4",
        
		pos = Vector3(0, 170, 0),
		side_align_tip = 100,
	},
	
	acceptsstacks = true,
	type = "chest",
}

local spacing = 80
local start_y = 2
local x_offset = -10
local y_offset = 190

for y = start_y, 0, -1 do
	if y == start_y then
		for x = 0, 1 do
			table.insert(params.fishfarmplot.widget.slotpos, 
			Vector3(spacing * x - spacing * 0.5 + x_offset, 
			spacing * (y - 1) - spacing * 1.5 + y_offset, 0))
		end
	else
		for x = 0, 2 do
			table.insert(params.fishfarmplot.widget.slotpos,
			Vector3(spacing * x - spacing + x_offset,
			spacing * (y - 1) - spacing * 1.5 + y_offset, 0))
			
			table.insert(params.fishfarmplot.widget.slotbg, 
			{ image = "fishfarmplot_slot_empty.tex", atlas = "images/inventoryimages/hof_hudimages.xml" })
		end
	end
end

function params.fishfarmplot.itemtestfn(container, item, slot)
	if slot == 1 then
		return item:HasTag("fishfarmable")
	elseif slot == 2 then
		return item:HasTag("roe") and item:GetTimeAlive() <= 0
	else
		local valid_fish_slots = 
		{
			[3] = true, [4]  = true,  [5]  = true,
			[6] = true, [7]  = true,  [8]  = true,
        }

		if valid_fish_slots[slot] then
			return item:HasTag("fishfarmable") and item:GetTimeAlive() <= 0
		end
	end

    if slot == nil then
		if item:HasTag("fishfarmable") then
			return container:GetItemInSlot(1) == nil
		end
	end
	
	return false
end

-- Tin Fishing' Bin accepts more kinds of fish.
function containers.params.fish_box.itemtestfn(container, item, slot)
    return item:HasAnyTag("smalloceancreature", "fish_box_valid")
end

params.octopustraderchest =
{
	widget =
	{
		slotpos =
		{
			Vector3(0, 64   + 32 + 8 + 4,  0),
			Vector3(0, 32   + 4,           0),
			Vector3(0, -(32 + 4),          0),
			Vector3(0, -(64 + 32 + 8 + 4), 0),
		},
		
		animbank = "ui_lamp_1x4",
		animbuild = "ui_lamp_1x4",
		
		pos = Vector3(75, 200, 0),
		side_align_tip = 160,
	},
	
	type = "chest",
}

params.packimbaggims =
{
	widget =
	{
		slotpos = {},
		
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		
		pos = Vector3(0, 200, 0),
		side_align_tip = 160,
	},
	
	type = "chest",
}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(params.packimbaggims.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
	end
end

params.packimbaggimsfat =
{
	widget =
	{
		slotpos = {},
		
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		
		pos = Vector3(0, 220, 0),
		side_align_tip = 160,
	},
	
	type = "chest",
}

for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.packimbaggimsfat.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end

params.winter_tree_hof =
{
	widget =
	{
		slotpos = {},
		
		animbank = "ui_backpack_2x4",
		animbuild = "ui_backpack_2x4",
		
		pos = Vector3(275, 0, 0),
		side_align_tip = 100,
	},
	
	acceptsstacks = false,
	type = "cooker",
}

for y = 0, 3 do
	table.insert(params.winter_tree_hof.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
	table.insert(params.winter_tree_hof.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
end

function params.winter_tree_hof.itemtestfn(container, item, slot)
	return item:HasTag("winter_ornament") and not container.inst:HasTag("burnt")
end