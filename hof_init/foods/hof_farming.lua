-- New Veggie System to match the R.W.Y.S update. Metatable Source: https://steamcommunity.com/workshop/filedetails/?id=2511339795
-- New Farm Plants. Source: https://forums.kleientertainment.com/forums/topic/126286-template-adding-farm-plants-to-the-game/
local _G = GLOBAL
_G.setmetatable(env, {__index=function(t, k) return _G.rawget(_G, k) end})

_G.KYNO_VEGGIES 	= {}
_G.KYNO_FARM_PLANTS = {}

AddSimPostInit(function()
    if VEGGIES ~= nil then
        for k, v in pairs(KYNO_VEGGIES) do
            VEGGIES[k] = v
        end
    end
end)

local function AddNewVeggie(name, veggie_health, veggie_hunger, veggie_sanity ,veggie_perish, veggie_cooked_health,
veggie_cooked_hunger, veggie_cooked_sanity, veggie_cooked_perish, chance)
    KYNO_VEGGIES[name]        =
	{
        health                = veggie_health,
        hunger                = veggie_hunger,
        sanity                = veggie_sanity,
        perishtime            = veggie_perish,
        float_settings        = {"small", 0.2, 0.9},

        cooked_health         = veggie_cooked_health,
        cooked_hunger         = veggie_cooked_hunger,
        cooked_sanity         = veggie_cooked_sanity,
        cooked_perishtime     = veggie_cooked_perish,
        cooked_float_settings = {"small", 0.2, 1},

        seed_weight           = chance,
    }
end

-- Name, Raw Stats, Raw Perish Time, Cooked Stats, Cooked Perish Time, Seed Chance.
AddNewVeggie("kyno_aloe",
	TUNING.KYNO_ALOE_HEALTH,
	TUNING.KYNO_ALOE_HUNGER,
	TUNING.KYNO_ALOE_SANITY,
	TUNING.PERISH_MED,
	TUNING.KYNO_ALOE_COOKED_HEALTH,
	TUNING.KYNO_ALOE_COOKED_HUNGER,
	TUNING.KYNO_ALOE_COOKED_SANITY,
	TUNING.PERISH_FAST,
	TUNING.SEED_CHANCE_RARE
)

AddNewVeggie("kyno_cucumber",
	TUNING.KYNO_CUCUMBER_HEALTH,
	TUNING.KYNO_CUCUMBER_HUNGER,
	TUNING.KYNO_CUCUMBER_SANITY,
	TUNING.PERISH_MED,
	TUNING.KYNO_CUCUMBER_COOKED_HEALTH,
	TUNING.KYNO_CUCUMBER_COOKED_HUNGER,
	TUNING.KYNO_CUCUMBER_COOKED_SANITY,
	TUNING.PERISH_FAST,
	TUNING.SEED_CHANCE_COMMON
)

AddNewVeggie("kyno_fennel",
	TUNING.KYNO_FENNEL_HEALTH,
	TUNING.KYNO_FENNEL_HUNGER,
	TUNING.KYNO_FENNEL_SANITY,
	TUNING.PERISH_MED,
	TUNING.KYNO_FENNEL_COOKED_HEALTH,
	TUNING.KYNO_FENNEL_COOKED_HUNGER,
	TUNING.KYNO_FENNEL_COOKED_SANITY,
	TUNING.PERISH_FAST,
	TUNING.SEED_CHANCE_RARE
)

AddNewVeggie("kyno_parznip",
	TUNING.KYNO_PARZNIP_HEALTH,
	TUNING.KYNO_PARZNIP_HUNGER,
	TUNING.KYNO_PARZNIP_SANITY,
	TUNING.PERISH_MED,
	TUNING.KYNO_PARZNIP_COOKED_HEALTH,
	TUNING.KYNO_PARZNIP_COOKED_HUNGER,
	TUNING.KYNO_PARZNIP_COOKED_SANITY,
	TUNING.PERISH_FAST,
	TUNING.SEED_CHANCE_UNCOMMON
)

AddNewVeggie("kyno_radish",

	TUNING.KYNO_RADISH_HEALTH,
	TUNING.KYNO_RADISH_HUNGER,
	TUNING.KYNO_RADISH_SANITY,
	TUNING.PERISH_MED,
	TUNING.KYNO_RADISH_COOKED_HEALTH,
	TUNING.KYNO_RADISH_COOKED_HUNGER,
	TUNING.KYNO_RADISH_COOOKED_SANITY,
	TUNING.PERISH_FAST,
	TUNING.SEED_CHANCE_COMMON
)

AddNewVeggie("kyno_rice",
	TUNING.KYNO_RICE_HEALTH,
	TUNING.KYNO_RICE_HUNGER,
	TUNING.KYNO_RICE_SANITY,
	TUNING.PERISH_SLOW,
	TUNING.KYNO_RICE_COOKED_HEALTH,
	TUNING.KYNO_RICE_COOKED_HUNGER,
	TUNING.KYNO_RICE_COOKED_SANITY,
	TUNING.PERISH_MED,
	TUNING.SEED_CHANCE_UNCOMMON
)

AddNewVeggie("kyno_sweetpotato",
	TUNING.KYNO_SWEETPOTATO_HEALTH,
	TUNING.KYNO_SWEETPOTATO_HUNGER,
	TUNING.KYNO_SWEETPOTATO_SANITY,
	TUNING.PERISH_MED,
	TUNING.KYNO_SWEETPOTATO_COOKED_HEALTH,
	TUNING.KYNO_SWEETPOTATO_COOKED_HUNGER,
	TUNING.KYNO_SWEETPOTATO_COOKED_SANITY,
	TUNING.PERISH_FAST,
	TUNING.SEED_CHANCE_UNCOMMON
)

AddNewVeggie("kyno_turnip",
	TUNING.KYNO_TURNIP_HEALTH,
	TUNING.KYNO_TURNIP_HUNGER,
	TUNING.KYNO_TURNIP_SANITY,
	TUNING.PERISH_MED,
	TUNING.KYNO_TURNIP_COOKED_HEALTH,
	TUNING.KYNO_TURNIP_COOKED_HUNGER,
	TUNING.KYNO_TURNIP_COOKED_SANITY,
	TUNING.PERISH_FAST,
	TUNING.SEED_CHANCE_UNCOMMON
)

local PLANT_DEFS        = require("prefabs/farm_plant_defs").PLANT_DEFS
local FRAMES            = _G.FRAMES

-- Grow Time of the Plants.
local function MakeGrowTimes(germination_min, germination_max, full_grow_min, full_grow_max)
	local grow_time     = {}

	grow_time.seed		= {germination_min, germination_max}
	grow_time.sprout	= {full_grow_min * 0.5, full_grow_max * 0.5}
	grow_time.small		= {full_grow_min * 0.3, full_grow_max * 0.3}
	grow_time.med		= {full_grow_min * 0.2, full_grow_max * 0.2}
	grow_time.full		= 4 * TUNING.TOTAL_DAY_TIME
	grow_time.oversized	= 6 * TUNING.TOTAL_DAY_TIME
	grow_time.regrow	= {4 * TUNING.TOTAL_DAY_TIME, 5 * TUNING.TOTAL_DAY_TIME}

	return grow_time
end

-- Water Values the plant should drink.
local DRINK_LOW 	    = TUNING.FARM_PLANT_DRINK_LOW
local DRINK_MED 	    = TUNING.FARM_PLANT_DRINK_MED
local DRINK_HIGH 	    = TUNING.FARM_PLANT_DRINK_HIGH

-- Nutrients Values the plant should use.
local NUTRIENT_LOW 	    = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local NUTRIENT_MED 	    = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local NUTRIENT_HIGH     = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

-- Aloe Plant
PLANT_DEFS.kyno_aloe                             = {build = "farm_plant_kyno_aloe", bank = "farm_plant_potato"}
PLANT_DEFS.kyno_aloe.prefab                      = "farm_plant_kyno_aloe"
PLANT_DEFS.kyno_aloe.product                     = "kyno_aloe"
PLANT_DEFS.kyno_aloe.product_oversized           = "kyno_aloe_oversized"
PLANT_DEFS.kyno_aloe.seed                        = "kyno_aloe_seeds"
PLANT_DEFS.kyno_aloe.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_aloe_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_aloe.family_min_count            = 1
PLANT_DEFS.kyno_aloe.family_check_dist           = 1
PLANT_DEFS.kyno_aloe.plant_type_tag              = "farm_plant_kyno_aloe"
PLANT_DEFS.kyno_aloe.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_aloe.moisture                    = {drink_rate = DRINK_MED, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_aloe.good_seasons                = {autumn = true, winter = true, spring = true}
PLANT_DEFS.kyno_aloe.nutrient_consumption        = {0, NUTRIENT_MED, NUTRIENT_MED}
PLANT_DEFS.kyno_aloe.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_aloe.weight_data                 = { 401.23, 533.08, .11 }
PLANT_DEFS.kyno_aloe.sounds                      = PLANT_DEFS.potato.sounds
PLANT_DEFS.kyno_aloe.nutrient_restoration        = {4, 0, 0}

for i = 1, #PLANT_DEFS.kyno_aloe.nutrient_consumption do
    PLANT_DEFS.kyno_aloe.nutrient_restoration[i] = PLANT_DEFS.kyno_aloe.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_aloe.pictureframeanim            = {anim = "emote_impatient", time = 27 * FRAMES}
PLANT_DEFS.kyno_aloe.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_aloe.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_aloe.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Cucumber Plant
PLANT_DEFS.kyno_cucumber                             = {build = "farm_plant_kyno_cucumber", bank = "farm_plant_pepper"}
PLANT_DEFS.kyno_cucumber.prefab                      = "farm_plant_kyno_cucumber"
PLANT_DEFS.kyno_cucumber.product                     = "kyno_cucumber"
PLANT_DEFS.kyno_cucumber.product_oversized           = "kyno_cucumber_oversized"
PLANT_DEFS.kyno_cucumber.seed                        = "kyno_cucumber_seeds"
PLANT_DEFS.kyno_cucumber.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_cucumber_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_cucumber.family_min_count            = 1
PLANT_DEFS.kyno_cucumber.family_check_dist           = 1
PLANT_DEFS.kyno_cucumber.plant_type_tag              = "farm_plant_kyno_cucumber"
PLANT_DEFS.kyno_cucumber.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_cucumber.moisture                    = {drink_rate = DRINK_HIGH, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_cucumber.good_seasons                = {autumn = true, spring = true, summer = true}
PLANT_DEFS.kyno_cucumber.nutrient_consumption        = {NUTRIENT_LOW, 0, NUTRIENT_LOW}
PLANT_DEFS.kyno_cucumber.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_cucumber.weight_data                 = { 430.23, 585.02, .21 }
PLANT_DEFS.kyno_cucumber.sounds                      = PLANT_DEFS.pepper.sounds
PLANT_DEFS.kyno_cucumber.nutrient_restoration        = {0, 2, 0}

for i = 1, #PLANT_DEFS.kyno_cucumber.nutrient_consumption do
    PLANT_DEFS.kyno_cucumber.nutrient_restoration[i] = PLANT_DEFS.kyno_cucumber.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_cucumber.pictureframeanim            = {anim = "emote_laugh", time = 27 * FRAMES}
PLANT_DEFS.kyno_cucumber.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_cucumber.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_cucumber.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Fennel Plant
PLANT_DEFS.kyno_fennel                             = {build = "farm_plant_kyno_fennel", bank = "farm_plant_asparagus"}
PLANT_DEFS.kyno_fennel.prefab                      = "farm_plant_kyno_fennel"
PLANT_DEFS.kyno_fennel.product                     = "kyno_fennel"
PLANT_DEFS.kyno_fennel.product_oversized           = "kyno_fennel_oversized"
PLANT_DEFS.kyno_fennel.seed                        = "kyno_fennel_seeds"
PLANT_DEFS.kyno_fennel.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_fennel_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_fennel.family_min_count            = 1
PLANT_DEFS.kyno_fennel.family_check_dist           = 1
PLANT_DEFS.kyno_fennel.plant_type_tag              = "farm_plant_kyno_fennel"
PLANT_DEFS.kyno_fennel.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_fennel.moisture                    = {drink_rate = DRINK_MED, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_fennel.good_seasons                = {autumn = true, winter = true}
PLANT_DEFS.kyno_fennel.nutrient_consumption        = {0, 0, NUTRIENT_HIGH}
PLANT_DEFS.kyno_fennel.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_fennel.weight_data                 = { 320.14, 601.34, .18 }
PLANT_DEFS.kyno_fennel.sounds                      = PLANT_DEFS.asparagus.sounds
PLANT_DEFS.kyno_fennel.nutrient_restoration        = {2, 1, 0}

for i = 1, #PLANT_DEFS.kyno_fennel.nutrient_consumption do
    PLANT_DEFS.kyno_fennel.nutrient_restoration[i] = PLANT_DEFS.kyno_fennel.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_fennel.pictureframeanim            = {anim = "emote_loop_carol", time = 27 * FRAMES}
PLANT_DEFS.kyno_fennel.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_fennel.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_fennel.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Parsnip Plant
PLANT_DEFS.kyno_parznip                             = {build = "farm_plant_kyno_parznip", bank = "farm_plant_potato"}
PLANT_DEFS.kyno_parznip.prefab                      = "farm_plant_kyno_parznip"
PLANT_DEFS.kyno_parznip.product                     = "kyno_parznip"
PLANT_DEFS.kyno_parznip.product_oversized           = "kyno_parznip_oversized"
PLANT_DEFS.kyno_parznip.seed                        = "kyno_parznip_seeds"
PLANT_DEFS.kyno_parznip.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_parznip_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_parznip.family_min_count            = 1
PLANT_DEFS.kyno_parznip.family_check_dist           = 1
PLANT_DEFS.kyno_parznip.plant_type_tag              = "farm_plant_kyno_parznip"
PLANT_DEFS.kyno_parznip.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_parznip.moisture                    = {drink_rate = DRINK_MED, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_parznip.good_seasons                = {autumn = true, winter = true, spring = true, summer = true}
PLANT_DEFS.kyno_parznip.nutrient_consumption        = {0, NUTRIENT_HIGH, 0}
PLANT_DEFS.kyno_parznip.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_parznip.weight_data                 = { 401.23, 563.02, .21 }
PLANT_DEFS.kyno_parznip.sounds                      = PLANT_DEFS.potato.sounds
PLANT_DEFS.kyno_parznip.nutrient_restoration        = {2, 0, 2}

for i = 1, #PLANT_DEFS.kyno_parznip.nutrient_consumption do
    PLANT_DEFS.kyno_parznip.nutrient_restoration[i] = PLANT_DEFS.kyno_parznip.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_parznip.pictureframeanim            = {anim = "emote_shrug", time = 27 * FRAMES}
PLANT_DEFS.kyno_parznip.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_parznip.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_parznip.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Radish Plant.
PLANT_DEFS.kyno_radish                             = {build = "farm_plant_kyno_radish", bank = "farm_plant_kyno_radish"}
PLANT_DEFS.kyno_radish.prefab                      = "farm_plant_kyno_radish"
PLANT_DEFS.kyno_radish.product                     = "kyno_radish"
PLANT_DEFS.kyno_radish.product_oversized           = "kyno_radish_oversized"
PLANT_DEFS.kyno_radish.seed                        = "kyno_radish_seeds"
PLANT_DEFS.kyno_radish.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_radish_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_radish.family_min_count            = 1
PLANT_DEFS.kyno_radish.family_check_dist           = 1
PLANT_DEFS.kyno_radish.plant_type_tag              = "farm_plant_kyno_radish"
PLANT_DEFS.kyno_radish.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_radish.moisture                    = {drink_rate = DRINK_LOW, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_radish.good_seasons                = {winter = true, spring = true}
PLANT_DEFS.kyno_radish.nutrient_consumption        = {NUTRIENT_HIGH, 0, 0}
PLANT_DEFS.kyno_radish.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_radish.weight_data                 = { 361.51, 506.04, .28 }
PLANT_DEFS.kyno_radish.sounds                      = PLANT_DEFS.carrot.sounds
PLANT_DEFS.kyno_radish.nutrient_restoration        = {0, 2, 4}

for i = 1, #PLANT_DEFS.kyno_radish.nutrient_consumption do
    PLANT_DEFS.kyno_radish.nutrient_restoration[i] = PLANT_DEFS.kyno_radish.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_radish.pictureframeanim            = {anim = "emoteXL_loop_dance8", time = 27 * FRAMES}
PLANT_DEFS.kyno_radish.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_radish.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_radish.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Rice Stalk.
PLANT_DEFS.kyno_rice                             = {build = "farm_plant_kyno_rice", bank = "farm_plant_kyno_rice"}
PLANT_DEFS.kyno_rice.prefab                      = "farm_plant_kyno_rice"
PLANT_DEFS.kyno_rice.product                     = "kyno_rice"
PLANT_DEFS.kyno_rice.product_oversized           = "kyno_rice_oversized"
PLANT_DEFS.kyno_rice.seed                        = "kyno_rice_seeds"
PLANT_DEFS.kyno_rice.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_rice_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_rice.family_min_count            = 1
PLANT_DEFS.kyno_rice.family_check_dist           = 1
PLANT_DEFS.kyno_rice.plant_type_tag              = "farm_plant_kyno_rice"
PLANT_DEFS.kyno_rice.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_rice.moisture                    = {drink_rate = DRINK_MED, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_rice.good_seasons                = {spring = true, summer = true}
PLANT_DEFS.kyno_rice.nutrient_consumption        = {NUTRIENT_MED, NUTRIENT_MED, 0}
PLANT_DEFS.kyno_rice.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_rice.weight_data                 = { 463.23, 694.20, .21 }
PLANT_DEFS.kyno_rice.sounds                      = PLANT_DEFS.pepper.sounds
PLANT_DEFS.kyno_rice.nutrient_restoration        = {0, 0, 4}

for i = 1, #PLANT_DEFS.kyno_rice.nutrient_consumption do
    PLANT_DEFS.kyno_rice.nutrient_restoration[i] = PLANT_DEFS.kyno_rice.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_rice.pictureframeanim            = {anim = "emoteXL_facepalm", time = 27 * FRAMES}
PLANT_DEFS.kyno_rice.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_rice.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_rice.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Sweet Potato Plant.
PLANT_DEFS.kyno_sweetpotato                             = {build = "farm_plant_kyno_sweetpotato", bank = "farm_plant_kyno_sweetpotato"}
PLANT_DEFS.kyno_sweetpotato.prefab                      = "farm_plant_kyno_sweetpotato"
PLANT_DEFS.kyno_sweetpotato.product                     = "kyno_sweetpotato"
PLANT_DEFS.kyno_sweetpotato.product_oversized           = "kyno_sweetpotato_oversized"
PLANT_DEFS.kyno_sweetpotato.seed                        = "kyno_sweetpotato_seeds"
PLANT_DEFS.kyno_sweetpotato.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_sweetpotato_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_sweetpotato.family_min_count            = 1
PLANT_DEFS.kyno_sweetpotato.family_check_dist           = 1
PLANT_DEFS.kyno_sweetpotato.plant_type_tag              = "farm_plant_kyno_sweetpotato"
PLANT_DEFS.kyno_sweetpotato.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_sweetpotato.moisture                    = {drink_rate = DRINK_LOW, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_sweetpotato.good_seasons                = {winter = true, spring = true, summer = true}
PLANT_DEFS.kyno_sweetpotato.nutrient_consumption        = {0, NUTRIENT_MED, 0}
PLANT_DEFS.kyno_sweetpotato.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_sweetpotato.weight_data                 = { 420.69, 510.07, .28 }
PLANT_DEFS.kyno_sweetpotato.sounds                      = PLANT_DEFS.potato.sounds
PLANT_DEFS.kyno_sweetpotato.nutrient_restoration        = {2, 0, 4}

for i = 1, #PLANT_DEFS.kyno_sweetpotato.nutrient_consumption do
    PLANT_DEFS.kyno_sweetpotato.nutrient_restoration[i] = PLANT_DEFS.kyno_sweetpotato.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_sweetpotato.pictureframeanim            = {anim = "emote_flex", time = 27 * FRAMES}
PLANT_DEFS.kyno_sweetpotato.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_sweetpotato.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_sweetpotato.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Turnip Plant.
PLANT_DEFS.kyno_turnip                             = {build = "farm_plant_kyno_turnip", bank = "farm_plant_kyno_turnip"}
PLANT_DEFS.kyno_turnip.prefab                      = "farm_plant_kyno_turnip"
PLANT_DEFS.kyno_turnip.product                     = "kyno_turnip"
PLANT_DEFS.kyno_turnip.product_oversized           = "kyno_turnip_oversized"
PLANT_DEFS.kyno_turnip.seed                        = "kyno_turnip_seeds"
PLANT_DEFS.kyno_turnip.loot_oversized_rot          = {"spoiled_food", "spoiled_food", "spoiled_food", "kyno_turnip_seeds", "fruitfly", "fruitfly"}
PLANT_DEFS.kyno_turnip.family_min_count            = 1
PLANT_DEFS.kyno_turnip.family_check_dist           = 1
PLANT_DEFS.kyno_turnip.plant_type_tag              = "farm_plant_kyno_turnip"
PLANT_DEFS.kyno_turnip.grow_time                   = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME)
PLANT_DEFS.kyno_turnip.moisture                    = {drink_rate = DRINK_LOW, min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE}
PLANT_DEFS.kyno_turnip.good_seasons                = {autumn = true, winter = true, spring = true, summer = true}
PLANT_DEFS.kyno_turnip.nutrient_consumption        = {NUTRIENT_MED, 0, NUTRIENT_MED}
PLANT_DEFS.kyno_turnip.max_killjoys_tolerance      = TUNING.FARM_PLANT_KILLJOY_TOLERANCE
PLANT_DEFS.kyno_turnip.weight_data                 = { 463.23, 694.20, .21 }
PLANT_DEFS.kyno_turnip.sounds                      = PLANT_DEFS.garlic.sounds
PLANT_DEFS.kyno_turnip.nutrient_restoration        = {0, 4, 0}

for i = 1, #PLANT_DEFS.kyno_turnip.nutrient_consumption do
    PLANT_DEFS.kyno_turnip.nutrient_restoration[i] = PLANT_DEFS.kyno_turnip.nutrient_consumption[i] == 0 or nil
end

PLANT_DEFS.kyno_turnip.pictureframeanim            = {anim = "emote_fistshake", time = 27 * FRAMES}
PLANT_DEFS.kyno_turnip.plantregistrywidget         = "widgets/redux/farmplantpage"
PLANT_DEFS.kyno_turnip.plantregistrysummarywidget  = "widgets/redux/farmplantsummarywidget"
PLANT_DEFS.kyno_turnip.plantregistryinfo           =
{
    {
        text            = "seed",
        anim            = "crop_seed",
        grow_anim       = "grow_seed",
        learnseed       = true,
        growing         = true,
    },
    {
        text            = "sprout",
        anim            = "crop_sprout",
        grow_anim       = "grow_sprout",
        growing         = true,
    },
    {
        text            = "small",
        anim            = "crop_small",
        grow_anim       = "grow_small",
        growing         = true,
    },
    {
        text            = "medium",
        anim            = "crop_med",
        grow_anim       = "grow_med",
        growing         = true,
    },
    {
        text            = "grown",
        anim            = "crop_full",
        grow_anim       = "grow_full",
        revealplantname = true,
        fullgrown       = true,
    },
    {
        text            = "oversized",
        anim            = "crop_oversized",
        grow_anim       = "grow_oversized",
        revealplantname = true,
        fullgrown       = true,
        hidden          = true,
    },
    {
        text            = "rotting",
        anim            = "crop_rot",
        grow_anim       = "grow_rot",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
    {
        text            = "oversized_rotting",
        anim            = "crop_rot_oversized",
        grow_anim       = "grow_rot_oversized",
        stagepriority   = -100,
        is_rotten       = true,
        hidden          = true,
    },
}

-- Icons for the Plant Registry and Farm Plants.
local old_GetInventoryItemAtlas = GetInventoryItemAtlas
_G.GetInventoryItemAtlas = function(name, ...)
    local myatlas = resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")

	if TheSim:AtlasContains(myatlas, name) then
        return myatlas
    end

    return old_GetInventoryItemAtlas(name, ...)
end