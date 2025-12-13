local _G           = GLOBAL
local require      = _G.require

local trinkets     =
{
	antliontrinket =
	{
		octopusvalue = TUNING.OCTOPUS_VALUES.ANTLIONTRINKET
	},
	
	cotl_trinket   =
	{
		octopusvalue = TUNING.OCTOPUS_VALUES.COTLTRINKET
	},
}

local seafoods     =
{
	"barnacle",
	"barnacle_cooked",
	"eel",
	"eel_cooked",
	"fish",
	"fish_cooked",
	"fishmeat",
	"fishmeat_cooked",
	"fishmeat_dried",
	"fishmeat_small",
	"fishmeat_small_cooked",
	"fishmeat_small_dried",
	"oceanfish_medium_1_inv",
	"oceanfish_medium_2_inv",
	"oceanfish_medium_3_inv",
	"oceanfish_medium_4_inv",
	"oceanfish_medium_5_inv",
	"oceanfish_medium_6_inv",
	"oceanfish_medium_7_inv",
	"oceanfish_medium_8_inv",
	"oceanfish_medium_9_inv",
	"oceanfish_small_1_inv",
	"oceanfish_small_2_inv",
	"oceanfish_small_3_inv",
	"oceanfish_small_4_inv",
	"oceanfish_small_5_inv",
	"oceanfish_small_6_inv",
	"oceanfish_small_7_inv",
	"oceanfish_small_8_inv",
	"oceanfish_small_9_inv",
	"pondeel",
	"pondfish",
	"wobster_moonglass_land",
	"wobster_sheller_dead",
	"wobster_sheller_dead_cooked",
	"wobster_sheller_land",
}

local function OctopusValuesTrinketPostInit(inst)
	inst:AddTag("hof_trinket")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.tradable ~= nil then
		entry = trinkets[inst.prefab]
		
		if entry then
			inst.components.tradable.octopusvalue = entry.octopusvalue
		end
	end
end

local function OctopusValuesSeafoodPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.tradable ~= nil then
		inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	end
end

for i = 1, _G.NUM_TRINKETS do
	AddPrefabPostInit("trinket_"..i, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		if inst.components.tradable ~= nil then
			inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.TRINKETS[i] or 3
		end
	end)
end

for k, v in pairs(trinkets) do
	AddPrefabPostInit(k, OctopusValuesTrinketPostInit)
end

for k, v in pairs(seafoods) do
	AddPrefabPostInit(v, OctopusValuesSeafoodPostInit)
end

-- Apparels Overload support.
if TUNING.HOF_IS_TCP_ENABLED then
	TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot["gorge_fishball_skewers"] = "piratehat"
	TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot["gorge_fishburger"]       = "captainhat"
	TUNING.OCTOPUSKING_OCEAN_LOOT.chestloot["wobstermonster"]         = "armorlifejacket"
end