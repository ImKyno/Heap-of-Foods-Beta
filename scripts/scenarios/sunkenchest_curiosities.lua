local chestfunctions = require("scenarios/chestfunctions")

local function GetRandomAmount2to4()
	return math.random(2, 4)
end

local function GetRandomAmount1to3()
	return math.random(1, 3)
end

local function InitFn(item)
	if item.components.fueled ~= nil then
		item.components.fueled:SetPercent(GetRandomMinMax(.9, 1))
    elseif item.components.finiteuses ~= nil then
		item.components.finiteuses:SetUses(math.ceil(GetRandomMinMax(.8, 1) * item.components.finiteuses.total))
	elseif item.components.perishable ~= nil then
		local min, max = 0.60, 1.0
		local freshness = math.random() * (max - min) + min
		item.components.perishable:SetPercent(freshness)
    end
end

local LOOT =
{
	{
		item   = { "seafoodgumbo", "barnaclestuffedfishhead" },
		chance = 1.00,
		count  = GetRandomAmount2to4,
		initfn = InitFn,
	},
	{
		item   = "chum",
		chance = 1.00,
		count  = GetRandomAmount1to3,
    },
	{
		item   = "trinket_4",
		chance = 0.85,
		count  = 1,
	},
	{
		item   = "trinket_13",
		chance = 0.85,
		count  = 1,
	},
	{
		item   = { "panflute", "onemanband" },
		chance = 0.50,
		count  = 1,
		initfn = InitFn,
	},
	{
		item   = "messagebottleempty",
		chance = 0.50,
		count  = GetRandomAmount2to4,
	},
	{
		item   = "trinket_5",
		chance = 0.25,
		count  = 1,
    },
    {
		item   = "trinket_11",
		chance = 0.25,
		count  = 1,
    },
	{
		item   = "krampus_sack", -- Let me know if you get one from here, I'll give you a reward.
		chance = 0.01,
		count  = 1,
	},
}

local function OnCreate(inst, scenariorunner)
	chestfunctions.AddChestItems(inst, LOOT)
end

return
{
	OnCreate  = OnCreate,
}