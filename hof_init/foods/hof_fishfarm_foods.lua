local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("hof_upvaluehacker")

require("hof_constants")

--[[
	{
		roe_time =
		roe_prefab =
		
		baby_time =
		baby_prefab =
	},
]]--

local ALL_SEASONS   = { "autumn", "winter", "spring", "summer" }

local fishes        =
{
	pondfish        =
	{
		roe_prefab  = "kyno_roe",
		baby_prefab = "pondfish",
	
		roe_time    = TUNING.PONDFISH_ROETIME,
		baby_time   = TUNING.PONDFISH_BABYTIME,
		
		seasons     = ALL_SEASONS,
	},
	
	pondeel         =
	{
		roe_prefab  = "unagi",
		baby_prefab = "pondeel",
		
		roe_time    = TUNING.PONDEEL_ROETIME,
		baby_time   = TUNING.PONDEEL_BABYTIME,
		
		seasons     = ALL_SEASONS,
	},
}

local function FishFarmablePostInit(inst)
	inst:AddTag("fishfarmable")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fishfarmable")
	
	entry = fishes[inst.prefab]
	if entry then
		inst.components.fishfarmable:SetTimes(entry.roe_time, entry.baby_time)
		inst.components.fishfarmable:SetProducts(entry.roe_prefab, entry.baby_prefab)
		inst.components.fishfarmable:SetSeasons(entry.seasons)
	end
end

for k, v in pairs(fishes) do
	AddPrefabPostInit(k, FishFarmablePostInit)
end

-- Make some items a valid fuel for the Fish Hatchery.
local fishfoods =
{
	chum =
	{
		fuelvalue = TUNING.LARGE_FUEL * 2,
	},
	
	barnacle =
	{
		fuelvalue = TUNING.MED_FUEL * 1.5,
	},
	
	kelp =
	{
		fuelvalue = TUNING.MED_FUEL,
	},
	
	seeds =
	{
		fuelvalue = TUNING.SMALL_FUEL,
	},
}

local function FishFoodPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if not inst.components.fuel then
		inst:AddComponent("fuel")
	end
	
	entry = fishfoods[inst.prefab]
	if inst.components.fuel then
		if entry then
			inst.components.fuel.fueltype = _G.FUELTYPE.FISHFOOD
			inst.components.fuel.fuelvalue = entry.fuelvalue
		end
	end
end

for k, v in pairs(fishfoods) do
	AddPrefabPostInit(k, FishFoodPostInit)
end