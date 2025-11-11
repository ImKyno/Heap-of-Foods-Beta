local map = require("map/forest_map")

local customizations_worldgen =
{	
	-- WORLDGEN
	aloes           = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 0,  world = { "forest" }},
	asparaguses     = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 1,  world = { "forest", "cave" }},
	coffeebushes    = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 2,  world = { "cave" }},
	fennels         = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 3,  world = { "cave" }},
	giantparznips   = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 4,  world = { "cave" }},
	mushstumps      = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 5,  world = { "forest", "cave" }},
	truffles        = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 6,  world = { "forest" }},
	parznips        = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 7,  world = { "cave" }},
	radishes        = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 8,  world = { "forest" }},
	rockflippables  = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 9,  world = { "forest", "cave" }},
	sweetpotatoes   = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 10, world = { "forest" }},
	turnips         = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 11, world = { "forest", "cave" }},
	wildwheats      = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_regrow",    order = 12, world = { "forest" }},
	
	-- OCEANGEN
	brainrocks      = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_ocean",     order = 7,  world = { "forest" }},
	lotusplants     = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_ocean",     order = 0,  world = { "forest" }},
	oceancrates     = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 1,  world = { "forest" }},
	oceanwrecks     = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_ocean",     order = 2,  world = { "forest" }},
	seacucumbers    = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 3,  world = { "forest" }},
	taroroots       = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 4,  world = { "forest" }},
	waterycresses   = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 5,  world = { "forest" }},
	weedsea         = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",     order = 6,  world = { "forest" }},
	
	-- OCEANCREATURES
	antchovies      = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 2,  world = { "forest" }},
	chickens        = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_creatures", order = 0,  world = { "forest" }},
	dogfishes       = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 5,  world = { "forest" }},
	hermitwobsters  = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_creatures", order = 6,  world = { "forest" }},
	jellyfishes     = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 3,  world = { "forest" }},
	jellyfishes2    = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 4,  world = { "forest" }},
	pebblecrabs     = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_creatures", order = 1,  world = { "forest" }},
	puffermonsters  = { category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_creatures", order = 8,  world = { "forest" }},
	swordfishes     = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_creatures", order = 7,  world = { "forest" }},
	
	-- SERENITYISLAND
	saltponds       = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity",  order = 3,  world = { "forest" }},
	spotbushes      = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity",  order = 4,  world = { "forest" }},
	sugarflowers    = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity",  order = 5,  world = { "forest" }},
	sugartrees      = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity",  order = 6,  world = { "forest" }},
	
	-- MEADOWISLAND
	fishermermhuts  = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 1,  world = { "forest" }},
	islandcrates    = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 5,  world = { "forest" }},
	kokonuttrees    = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 3,  world = { "forest" }},
	limpetrocks     = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 4,  world = { "forest" }},
	mermhuts        = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 2,  world = { "forest" }},
	pikotrees       = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 6,  world = { "forest" }},
	pineapplebushes = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 7,  world = { "forest" }},
	sandhills       = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 8,  world = { "forest" }},
	teatrees        = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 9,  world = { "forest" }},
	tidalpools      = { category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow",    order = 10, world = { "forest" }},
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
	
	v.category = v.category
	v.group    = v.group
	v.order    = v.order
	
	v.value    = v.value or "default"
	v.desc     = v.desc  or "frequency_descriptions"
	v.world    = v.world or { "forest" }
end

return customizations_worldgen