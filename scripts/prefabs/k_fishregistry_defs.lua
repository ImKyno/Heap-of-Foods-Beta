--[[
{
	name           =
	
	bank           =
	build          =
	anim           =
	
	scale          =
	xpos           =
	ypos           =
	
	phases         =
	moonphases     =
	seasons        =
	worlds         =
}
]]--

local FISHREGISTRY_DEFS = {}

local ALL_PHASES     = { "day", "dusk", "night" }
local ALL_MOONPHASES = { "new", "quarter", "half", "threequarter", "full" }
local ALL_SEASONS    = { "autumn", "winter", "spring", "summer" }
local ALL_WORLDS     = { "forest", "cave" }

FISHREGISTRY_DEFS.pondfish = 
{
	name           = "PONDFISH",

	bank           = "fish",
	build          = "fish",
	anim           = "idle",
	
	scale          = 0.25,
	xpos           = -5,
	ypos           = 40,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.pondeel = 
{
	name           = "PONDEEL",

	bank           = "eel",
	build          = "eel",
	anim           = "idle",
	
	scale          = 0.25,
	xpos           = -5,
	ypos           = 45,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = { "cave" },
}

FISHREGISTRY_DEFS.wobster_sheller_land =
{
	name           = "WOBSTER_SHELLER_LAND",
	
	bank           = "lobster",
	build          = "lobster_sheller",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = 0,
	ypos           = 43,
	
	phases         = { "dusk", "night" },
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.wobster_moonglass_land =
{
	name           = "WOBSTER_MOONGLASS",
	
	bank           = "lobster",
	build          = "lobster_moonglass",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = 0,
	ypos           = 40,
	
	phases         = { "night" },
	moonphases     = { "full", "glassed" },
	seasons        = ALL_SEASONS,
	worlds         = { "forest" },
}

FISHREGISTRY_DEFS.wobster_monkeyisland_land =
{
	name           = "WOBSTER_MONKEYISLAND_LAND",
	
	bank           = "lobster",
	build          = "kyno_lobster_monkeyisland",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = 0,
	ypos           = 43,
	
	phases         = { "day" },
	moonphases     = ALL_MOONPHASES,
	seasons        = { "autumn", "summer" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_1_inv =
{
	name           = "OCEANFISH_SMALL_1_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_1",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_2_inv =
{
	name           = "OCEANFISH_SMALL_2_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_2",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 37,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_3_inv =
{
	name           = "OCEANFISH_SMALL_3_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_3",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 37,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_4_inv =
{
	name           = "OCEANFISH_SMALL_4_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_4",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_5_inv =
{
	name           = "OCEANFISH_SMALL_5_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_5",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_6_inv =
{
	name           = "OCEANFISH_SMALL_6_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_6",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 43,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = { "autumn" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_7_inv =
{
	name           = "OCEANFISH_SMALL_7_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_7",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 35,
	
	phases         = { "dusk" },
	moonphases     = ALL_MOONPHASES,
	seasons        = { "spring" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_8_inv =
{
	name           = "OCEANFISH_SMALL_8_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_8",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 40,
	
	phases         = { "day" },
	moonphases     = ALL_MOONPHASES,
	seasons        = { "summer" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_small_9_inv =
{
	name           = "OCEANFISH_SMALL_9_INV",
	
	bank           = "oceanfish_small",
	build          = "oceanfish_small_9",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_pufferfish_inv =
{
	name           = "OCEANFISH_PUFFERFISH_INV",
	
	bank           = "kyno_oceanfish_pufferfish",
	build          = "kyno_oceanfish_pufferfish",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 0,
	ypos           = 40,
	
	phases         = { "day" },
	moonphases     = ALL_MOONPHASES,
	seasons        = { "summer" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_1_inv =
{
	name           = "OCEANFISH_MEDIUM_1_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_1",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_2_inv =
{
	name           = "OCEANFISH_MEDIUM_2_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_2",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_3_inv =
{
	name           = "OCEANFISH_MEDIUM_3_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_3",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_4_inv =
{
	name           = "OCEANFISH_MEDIUM_4_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_4",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_5_inv =
{
	name           = "OCEANFISH_MEDIUM_5_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_5",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_6_inv =
{
	name           = "OCEANFISH_MEDIUM_6_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_6",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_7_inv =
{
	name           = "OCEANFISH_MEDIUM_7_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_7",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_8_inv =
{
	name           = "OCEANFISH_MEDIUM_8_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_8",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 43,
	
	phases         = { "night" },
	moonphases     = ALL_MOONPHASES,
	seasons        = { "winter" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_medium_9_inv =
{
	name           = "OCEANFISH_MEDIUM_9_INV",
	
	bank           = "oceanfish_medium",
	build          = "oceanfish_medium_9",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.oceanfish_sturgeon_inv =
{
	name           = "OCEANFISH_STURGEON_INV",
	
	bank           = "kyno_oceanfish_sturgeon",
	build          = "kyno_oceanfish_sturgeon",
	anim           = "flop_pst",
	
	scale          = 0.25,
	xpos           = 5,
	ypos           = 40,
	
	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = { "summer", "winter" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_tropicalfish =
{
	name           = "KYNO_TROPICALFISH",

	bank           = "tropicalfish",
	build          = "tropicalfish",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = -9,
	ypos           = 40,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = { "autumn" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_neonfish =
{
	name           = "KYNO_NEONFISH",

	bank           = "neonfish",
	build          = "neonfish",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = -9,
	ypos           = 40,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = { "winter" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_pierrotfish =
{
	name           = "KYNO_PEIRROTFISH",

	bank           = "pierrotfish",
	build          = "pierrotfish",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = -5,
	ypos           = 40,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = { "spring" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_grouper =
{
	name           = "KYNO_GROUPER",

	bank           = "grouper",
	build          = "grouper",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = -5,
	ypos           = 40,

	phases         = { "dusk", "night" },
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_koi =
{
	name           = "KYNO_KOI",

	bank           = "koi",
	build          = "koi",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = -5,
	ypos           = 40,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = { "summer" },
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_salmonfish =
{
	name           = "KYNO_SALMONFISH",

	bank           = "salmonfish",
	build          = "salmonfish",
	anim           = "idle",
	
	scale          = 0.20,
	xpos           = -5,
	ypos           = 40,

	phases         = { "day", "dusk" },
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_antchovy =
{
	name           = "KYNO_ANTCHOVY",

	bank           = "kyno_antchovy",
	build          = "kyno_antchovy",
	anim           = "idle",
	
	scale          = 0.40,
	xpos           = 0,
	ypos           = 50,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_jellyfish =
{
	name           = "KYNO_JELLYFISH",

	bank           = "kyno_jellyfish2",
	build          = "kyno_jellyfish2",
	anim           = "idle1",
	
	scale          = 0.20,
	xpos           = 0,
	ypos           = 49,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_jellyfish_rainbow =
{
	name           = "KYNO_JELLYFISH_RAINBOW",

	bank           = "kyno_jellyfish2",
	build          = "kyno_jellyfish2",
	anim           = "idle2",
	
	scale          = 0.15,
	xpos           = 0,
	ypos           = 48,

	phases         = { "dusk", "night" },
	moonphases     = ALL_MOONPHASES,
	seasons        = ALL_SEASONS,
	worlds         = ALL_WORLDS,
}

FISHREGISTRY_DEFS.kyno_swordfish_blue =
{
	name           = "KYNO_SWORDFISH_BLUE",

	bank           = "kyno_swordfish_blue",
	build          = "kyno_swordfish_blue",
	anim           = "idle",
	
	scale          = 0.12,
	xpos           = 15,
	ypos           = 45,

	phases         = ALL_PHASES,
	moonphases     = ALL_MOONPHASES,
	seasons        = { "winter" },
	worlds         = { "cave" },
}

for fish, data in pairs(FISHREGISTRY_DEFS) do
	if data.name == nil then
		data.name = string.upper(fish)
	end
end

setmetatable(FISHREGISTRY_DEFS, 
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

return 
{
	FISHREGISTRY_DEFS = FISHREGISTRY_DEFS,
	FISH_SORT_ORDER    = FISH_SORT_ORDER,
}