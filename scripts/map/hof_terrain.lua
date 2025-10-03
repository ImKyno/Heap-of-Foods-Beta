local filters = terrain.filter

local function OnlyAllow(approved)
	local filter = {}
	
	for _,v in pairs(GetWorldTileMap()) do
		if not table.contains(approved, v) then
			table.insert(filter, v)
		end
	end
	
	return filter
end

local hof_filters =
{
	kyno_aloe_ground               = OnlyAllow({ WORLD_TILES.GRASS }),
	kyno_aspargos_ground           = OnlyAllow({ WORLD_TILES.GRASS, WORLD_TILES.FOREST, WORLD_TILES.SINKHOLE }),
	kyno_radish_ground             = OnlyAllow({ WORLD_TILES.DECIDUOUS }),
	kyno_fennel_ground             = OnlyAllow({ WORLD_TILES.GRASS, WORLD_TILES.FOREST, WORLD_TILES.SINKHOLE }),
	kyno_sweetpotato_ground        = OnlyAllow({ WORLD_TILES.FOREST, WORLD_TILES.HOF_FIELDS }),
	kyno_parznip_ground            = OnlyAllow({ WORLD_TILES.MUD }),
	kyno_turnip_ground             = OnlyAllow({ WORLD_TILES.FOREST, WORLD_TILES.MARSH }),
	kyno_seaweeds_ocean            = OnlyAllow({ WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_taroroot_ocean            = OnlyAllow({ WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_waterycress_ocean         = OnlyAllow({ WORLD_TILES.OCEAN_SWELL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_wildwheat                 = OnlyAllow({ WORLD_TILES.SAVANNA }),
	kyno_parznip_big               = OnlyAllow({ WORLD_TILES.MUD }),
	kyno_mushstump_natural         = OnlyAllow({ WORLD_TILES.FOREST }),
	kyno_limpetrock                = OnlyAllow({ WORLD_TILES.MONKEY_GROUND, WORLD_TILES.QUAGMIRE_CITSTONE }),
	kyno_spotbush                  = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_short           = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_normal          = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree                 = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_flower          = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_sugartree_flower_planted  = OnlyAllow({ WORLD_TILES.QUAGMIRE_PARKFIELD }),
	kyno_kokonuttree               = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_kokonuttree_short         = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_kokonuttree_normal        = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_kokonuttree_tall          = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_meadowisland_tree_sapling = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_meadowisland_sandhill     = OnlyAllow({ WORLD_TILES.MONKEY_GROUND }),
	kyno_meadowisland_tree         = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_meadowisland_tree_short   = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_meadowisland_tree_normal  = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_meadowisland_tree_tall    = OnlyAllow({ WORLD_TILES.HOF_FIELDS }),
	kyno_watery_crate              = OnlyAllow({ WORLD_TILES.OCEAN_COASTAL_SHORE, WORLD_TILES.OCEAN_COASTAL, WORLD_TILES.OCEAN_SWELL, WORLD_TILES.OCEAN_ROUGH, WORLD_TILES.OCEAN_HAZARDOUS }),
	kyno_rockflippable             = { WORLD_TILES.ROAD, WORLD_TILES.WOODFLOOR, WORLD_TILES.CARPET, WORLD_TILES.CHECKER, WORLD_TILES.MONKEY_DOCK },
}

local hof_addedtiles =
{
	reeds      = { WORLD_TILES.HOF_TIDALMARSH },
	berrybush2 = { WORLD_TILES.HOF_FIELDS },
	cave_fern  = { WORLD_TILES.QUAGMIRE_PARKFIELD },
}

for terrain, tiles in pairs(hof_filters) do
	filters[terrain] = tiles
end

for terrain, tiles in pairs(hof_addedtiles) do
	for _, tile in ipairs(tiles) do
		table.insert(filters[terrain], tile)
	end
end