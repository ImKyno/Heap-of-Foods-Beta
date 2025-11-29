local chestfunctions = require("scenarios/chestfunctions")

local function GetRandomAmount4to6()
	return math.random(4, 6)
end

local function GetRandomAmount2to4()
	return math.random(2, 4)
end

local function InitFn(item)
	if item.components.fueled ~= nil then
		item.components.fueled:SetPercent(GetRandomMinMax(.9, 1))
    elseif item.components.finiteuses ~= nil then
		item.components.finiteuses:SetUses(math.ceil(GetRandomMinMax(.8, 1) * item.components.finiteuses.total))
	elseif item.components.perishable ~= nil then
		local min, max = 0.33, 1.0
		local freshness = math.random() * (max - min) + min
		item.components.perishable:SetPercent(freshness)
    end
end

local LOOT =
{
	{
		item   = "kyno_oceantrap",
		chance = 1.00,
		count  = 1,
	},
	{
		item   = "boat_ancient_item",
		chance = 1.00,
		count  = 1,
	},
	{
		item   = "gnarwail_horn",
		chance = 1.00,
		count  = 1,
	},
	{
		item   = "antliontrinket",
		chance = 1.00,
		count  = 1,
	},
	{
		item   = "chum",
		chance = 1.00,
		count  = 5,
	},
	{
		item   = "ancienttree_seed",
		chance = 1.00,
		count  = 1,
	},
	{
		item   = "stash_map",
		chance = 1.00,
		count  = GetRandomAmount2to4,
	},
	{
		item   = "bootleg",
		chance = 1.00,
		count  = GetRandomAmount4to6,
	},
}

local function OnCreate(inst, scenariorunner)
	chestfunctions.AddChestItems(inst, LOOT)
end

return
{
	OnCreate  = OnCreate,
}