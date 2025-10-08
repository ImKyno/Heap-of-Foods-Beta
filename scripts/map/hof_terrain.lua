require("map/terrain")

local function OnlyAllow(approved)
	local filter = {}
	
	for _, v in pairs(WORLD_TILES) do
		if not table.contains(approved, v) then
			table.insert(filter, v)
		end
	end
	
	return filter
end

local TERRAIN_FILTER               =
{
	kyno_aloe_ground               = OnlyAllow({ WORLD_TILES.GRASS }),
	kyno_aspargos_ground           = OnlyAllow({ WORLD_TILES.GRASS, WORLD_TILES.FOREST, WORLD_TILES.SINKHOLE }),
	kyno_radish_ground             = { WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.MONKEY_DOCK },--OnlyAllow({ WORLD_TILES.DECIDUOUS, WORLD_TILES.GRASS, WORLD_TILES.FOREST }),
	kyno_fennel_ground             = OnlyAllow({ WORLD_TILES.GRASS, WORLD_TILES.FOREST, WORLD_TILES.SINKHOLE }),
	kyno_sweetpotato_ground        = OnlyAllow({ WORLD_TILES.FOREST, WORLD_TILES.HOF_FIELDS }),
	kyno_parznip_ground            = OnlyAllow({ WORLD_TILES.MUD }),
	kyno_turnip_ground             = OnlyAllow({ WORLD_TILES.FOREST, WORLD_TILES.MARSH }),
	kyno_seaweeds_ocean            = OnlyAllow({ WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_taroroot_ocean            = OnlyAllow({ WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_cucumber_ground           = OnlyAllow({ WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_waterycress_ocean         = OnlyAllow({ WORLD_TILES.OCEAN_SWELL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_ocean_wreck               = OnlyAllow({ WORLD_TILES.OCEAN_SWELL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_wildwheat                 = OnlyAllow({ WORLD_TILES.SAVANNA }),
	kyno_parznip_big               = OnlyAllow({ WORLD_TILES.MUD }),
	kyno_mushstump_natural         = OnlyAllow({ WORLD_TILES.FOREST }),
	kyno_limpetrock                = OnlyAllow({ WORLD_TILES.MONKEY_GROUND, WORLD_TILES.QUAGMIRE_CITSTONE }),
	kyno_spotbush                  = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_sapling         = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_short           = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_normal          = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree                 = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_flower          = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_flower_planted  = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_kokonuttree_sapling       = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_kokonuttree               = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_kokonuttree_short         = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_kokonuttree_normal        = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_kokonuttree_tall          = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_pineapplebush             = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_meadowisland_tree_sapling = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_meadowisland_sandhill     = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_meadowisland_tree         = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_meadowisland_tree_short   = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_meadowisland_tree_normal  = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_meadowisland_tree_tall    = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_watery_crate              = OnlyAllow({ WORLD_TILES.OCEAN_COASTAL_SHORE, WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_SWELL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_coffeebush                = OnlyAllow({ WORLD_TILES.VENT }),
	kyno_truffles_ground           = { WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.MONKEY_DOCK },--OnlyAllow({ WORLD_TILES.DECIDUOUS, WORLD_TILES.GRASS, WORLD_TILES.FOREST }),
	kyno_rockflippable             = { WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.MONKEY_DOCK },
}

for k, v in pairs(TERRAIN_FILTER) do
	if terrain.filter[k] then
		ConcatArrays(terrain.filter[k], v)
	else
		terrain.filter[k] = v
	end
end