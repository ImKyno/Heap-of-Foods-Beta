local _G                 = GLOBAL
local require            = _G.require
local UpvalueHacker      = require("hof_upvaluehacker")
local FISHREGISTRY_DEFS  = require("prefabs/k_fishregistry_defs").FISHREGISTRY_DEFS

require("hof_constants")

--[[
	{
		roe_prefab   =
		baby_prefab  =
		
		roe_time     =
		baby_time    =
		
		phases       =
		moonphases   =
		seasons      =
		worlds       =
	},
]]--

local ALL_PHASES     = { "day", "dusk", "night" }
local ALL_MOONPHASES = { "new", "quarter", "half", "threequarter", "full" }
local ALL_SEASONS    = { "autumn", "winter", "spring", "summer" }
local ALL_WORLDS     = { "forest", "cave" }

local fishes         =
{
	pondfish         =
	{
		roe_prefab   = "kyno_roe_pondfish",
		baby_prefab  = "pondfish",
	
		roe_time     = TUNING.PONDFISH_ROETIME,
		baby_time    = TUNING.PONDFISH_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	pondeel          =
	{
		roe_prefab   = "kyno_roe_pondeel",
		baby_prefab  = "pondeel",
		
		roe_time     = TUNING.PONDEEL_ROETIME,
		baby_time    = TUNING.PONDEEL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = { "cave" },
	},
	
	wobster_sheller_land =
	{
		roe_prefab   = "kyno_roe_wobster",
		baby_prefab  = "wobster_sheller_land",
		
		roe_time     = TUNING.WOBSTER_ROETIME,
		baby_time    = TUNING.WOBSTER_BABYTIME,
		
		phases       = { "dusk", "night" },
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	-- There's no moon in Caves, so this fish shouldn't work there.
	-- Locking it to Forest only will prevent it from doing so.
	wobster_moonglass_land =
	{
		roe_prefab   = "kyno_roe_wobster_moonglass",
		baby_prefab  = "wobster_moonglass_land",
		
		roe_time     = TUNING.WOBSTER_MOONGLASS_ROETIME,
		baby_time    = TUNING.WOBSTER_MOONGLASS_BABYTIME,
		
		phases       = { "night" },
		moonphases   = { "full" },
		seasons      = ALL_SEASONS,
		worlds       = { "forest" },
	},

	oceanfish_small_1_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_1",
		baby_prefab  = "oceanfish_small_1_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_2_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_2",
		baby_prefab  = "oceanfish_small_2_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_3_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_3",
		baby_prefab  = "oceanfish_small_3_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_4_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_4",
		baby_prefab  = "oceanfish_small_4_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_5_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_5",
		baby_prefab  = "oceanfish_small_5_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_6_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_6",
		baby_prefab  = "oceanfish_small_6_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = { "autumn" },
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_7_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_7",
		baby_prefab  = "oceanfish_small_7_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = { "dusk" },
		moonphases   = ALL_MOONPHASES,
		seasons      = { "spring" },
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_8_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_8",
		baby_prefab  = "oceanfish_small_8_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = { "day" },
		moonphases   = ALL_MOONPHASES,
		seasons      = { "summer" },
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_small_9_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_small_9",
		baby_prefab  = "oceanfish_small_9_inv",
		
		roe_time     = TUNING.OCEANFISH_SMALL_ROETIME,
		baby_time    = TUNING.OCEANFISH_SMALL_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_1_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_1",
		baby_prefab  = "oceanfish_medium_1_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_2_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_2",
		baby_prefab  = "oceanfish_medium_2_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_3_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_3",
		baby_prefab  = "oceanfish_medium_3_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_4_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_4",
		baby_prefab  = "oceanfish_medium_4_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_5_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_5",
		baby_prefab  = "oceanfish_medium_5_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_6_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_6",
		baby_prefab  = "oceanfish_medium_6_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_7_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_7",
		baby_prefab  = "oceanfish_medium_7_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_8_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_8",
		baby_prefab  = "oceanfish_medium_8_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = { "night" },
		moonphases   = ALL_MOONPHASES,
		seasons      = { "winter" },
		worlds       = ALL_WORLDS,
	},
	
	oceanfish_medium_9_inv =
	{
		roe_prefab   = "kyno_roe_oceanfish_medium_9",
		baby_prefab  = "oceanfish_medium_9_inv",
		
		roe_time     = TUNING.OCEANFISH_MEDIUM_ROETIME,
		baby_time    = TUNING.OCEANFISH_MEDIUM_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
}

local function FishFarmablePostInit(inst)
	local function GetFishKey(inst)
		return inst.prefab
	end

	local function fishresearchfn(inst)
		return inst:GetFishKey()
	end

	inst:AddTag("fishfarmable")
	inst:AddTag("fishresearchable")

	inst.GetFishKey = GetFishKey
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fishfarmable")
	
	inst:AddComponent("fishresearchable")
	inst.components.fishresearchable:SetResearchFn(fishresearchfn)
	
	entry = fishes[inst.prefab]
	if entry then
		inst.components.fishfarmable:SetTimes(entry.roe_time, entry.baby_time)
		inst.components.fishfarmable:SetProducts(entry.roe_prefab, entry.baby_prefab)
		inst.components.fishfarmable:SetPhases(entry.phases)
		inst.components.fishfarmable:SetMoonPhases(entry.moonphases)
		inst.components.fishfarmable:SetSeasons(entry.seasons)
		inst.components.fishfarmable:SetWorlds(entry.worlds)
	end
end

for k, v in pairs(fishes) do
	AddPrefabPostInit(k, FishFarmablePostInit)
end

-- Make Fish Food a valid fuel for the Fish Hatchery.
local function ChumPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if not inst.components.fuel then
		inst:AddComponent("fuel")
	end
	
	if inst.components.fuel ~= nil then
		inst.components.fuel.fueltype = _G.FUELTYPE.FISHFOOD
		inst.components.fuel.fuelvalue = TUNING.HUGE_FUEL
	end
end

AddPrefabPostInit("chum", ChumPostInit)