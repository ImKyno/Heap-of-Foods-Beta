local _G = GLOBAL

local SEAFOODS =
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

local function SeafoodPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.tradable ~= nil then
		inst.components.tradable.octopusvalue = TUNING.OCTOPUS_VALUES.SEAFOOD
	end
end

for k, v in pairs(SEAFOODS) do
	AddPrefabPostInit(v, SeafoodPostInit)
end