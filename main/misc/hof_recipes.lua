local _G                   = GLOBAL
local TECH                 = _G.TECH
local Ingredient           = _G.Ingredient
local AllRecipes           = _G.AllRecipes
local Recipe2              = _G.Recipe2
local CONSTRUCTION_PLANS   = _G.CONSTRUCTION_PLANS
local TechTree             = require("techtree")
local RecipeFilter         = require("recipes_filter")

local HOF_WARLYMEALGRINDER = GetModConfigData("WARLYMEALGRINDER")
local HOF_FERTILIZERTWEAK  = GetModConfigData("FERTILIZERTWEAK")

-- Atlases for Recipes.
local DefaultAtlas         = "images/inventoryimages.xml"
local DefaultAtlas1        = "images/inventoryimages1.xml"
local DefaultAtlas2        = "images/inventoryimages2.xml"
local ModAtlas             = "images/inventoryimages/hof_inventoryimages.xml"
local CraftingFilterAtlas  = "images/tabimages/hof_tabimages.xml"

-- Wurt can craft her structures on Tidal Marsh ground.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=3435352667
local _IsMarshLand = AllRecipes["mermhouse_crafted"].testfn
local function IsTidalMarshLand(pt, rot, ...)
	return _G.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) == _G.WORLD_TILES.HOF_TIDALMARSH
	or _IsMarshLand(pt, rot, ...)
end

AllRecipes["mermhouse_crafted"].testfn       = IsTidalMarshLand
AllRecipes["mermthrone_construction"].testfn = IsTidalMarshLand
AllRecipes["mermwatchtower"].testfn          = IsTidalMarshLand
AllRecipes["offering_pot"].testfn            = IsTidalMarshLand
AllRecipes["offering_pot_upgraded"].testfn   = IsTidalMarshLand
AllRecipes["merm_toolshed"].testfn           = IsTidalMarshLand
AllRecipes["merm_toolshed_upgraded"].testfn  = IsTidalMarshLand
AllRecipes["merm_armory"].testfn             = IsTidalMarshLand
AllRecipes["merm_armory_upgraded"].testfn    = IsTidalMarshLand

-- Using Bananas instead of Cave Bananas.
AllRecipes["wormwood_reeds"].ingredients = {Ingredient("kyno_banana", 1, ModAtlas)}

-- Custom TechTree for Crafting Stations and NPCs.
TECH.MEALING            = { MEALING          = 1  }
TECH.MEALING_ONE        = { MEALING          = 1  }
TECH.MEALING_TWO        = { MEALING          = 2  }

TECH.SERENITYSHOP       = { SERENITYSHOP     = 1  }
TECH.SERENITYSHOP_ONE   = { SERENITYSHOP     = 1  }
TECH.SERENITYSHOP_TWO   = { SERENITYSHOP     = 2  }

TECH.MEADOWSHOP         = { MEADOWSHOP       = 1  }
TECH.MEADOWSHOP_ONE     = { MEADOWSHOP       = 1  }
TECH.MEADOWSHOP_TWO     = { MEADOWSHOP       = 2  }

TECH.DECIDUOUSSHOP      = { DECIDUOUSSHOP    = 1  }
TECH.DECIDUOUSSHOP_ONE  = { DECIDUOUSSHOP    = 1  }
TECH.DECIDUOUSSHOP_TWO  = { DECIDUOUSSHOP    = 2  }

TECH.HOFBIRTHDAY        = { SCIENCE          = 10 }

local function ResetAllTech()
	TECH.NONE = TechTree.Create()

	for k, v in pairs(AllRecipes) do
		AllRecipes[k].level = TechTree.Create(v.level)
	end

	for k, v in pairs(TUNING.PROTOTYPER_TREES) do
		TUNING.PROTOTYPER_TREES[k] = TechTree.Create(v)
	end
end

table.insert(TechTree.AVAILABLE_TECH, "MEALING")
table.insert(TechTree.AVAILABLE_TECH, "SERENITYSHOP")
table.insert(TechTree.AVAILABLE_TECH, "MEADOWSHOP")
table.insert(TechTree.AVAILABLE_TECH, "DECIDUOUSSHOP")
table.insert(TechTree.AVAILABLE_TECH, "HOFBIRTHDAY")

ResetAllTech()

-- Custom Recipe Filters.
local HOF_FILTERS  =
{
	MEALING        =
	{
		name       = "MEALING",
		atlas      = CraftingFilterAtlas,
		image      = "kyno_tab_mealing.tex",
		custom_pos = true,
	},

	SERENITYSHOP   =
	{
		name       = "SERENITYSHOP",
		atlas      = CraftingFilterAtlas,
		image      = "kyno_tab_serenity.tex",
		custom_pos = true,
	},

	MEADOWSHOP     =
	{
		name       = "MEADOWSHOP",
		atlas      = CraftingFilterAtlas,
		image      = "kyno_tab_meadow.tex",
		custom_pos = true,
	},

	DECIDUOUSSHOP  =
	{
		name       = "DECIDUOUSSHOP",
		atlas      = CraftingFilterAtlas,
		image      = "kyno_tab_deciduous.tex",
		custom_pos = true,
	},
}

for k, filter in pairs(HOF_FILTERS) do
	AddRecipeFilter(k, filter)
end

-- Custom Prototyper and Crafting Stations.
local HOF_PROTOTYPERS           =
{
	kyno_mealgrinder            =
	{
		icon_atlas              = CraftingFilterAtlas,
		icon_image              = "kyno_tab_mealing.tex",
		is_crafting_station     = true,
		action_str              = "MEALING",
		filter_text             = _G.STRINGS.UI.CRAFTING_FILTERS.MEALING,
	},

	kyno_serenityisland_shop    =
	{
		icon_atlas			    = CraftingFilterAtlas,
		icon_image			    = "kyno_tab_serenity.tex",
		is_crafting_station	    = true,
		action_str			    = "TRADE",
		filter_text			    = _G.STRINGS.UI.CRAFTING_FILTERS.SERENITYSHOP,
	},

	kyno_meadowisland_seller    =
	{
		icon_atlas              = CraftingFilterAtlas,
		icon_image              = "kyno_tab_meadow.tex",
		is_crafting_station     = true,
		action_str              = "TRADE",
		filter_text             = _G.STRINGS.UI.CRAFTING_FILTERS.MEADOWSHOP,
	},

	kyno_deciduousforest_seller =
	{
		icon_atlas              = CraftingFilterAtlas,
		icon_image              = "kyno_tab_deciduous.tex",
		is_crafting_station     = true,
		action_str              = "TRADE",
		filter_text             = _G.STRINGS.UI.CRAFTING_FILTERS.DECIDUOUSSHOP,
	},
}

for k, prototyper in pairs(HOF_PROTOTYPERS) do
	AddPrototyperDef(k, prototyper)
end

-- Mod Recipes.
AddRecipe2("kyno_flour", {Ingredient("kyno_wheat", 2, ModAtlas)}, TECH.MEALING_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "MEALGRINDER",
		numtogive 			= 3,
		atlas 				= DefaultAtlas,
		image 				= "quagmire_flour.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_spotspice", {Ingredient("kyno_spotspice_leaf", 2, ModAtlas)}, TECH.MEALING_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "MEALGRINDER",
		numtogive 			= 3,
		atlas 				= DefaultAtlas,
		image 				= "quagmire_spotspice_ground.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_salt", {Ingredient("saltrock", 2)}, TECH.MEALING_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "MEALGRINDER",
		numtogive 			= 3,
		atlas 				= DefaultAtlas,
		image 				= "quagmire_salt.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_bacon", {Ingredient("smallmeat", 1)}, TECH.MEALING_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "MEALGRINDER",
		product				= "kyno_bacon",
		numtogive 			= 2,
		atlas 				= DefaultAtlas,
		image 				= "quagmire_smallmeat.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_oil", {Ingredient("corn", 1), Ingredient("seeds", 1), Ingredient("petals", 2)}, TECH.MEALING_ONE,
	{
		nounlock			= true,
		no_deconstruction   = true,
		actionstr			= "MEALGRINDER",
		numtogive			= 3,
		atlas				= ModAtlas,
		image				= "kyno_oil.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_sugar", {Ingredient("kyno_sugartree_petals", 1, ModAtlas)}, TECH.MEALING_ONE,
	{
		nounlock 			= true,
		no_deconstruction   = true,
		actionstr 			= "MEALGRINDER",
		numtogive 			= 3,
		atlas 				= ModAtlas,
		image 				= "kyno_sugar.tex",
	},
	{"CRAFTING_STATION"}
)

AddRecipe2("kyno_musselstick_item", {Ingredient("twigs", 3), Ingredient("rope", 1), Ingredient("boards", 1)}, TECH.FISHING_ONE,
	{
		atlas 				= ModAtlas,
		image 				= "kyno_musselstick_item.tex",
	},
	{"GARDENING", "FISHING"}
)

AddRecipe2("kyno_mealgrinder", {Ingredient("cutstone", 2), Ingredient("flint", 2), Ingredient("marble", 2)}, TECH.SCIENCE_ONE,
	{
		placer 				= "kyno_mealgrinder_placer",
		min_spacing 		= 1.75,
		atlas 				= ModAtlas,
		image 				= "kyno_mealgrinder.tex",
	},
	{"COOKING"}
)

AddRecipe2("kyno_mushstump", {Ingredient("spoiled_food", 4), Ingredient("poop", 3), Ingredient("livinglog", 2)}, TECH.SCIENCE_TWO,
	{
		placer 				= "kyno_mushstump_placer",
		min_spacing			= 1.75,
		atlas 				= ModAtlas,
		image 				= "kyno_mushroomstump.tex",
	},
	{"GARDENING"}
)

AddRecipe2("kyno_floatilizer", {Ingredient("poop", 3), Ingredient("kelp", 2), Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
	{
		atlas 				= ModAtlas,
		image       		= "kyno_floatilizer.tex",
	},
	{"GARDENING"}
)

AddRecipe2("kyno_bucket_empty", {Ingredient("boneshard", 1), Ingredient("boards", 1), Ingredient("rope", 1)}, TECH.SCIENCE_ONE,
	{
		atlas				= ModAtlas,
		image				= "kyno_bucket_empty.tex",
	},
	{"TOOLS"}
)

AddRecipe2("kyno_itemslicer", {Ingredient("flint", 3), Ingredient("twigs", 2)}, TECH.SCIENCE_ONE,
	{
		atlas				= ModAtlas,
		image				= "kyno_itemslicer.tex",
	},
	{"TOOLS"}
)

AddRecipe2("kyno_brewbook", {Ingredient("papyrus", 1), Ingredient("kyno_wheat", 1, ModAtlas)}, TECH.SCIENCE_ONE,
	{
		atlas 				= ModAtlas,
		image				= "kyno_brewbook.tex",
	},
	{"COOKING"}
)

AddRecipe2("kyno_woodenkeg", {Ingredient("boards", 3), Ingredient("rope", 2), Ingredient("nitre", 3)}, TECH.SCIENCE_ONE,
	{
		placer 				= "kyno_woodenkeg_placer",
		min_spacing			= 2.5,
		atlas 				= ModAtlas,
		image 				= "kyno_woodenkeg.tex",
	},
	{"COOKING", "STRUCTURES"}
)

AddRecipe2("kyno_preservesjar", {Ingredient("boards", 3), Ingredient("rope", 2), Ingredient("nitre", 3)}, TECH.SCIENCE_ONE,
	{
		placer 				= "kyno_preservesjar_placer",
		min_spacing			= 1.75,
		atlas 				= ModAtlas,
		image 				= "kyno_preservesjar.tex",
	},
	{"COOKING", "STRUCTURES"}
)

AddRecipe2("kyno_antchest", {Ingredient("honeycomb", 1), Ingredient("honey", 12), Ingredient("boards", 3)}, TECH.LOST,
	{
		placer				= "kyno_antchest_placer",
		min_spacing			= 1.75,
		atlas				= ModAtlas,
		image				= "kyno_antchest_honey.tex",
	},
	{"COOKING", "CONTAINERS", "STRUCTURES"}
)

AddRecipe2("kyno_garden_sprinkler", {Ingredient("gears", 3), Ingredient("ice", 15), Ingredient("trinket_6", 3)}, TECH.LOST,
	{
		placer              = "kyno_garden_sprinkler_placer",
		min_spacing         = 3,
		atlas               = ModAtlas,
		image               = "kyno_garden_sprinkler.tex",
	},
	{"GARDENING", "STRUCTURES"}
)

AddRecipe2("kyno_foodsack", {Ingredient("saltrock", 10), Ingredient("malbatross_feathered_weave", 4), Ingredient("bluegem", 1)}, TECH.LOST,
	{
		atlas               = ModAtlas,
		image               = "kyno_foodsack.tex",
	},
	{"COOKING", "CONTAINERS"}
)

AddRecipe2("slow_farmplot", {Ingredient("cutgrass", 8), Ingredient("poop", 4), Ingredient("log", 4)}, TECH.LOST,
	{
		placer              = "slow_farmplot_placer",
		min_spacing         = 3,
		hint_msg            = "NEEDSMEADOWSHOP",
		atlas               = DefaultAtlas,
		image               = "slow_farmplot.tex",
	},
	{"GARDENING", "STRUCTURES"}
)

AddRecipe2("fast_farmplot", {Ingredient("cutgrass", 10), Ingredient("poop", 6), Ingredient("rocks", 4)}, TECH.LOST,
	{
		placer              = "fast_farmplot_placer",
		min_spacing         = 3,
		hint_msg            = "NEEDSMEADOWSHOP",
		atlas               = DefaultAtlas,
		image               = "fast_farmplot.tex",
	},
	{"GARDENING", "STRUCTURES"}
)

AddRecipe2("kyno_itemshowcaser", {Ingredient("boards", 3), Ingredient("rope", 3), Ingredient("moonglass", 5)}, TECH.CARPENTRY_THREE,
	{
		placer              = "kyno_itemshowcaser_placer",
		min_spacing         = 1.75,
		station_tag         = "carpentry_station",
		atlas               = ModAtlas,
		image               = "kyno_itemshowcaser.tex",
	},
	{"CRAFTING_STATION", "STRUCTURES"}
)

AddRecipe2("kyno_messagebottle_empty", {Ingredient("moonglass", 3)}, TECH.SCIENCE_ONE,
	{
		atlas               = ModAtlas,
		image               = "kyno_messagebottle_empty.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_malbatrossfood", {Ingredient("chum", 1), Ingredient("oceanfish_medium_2_inv", 2), Ingredient("kyno_mysterymeat", 1, ModAtlas)}, TECH.LOST,
	{
		atlas 				= ModAtlas,
		image 				= "kyno_malbatrossfood.tex",
	},
	{"FISHING"}
)

AddRecipe2("kyno_oceantrap", {Ingredient("kyno_seaweeds", 4, ModAtlas), Ingredient("kyno_messagebottle_empty", 2, ModAtlas), Ingredient("kyno_jellyfish", 1, ModAtlas)}, TECH.FISHING_ONE,
	{
		atlas               = ModAtlas,
		image               = "kyno_oceantrap.tex",
	},
	{"TOOLS", "GARDENING", "FISHING"}
)

AddRecipe2("kyno_brainrock_nubbin", {Ingredient("rocks", 6), Ingredient("kyno_brainrock_larvae", 1, ModAtlas)}, TECH.SEAFARING_ONE,
	{
		atlas               = ModAtlas,
		image               = "kyno_brainrock_nubbin.tex",
	},
	{"REFINE", "SEAFARING"}
)

AddRecipe2("kyno_fishregistryhat", {Ingredient("strawhat", 1), Ingredient("oceanfishinglure_spinner_red", 3), Ingredient("kyno_seaweeds", 1, ModAtlas)}, TECH.FISHING_ONE,
	{
		atlas               = ModAtlas,
		image               = "kyno_fishregistryhat.tex",
	},
	{"FISHING", "GARDENING"}
)

AddRecipe2("kyno_animalfeeder", {Ingredient("seeds", 3), Ingredient("kyno_wheat", 3, ModAtlas), Ingredient("boards", 3)}, TECH.SCIENCE_ONE,
	{
		placer              = "kyno_animalfeeder_placer",
		min_spacing         = 3,
		atlas               = ModAtlas,
		image               = "kyno_animalfeeder.tex",
	},
	{"GARDENING"}
)

AddRecipe2("kyno_chickenhouse", {Ingredient("kyno_chicken2", 3, ModAtlas, true), Ingredient("cutgrass", 3), Ingredient("boards", 3)}, TECH.SCIENCE_TWO,
	{
		placer              = "kyno_chickenhouse_placer",
		min_spacing         = 3,
		atlas               = ModAtlas,
		image               = "kyno_chickenhouse.tex",
	},
	{"GARDENING"}
)

AddDeconstructRecipe("kyno_chicken2", {}, { no_deconstruction = true })

AddRecipe2("kyno_dailyrecipe_sign", {Ingredient("boards", 1), Ingredient("papyrus", 1), Ingredient("featherpencil", 1)}, TECH.SCIENCE_ONE,
	{
		placer              = "kyno_dailyrecipe_sign_placer",
		min_spacing         = 2,
		atlas               = ModAtlas,
		image               = "kyno_dailyrecipe_sign.tex",
	},
	{"STRUCTURES", "COOKING"}
)

AddRecipe2("kyno_eldermandrakehouse", {Ingredient("boards", 4), Ingredient("kyno_cavetuber", 6, ModAtlas), Ingredient("mandrake", 2)}, TECH.SCIENCE_TWO,
	{
		placer              = "kyno_eldermandrakehouse_placer",
		min_spacing         = 4,
		atlas               = ModAtlas,
		image               = "kyno_eldermandrakehouse.tex",
	},
	{"STRUCTURES"}
)

AddCharacterRecipe("potatosack2", {Ingredient("cutgrass", 4), Ingredient("papyrus", 1), Ingredient("rope", 2)}, TECH.SCIENCE_ONE,
	{
		builder_tag         = "strongman",
		product             = "potatosack",
		atlas               = DefaultAtlas2,
		image               = "potato_sack_full.tex",
	},
	{"CONTAINERS", "COOKING"}
)

AddDeconstructRecipe("potatosack", {Ingredient("cutgrass", 4), Ingredient("papyrus", 1), Ingredient("rope", 2)})

AddCharacterRecipe("wendy_sugarfly", {Ingredient("ghostflower", 3), Ingredient("kyno_sugarflywings", 1)}, TECH.NONE,
	{
		no_deconstruction   = true,
		product             = "kyno_sugarfly",
		description         = "kyno_sugarfly",
		builder_skill       = "wendy_ghostflower_butterfly",
		atlas               = ModAtlas,
		image               = "kyno_sugarfly.tex",
	}
)

AddCharacterRecipe("kyno_fishermermhut_wurt", {Ingredient("boards", 4), Ingredient("cutreeds", 3), Ingredient("kyno_tropicalfish", 2, ModAtlas)}, TECH.SCIENCE_ONE,
	{
		placer              = "kyno_fishermermhut_wurt_placer",
		min_spacing         = 1.75,
		testfn              = IsTidalMarshLand,
		builder_tag         = "merm_builder",
		atlas               = ModAtlas,
		image               = "kyno_fishermermhut_wurt.tex",
	},
	{"STRUCTURES"}
)

AddCharacterRecipe("wurt_turf_tidalmarsh", {Ingredient("cutreeds", 1), Ingredient("ice", 2)}, TECH.NONE,
	{
		product             = "turf_tidalmarsh",
		description         = "turf_tidalmarsh",
		builder_tag         = "merm_builder",
		numtogive           = 4,
		atlas               = ModAtlas,
		image               = "turf_tidalmarsh.tex",
	},
	{"DECOR"}
)

-- Holy shit... he's back.
AddCharacterRecipe("kyno_book_gardening", {Ingredient("book_horticulture_upgraded", 1), Ingredient("fertilizer", 1), Ingredient("papyrus", 2)}, TECH.BOOKCRAFT_ONE,
	{
		product             = "kyno_book_gardening",
		description         = "kyno_book_gardening",
		builder_tag         = "bookbuilder",
		atlas               = DefaultAtlas1,
		image               = "book_gardening.tex",
	}
)

-- New transmutations for Wilson.
AddCharacterRecipe("transmute_red_cap", {Ingredient("green_cap", 1)}, TECH.NONE,
	{
		product             = "red_cap",
		numtogive           = 2,
		description         = "transmute_red_cap",
		builder_skill       = "wilson_alchemy_1",
		atlas               = DefaultAtlas,
		image               = "red_cap.tex",
	}
)

AddCharacterRecipe("transmute_green_cap", {Ingredient("red_cap", 3)}, TECH.NONE,
	{
		product             = "green_cap",
		description         = "transmute_green_cap",
		builder_skill       = "wilson_alchemy_1",
		atlas               = DefaultAtlas,
		image               = "green_cap.tex",
	}
)

AddCharacterRecipe("transmute_succulent", {Ingredient("foliage", 1)}, TECH.NONE,
	{
		product             = "succulent_picked",
		description         = "transmute_succulent",
		builder_skill       = "wilson_alchemy_1",
		atlas               = DefaultAtlas,
		image               = "succulent_picked.tex",
	}
)

AddCharacterRecipe("transmute_foliage", {Ingredient("succulent_picked", 1)}, TECH.NONE,
	{
		product             = "foliage",
		description         = "transmute_foliage",
		builder_skill       = "wilson_alchemy_1",
		atlas               = DefaultAtlas,
		image               = "foliage.tex",
	}
)

AddCharacterRecipe("transmute_blue_cap", {Ingredient("moon_cap", 1)}, TECH.NONE,
	{
		product             = "blue_cap",
		numtogive           = 2,
		description         = "transmute_blue_cap",
		builder_skill       = "wilson_alchemy_9",
		atlas               = DefaultAtlas,
		image               = "blue_cap.tex",
	}
)

AddCharacterRecipe("transmute_moon_cap", {Ingredient("blue_cap", 3)}, TECH.NONE,
	{
		product             = "moon_cap",
		description         = "transmute_moon_cap",
		builder_skill       = "wilson_alchemy_9",
		atlas               = DefaultAtlas2,
		image               = "moon_cap.tex",
	}
)

AddCharacterRecipe("transmute_kyno_white_cap", {Ingredient("kyno_truffles", 1, ModAtlas)}, TECH.NONE,
	{
		product             = "kyno_white_cap",
		numtogive           = 2,
		description         = "transmute_kyno_white_cap",
		builder_skill       = "wilson_alchemy_9",
		atlas               = ModAtlas,
		image               = "kyno_white_cap.tex",
	}
)

AddCharacterRecipe("transmute_kyno_sporecap", {Ingredient("red_cap", 1), Ingredient("green_cap", 1), Ingredient("blue_cap", 1), Ingredient("moon_cap", 1),
Ingredient("kyno_white_cap", 1, ModAtlas)}, TECH.NONE,
	{
		product             = "kyno_sporecap",
		description         = "transmute_kyno_sporecap",
		builder_skill       = "wilson_alchemy_10",
		atlas               = ModAtlas,
		image               = "kyno_sporecap.tex",
	}
)

AddCharacterRecipe("transmute_kyno_sporecap_dark", {Ingredient("red_cap", 1), Ingredient("green_cap", 1), Ingredient("blue_cap", 1), Ingredient("moon_cap", 1),
Ingredient("kyno_white_cap", 1, ModAtlas)}, TECH.NONE,
	{
		product             = "kyno_sporecap_dark",
		description         = "transmute_kyno_sporecap_dark",
		builder_skill       = "wilson_alchemy_10",
		atlas               = ModAtlas,
		image               = "kyno_sporecap_dark.tex",
	}
)

AddCharacterRecipe("transmute_kyno_truffles", {Ingredient("kyno_white_cap", 3, ModAtlas)}, TECH.NONE,
	{
		product             = "kyno_truffles",
		description         = "transmute_kyno_truffles",
		builder_skill       = "wilson_alchemy_9",
		atlas               = ModAtlas,
		image               = "kyno_truffles.tex",
	}
)

AddCharacterRecipe("transmute_berries", {Ingredient("berries_juicy", 1)}, TECH.NONE,
	{
		product             = "berries",
		numtogive           = 2,
		description         = "transmute_berries",
		builder_skill       = "wilson_alchemy_4",
		atlas               = DefaultAtlas,
		image               = "berries.tex",
	}
)

AddCharacterRecipe("transmute_berries_juicy", {Ingredient("berries", 3)}, TECH.NONE,
	{
		product             = "berries_juicy",
		description         = "transmute_berries_juicy",
		builder_skill       = "wilson_alchemy_4",
		atlas               = DefaultAtlas,
		image               = "berries_juicy.tex",
	}
)

AddCharacterRecipe("transmute_fishmeat", {Ingredient("fishmeat_small", 3)}, TECH.NONE,
	{
		product             = "fishmeat",
		description         = "transmute_fishmeat",
		builder_skill       = "wilson_alchemy_4",
		atlas               = DefaultAtlas2,
		image               = "fishmeat.tex",
	}
)

AddCharacterRecipe("transmute_fishmeat_small", {Ingredient("fishmeat", 1)}, TECH.NONE,
	{
		product             = "fishmeat_small",
		numtogive           = 2,
		description         = "transmute_fishmeat_small",
		builder_skill       = "wilson_alchemy_4",
		atlas               = DefaultAtlas2,
		image               = "fishmeat_small.tex",
	}
)

AddCharacterRecipe("transmute_fossil_piece", {Ingredient("kyno_worm_bone", 3, ModAtlas)}, TECH.NONE,
	{
		product             = "fossil_piece",
		description         = "transmute_fossil_piece",
		builder_skill       = "wilson_alchemy_10",
		atlas               = DefaultAtlas,
		image               = "fossil_piece.tex",
	}
)

AddCharacterRecipe("transmute_kyno_worm_bone", {Ingredient("fossil_piece", 1)}, TECH.NONE,
	{
		product             = "kyno_worm_bone",
		numtogive           = 2,
		description         = "transmute_kyno_worm_bone",
		builder_skill       = "wilson_alchemy_10",
		atlas               = ModAtlas,
		image               = "kyno_worm_bone.tex",
	}
)

AddRecipe2("hermitshop_kyno_malbatrossfood_blueprint", {Ingredient("messagebottleempty", 10)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock            = true,
		no_deconstruction   = true,
		actionstr           = "HERMITCRABSHOP",
		description         = "kyno_malbatrossfood_blueprint",
		sg_state            = "give",
		product             = "kyno_malbatrossfood_blueprint",
		atlas               = DefaultAtlas,
		image               = "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

-- For people who wants to use Warly's Grinding Mill as the Mealing Stone.
if HOF_WARLYMEALGRINDER then
	AddRecipe2("kyno_flour_w", {Ingredient("kyno_wheat", 2, ModAtlas)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock 			= true,
			no_deconstruction   = true,
			actionstr 			= "MEALGRINDER",
			product				= "kyno_flour",
			builder_tag         = "professionalchef",
			numtogive 			= 3,
			atlas 				= DefaultAtlas,
			image 				= "quagmire_flour.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("kyno_spotspice_w", {Ingredient("kyno_spotspice_leaf", 2, ModAtlas)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock 			= true,
			no_deconstruction   = true,
			actionstr 			= "MEALGRINDER",
			product				= "kyno_spotspice",
			builder_tag         = "professionalchef",
			numtogive 			= 3,
			atlas 				= DefaultAtlas,
			image 				= "quagmire_spotspice_ground.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("kyno_salt_w", {Ingredient("saltrock", 2)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock 			= true,
			no_deconstruction   = true,
			actionstr 			= "MEALGRINDER",
			product				= "kyno_salt",
			builder_tag         = "professionalchef",
			numtogive 			= 3,
			atlas 				= DefaultAtlas,
			image 				= "quagmire_salt.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("kyno_bacon_w", {Ingredient("smallmeat", 1)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock 			= true,
			no_deconstruction   = true,
			actionstr 			= "MEALGRINDER",
			product				= "kyno_bacon",
			builder_tag         = "professionalchef",
			numtogive 			= 2,
			atlas 				= DefaultAtlas,
			image 				= "quagmire_smallmeat.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("kyno_oil_w", {Ingredient("corn", 1), Ingredient("seeds", 1), Ingredient("petals", 2)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock			= true,
			no_deconstruction   = true,
			actionstr			= "MEALGRINDER",
			product				= "kyno_oil",
			builder_tag			= "professionalchef",
			numtogive			= 3,
			atlas				= ModAtlas,
			image				= "kyno_oil.tex",
		},
	{"CRAFTING_STATION"}
	)

	AddRecipe2("kyno_sugar_w", {Ingredient("kyno_sugartree_petals", 1, ModAtlas)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock 			= true,
			no_deconstruction   = true,
			actionstr 			= "MEALGRINDER",
			product				= "kyno_sugar",
			builder_tag         = "professionalchef",
			numtogive 			= 3,
			atlas 				= ModAtlas,
			image 				= "kyno_sugar.tex",
		},
		{"CRAFTING_STATION"}
	)
end

-- Replace the Bucket-o-Poop recipe with ours.
if HOF_FERTILIZERTWEAK then
	AllRecipes["fertilizer"].ingredients = {Ingredient("poop", 3), Ingredient("kyno_bucket_empty", 1, ModAtlas)}
end

-- Pearl Tea Shop.
local NUM_TEASHOP_LEVELS = 3
local NUM_COMMON_PETALS_FOR_TEASHOP_LEVEL = { 8, 6, 4 }
local NUM_RARE_PETALS_FOR_TEASHOP_LEVEL = { 6, 4, 2 }
for i = 1, NUM_TEASHOP_LEVELS do
	local num_common_petals = NUM_COMMON_PETALS_FOR_TEASHOP_LEVEL[i]
	local num_rare_petals = NUM_RARE_PETALS_FOR_TEASHOP_LEVEL[i]

	AddRecipe2("kyno_hermitcrabtea_aloe_"..i, {Ingredient("messagebottleempty", 1), Ingredient("kyno_aloe_dried", num_rare_petals, ModAtlas)}, TECH.LOST,
		{
			nounlock            = true,
			manufactured        = true,
			actionstr           = "HERMITCRABSHOP",
			hint_msg            = "NEEDSHERMITCRAB_TEASHOP",
			product             = "kyno_hermitcrabtea_aloe",
			sg_state            = "give",
			atlas               = ModAtlas,
			image               = "kyno_hermitcrabtea_aloe.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("kyno_hermitcrabtea_sugartree_petals_"..i, {Ingredient("messagebottleempty", 1),
	Ingredient("kyno_sugartree_petals_dried", num_common_petals, ModAtlas)}, TECH.LOST,
		{
			nounlock            = true,
			manufactured        = true,
			actionstr           = "HERMITCRABSHOP",
			hint_msg            = "NEEDSHERMITCRAB_TEASHOP",
			product             = "kyno_hermitcrabtea_sugartree_petals",
			sg_state            = "give",
			atlas               = ModAtlas,
			image               = "kyno_hermitcrabtea_sugartree_petals.tex",
		},
		{"CRAFTING_STATION"}
	)
end

-- Construction Plans.
AddRecipe2("kyno_fishfarmplot_construction", {}, TECH.LOST,
	{
		placer              = "kyno_fishfarmplot_construction_placer",
		min_spacing         = 5,
		testfn              = function(pt) return TheWorld.Map:GetPlatformAtPoint(pt.x, 0, pt.z, 0.5) == nil end,
		nameoverride        = "kyno_fishfarmplot",
		description         = "kyno_fishfarmplot_kit",
		atlas               = ModAtlas,
		image               = "kyno_fishfarmplot_construction.tex",
	},
	{"GARDENING", "FISHING"}
)

CONSTRUCTION_PLANS["kyno_fishfarmplot_construction"] =
{
	Ingredient("shovel",            1, nil,      nil),
	Ingredient("kyno_bucket_water", 1, ModAtlas, nil),
	Ingredient("rocks",            20, nil,      nil),
	Ingredient("chum",              5, nil,      nil),
}

AddDeconstructRecipe("kyno_fishfarmplot", {Ingredient("rocks", 20)})

-- Complementary Mod Spices for Warly.
if TUNING.HOF_WARLYSPICES then
	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - Added Mod Spices Recipes.")
	end

	AddRecipe2("spice_fed", {Ingredient("corn", 3)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock			= true,
			builder_tag			= "spicemaker",
			numtogive			= 2,
			atlas				= ModAtlas,
			image				= "spice_fed.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("spice_cure", {Ingredient("kyno_spotspice", 3, ModAtlas)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock			= true,
			builder_tag			= "spicemaker",
			numtogive			= 2,
			atlas				= ModAtlas,
			image				= "spice_cure.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("spice_mind", {Ingredient("kyno_sugartree_petals", 3, ModAtlas)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock            = true,
			builder_tag         = "spicemaker",
			numtogive           = 2,
			atlas               = ModAtlas,
			image               = "spice_mind.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("spice_cold", {Ingredient("oceanfish_medium_8_inv", 1)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock            = true,
			builder_tag         = "spicemaker",
			numtogive           = 2,
			atlas               = ModAtlas,
			image               = "spice_cold.tex",
		},
		{"CRAFTING_STATION"}
	)

	AddRecipe2("spice_fire", {Ingredient("oceanfish_small_8_inv", 1)}, TECH.FOODPROCESSING_ONE,
		{
			nounlock            = true,
			builder_tag         = "spicemaker",
			numtogive           = 2,
			atlas               = ModAtlas,
			image               = "spice_fire.tex",
		},
		{"CRAFTING_STATION"}
	)
end