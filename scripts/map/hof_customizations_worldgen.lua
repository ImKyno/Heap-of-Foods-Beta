local map = require("map/forest_map")

local customizations_worldgen =
{	
	-- WORLDGEN
	aloes           = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 0,  world = { "forest" }},
	asparaguses     = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 1,  world = { "forest", "cave" }},
	coffeebushes    = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 2,  world = { "cave" }},
	fennels         = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 3,  world = { "cave" }},
	giantparznips   = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 4,  world = { "cave" }},
	mushstumps      = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 5,  world = { "forest", "cave" }},
	truffles        = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 6,  world = { "forest" }},
	parznips        = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 7,  world = { "cave" }},
	radishes        = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 8,  world = { "forest" }},
	rockflippables  = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 9,  world = { "forest", "cave" }},
	sweetpotatoes   = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 10, world = { "forest" }},
	turnips         = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 11, world = { "forest", "cave" }},
	wildwheats      = { desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 12, world = { "forest" }},
	
	-- OCEANGEN
	brainrocks      = { desc = "yesno_descriptions",              group = "hof_ocean",     order = 7,  world = { "forest" }},
	lotusplants     = { desc = "yesno_descriptions",              group = "hof_ocean",     order = 0,  world = { "forest" }},
	oceancrates     = { desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 1,  world = { "forest" }},
	oceanwrecks     = { desc = "yesno_descriptions",              group = "hof_ocean",     order = 2,  world = { "forest" }},
	seacucumbers    = { desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 3,  world = { "forest" }},
	taroroots       = { desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 4,  world = { "forest" }},
	waterycresses   = { desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 5,  world = { "forest" }},
	weedsea         = { desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 6,  world = { "forest" }},
	
	-- OCEANCREATURES
	antchovies      = { desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 2,  world = { "forest" }},
	chickens        = { desc = "yesno_descriptions",              group = "hof_creatures", order = 0,  world = { "forest" }},
	dogfishes       = { desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 5,  world = { "forest" }},
	hermitwobsters  = { desc = "yesno_descriptions",              group = "hof_creatures", order = 6,  world = { "forest" }},
	jellyfishes     = { desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 3,  world = { "forest" }},
	jellyfishes2    = { desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 4,  world = { "forest" }},
	pebblecrabs     = { desc = "yesno_descriptions",              group = "hof_creatures", order = 1,  world = { "forest" }},
	puffermonsters  = { desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 8,  world = { "forest" }},
	swordfishes     = { desc = "yesno_descriptions",              group = "hof_creatures", order = 7,  world = { "forest" }},
	
	-- SERENITYISLAND
	saltponds       = { desc = "yesno_descriptions",              group = "hof_serenity",  order = 0,  world = { "forest" }},
	spotbushes      = { desc = "yesno_descriptions",              group = "hof_serenity",  order = 1,  world = { "forest" }},
	sugarflowers    = { desc = "yesno_descriptions",              group = "hof_serenity",  order = 2,  world = { "forest" }},
	sugartrees      = { desc = "yesno_descriptions",              group = "hof_serenity",  order = 3,  world = { "forest" }},
	
	-- MEADOWISLAND
	fishermermhuts  = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 0,  world = { "forest" }},
	islandcrates    = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 4,  world = { "forest" }},
	kokonuttrees    = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 2,  world = { "forest" }},
	limpetrocks     = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 3,  world = { "forest" }},
	mermhuts        = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 1,  world = { "forest" }},
	pikotrees       = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 5,  world = { "forest" }},
	pineapplebushes = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 6,  world = { "forest" }},
	sandhills       = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 7,  world = { "forest" }},
	teatrees        = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 8,  world = { "forest" }},
	tidalpools      = { desc = "yesno_descriptions",              group = "hof_meadow",    order = 9,  world = { "forest" }},
}

map.TRANSLATE_TO_PREFABS["aloes"]           = { "kyno_aloe_ground" }
map.TRANSLATE_TO_PREFABS["asparaguses"]     = { "kyno_aspargos_ground" }
map.TRANSLATE_TO_PREFABS["coffeebushes"]    = { "kyno_coffeebush" }
map.TRANSLATE_TO_PREFABS["fennels"]         = { "kyno_fennel_ground" }
map.TRANSLATE_TO_PREFABS["giantparznips"]   = { "kyno_parznip_big" }
map.TRANSLATE_TO_PREFABS["mushstumps"]      = { "kyno_mushstump_natural", "kyno_mushstump_cave" }
map.TRANSLATE_TO_PREFABS["truffles"]        = { "kyno_truffles_ground" }
map.TRANSLATE_TO_PREFABS["radishes"]        = { "kyno_radish_ground" }
map.TRANSLATE_TO_PREFABS["rockflippables"]  = { "kyno_rockflippable", "kyno_rockflippable_cave" }
map.TRANSLATE_TO_PREFABS["sweetpotatoes"]   = { "kyno_sweetpotato_ground" }
map.TRANSLATE_TO_PREFABS["turnips"]         = { "kyno_turnip_ground" }
map.TRANSLATE_TO_PREFABS["wildwheats"]      = { "kyno_wildwheat" }

map.TRANSLATE_TO_PREFABS["brainrocks"]      = { "kyno_brainrock_rock" }
map.TRANSLATE_TO_PREFABS["lotusplants"]     = { "kyno_lotus_ocean" }
map.TRANSLATE_TO_PREFABS["oceancrates"]     = { "kyno_watery_crate", "kyno_serenityisland_crate", "kyno_serenityisland_crate_spawner" }
map.TRANSLATE_TO_PREFABS["seacucumbers"]    = { "kyno_cucumber_ground" }
map.TRANSLATE_TO_PREFABS["taroroots"]       = { "kyno_taroroot_ocean" }
map.TRANSLATE_TO_PREFABS["waterycresses"]   = { "kyno_waterycress_ocean" }
map.TRANSLATE_TO_PREFABS["weedsea"]         = { "kyno_seaweeds_ocean" }

map.TRANSLATE_TO_PREFABS["antchovies"]      = { "kyno_antchovy_spawner" }
map.TRANSLATE_TO_PREFABS["chickens"]        = { "kyno_chicken", "kyno_chicken2", "kyno_chicken2_herd" }
map.TRANSLATE_TO_PREFABS["dogfishes"]       = { "kyno_dogfish", "kyno_dogfish_spawner" }
map.TRANSLATE_TO_PREFABS["fishermerms"]     = { "kyno_meadowisland_mermfisher" }
map.TRANSLATE_TO_PREFABS["hermitwobsters"]  = { "wobster_monkeyisland", "wobster_monkeyisland_land", "kyno_wobster_den_monkeyisland" }
map.TRANSLATE_TO_PREFABS["jellyfishes"]     = { "kyno_jellyfish_ocean", "kyno_jellyfish_spawner" }
map.TRANSLATE_TO_PREFABS["jellyfishes2"]    = { "kyno_jellyfish_rainbow_ocean", "kyno_jellyfish_rainbow_spawner" }
map.TRANSLATE_TO_PREFABS["pebblecrabs"]     = { "kyno_pebblecrab", "kyno_pebblecrab_spawner" }
map.TRANSLATE_TO_PREFABS["pikos"]           = { "kyno_piko" }
map.TRANSLATE_TO_PREFABS["pikosorange"]     = { "kyno_piko_orange" }
map.TRANSLATE_TO_PREFABS["puffermonsters"]  = { "kyno_puffermonster", "kyno_puffermonster_spawner" }
map.TRANSLATE_TO_PREFABS["sugarflies"]      = { "kyno_sugarfly" }
map.TRANSLATE_TO_PREFABS["swordfishes"]     = { "kyno_swordfish", "kyno_swordfish_spawner" }

map.TRANSLATE_TO_PREFABS["saltponds"]       = { "kyno_pond_salt" }
map.TRANSLATE_TO_PREFABS["spotbushes"]      = { "kyno_spotbush" }
map.TRANSLATE_TO_PREFABS["sugarflowers"]    = { "kyno_sugartree_flower" }
map.TRANSLATE_TO_PREFABS["sugartrees"]      = { "kyno_sugartree" }

map.TRANSLATE_TO_PREFABS["fishermermhuts"]  = { "kyno_meadowisland_fishermermhut" }
map.TRANSLATE_TO_PREFABS["islandcrates"]    = { "kyno_meadowisland_crate" }
map.TRANSLATE_TO_PREFABS["kokonuttrees"]    = { "kyno_kokonuttree" }
map.TRANSLATE_TO_PREFABS["limpetrocks"]     = { "kyno_limpetrock" }
map.TRANSLATE_TO_PREFABS["mermhuts"]        = { "kyno_meadowisland_mermhut" }
map.TRANSLATE_TO_PREFABS["pikotrees"]       = { "kyno_meadowisland_pikotree" }
map.TRANSLATE_TO_PREFABS["pineapplebushes"] = { "kyno_pineapplebush", "kyno_pineapplebush2" }
map.TRANSLATE_TO_PREFABS["sandhills"]       = { "kyno_meadowisland_sandhill" }
map.TRANSLATE_TO_PREFABS["teatrees"]        = { "kyno_meadowisland_tree" }
map.TRANSLATE_TO_PREFABS["tidalpools"]      = { "kyno_meadowisland_pond" }

for k, v in pairs(customizations_worldgen) do
	v.name     = k
	
	v.category = LEVELCATEGORY.WORLDGEN
	v.group    = v.group
	v.order    = v.order
	
	v.value    = v.value or "default"
	v.desc     = v.desc  or "frequency_descriptions"
	v.world    = v.world or { "forest" }
end

return customizations_worldgen