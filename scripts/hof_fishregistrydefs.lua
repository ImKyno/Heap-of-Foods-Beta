-- DEFS for the Fish Registry. THIS FILE IS NOT MEANT TO BE EDITED BY OTHER MODS!
-- For adding new fish/roe please refer to: hof_fishregistryapi.lua

require("strings/hof_strings")

local FISHREGISTRY_ATLAS           = "images/hof_fishregistry.xml"
local FISHREGISTRY_INVENTORY_ATLAS = "images/inventoryimages/hof_inventoryimages.xml"

-- Time thresholds (In days = TUNING.TOTAL_DAY_TIME = 480 seconds).
TUNING.FISHREGISTRY_ROE_THRESHOLDS = TUNING.FISHREGISTRY_ROE_THRESHOLDS or
{
	{ max = 0.75,      string = STRINGS.FISHREGISTRY.ROE_TIME_HALF_DAY     },
	{ max = 1.50,      string = STRINGS.FISHREGISTRY.ROE_TIME_ONE_DAY      },
	{ max = 1.85,      string = STRINGS.FISHREGISTRY.ROE_TIME_ONE_HALF_DAY },
	{ max = 2.5,       string = STRINGS.FISHREGISTRY.ROE_TIME_TWO_DAY      },
	{ max = 3.5,       string = STRINGS.FISHREGISTRY.ROE_TIME_THREE_DAY    },
	{ max = math.huge, string = STRINGS.FISHREGISTRY.ROE_TIME_MORE_DAY     },
}

TUNING.FISHREGISTRY_BABY_THRESHOLDS = TUNING.FISHREGISTRY_BABY_THRESHOLDS or
{
	{ max = 0.75,      string = STRINGS.FISHREGISTRY.BABY_TIME_HALF_DAY     },
	{ max = 1.50,      string = STRINGS.FISHREGISTRY.BABY_TIME_ONE_DAY      },
	{ max = 1.85,      string = STRINGS.FISHREGISTRY.BABY_TIME_ONE_HALF_DAY },
	{ max = 2.5,       string = STRINGS.FISHREGISTRY.BABY_TIME_TWO_DAY      },
	{ max = 3.5,       string = STRINGS.FISHREGISTRY.BABY_TIME_THREE_DAY    },
	{ max = 4.5,       string = STRINGS.FISHREGISTRY.BABY_TIME_FOUR_DAY     },
	{ max = 5.5,       string = STRINGS.FISHREGISTRY.BABY_TIME_FIVE_DAY     },
	{ max = 6.5,       string = STRINGS.FISHREGISTRY.BABY_TIME_SIX_DAY      },
	{ max = math.huge, string = STRINGS.FISHREGISTRY.BABY_TIME_MORE_DAY     },
}

-- IDs and Icons that populates the Fish/Roe cells.
TUNING.FISHREGISTRY_PHASE_IDS     = TUNING.FISHREGISTRY_PHASE_IDS     or { "day", "dusk", "night" }
TUNING.FISHREGISTRY_MOONPHASE_IDS = TUNING.FISHREGISTRY_MOONPHASE_IDS or { "new", "quarter", "half", "threequarter", "full", "glassed" }
TUNING.FISHREGISTRY_SEASON_IDS    = TUNING.FISHREGISTRY_SEASON_IDS    or { "autumn", "winter", "spring", "summer" }
TUNING.FISHREGISTRY_WORLD_IDS     = TUNING.FISHREGISTRY_WORLD_IDS     or { "forest", "cave" }

TUNING.FISHREGISTRY_PHASE_ICONS = TUNING.FISHREGISTRY_PHASE_ICONS or
{
	day   = { atlas = FISHREGISTRY_ATLAS, image = "phase_day.tex"   },
	dusk  = { atlas = FISHREGISTRY_ATLAS, image = "phase_dusk.tex"  },
	night = { atlas = FISHREGISTRY_ATLAS, image = "phase_night.tex" },
}

TUNING.FISHREGISTRY_MOONPHASE_ICONS = TUNING.FISHREGISTRY_MOONPHASE_ICONS or
{
	new          = { atlas = FISHREGISTRY_ATLAS, image = "moon_new.tex"           },
	quarter      = { atlas = FISHREGISTRY_ATLAS, image = "moon_quarter.tex"       },
	half         = { atlas = FISHREGISTRY_ATLAS, image = "moon_half.tex"          },
	threequarter = { atlas = FISHREGISTRY_ATLAS, image = "moon_three_quarter.tex" },
	full         = { atlas = FISHREGISTRY_ATLAS, image = "moon_full.tex"          },
	glassed      = { atlas = FISHREGISTRY_ATLAS, image = "moon_glassed.tex"       },
}

TUNING.FISHREGISTRY_SEASON_ICONS = TUNING.FISHREGISTRY_SEASON_ICONS or
{
	autumn = { atlas = FISHREGISTRY_ATLAS, image = "season_autumn.tex" },
	winter = { atlas = FISHREGISTRY_ATLAS, image = "season_winter.tex" },
	spring = { atlas = FISHREGISTRY_ATLAS, image = "season_spring.tex" },
	summer = { atlas = FISHREGISTRY_ATLAS, image = "season_summer.tex" },
}

TUNING.FISHREGISTRY_WORLD_ICONS = TUNING.FISHREGISTRY_WORLD_ICONS or
{
	forest = { atlas = FISHREGISTRY_ATLAS, image = "world_forest.tex" },
	cave   = { atlas = FISHREGISTRY_ATLAS, image = "world_cave.tex"   },
}

local function GetTimeCategory(days, thresholds)
	for _, data in ipairs(thresholds) do
		if days <= data.max then
			return data.string
		end
	end
	
	return thresholds[#thresholds].string
end

global("FishRegistryGetRoeTimeString")
function FishRegistryGetRoeTimeString(time)
	if not time then
		return STRINGS.FISHREGISTRY.MISSING_ROE_TIME
	end

	local days = time / TUNING.TOTAL_DAY_TIME
	return GetTimeCategory(days, TUNING.FISHREGISTRY_ROE_THRESHOLDS)
end

global("FishRegistryGetBabyTimeString")
function FishRegistryGetBabyTimeString(time)
	if not time then
		return STRINGS.FISHREGISTRY.MISSING_BABY_TIME
	end

	local days = time / TUNING.TOTAL_DAY_TIME
	return GetTimeCategory(days, TUNING.FISHREGISTRY_BABY_THRESHOLDS)
end

global("FISHREGISTRY_FISH_DEFS")
FISHREGISTRY_FISH_DEFS = FISHREGISTRY_FISH_DEFS or {}

local ALL_PHASES     = { "day", "dusk", "night" }
local ALL_MOONPHASES = { "new", "quarter", "half", "threequarter", "full" } -- Must not include glassed!
local ALL_SEASONS    = { "autumn", "winter", "spring", "summer" }
local ALL_WORLDS     = { "forest", "cave" }

FISHREGISTRY_FISH_DEFS.pondfish = 
{
	name             = "PONDFISH",

	bank             = "fish",
	build            = "fish",
	anim             = "idle",
	
	scale            = 0.25,
	xpos             = -5,
	ypos             = 40,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.pondeel = 
{
	name             = "EEL",

	bank             = "eel",
	build            = "eel",
	anim             = "idle",
	
	scale            = 0.25,
	xpos             = -5,
	ypos             = 45,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = { "cave" },
}

FISHREGISTRY_FISH_DEFS.wobster_sheller_land =
{
	name             = "WOBSTER_SHELLER_LAND",
	
	bank             = "lobster",
	build            = "lobster_sheller",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = 0,
	ypos             = 43,
	
	phases           = { "dusk", "night" },
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.wobster_moonglass_land =
{
	name             = "WOBSTER_MOONGLASS",
	
	bank             = "lobster",
	build            = "lobster_moonglass",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = 0,
	ypos             = 40,
	
	phases           = { "night" },
	moonphases       = { "full", "glassed" },
	seasons          = ALL_SEASONS,
	worlds           = { "forest" },
}

FISHREGISTRY_FISH_DEFS.wobster_monkeyisland_land =
{
	name             = "WOBSTER_MONKEYISLAND_LAND",
	
	bank             = "lobster",
	build            = "kyno_lobster_monkeyisland",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = 0,
	ypos             = 43,
	
	phases           = { "day" },
	moonphases       = ALL_MOONPHASES,
	seasons          = { "autumn", "summer" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_1_inv =
{
	name             = "OCEANFISH_SMALL_1_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_1",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_2_inv =
{
	name             = "OCEANFISH_SMALL_2_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_2",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 37,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_3_inv =
{
	name             = "OCEANFISH_SMALL_3_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_3",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 37,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_4_inv =
{
	name             = "OCEANFISH_SMALL_4_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_4",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_5_inv =
{
	name             = "OCEANFISH_SMALL_5_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_5",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_6_inv =
{
	name             = "OCEANFISH_SMALL_6_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_6",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 43,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = { "autumn" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_7_inv =
{
	name             = "OCEANFISH_SMALL_7_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_7",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 35,
	
	phases           = { "dusk" },
	moonphases       = ALL_MOONPHASES,
	seasons          = { "spring" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_8_inv =
{
	name             = "OCEANFISH_SMALL_8_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_8",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 40,
	
	phases           = { "day" },
	moonphases       = ALL_MOONPHASES,
	seasons          = { "summer" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_small_9_inv =
{
	name             = "OCEANFISH_SMALL_9_INV",
	
	bank             = "oceanfish_small",
	build            = "oceanfish_small_9",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_pufferfish_inv =
{
	name             = "OCEANFISH_PUFFERFISH_INV",
	
	bank             = "kyno_oceanfish_pufferfish",
	build            = "kyno_oceanfish_pufferfish",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 0,
	ypos             = 40,
	
	phases           = { "day" },
	moonphases       = ALL_MOONPHASES,
	seasons          = { "summer" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_1_inv =
{
	name             = "OCEANFISH_MEDIUM_1_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_1",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_2_inv =
{
	name             = "OCEANFISH_MEDIUM_2_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_2",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_3_inv =
{
	name             = "OCEANFISH_MEDIUM_3_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_3",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_4_inv =
{
	name             = "OCEANFISH_MEDIUM_4_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_4",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_5_inv =
{
	name             = "OCEANFISH_MEDIUM_5_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_5",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_6_inv =
{
	name             = "OCEANFISH_MEDIUM_6_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_6",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_7_inv =
{
	name             = "OCEANFISH_MEDIUM_7_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_7",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_8_inv =
{
	name             = "OCEANFISH_MEDIUM_8_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_8",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 43,
	
	phases           = { "night" },
	moonphases       = ALL_MOONPHASES,
	seasons          = { "winter" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_medium_9_inv =
{
	name             = "OCEANFISH_MEDIUM_9_INV",
	
	bank             = "oceanfish_medium",
	build            = "oceanfish_medium_9",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.oceanfish_sturgeon_inv =
{
	name             = "OCEANFISH_STURGEON_INV",
	
	bank             = "kyno_oceanfish_sturgeon",
	build            = "kyno_oceanfish_sturgeon",
	anim             = "flop_pst",
	
	scale            = 0.25,
	xpos             = 5,
	ypos             = 40,
	
	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = { "summer", "winter" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_tropicalfish =
{
	name             = "KYNO_TROPICALFISH",

	bank             = "tropicalfish",
	build            = "tropicalfish",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = -9,
	ypos             = 40,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = { "autumn" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_neonfish =
{
	name             = "KYNO_NEONFISH",

	bank             = "neonfish",
	build            = "neonfish",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = -9,
	ypos             = 40,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = { "winter" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_pierrotfish =
{
	name             = "KYNO_PIERROTFISH",

	bank             = "pierrotfish",
	build            = "pierrotfish",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = -5,
	ypos             = 40,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = { "spring" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_grouper =
{
	name             = "KYNO_GROUPER",

	bank             = "grouper",
	build            = "grouper",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = -5,
	ypos             = 40,

	phases           = { "dusk", "night" },
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_koi =
{
	name             = "KYNO_KOI",

	bank             = "koi",
	build            = "koi",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = -5,
	ypos             = 40,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = { "summer" },
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_salmonfish =
{
	name             = "KYNO_SALMONFISH",

	bank             = "salmonfish",
	build            = "salmonfish",
	anim             = "idle",
	
	scale            = 0.20,
	xpos             = -5,
	ypos             = 40,

	phases           = { "day", "dusk" },
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_antchovy =
{
	name             = "KYNO_ANTCHOVY",

	bank             = "kyno_antchovy",
	build            = "kyno_antchovy",
	anim             = "idle",
	
	scale            = 0.40,
	xpos             = 0,
	ypos             = 50,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_jellyfish =
{
	name             = "KYNO_JELLYFISH",

	bank             = "kyno_jellyfish2",
	build            = "kyno_jellyfish2",
	anim             = "idle1",
	
	scale            = 0.20,
	xpos             = 0,
	ypos             = 49,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_jellyfish_rainbow =
{
	name             = "KYNO_JELLYFISH_RAINBOW",

	bank             = "kyno_jellyfish2",
	build            = "kyno_jellyfish2",
	anim             = "idle2",
	
	scale            = 0.15,
	xpos             = 0,
	ypos             = 48,

	phases           = { "dusk", "night" },
	moonphases       = ALL_MOONPHASES,
	seasons          = ALL_SEASONS,
	worlds           = ALL_WORLDS,
}

FISHREGISTRY_FISH_DEFS.kyno_swordfish_blue =
{
	name             = "KYNO_SWORDFISH_BLUE",

	bank             = "kyno_swordfish_blue",
	build            = "kyno_swordfish_blue",
	anim             = "idle",
	
	scale            = 0.12,
	xpos             = 15,
	ypos             = 45,

	phases           = ALL_PHASES,
	moonphases       = ALL_MOONPHASES,
	seasons          = { "winter" },
	worlds           = { "cave" },
}

for fish, data in pairs(FISHREGISTRY_FISH_DEFS) do
	if data.name == nil then
		data.name = string.upper(fish)
	end
end

setmetatable(FISHREGISTRY_FISH_DEFS, 
{
	__newindex = function(t, k, v)
		v.modded = true
		rawset(t, k, v)
	end,
})

local FISH_SORT_ORDER =
{
	"pondfish",
	"pondeel",
	"wobster_sheller_land",
	"wobster_moonglass_land",
	"wobster_monkeyisland_land",
	"oceanfish_small_1_inv",
	"oceanfish_small_2_inv",
	"oceanfish_small_3_inv",
	"oceanfish_small_4_inv",
	"oceanfish_small_5_inv",
	"oceanfish_small_6_inv",
	"oceanfish_small_7_inv",
	"oceanfish_small_8_inv",
	"oceanfish_small_9_inv",
	"oceanfish_pufferfish_inv",
	"oceanfish_medium_1_inv",
	"oceanfish_medium_2_inv",
	"oceanfish_medium_3_inv",
	"oceanfish_medium_4_inv",
	"oceanfish_medium_5_inv",
	"oceanfish_medium_6_inv",
	"oceanfish_medium_7_inv",
	"oceanfish_medium_8_inv",
	"oceanfish_medium_9_inv",
	"oceanfish_sturgeon_inv",
	"kyno_tropicalfish",
	"kyno_neonfish",
	"kyno_pierrotfish",
	"kyno_grouper",
	"kyno_koi",
	"kyno_salmonfish",
	"kyno_antchovy",
	"kyno_jellyfish",
	"kyno_jellyfish_rainbow",
	"kyno_swordfish_blue",
}

global("FISHREGISTRY_ROE_DEFS")
FISHREGISTRY_ROE_DEFS = FISHREGISTRY_ROE_DEFS or {}

FISHREGISTRY_ROE_DEFS.kyno_roe_pondfish =
{
	name        = "KYNO_ROE_PONDFISH",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_pondfish",
	
	roe_time    = TUNING.PONDFISH_ROETIME,
	baby_time   = TUNING.PONDFISH_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_pondeel =
{
	name        = "KYNO_ROE_PONDEEL",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_pondeel",
	
	roe_time    = TUNING.PONDEEL_ROETIME,
	baby_time   = TUNING.PONDEEL_BABYTIME,
	
	roe_string  = STRINGS.FISHREGISTRY.ROE_TIME_ONE_HALF_DAY,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_wobster =
{
	name        = "KYNO_ROE_WOBSTER",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_wobster",
	
	roe_time    = TUNING.WOBSTER_ROETIME,
	baby_time   = TUNING.WOBSTER_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_wobster_moonglass =
{
	name        = "KYNO_ROE_WOBSTER_MOONGLASS",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_wobster_moonglass",
	
	roe_time    = TUNING.WOBSTER_MOONGLASS_ROETIME,
	baby_time   = TUNING.WOBSTER_MOONGLASS_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_wobster_monkeyisland =
{
	name        = "KYNO_ROE_WOBSTER_MONKEYISLAND",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_wobster_monkeyisland",
	
	roe_time    = TUNING.WOBSTER_MONKEYISLAND_ROETIME,
	baby_time   = TUNING.WOBSTER_MONKEYISLAND_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_1 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_1",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_1",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_2 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_2",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_2",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_3 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_3",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_3",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_4 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_4",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_4",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_5 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_5",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_5",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_6 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_6",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_6",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_7 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_7",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_7",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_8 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_8",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_8",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_small_9 =
{
	name        = "KYNO_ROE_OCEANFISH_SMALL_9",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_small_9",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_pufferfish =
{
	name        = "KYNO_ROE_OCEANFISH_PUFFERFISH",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_pufferfish",
	
	roe_time    = TUNING.OCEANFISH_SMALL_ROETIME,
	baby_time   = TUNING.OCEANFISH_SMALL_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_1 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_1",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_1",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_2 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_2",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_2",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_3 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_3",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_3",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_4 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_4",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_4",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_5 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_5",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_5",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_6 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_6",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_6",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_7 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_7",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_7",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_8 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_8",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_8",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_medium_9 =
{
	name        = "KYNO_ROE_OCEANFISH_MEDIUM_9",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_medium_9",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_oceanfish_sturgeon =
{
	name        = "KYNO_ROE_OCEANFISH_STURGEON",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_oceanfish_sturgeon",
	
	roe_time    = TUNING.OCEANFISH_MEDIUM_ROETIME,
	baby_time   = TUNING.OCEANFISH_MEDIUM_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_tropicalfish =
{
	name        = "KYNO_ROE_TROPICALFISH",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_tropicalfish",
	
	roe_time    = TUNING.TROPICALFISH_ROETIME,
	baby_time   = TUNING.TROPICALFISH_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_neonfish =
{
	name        = "KYNO_ROE_NEONFISH",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_neonfish",
	
	roe_time    = TUNING.NEONFISH_ROETIME,
	baby_time   = TUNING.NEONFISH_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_pierrotfish =
{
	name        = "KYNO_ROE_PIERROTFISH",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_pierrotfish",
	
	roe_time    = TUNING.PIERROTFISH_ROETIME,
	baby_time   = TUNING.PIERROTFISH_BABYTIME,
	
	roe_string  = STRINGS.FISHREGISTRY.ROE_TIME_ONE_HALF_DAY,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_grouper =
{
	name        = "KYNO_ROE_GROUPER",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_grouper",
	
	roe_time    = TUNING.GROUPER_ROETIME,
	baby_time   = TUNING.GROUPER_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_koi =
{
	name        = "KYNO_ROE_KOI",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_koi",
	
	roe_time    = TUNING.TROPICALKOI_ROETIME,
	baby_time   = TUNING.TROPICALKOI_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_salmonfish =
{
	name        = "KYNO_ROE_SALMONFISH",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_salmonfish",
	
	roe_time    = TUNING.SALMONFISH_ROETIME,
	baby_time   = TUNING.SALMONFISH_BABYTIME,
	
	roe_string  = STRINGS.FISHREGISTRY.ROE_TIME_ONE_HALF_DAY,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_antchovy =
{
	name        = "KYNO_ROE_ANTCHOVY",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_antchovy",
	
	roe_time    = TUNING.ANTCHOVY_ROETIME,
	baby_time   = TUNING.ANTCHOVY_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_jellyfish =
{
	name        = "KYNO_ROE_JELLYFISH",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_jellyfish",
	
	roe_time    = TUNING.JELLYFISH_ROETIME,
	baby_time   = TUNING.JELLYFISH_BABYTIME,
	
	roe_string  = STRINGS.FISHREGISTRY.ROE_TIME_ONE_HALF_DAY,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_jellyfish_rainbow =
{
	name        = "KYNO_ROE_JELLYFISH_RAINBOW",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_jellyfish_rainbow",
	
	roe_time    = TUNING.JELLYFISH_RAINBOW_ROETIME,
	baby_time   = TUNING.JELLYFISH_RAINBOW_BABYTIME,
}

FISHREGISTRY_ROE_DEFS.kyno_roe_swordfish_blue =
{
	name        = "KYNO_ROE_SWORDFISH_BLUE",
	
	atlas       = FISHREGISTRY_INVENTORY_ATLAS,
	image       = "kyno_roe_swordfish_blue",
	
	roe_time    = TUNING.SWORDFISH_BLUE_ROETIME,
	baby_time   = TUNING.SWORDFISH_BLUE_BABYTIME,
}

for roe, data in pairs(FISHREGISTRY_ROE_DEFS) do
	if data.name == nil then
		data.name = string.upper(roe)
	end
end

setmetatable(FISHREGISTRY_ROE_DEFS, 
{
	__newindex = function(t, k, v)
		v.modded = true
		rawset(t, k, v)
	end,
})

local ROE_SORT_ORDER =
{
	"kyno_roe_pondfish",
	"kyno_roe_pondeel",
	"kyno_roe_wobster",
	"kyno_roe_wobster_moonglass",
	"kyno_roe_wobster_monkeyisland",
	"kyno_roe_oceanfish_small_1",
	"kyno_roe_oceanfish_small_2",
	"kyno_roe_oceanfish_small_3",
	"kyno_roe_oceanfish_small_4",
	"kyno_roe_oceanfish_small_5",
	"kyno_roe_oceanfish_small_6",
	"kyno_roe_oceanfish_small_7",
	"kyno_roe_oceanfish_small_8",
	"kyno_roe_oceanfish_small_9",
	"kyno_roe_oceanfish_pufferfish",
	"kyno_roe_oceanfish_medium_1",
	"kyno_roe_oceanfish_medium_2",
	"kyno_roe_oceanfish_medium_3",
	"kyno_roe_oceanfish_medium_4",
	"kyno_roe_oceanfish_medium_5",
	"kyno_roe_oceanfish_medium_6",
	"kyno_roe_oceanfish_medium_7",
	"kyno_roe_oceanfish_medium_8",
	"kyno_roe_oceanfish_medium_9",
	"kyno_roe_oceanfish_sturgeon",
	"kyno_roe_tropicalfish",
	"kyno_roe_neonfish",
	"kyno_roe_pierrotfish",
	"kyno_roe_grouper",
	"kyno_roe_koi",
	"kyno_roe_salmonfish",
	"kyno_roe_antchovy",
	"kyno_roe_jellyfish",
	"kyno_roe_jellyfish_rainbow",
	"kyno_roe_swordfish_blue",
}

return 
{
	FISHREGISTRY_FISH_DEFS = FISHREGISTRY_FISH_DEFS,
	FISHREGISTRY_ROE_DEFS  = FISHREGISTRY_ROE_DEFS,

	FISH_SORT_ORDER        = FISH_SORT_ORDER,
	ROE_SORT_ORDER         = ROE_SORT_ORDER,
}