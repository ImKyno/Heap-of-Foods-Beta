local _G = GLOBAL

-- For sorting recipe.
-- From Island Adventures: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
local function SortRecipe(a, b, filter_name, offset)
	local filter = _G.CRAFTING_FILTERS[filter_name]

	if filter and filter.recipes then
		for sortvalue, product in ipairs(filter.recipes) do
			if product == a then
				table.remove(filter.recipes, sortvalue)
				break
			end
		end

		local target_position = #filter.recipes + 1

		for sortvalue, product in ipairs(filter.recipes) do
			if product == b then
				target_position = sortvalue + offset
				break
			end
		end

		table.insert(filter.recipes, target_position, a)
	end
end

local function SortBefore(a, b, filter_name)
	SortRecipe(a, b, filter_name, 0)
end

local function SortAfter(a, b, filter_name)
	SortRecipe(a, b, filter_name, 1)
end

SortAfter("kyno_musselstick_item",                    "ocean_trawler_kit",                "GARDENING")
SortAfter("kyno_musselstick_item",                    "kyno_fishfarmplot_construction",   "FISHING")
SortAfter("kyno_mealgrinder",                         "wintersfeastoven",                 "COOKING")
SortAfter("kyno_mushstump",                           "mushroom_farm",                    "GARDENING")
SortAfter("kyno_floatilizer",                         "fertilizer",                       "GARDENING")
SortAfter("kyno_bucket_empty",                        "goldenpitchfork",                  "TOOLS")
SortAfter("kyno_itemslicer",                          "razor",                            "TOOLS")
SortAfter("kyno_brewbook",                            "cookbook",                         "COOKING")
SortAfter("kyno_woodenkeg",                           "cookpot",                          "COOKING")
SortAfter("kyno_woodenkeg",                           "cookpot",                          "STRUCTURES")
SortAfter("kyno_preservesjar",                        "kyno_woodenkeg",                   "COOKING")
SortAfter("kyno_preservesjar",                        "kyno_woodenkeg",                   "STRUCTURES")
SortAfter("kyno_antchest",                            "saltbox",                          "CONTAINERS")
SortAfter("kyno_antchest",                            "saltbox",                          "STRUCTURES")
SortAfter("kyno_antchest",                            "saltbox",                          "COOKING")
SortAfter("kyno_garden_sprinkler",                    "firesuppressor",                   "STRUCTURES")
SortAfter("kyno_garden_sprinkler",                    "compostwrap",                      "GARDENING")
SortAfter("kyno_foodsack",                            "icepack",                          "COOKING")
SortAfter("kyno_foodsack",                            "icepack",                          "CONTAINERS")
SortAfter("slow_farmplot",                            "farm_plow_item",                   "GARDENING")
SortAfter("slow_farmplot",                            "meatrack",                         "STRUCTURES")
SortAfter("fast_farmplot",                            "slow_farmplot",                    "GARDENING")
SortAfter("fast_farmplot",                            "slow_farmplot",                    "STRUCTURES")
SortAfter("kyno_itemshowcaser",                       "endtable",                         "STRUCTURES")
SortAfter("kyno_malbatrossfood",                      "chum",                             "FISHING")
SortAfter("kyno_oceantrap",                           "trap",                             "TOOLS")
SortAfter("kyno_oceantrap",                           "trap",                             "GARDENING")
SortAfter("kyno_brainrock_nubbin",                    "dock_woodposts_item",              "SEAFARING")
SortAfter("kyno_fishregistryhat",                     "tacklestation",                    "FISHING")
SortAfter("kyno_fishregistryhat",                     "plantregistryhat",                 "GARDENING")
SortAfter("kyno_animalfeeder",                        "kyno_mushstump",                   "GARDENING")
SortAfter("kyno_chickenhouse",                        "beebox",                           "GARDENING")
SortAfter("kyno_eldermandrakehouse",                  "rabbithouse",                      "STRUCTURES")
SortAfter("potatosack2",                              "mighty_gym",                       "CHARACTER")
SortBefore("potatosack2",                             "icebox",                           "CONTAINERS")
SortBefore("potatosack2",                             "icebox",                           "COOKING")
SortAfter("kyno_fishermermhut_wurt",                  "mermhouse_crafted",                "CHARACTER")
SortAfter("kyno_fishermermhut_wurt",                  "mermhouse_crafted",                "STRUCTURES")
SortAfter("wurt_turf_tidalmarsh",                     "wurt_turf_marsh",                  "CHARACTER")
SortAfter("wurt_turf_tidalmarsh",                     "turf_marsh",                       "DECOR")
SortAfter("kyno_book_gardening",                      "book_horticulture_upgraded",       "CHARACTER")
SortBefore("transmute_red_cap",                       "transmute_meat",                   "CHARACTER")
SortAfter("transmute_green_cap",                      "transmute_red_cap",                "CHARACTER")
SortAfter("transmute_succulent",                      "transmute_green_cap",              "CHARACTER")
SortAfter("transmute_foliage",                        "transmute_succulent",              "CHARACTER")
SortAfter("transmute_blue_cap",                       "transmute_green_cap",              "CHARACTER")
SortAfter("transmute_moon_cap",                       "transmute_blue_cap",               "CHARACTER")
SortAfter("transmute_kyno_white_cap",                 "transmute_moon_cap",               "CHARACTER")
SortAfter("transmute_kyno_sporecap",                  "transmute_kyno_white_cap",         "CHARACTER")
SortAfter("transmute_kyno_sporecap_dark",             "transmute_kyno_sporecap",          "CHARACTER")
SortAfter("transmute_kyno_truffles",                  "transmute_kyno_sporecap_dark",     "CHARACTER")
SortAfter("transmute_berries",                        "transmute_kyno_truffles",          "CHARACTER")
SortAfter("transmute_berries_juicy",                  "transmute_berries",                "CHARACTER")
SortAfter("transmute_fishmeat",                       "transmute_smallmeat",              "CHARACTER")
SortAfter("transmute_fishmeat_small",                 "transmute_fishmeat",               "CHARACTER")
SortAfter("transmute_fossil_piece",                   "transmute_houndstooth",            "CHARACTER")
SortAfter("transmute_kyno_worm_bone",                 "transmute_fossil_piece",           "CHARACTER")
SortAfter("hermitshop_kyno_malbatrossfood_blueprint", "hermitshop_chum_blueprint",        "CRAFTING_STATION")
SortAfter("kyno_hermitcrabtea_aloe_1",                "hermitcrabtea_succulent_picked_1", "CRAFTING_STATION")
SortAfter("kyno_hermitcrabtea_aloe_2",                "hermitcrabtea_succulent_picked_2", "CRAFTING_STATION")
SortAfter("kyno_hermitcrabtea_aloe_3",                "hermitcrabtea_succulent_picked_3", "CRAFTING_STATION")
SortAfter("kyno_hermitcrabtea_sugartree_petals_1",    "hermitcrabtea_petals_evil_1",      "CRAFTING_STATION")
SortAfter("kyno_hermitcrabtea_sugartree_petals_2",    "hermitcrabtea_petals_evil_2",      "CRAFTING_STATION")
SortAfter("kyno_hermitcrabtea_sugartree_petals_3",    "hermitcrabtea_petals_evil_3",      "CRAFTING_STATION")
SortAfter("kyno_fishfarmplot_construction",           "trophyscale_fish",                 "FISHING")