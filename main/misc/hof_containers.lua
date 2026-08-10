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
			container[k] = v
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

-- Salt Pack.
params.foodsack =
{
	widget =
	{
		slotbg = {},
		slotpos = {},

		animbank = "ui_piggyback_2x6",
		animbuild = "ui_piggyback_2x6",

		pos = Vector3(-5, -90, 0),
	},

	issidewidget = true,
	type = "pack",
	openlimit = 1,
}

-- local foodsack_slotbg = { atlas = "images/hud.xml", image = "inv_slot_morsel.tex" }
for y = 5, 0, -1 do
	table.insert(params.foodsack.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
	table.insert(params.foodsack.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
	-- table.insert(params.foodsack.widget.slotbg, foodsack_slotbg)
end
-- foodsack_slotbg = nil

function params.foodsack.itemtestfn(container, item, slot)
	if item:HasAnyTag("preparedfood", "preparedbrew") then
		return false
	end

	for k, v in pairs(FOODGROUP.OMNI.types) do
		if item:HasTag("edible_"..v) or item:HasTag("foodsack_valid") then
			return true
		end
	end

	return true
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

-- Seed Sack.
params.seedsbag =
{
	widget =
	{
		slotbg = {},
		slotpos =
		{
			Vector3(-37.5, 32 + 4,    0),
			Vector3(37.5,  32 + 4,    0),
			Vector3(-37.5, -(32 + 4), 0),
			Vector3(37.5,  -(32 + 4), 0),
		},

		animbank = "ui_chest_2x2",
		animbuild = "ui_chest_2x2",
		animbank_upgraded = "ui_seedsbag_upgraded_2x2",
		animbuild_upgraded = "ui_seedsbag_upgraded_2x2",

		pos = Vector3(0, 160, 0),
		side_align_tip = 190,
	},

	type = "chest",
}

for i = 1, #params.seedsbag.widget.slotpos do
	table.insert(params.seedsbag.widget.slotbg,
	{
		image = "seedsbag_slot_seed.tex",
		atlas = "images/inventoryimages/hof_hudimages.xml",
	})
end

function params.seedsbag.itemtestfn(container, item, slot)
	return item.prefab == "seeds" or string.match(item.prefab, "_seeds")
end

params.seedsbag.priorityfn = params.seedsbag.itemtestfn

local WX78_BACKUPBODY_POS = Vector3(0, 280, 0)
local WX78_BACKUPBODY_POS_ALT = Vector3(0, 280, 0)

local WX78_INVENTORY_COOKER_OFFSET = Vector3(0, 185, 0)
local WX78_INVENTORY_COOKER_SLOTPOS = {}
local WX78_INVENTORY_COOKER_BACKUP_SLOTPOS = {}

for x = 0, 4 do
	table.insert(WX78_INVENTORY_COOKER_SLOTPOS, { Vector3(60 * x - 60 * 2, -320, 0), Vector3(60 * x - 60 * 2, -380, 0) })
end

for x = 0, 4 do
	local offset = (x - 2) * 80

	table.insert(WX78_INVENTORY_COOKER_BACKUP_SLOTPOS,
	{
		Vector3(-4 + offset, -354, 0),
		Vector3(-2 + offset, -458, 0)
	})
end

local function wx78_isinbackupbody(container, doer)
	local inventoryitem = container.replica.inventoryitem
	return not (inventoryitem and inventoryitem:IsHeldBy(doer))
end

local function wx78_getcolumn(container)
	local parent = container.entity:GetParent()
	local _container = parent and parent.replica.container

	if _container then
		for slot, v in pairs(_container:GetItems()) do
			if v == container then
				return ((slot - 1) % 5) + 1
			end
		end
	end

	return 5
end

params.wx78_inventorycooker =
{
	widget =
	{
		slotbg =
		{
			{ image = "wx78_inventorycooker_slot_cook.tex", atlas = "images/inventoryimages/hof_hudimages.xml" },
		},

		slotpos =
		{ 
			Vector3(-3, -16, 0),
			Vector3(-2, -149, 0),
		},

		slotposfn = function(container, doer)
			local column = wx78_getcolumn(container)

			if wx78_isinbackupbody(container, doer) then
				return WX78_INVENTORY_COOKER_BACKUP_SLOTPOS[column]
			end

			return nil
		end,

		slotscalefn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and 0.85 or nil
		end,

		slothighlightscalefn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and 1.08 or nil
		end,

		animbank = "ui_wx78_inventorycooker_1x2",
		animbuild = "ui_wx78_inventorycooker_1x2",
		animfn = function(container, doer, anim)
			return wx78_isinbackupbody(container, doer)
			and (anim..tostring(wx78_getcolumn(container))) or nil
		end,

		pos = WX78_INVENTORY_COOKER_OFFSET,
		posfn = function(container, doer)
			if wx78_isinbackupbody(container, doer) then
				return WX78_BACKUPBODY_POS_ALT
			end

			for k, v in pairs(doer.HUD.controls.inv.inv) do
				if v.tile and v.tile.item == container then
					return v:GetPosition() + WX78_INVENTORY_COOKER_OFFSET
				end
			end
		end,

		opensound = "balatro/balatro_cabinet/cards_flip_HUD",
		closesound = "balatro/balatro_cabinet/cards_flip_HUD",

		bottom_align_tip_fn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and -90 or nil
		end,

		top_align_tip_fn = function(container, doer)
			return not wx78_isinbackupbody(container, doer) and 70 or nil
		end,

		top_align_tip = 70,
	},

	type = "inv",
	typefn = function(container, doer)
		return wx78_isinbackupbody(container, doer) and "chest_addon" or nil
	end,
}

function params.wx78_inventorycooker.itemtestfn(container, item, slot)
	local owner

	if TheWorld.ismastersim then
		owner = container.inst.components.container:GetOpeners()[1]
	elseif ThePlayer and container:IsOpenedBy(ThePlayer) then
		owner = ThePlayer
	end

	-- Can have no owner when loading.
	local beta2 = not owner or (owner.components.skilltreeupdater
	and owner.components.skilltreeupdater:IsActivated("wx78_circuitry_betabuffs_2"))

	if slot == 1 then
		if beta2 then
			return item:HasTag("cookable") or item:HasTag("canlight")
		end

		return item:HasTag("cookable")
	elseif slot == 2 then
		return item:GetTimeAlive() <= 0
	end

	if slot == nil then
		if container:GetItemInSlot(1) == nil then
			if beta2 then
				return item:HasTag("cookable") or item:HasTag("canlight")
			end

			return item:HasTag("cookable")
		end
	end

	return false
end

function params.wx78_inventorycooker.priorityfn(container, item)
	local existingitem = container:GetItemInSlot(1)
	local stackable = existingitem and existingitem.replica.stackable

	return stackable ~= nil and stackable:CanStackWith(item)
end

local WX78_INVENTORY_DRYER_OFFSET = Vector3(0, 100, 0)
local WX78_INVENTORY_DRYER_SLOTPOS = {}

for x = 0, 4, 1 do
	table.insert(WX78_INVENTORY_DRYER_SLOTPOS, { Vector3(80 * x - 80 * 2, -340, 0) })
end

params.wx78_inventorydryer =
{
	widget =
	{
		slotbg =
		{
			{ image = "inv_slot_morsel.tex" },
		},
	
		slotpos =
		{
			Vector3(0, 0, 0)
		},

		slotposfn = function(container, doer)
			return wx78_isinbackupbody(container, doer)
			and WX78_INVENTORY_DRYER_SLOTPOS[wx78_getcolumn(container)] or nil
		end,

		slotscalefn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and 0.85 or nil
		end,

		slothighlightscalefn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and 1.08 or nil
		end,

		animbank = "ui_wx78_inventorydryer_1x1",
		animbuild = "ui_wx78_inventorydryer_1x1",
		animfn = function(container, doer, anim)
			return wx78_isinbackupbody(container, doer)
			and (anim..tostring(wx78_getcolumn(container))) or nil
		end,

		pos = WX78_INVENTORY_DRYER_OFFSET,
		posfn = function(container, doer)
			if wx78_isinbackupbody(container, doer) then
				return WX78_BACKUPBODY_POS
			end

			for k, v in pairs(doer.HUD.controls.inv.inv) do
				if v.tile and v.tile.item == container then
					return v:GetPosition() + WX78_INVENTORY_DRYER_OFFSET
				end
			end
		end,

		opensound = "balatro/balatro_cabinet/cards_flip_HUD",
		closesound = "balatro/balatro_cabinet/cards_flip_HUD",

		bottom_align_tip_fn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and -90 or nil
		end,

		top_align_tip_fn = function(container, doer)
			return not wx78_isinbackupbody(container, doer) and 70 or nil
		end,

		top_align_tip = 70,
	},

	type = "inv",
	typefn = function(container, doer)
		return wx78_isinbackupbody(container, doer) and "chest_addon" or nil
	end,
}

function params.wx78_inventorydryer.itemtestfn(container, item, slot)
	return item:HasTag("dryable")
	or (TheWorld.ismastersim and (item:GetTimeAlive() == 0
	or (item.dryingrack_lastinfo and item.dryingrack_lastinfo.container == container and item.dryingrack_lastinfo.slot == slot)))
end

local WX78_INVENTORY_DRYER2_OFFSET = Vector3(0, 100, 0)
local WX78_INVENTORY_DRYER2_SLOTPOS = {}

for x = 0, 4, 1 do
	table.insert(WX78_INVENTORY_DRYER2_SLOTPOS, { Vector3(80 * x - 80 * 2, -340, 0) })
end

params.wx78_inventorydryer2 =
{
	widget =
	{
		slotbg =
		{
			{ image = "inv_slot_kelp.tex", atlas = "images/hud2.xml" },
		},
	
		slotpos =
		{
			Vector3(0, 0, 0)
		},

		slotposfn = function(container, doer)
			return wx78_isinbackupbody(container, doer)
			and WX78_INVENTORY_DRYER2_SLOTPOS[wx78_getcolumn(container)] or nil
		end,

		slotscalefn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and 0.85 or nil
		end,

		slothighlightscalefn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and 1.08 or nil
		end,

		animbank = "ui_wx78_inventorydryer2_1x1",
		animbuild = "ui_wx78_inventorydryer2_1x1",
		animfn = function(container, doer, anim)
			return wx78_isinbackupbody(container, doer)
			and (anim..tostring(wx78_getcolumn(container))) or nil
		end,

		pos = WX78_INVENTORY_DRYER2_OFFSET,
		posfn = function(container, doer)
			if wx78_isinbackupbody(container, doer) then
				return WX78_BACKUPBODY_POS
			end

			for k, v in pairs(doer.HUD.controls.inv.inv) do
				if v.tile and v.tile.item == container then
					return v:GetPosition() + WX78_INVENTORY_DRYER2_OFFSET
				end
			end
		end,

		opensound = "balatro/balatro_cabinet/cards_flip_HUD",
		closesound = "balatro/balatro_cabinet/cards_flip_HUD",

		bottom_align_tip_fn = function(container, doer)
			return wx78_isinbackupbody(container, doer) and -90 or nil
		end,

		top_align_tip_fn = function(container, doer)
			return not wx78_isinbackupbody(container, doer) and 70 or nil
		end,

		top_align_tip = 70,
	},

	type = "inv",
	typefn = function(container, doer)
		return wx78_isinbackupbody(container, doer) and "chest_addon" or nil
	end,
}

params.wx78_inventorydryer2.itemtestfn = params.wx78_inventorydryer.itemtestfn

params.piggybank =
{
	widget =
	{
		slotpos = {},
		slotbg = {},

		animbank = "ui_chest_3x2",
		animbuild = "ui_chest_3x2",
		animbank_upgraded = "ui_piggybank_upgraded_3x2",
		animbuild_upgraded = "ui_piggybank_upgraded_3x2",

		pos = Vector3(0, 200, 0),
		side_align_tip = 160,
	},

	type = "chest",
}

for y = 1, 0, -1 do
	for x = 0, 2 do
		table.insert(params.piggybank.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 120, 0))
		table.insert(params.piggybank.widget.slotbg, { image = "piggybank_pigcoin_slot.tex", atlas = "images/inventoryimages/hof_hudimages.xml" })
	end
end

function params.piggybank.itemtestfn(container, item, slot)
	local VALID_PREFABS =
	{
		pig_coin             = true,
		goldnugget           = true,
		lucky_goldnugget     = true,
		carnival_prizeticket = true,
		carnival_gametoken   = true,
	}

	return VALID_PREFABS[item.prefab] or item:HasAnyTag("pigcoin", "piggybank_valid")
end

-- Tweaks for vanilla containers.
-- Portable Seasoning Station does not accept items with nospice tag.
local _portablespicer_itemtestfn = containers.params.portablespicer.itemtestfn
containers.params.portablespicer.itemtestfn = function(container, item, slot)
	if item:HasTag("nospice") then
		return false
	end

	return _portablespicer_itemtestfn(container, item, slot)
end

-- Tin Fishin' Bin accepts more kinds of fish.
local _fish_box_itemtestfn = containers.params.fish_box.itemtestfn
containers.params.fish_box.itemtestfn = function(container, item, slot)
	if item:HasAnyTag("smalloceancreature", "fish_box_valid") then
		return true
	end

	return _fish_box_itemtestfn(container, item, slot)
end

-- Sisturn accepts Sweet Flower.
local _sisturn_itemtestfn = containers.params.sisturn.itemtestfn
containers.params.sisturn.itemtestfn = function(container, item, slot)
	if item.prefab == "kyno_sugartree_petals" then
		local owner

		if TheWorld.ismastersim then
			owner = container.inst.components.container:GetOpeners()[1]
		elseif ThePlayer and container:IsOpenedBy(ThePlayer) then
			owner = ThePlayer
		end

		if not owner or (owner.components.skilltreeupdater
		and owner.components.skilltreeupdater:IsActivated("wendy_sisturn_3")) then
			return true
		end

		return true
	end

	return _sisturn_itemtestfn(container, item, slot)
end

-- Salt Box and Polar Bearger Bin accepts dried food.
local _saltbox_itemtestfn = containers.params.saltbox.itemtestfn
containers.params.saltbox.itemtestfn = function(container, item, slot)
	local PERISHABLE_TAGS = item:HasAnyTag("fresh", "stale", "spoiled")

	for k, v in pairs(FOODGROUP.OMNI.types) do
		if PERISHABLE_TAGS and item:HasTag("edible_"..v) and item.prefab:find("_dried", 1, true) then
			return true
		end
	end

	return _saltbox_itemtestfn(container, item, slot)
end

local _beargerfur_sack_itemtestfn = containers.params.beargerfur_sack.itemtestfn
containers.params.beargerfur_sack.itemtestfn = function(container, item, slot)
	local PERISHABLE_TAGS = item:HasAnyTag("fresh", "stale", "spoiled")

	for k, v in pairs(FOODGROUP.OMNI.types) do
		if PERISHABLE_TAGS and item:HasTag("edible_"..v) and item.prefab:find("_dried", 1, true) then
			return true
		end
	end

	return _beargerfur_sack_itemtestfn(container, item, slot)
end

-- Chef's Pouch Rework, acts like the Polar Bearger Bin if the rework option is enabled.
-- Otherwise it now have the same amount of slots as the Backpack.
params.spicepackrework =
{
	widget =
	{
		slotpos = {},
		slotbg  = {},

		animbank  = "ui_chest_2x2",
		animbuild = "ui_chest_2x2",

		pos = Vector3(0, 175, 0),
		side_align_tip = 160,
	},

	type = "chest",
}

for y = 0, 1 do
	for x = 0, 1 do
		table.insert(params.spicepackrework.widget.slotpos, Vector3(-37.5 + (75 * x), 36 - (68 * y), 0))
		table.insert(params.spicepackrework.widget.slotbg, { image = "preparedfood_slot.tex", atlas = "images/hud2.xml" })
	end
end

function params.spicepackrework.itemtestfn(container, item, slot)
	return item:HasAnyTag("beargerfur_sack_valid", "preparedfood")
end

if TUNING.HOF_SPICEPACKREWORK then
	containers.params.spicepack = params.spicepackrework
else
	containers.params.spicepack = containers.params.backpack
end