local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("hof_upvaluehacker")

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
		worlds       = { "caves" },
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
	
	wobster_moonglass_land =
	{
		roe_prefab   = "kyno_roe_wobster_moonglass",
		baby_prefab  = "wobster_moonglass_land",
		
		roe_time     = TUNING.WOBSTER_ROETIME,
		baby_time    = TUNING.WOBSTER_BABYTIME,
		
		phases       = { "night" },
		moonphases   = { "full" },
		seasons      = ALL_SEASONS,
		worlds       = { "forest" },
	},
	
	--[[
	kyno_wobster_moonquay_land =
	{
		roe_prefab   = "kyno_roe_wobster_moonquay",
		baby_prefab  = "kyno_wobster_moonquay_land",
		
		roe_time     = TUNING.WOBSTER_MOONQUAY_ROETIME,
		baby_time    = TUNING.WOBSTER_MOONQUAY_BABYTIME,
		
		seasons      = {"autumn", "summer"},
	},
	]]--
	
	kyno_neonfish    =
	{
		roe_prefab   = "kyno_roe_neonfish",
		baby_prefab  = "kyno_neonfish",
		
		roe_time     = TUNING.NEONFISH_ROETIME,
		baby_time    = TUNING.NEONFISH_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = { "winter" },
		worlds       = { "forest" },
	},
	
	kyno_pierrotfish =
	{
		roe_prefab   = "kyno_roe_pierrotfish",
		baby_prefab  = "kyno_pierrotfish",
		
		roe_time     = TUNING.PIERROTFISH_ROETIME,
		baby_time    = TUNING.PIERROTFISH_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = { "spring" },
		worlds       = { "forest" },
	},
	
	kyno_grouper     =
	{
		roe_prefab   = "kyno_roe_grouper",
		baby_prefab  = "kyno_grouper",
		
		roe_time     = TUNING.GROUPER_ROETIME,
		baby_time    = TUNING.GROUPER_BABYTIME,
		
		phases       = { "dusk", "night" },
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = { "forest" },
	},
	
	kyno_tropicalfish =
	{
		roe_prefab   = "kyno_roe_tropicalfish",
		baby_prefab  = "kyno_tropicalfish",
		
		roe_time     = TUNING.TROPICALFISH_ROETIME,
		baby_time    = TUNING.TROPICALFISH_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = { "autumn" },
		worlds       = { "forest" },
	},
	
	--[[
	kyno_jellyfish   =
	{
		roe_prefab   = "kyno_roe_jellyfish",
		baby_prefab  = "kyno_jellyfish",
		
		roe_time     = TUNING.JELLYFISH_ROETIME,
		baby_time    = TUNING.JELLYFISH_BABYTIME,
		
		seasons      = ALL_SEASONS,
	},
	
	kyno_jellyfish_rainbow =
	{
		roe_prefab   = "kyno_roe_jellyfish_rainbow",
		baby_prefab  = "kyno_jellyfish_rainbow",
		
		roe_time     = TUNING.JELLYFISH_RAINBOW_ROETIME,
		baby_time    = TUNING.JELLYFISH_RAINBOW_BABYTIME,
		
		seasons      = ALL_SEASONS,
	},
	]]--
	
	kyno_salmonfish  =
	{
		roe_prefab   = "kyno_roe_salmonfish",
		baby_prefab  = "kyno_salmonfish",
		
		roe_time     = TUNING.SALMONFISH_ROETIME,
		baby_time    = TUNING.SALMONFISH_BABYTIME,
		
		phases       = { "day", "dusk" },
		moonphases   = ALL_MOONPHASES,
		seasons      = ALL_SEASONS,
		worlds       = ALL_WORLDS,
	},
	
	kyno_koi         =
	{
		roe_prefab   = "kyno_roe_koi",
		baby_prefab  = "kyno_koi",
		
		roe_time     = TUNING.TROPICALKOI_ROETIME,
		baby_time    = TUNING.TROPICALKOI_BABYTIME,
		
		phases       = ALL_PHASES,
		moonphases   = ALL_MOONPHASES,
		seasons      = { "summer" },
		worlds       = ALL_WORLDS,
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
	inst:AddTag("fishfarmable")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("fishfarmable")
	
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

-- Make some items a valid fuel for the Fish Hatchery.
local fishfoods =
{
	chum =
	{
		fuelvalue = TUNING.HUGE_FUEL,
	},
	
	barnacle =
	{
		fuelvalue = TUNING.LARGE_FUEL,
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