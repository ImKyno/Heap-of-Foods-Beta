local _G                     = GLOBAL
local require                = _G.require
local SpawnPrefab            = _G.SpawnPrefab
local CIRCUIT_BARS           = _G.CIRCUIT_BARS
local WX78Common             = require("prefabs/wx78_common")
local WX78_MODULES_DEF       = require("wx78_moduledefs")
local module_definitions     = WX78_MODULES_DEF.module_definitions
local hof_module_definitions = {}

local function IsSkillActivated(wx, skill)
	return wx.components.skilltreeupdater and wx.components.skilltreeupdater:IsActivated(skill)
end

local function Circuit_SetUpSkillCb(inst, wx, skillnames, activatecb, deactivatecb, isloading)
	local is_one_skill = type(skillnames) == "string"
	local skilltreeupdater = wx.components.skilltreeupdater

	if skilltreeupdater == nil and wx.components.follower ~= nil then
		local leader = wx.components.follower:GetLeader()
		skilltreeupdater = leader and leader.components.skilltreeupdater
	end

	if skilltreeupdater then
		local do_activate = false

		if is_one_skill then
			do_activate = skilltreeupdater:IsActivated(skillnames)
		else
			for skill in pairs(skillnames) do
				if skilltreeupdater:IsActivated(skill) then
					do_activate = true
					break
				end
			end
		end

		if do_activate then
			activatecb(inst, wx, isloading)
			inst._circuit_skill_activated = true
		end
	end

	inst._onactivateskill_handler = function(_, data)
		if (is_one_skill and data.skill == skillnames) or (not is_one_skill and skillnames[data.skill]) then
			activatecb(inst, wx, isloading, true)
			inst._circuit_skill_activated = true
		end
	end

	inst._ondeactivateskill_handler = function(_, data)
		if (is_one_skill and data.skill == skillnames) or (not is_one_skill and skillnames[data.skill]) or data.force then
			deactivatecb(inst, wx, isloading)
			inst._circuit_skill_activated = nil
		end
	end

	if wx.isplayer then
		inst:ListenForEvent("onactivateskill_server", inst._onactivateskill_handler, wx)
		inst:ListenForEvent("ondeactivateskill_server", inst._ondeactivateskill_handler, wx)
	elseif wx.components.follower ~= nil then
		inst._onleaderchanged_handler = function(_, data)
			local oldleader = data.old

			if oldleader ~= nil then
				inst:RemoveEventCallback("onactivateskill_server", inst._onactivateskill_handler, oldleader)
				inst:RemoveEventCallback("ondeactivateskill_server", inst._ondeactivateskill_handler, oldleader)
			end

			local newleader = data.new

			if newleader ~= nil then
				inst:ListenForEvent("onactivateskill_server", inst._onactivateskill_handler, newleader)
				inst:ListenForEvent("ondeactivateskill_server", inst._ondeactivateskill_handler, newleader)
			end
		end

		local leader = wx.components.follower:GetLeader()

		if leader ~= nil then
			inst:ListenForEvent("onactivateskill_server", inst._onactivateskill_handler, leader)
			inst:ListenForEvent("ondeactivateskill_server", inst._ondeactivateskill_handler, leader)
		end

		inst:ListenForEvent("leaderchanged", inst._onleaderchanged_handler, wx)
	end
end

local function Circuit_DestroySkillCb(inst, wx)
	if inst._circuit_skill_activated then
		inst._ondeactivateskill_handler(wx, { force = true })
	end

	if wx.isplayer then
		inst:RemoveEventCallback("onactivateskill_server", inst._onactivateskill_handler, wx)
		inst:RemoveEventCallback("ondeactivateskill_server", inst._ondeactivateskill_handler, wx)
	elseif wx.components.follower ~= nil then
		local leader = wx.components.follower:GetLeader()

		if leader ~= nil then
			inst:RemoveEventCallback("onactivateskill_server", inst._onactivateskill_handler, leader)
			inst:RemoveEventCallback("ondeactivateskill_server", inst._ondeactivateskill_handler, leader)
		end

		inst:RemoveEventCallback("leaderchanged", inst._onleaderchanged_handler, wx)
	end

	inst._onactivateskill_handler = nil
	inst._ondeactivateskill_handler = nil
	inst._onleaderchanged_handler = nil
end

-- Gourmand Circuit
-- Grants increased stats from prepared foods. (+5 per circuit).
-- Grants decreased negative stats from prepared foods. (-5 per circuit).
-- Beta Circuits Tinkering II decreases negative stats by another -5 and allows quick eating.
local function GourmandOnUpdate(wx)
	local chips = wx._gourmandchips or 0

	if chips > 0 and IsSkillActivated(wx, "wx78_circuitry_betabuffs_2") then
		wx:AddTag("gourmand_fasteater")
	else
		wx:RemoveTag("gourmand_fasteater")
	end

	local strongstomach = chips >= 2

	if strongstomach then
		wx:AddTag("strongstomach")
	else
		wx:RemoveTag("strongstomach")
	end

	if wx.components.eater ~= nil then
		wx.components.eater:SetStrongStomach(strongstomach)
	end
end

local function GourmandSkillActivate(inst, wx)
	GourmandOnUpdate(wx)
end

local function GourmandSkillDeactivate(inst, wx)
	GourmandOnUpdate(wx)
end

local function GourmandOnEat(wx, data)
	local food = data and data.food

	if food == nil or not food:HasTag("preparedfood") then
		return
	end

	local chips = wx._gourmandchips or 0
	local bonus = TUNING.KYNO_WX78_MODULES_GOURMAND_BONUS * chips
	local penalty = 5 * chips

	if IsSkillActivated(wx, "wx78_circuitry_betabuffs_2") then
		penalty = penalty + 5
	end

	local health = food.components.edible:GetHealth(wx)

	if health > 0 then
		if wx.components.health ~= nil then
			wx.components.health:DoDelta(bonus, nil, food.prefab)
		end
	elseif health < 0 then
		if wx.components.health ~= nil then
			wx.components.health:DoDelta(penalty, nil, food.prefab)
		end
	end

	local hunger = food.components.edible:GetHunger(wx)

	if hunger > 0 then
		if wx.components.hunger ~= nil then
			wx.components.hunger:DoDelta(bonus)
		end
	elseif hunger < 0 then
		if wx.components.hunger ~= nil then
			wx.components.hunger:DoDelta(penalty)
		end
	end

	local sanity = food.components.edible:GetSanity(wx)

	if sanity > 0 then
		if wx.components.sanity ~= nil then
			wx.components.sanity:DoDelta(bonus)
		end
	elseif sanity < 0 then
		if wx.components.sanity ~= nil then
			wx.components.sanity:DoDelta(penalty)
		end
	end
end

local function GourmandActivate(inst, wx)
	wx._gourmandchips = (wx._gourmandchips or 0) + 1

	GourmandOnUpdate(wx)

	if wx._gourmandchips == 1 then
		Circuit_SetUpSkillCb(inst, wx, "wx78_circuitry_betabuffs_2", GourmandSkillActivate, GourmandSkillDeactivate)
	end

	if wx._gourmandoneat == nil then
		wx._gourmandoneat = function(owner, data)
			GourmandOnEat(owner, data)
		end

		wx:ListenForEvent("oneat", wx._gourmandoneat)
	end
end

local function GourmandDeactivate(inst, wx)
	wx._gourmandchips = math.max(0, (wx._gourmandchips or 1) - 1)

	GourmandOnUpdate(wx)

	if wx._gourmandchips <= 0 then
		Circuit_DestroySkillCb(inst, wx)

		if wx._gourmandoneat ~= nil then
			wx:RemoveEventCallback("oneat", wx._gourmandoneat)
			wx._gourmandoneat = nil
		end
	end
end

local GOURMAND_MODULE_DATA =
{
	name                = "gourmand",
	slots               = 2,
	type                = CIRCUIT_BARS.BETA,
	activatefn          = GourmandActivate,
	deactivatefn        = GourmandDeactivate,
	overridebank        = "kyno_wx78_chips",
	overridebuild       = "kyno_wx78_chips",
	overrideminiuibuild = "kyno_wx78_status",
	overrideuibuild     = "kyno_wx78_status_chest",
}

table.insert(hof_module_definitions, GOURMAND_MODULE_DATA)

-- Combustion Circuit
-- Grants an inventory container that can cooks items automatically every 5 seconds.
-- Beta Circuits Tinkering II allows any item to be burned inside like the Scaled Furnace.
-- Any wood-related item will transform into charcoal while other burnable items will transfomr into ash.

-- NOTE: wx._stacksize_modules is being reused here because it already takes into account the Spatializer Circuit as well!
-- That means no extra shit to deal with choosing a valid inventory slot and whatever it needs too.
local function CookerAddedToOwner(inst, wx, isloading)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_modules = (wx._stacksize_modules or 0) + 1

		if not isloading then
			local invslot = inventory:GetNumSlots() - (wx._stacksize_modules - 1)
			local itemtomove = inventory:GetItemInSlot(invslot)

			if itemtomove and itemtomove.components.inventoryitem.islockedinslot then
				if itemtomove.prefab == "kyno_wx78_inventorycooker" then
					itemtomove:SetPowered(false)
				end

				return
			end

			local chargelevel = wx.components.upgrademoduleowner:GetChargeLevel()

			if chargelevel < wx._stacksize_modules then
				if wx.components.inventory then
					wx.components.inventory:DropItem(itemtomove, true, true)
				else
					wx.components.container:DropItemBySlot(invslot)
				end

				itemtomove = nil
			else
				itemtomove = inventory:RemoveItem(itemtomove, true)
			end

			local container = SpawnPrefab("kyno_wx78_inventorycooker")

			inventory:GiveItem(container, invslot)
			container.components.inventoryitem.islockedinslot = true

			if itemtomove then
				container.components.container:GiveItem(itemtomove)
			end
		end
	end
end

local function CookerRemovedFromOwner(inst, wx)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_modules = (wx._stacksize_modules or 1) - 1

		local invslot = inventory:GetNumSlots() - wx._stacksize_modules
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorycooker" and not container._backupbody_transferring then
			container.components.inventoryitem.islockedinslot = false
			inventory:DropItem(container)
		end
	end
end

local function CookerActivate(inst, wx, isloading)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_active_modules = (wx._stacksize_active_modules or 0) + 1

		local invslot = inventory:GetNumSlots() - (wx._stacksize_active_modules - 1)
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorycooker" then
			container:SetPowered(true)
		end
	end
end

local function CookerDeactivate(inst, wx)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_active_modules = (wx._stacksize_active_modules or 1) - 1

		local invslot = inventory:GetNumSlots() - wx._stacksize_active_modules
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorycooker" then
			container:SetPowered(false)
		end
	end
end

local COOKER_MODULE_DATA =
{
	name                = "cooker",
	slots               = 1,
	type                = CIRCUIT_BARS.BETA,
	activatefn          = CookerActivate,
	deactivatefn        = CookerDeactivate,
	addedtoownerfn      = CookerAddedToOwner,
	removedfromownerfn  = CookerRemovedFromOwner,
	overridebank        = "kyno_wx78_chips",
	overridebuild       = "kyno_wx78_chips",
	overrideminiuibuild = "kyno_wx78_status",
	overrideuibuild     = "kyno_wx78_status_chest",

	extra_prefabs       = { "kyno_wx78_inventorycooker" },
}

table.insert(hof_module_definitions, COOKER_MODULE_DATA)

-- Dessicant Circuit.
-- Grants an inventory container that can dry items.
-- Beta Circuits Tinkering II provides 25% waterprofness.

-- NOTE: wx._stacksize_modules is being reused here because it already takes into account the Spatializer Circuit as well!
-- That means no extra shit to deal with choosing a valid inventory slot and whatever it needs too.
local function DryerOnUpdate(wx)
	local chips = wx._dryerchips or 0

	if IsSkillActivated(wx, "wx78_circuitry_betabuffs_2") then
		if wx.components.moisture ~= nil then
			wx.components.moisture.waterproofnessmodifiers:SetModifier(inst, TUNING.KYNO_WX78_MODULES_DRYER_WATERPROOFNESS)
		end
	else
		if wx.components.moisture ~= nil then
			wx.components.moisture.waterproofnessmodifiers:RemoveModifier(inst)
		end
	end
end

local function DryerSkillActivate(inst, wx)
	DryerOnUpdate(wx)
end

local function DryerSkillDeactivate(inst, wx)
	DryerOnUpdate(wx)
end

local function DryerAddedToOwner(inst, wx, isloading)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_modules = (wx._stacksize_modules or 0) + 1

		if not isloading then
			local invslot = inventory:GetNumSlots() - (wx._stacksize_modules - 1)
			local itemtomove = inventory:GetItemInSlot(invslot)

			if itemtomove and itemtomove.components.inventoryitem.islockedinslot then
				if itemtomove.prefab == "kyno_wx78_inventorydryer" then
					itemtomove:SetPowered(false)
				end

				return
			end

			local chargelevel = wx.components.upgrademoduleowner:GetChargeLevel()

			if chargelevel < wx._stacksize_modules then
				if wx.components.inventory then
					wx.components.inventory:DropItem(itemtomove, true, true)
				else
					wx.components.container:DropItemBySlot(invslot)
				end

				itemtomove = nil
			else
				itemtomove = inventory:RemoveItem(itemtomove, true)
			end

			local container = SpawnPrefab("kyno_wx78_inventorydryer")

			inventory:GiveItem(container, invslot)
			container.components.inventoryitem.islockedinslot = true

			if itemtomove then
				container.components.container:GiveItem(itemtomove)
			end
		end
	end
end

local function DryerRemovedFromOwner(inst, wx)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_modules = (wx._stacksize_modules or 1) - 1

		local invslot = inventory:GetNumSlots() - wx._stacksize_modules
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorydryer" and not container._backupbody_transferring then
			container.components.inventoryitem.islockedinslot = false
			inventory:DropItem(container)
		end
	end
end

local function DryerActivate(inst, wx, isloading)
	wx._dryerchips = (wx._dryerchips or 0) + 1

	DryerOnUpdate(wx)

	if wx._dryerchips == 1 then
		Circuit_SetUpSkillCb(inst, wx, "wx78_circuitry_betabuffs_2", DryerSkillActivate, DryerSkillDeactivate)
	end

	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_active_modules = (wx._stacksize_active_modules or 0) + 1

		local invslot = inventory:GetNumSlots() - (wx._stacksize_active_modules - 1)
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorydryer" then
			container:SetPowered(true)
		end
	end
end

local function DryerDeactivate(inst, wx)
	wx._dryerchips = math.max(0, (wx._dryerchips or 1) - 1)

	DryerOnUpdate(wx)

	if wx._dryerchips <= 0 then
		Circuit_DestroySkillCb(inst, wx)
	end

	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_active_modules = (wx._stacksize_active_modules or 1) - 1

		local invslot = inventory:GetNumSlots() - wx._stacksize_active_modules
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorydryer" then
			container:SetPowered(false)
		end
	end
end

local DRYER_MODULE_DATA =
{
	name                = "dryer",
	slots               = 3,
	type                = CIRCUIT_BARS.BETA,
	activatefn          = DryerActivate,
	deactivatefn        = DryerDeactivate,
	addedtoownerfn      = DryerAddedToOwner,
	removedfromownerfn  = DryerRemovedFromOwner,
	overridebank        = "kyno_wx78_chips",
	overridebuild       = "kyno_wx78_chips",
	overrideminiuibuild = "kyno_wx78_status",
	overrideuibuild     = "kyno_wx78_status_chest",

	extra_prefabs       = { "kyno_wx78_inventorydryer" },
}

table.insert(hof_module_definitions, DRYER_MODULE_DATA)

-- Super-Dessicant Circuit.
-- Grants an inventory container that can dry items.
-- Beta Circuits Tinkering II provides 50% waterproofness and allows dried items to produce Salt Crystals.

-- NOTE: wx._stacksize_modules is being reused here because it already takes into account the Spatializer Circuit as well!
-- That means no extra shit to deal with choosing a valid inventory slot and whatever it needs too.
local function OnStartRain(wx)
	wx:PushEvent("wx78moistureimmune")
end

local function Dryer2OnUpdate(wx)
	local chips = wx._dryer2chips or 0

	if IsSkillActivated(wx, "wx78_circuitry_betabuffs_2") then
		if wx.components.moisture ~= nil then
			wx.components.moisture.waterproofnessmodifiers:SetModifier(inst, TUNING.KYNO_WX78_MODULES_DRYER2_WATERPROOFNESS)
		end

		if chips >= 2 then
			wx:WatchWorldState("startrain", OnStartRain)

			if wx.components.moisture ~= nil then
				wx.components.moisture:ForceDry(true, wx)
			end
		end
	else
		if wx.components.moisture ~= nil then
			wx.components.moisture.waterproofnessmodifiers:RemoveModifier(inst)
		end

		if chips < 2 then
			wx:StopWatchingWorldState("startrain", OnStartRain)
		end
	end
end

local function Dryer2SkillActivate(inst, wx)
	Dryer2OnUpdate(wx)
end

local function Dryer2SkillDeactivate(inst, wx)
	Dryer2OnUpdate(wx)
end

local function Dryer2AddedToOwner(inst, wx, isloading)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_modules = (wx._stacksize_modules or 0) + 1

		if not isloading then
			local invslot = inventory:GetNumSlots() - (wx._stacksize_modules - 1)
			local itemtomove = inventory:GetItemInSlot(invslot)

			if itemtomove and itemtomove.components.inventoryitem.islockedinslot then
				if itemtomove.prefab == "kyno_wx78_inventorydryer2" then
					itemtomove:SetPowered(false)
				end

				return
			end

			local chargelevel = wx.components.upgrademoduleowner:GetChargeLevel()

			if chargelevel < wx._stacksize_modules then
				if wx.components.inventory then
					wx.components.inventory:DropItem(itemtomove, true, true)
				else
					wx.components.container:DropItemBySlot(invslot)
				end

				itemtomove = nil
			else
				itemtomove = inventory:RemoveItem(itemtomove, true)
			end

			local container = SpawnPrefab("kyno_wx78_inventorydryer2")

			inventory:GiveItem(container, invslot)
			container.components.inventoryitem.islockedinslot = true

			if itemtomove then
				container.components.container:GiveItem(itemtomove)
			end
		end
	end
end

local function Dryer2RemovedFromOwner(inst, wx)
	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_modules = (wx._stacksize_modules or 1) - 1

		local invslot = inventory:GetNumSlots() - wx._stacksize_modules
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorydryer2" and not container._backupbody_transferring then
			container.components.inventoryitem.islockedinslot = false
			inventory:DropItem(container)
		end
	end
end

local function Dryer2Activate(inst, wx, isloading)
	wx._dryer2chips = (wx._dryer2chips or 0) + 1

	Dryer2OnUpdate(wx)

	if wx._dryer2chips == 1 then
		Circuit_SetUpSkillCb(inst, wx, "wx78_circuitry_betabuffs_2", Dryer2SkillActivate, Dryer2SkillDeactivate)
	end

	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_active_modules = (wx._stacksize_active_modules or 0) + 1

		local invslot = inventory:GetNumSlots() - (wx._stacksize_active_modules - 1)
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorydryer2" then
			container:SetPowered(true)
		end
	end
end

local function Dryer2Deactivate(inst, wx)
	wx._dryer2chips = math.max(0, (wx._dryer2chips or 1) - 1)

	Dryer2OnUpdate(wx)

	if wx._dryer2chips <= 0 then
		Circuit_DestroySkillCb(inst, wx)
	end

	local inventory = wx.components.inventory or wx.components.container

	if inventory then
		wx._stacksize_active_modules = (wx._stacksize_active_modules or 1) - 1

		local invslot = inventory:GetNumSlots() - wx._stacksize_active_modules
		local container = inventory:GetItemInSlot(invslot)

		if container and container.prefab == "kyno_wx78_inventorydryer2" then
			container:SetPowered(false)
		end
	end
end

local DRYER2_MODULE_DATA =
{
	name                = "dryer2",
	slots               = 2,
	type                = CIRCUIT_BARS.BETA,
	activatefn          = Dryer2Activate,
	deactivatefn        = Dryer2Deactivate,
	addedtoownerfn      = Dryer2AddedToOwner,
	removedfromownerfn  = Dryer2RemovedFromOwner,
	overridebank        = "kyno_wx78_chips",
	overridebuild       = "kyno_wx78_chips",
	overrideminiuibuild = "kyno_wx78_status",
	overrideuibuild     = "kyno_wx78_status_chest",

	extra_prefabs       = { "kyno_wx78_inventorydryer2" },
}

table.insert(hof_module_definitions, DRYER2_MODULE_DATA)

-- New scannable creatures.
local WX78_HOF_CREATURES_SCAN =
{
	-- Gourmand Circuit
	-- I'm going to use critters for the gourmand circuit since the little shits keep asking for food.
	critter_kitten           = { module = "gourmand", maxdata = 3 },
	critter_puppy            = { module = "gourmand", maxdata = 3 },
	critter_lamb             = { module = "gourmand", maxdata = 3 },
	critter_dragonling       = { module = "gourmand", maxdata = 3 },
	critter_glomling         = { module = "gourmand", maxdata = 3 },
	critter_perdling         = { module = "gourmand", maxdata = 3 },
	critter_lunarmothling    = { module = "gourmand", maxdata = 3 },
	critter_eyeofterror      = { module = "gourmand", maxdata = 3 },
	critter_bulbin           = { module = "gourmand", maxdata = 3 },
	critter_eets             = { module = "gourmand", maxdata = 3 },
	wobysmall                = { module = "gourmand", maxdata = 4 }, -- Woby because she's cute.
	kyno_serenityisland_shop = { module = "gourmand", maxdata = 5 },

	-- Combustion Circuit
	lavae                    = { module = "cooker",   maxdata = 5 },
	lavae_pet                = { module = "cooker",   maxdata = 3 },

	-- Desiccant Circuit
	cookiecutter             = { module = "dryer",    maxdata = 3 },

	-- Super-Desiccant Circuit
	salty_dog                = { module = "dryer2",   maxdata = 4 },
}

-- Register the new circuits and scannable creatures.
for creature, data in pairs(WX78_HOF_CREATURES_SCAN) do
	WX78_MODULES_DEF.AddCreatureScanDataDefinition(creature, data.module, data.maxdata)
end

for i, definition in ipairs(hof_module_definitions) do
	local module_def = hof_module_definitions[i]

	WX78_MODULES_DEF.AddNewModuleDefinition(definition)
	table.insert(WX78_MODULES_DEF.module_definitions, module_def)
end