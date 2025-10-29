local map = require("map/forest_map")

local customizations_worldgen =
{	
	-- WORLDGEN
	aloes           = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 0,  world = {"forest"}},
	asparaguses     = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 1,  world = {"forest", "cave"}},
	fennels         = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 2,  world = {"cave"}},
	giantparznips   = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 3,  world = {"cave"}},
	mushstumps      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 4,  world = {"forest", "cave"}},
	truffles        = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 5,  world = {"forest"}},
	parznips        = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 6,  world = {"cave"}},
	radishes        = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 7,  world = {"forest"}},
	rockflippables  = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 8,  world = {"forest", "cave"}},
	sweetpotatoes   = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 9,  world = {"forest"}},
	turnips         = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 10, world = {"forest", "cave"}},
	wildwheats      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof",          order = 11, world = {"forest"}},
	
	-- OCEANGEN
	antchovies      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 0,  world = {"forest"}},
	jellyfishes     = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 1,  world = {"forest"}},
	jellyfishes2    = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 2,  world = {"forest"}},
	lotusplants     = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_ocean",    order = 3,  world = {"forest"}},
	oceancrates     = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 4,  world = {"forest"}},
	oceanwrecks     = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_ocean",    order = 5,  world = {"forest"}},
	seacucumbers    = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 6,  world = {"forest"}},
	taroroots       = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 7,  world = {"forest"}},
	waterycresses   = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 8,  world = {"forest"}},
	weedsea         = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "hof_ocean",    order = 9,  world = {"forest"}},
	
	-- SERENITYISLAND
 -- serenityisland  = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity", order = 0,  world = {"forest"}},
	chickens        = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity", order = 1,  world = {"forest"}},
	pebblecrabs     = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity", order = 2,  world = {"forest"}},
	saltponds       = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity", order = 3,  world = {"forest"}},
	spotbushes      = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity", order = 4,  world = {"forest"}},
	sugarflowers    = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity", order = 5,  world = {"forest"}},
	sugartrees      = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_serenity", order = 6,  world = {"forest"}},
	
	-- MEADOWISLAND
 -- meadowisland    = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 0,    world = {"forest"}},
	fishermermhuts  = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 1,    world = {"forest"}},
	islandcrates    = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 5,    world = {"forest"}},
	kokonuttrees    = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 3,    world = {"forest"}},
	limpetrocks     = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 4,    world = {"forest"}},
	mermhuts        = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 2,    world = {"forest"}},
	pikotrees       = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 6,    world = {"forest"}},
	pineapplebushes = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 7,    world = {"forest"}},
	sandhills       = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 8,    world = {"forest"}},
	teatrees        = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 9,    world = {"forest"}},
	tidalpools      = {category = LEVELCATEGORY.WORLDGEN, desc = "yesno_descriptions",              group = "hof_meadow", order = 10,   world = {"forest"}},
}

map.TRANSLATE_TO_PREFABS["aloes"]           = {"kyno_aloe_ground"}
map.TRANSLATE_TO_PREFABS["asparaguses"]     = {"kyno_aspargos_ground"}
map.TRANSLATE_TO_PREFABS["fennels"]         = {"kyno_fennel_ground"}
map.TRANSLATE_TO_PREFABS["giantparznips"]   = {"kyno_parznip_big"}
map.TRANSLATE_TO_PREFABS["mushstumps"]      = {"kyno_mushstump_natural", "kyno_mushstump_cave"}
map.TRANSLATE_TO_PREFABS["truffles"]        = {"kyno_truffles_ground"}
map.TRANSLATE_TO_PREFABS["radishes"]        = {"kyno_radish_ground"}
map.TRANSLATE_TO_PREFABS["rockflippables"]  = {"kyno_rockflippable", "kyno_rockflippable_cave"}
map.TRANSLATE_TO_PREFABS["sweetpotatoes"]   = {"kyno_sweetpotato_ground"}
map.TRANSLATE_TO_PREFABS["turnips"]         = {"kyno_turnip_ground"}
map.TRANSLATE_TO_PREFABS["wildwheats"]      = {"kyno_wildwheat"}

map.TRANSLATE_TO_PREFABS["antchovies"]      = {"kyno_antchovy_spawner"}
map.TRANSLATE_TO_PREFABS["jellyfishes"]     = {"kyno_jellyfish_ocean", "kyno_jellyfish_spawner"}
map.TRANSLATE_TO_PREFABS["jellyfishes2"]    = {"kyno_jellyfish_rainbow_ocean", "kyno_jellyfish_rainbow_spawner"}
map.TRANSLATE_TO_PREFABS["lotusplants"]     = {"kyno_lotus_ocean"}
map.TRANSLATE_TO_PREFABS["oceancrates"]     = {"kyno_watery_crate", "kyno_serenityisland_crate", "kyno_serenityisland_crate_spawner"}
map.TRANSLATE_TO_PREFABS["seacucumbers"]    = {"kyno_cucumber_ground"}
map.TRANSLATE_TO_PREFABS["taroroots"]       = {"kyno_taroroot_ocean"}
map.TRANSLATE_TO_PREFABS["waterycresses"]   = {"kyno_waterycress_ocean"}
map.TRANSLATE_TO_PREFABS["weedsea"]         = {"kyno_seaweeds_ocean"}

-- Required prefab, can't change.
-- map.TRANSLATE_TO_PREFABS["serenityisland"]  = {"kyno_serenityisland_shop", "kyno_serenityisland_decor2", "kyno_repairtool"}
map.TRANSLATE_TO_PREFABS["chickens"]        = {"kyno_chicken", "kyno_chicken2", "kyno_chicken2_herd"}
map.TRANSLATE_TO_PREFABS["pebblecrabs"]     = {"kyno_pebblecrab", "kyno_pebblecrab_spawner"}
map.TRANSLATE_TO_PREFABS["saltponds"]       = {"kyno_pond_salt"}
map.TRANSLATE_TO_PREFABS["spotbushes"]      = {"kyno_spotbush"}
map.TRANSLATE_TO_PREFABS["sugarflies"]      = {"kyno_sugarfly"}
map.TRANSLATE_TO_PREFABS["sugarflowers"]    = {"kyno_sugartree_flower"}
map.TRANSLATE_TO_PREFABS["sugartrees"]      = {"kyno_sugartree"}

-- Required prefab, can't change.
-- map.TRANSLATE_TO_PREFABS["meadowisland"]    = {"kyno_meadowisland_shop", "kyno_meadowisland_mermcart"}
map.TRANSLATE_TO_PREFABS["fishermerms"]     = {"kyno_meadowisland_mermfisher"}
map.TRANSLATE_TO_PREFABS["fishermermhuts"]  = {"kyno_meadowisland_fishermermhut"}
map.TRANSLATE_TO_PREFABS["islandcrates"]    = {"kyno_meadowisland_crate"}
map.TRANSLATE_TO_PREFABS["kokonuttrees"]    = {"kyno_kokonuttree"}
map.TRANSLATE_TO_PREFABS["limpetrocks"]     = {"kyno_limpetrock"}
map.TRANSLATE_TO_PREFABS["mermhuts"]        = {"kyno_meadowisland_mermhut"}
map.TRANSLATE_TO_PREFABS["pikos"]           = {"kyno_piko"}
map.TRANSLATE_TO_PREFABS["pikosorange"]     = {"kyno_piko_orange"}
map.TRANSLATE_TO_PREFABS["pikotrees"]       = {"kyno_meadowisland_pikotree"}
map.TRANSLATE_TO_PREFABS["pineapplebushes"] = {"kyno_pineapplebush", "kyno_pineapplebush2"}
map.TRANSLATE_TO_PREFABS["sandhills"]       = {"kyno_meadowisland_sandhill"}
map.TRANSLATE_TO_PREFABS["teatrees"]        = {"kyno_meadowisland_tree"}
map.TRANSLATE_TO_PREFABS["tidalpools"]      = {"kyno_meadowisland_pond"}

for k, v in pairs(customizations_worldgen) do
	v.name     = k
	
	v.category = v.category
	v.group    = v.group
	v.order    = v.order
	
	v.value    = v.value or "default"
	v.desc     = v.desc  or "frequency_descriptions"
	v.world    = v.world or {"forest"}
end

return customizations_worldgen