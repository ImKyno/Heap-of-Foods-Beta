local customizations =
{
	kyno_aloe_ground        = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_radish_ground      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"}, 
	kyno_sweetpotato_ground = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_turnip_ground      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_cucumber_ground    = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_aspargos_ground    = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	
	kyno_wildwheat          = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_rockflippable      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_mushstump_natural  = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_pineapplebush      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	
	kyno_lotus_ocean        = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_seaweeds_ocean     = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_taroroot_ocean     = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	kyno_waterycress_ocean  = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	
	kyno_fennel_ground      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", world = {"cave"}, group = "hof_cave"},
	kyno_parznip_ground     = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", world = {"cave"}, group = "hof_cave"},
	kyno_parznip_big        = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", world = {"cave"}, group = "hof_cave"},
	kyno_rockflippable      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", world = {"cave"}, group = "hof_cave"},
	kyno_mushstump_natural  = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", world = {"cave"}, group = "hof_cave"},
	kyno_turnip_ground      = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", world = {"cave"}, group = "hof_cave"},
	kyno_aspargos_ground    = {category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", world = {"cave"}, group = "hof_cave"},
}

local map                    = require("map/forest_map")
local TRANSLATE_TO_PREFABS   = map.TRANSLATE_TO_PREFABS
local TRANSLATE_AND_OVERRIDE = map.TRANSLATE_AND_OVERRIDE

TRANSLATE_TO_PREFABS["hof_plants"] = 
{
	"kyno_aloe_ground", 
	"kyno_radish_ground", 
	"kyno_sweetpotato_ground", 
	"kyno_turnip_ground", 
	"kyno_aspargos_ground",
	"kyno_fennel_ground",
	"kyno_parznip_ground", 
	"kyno_parznip_big",
	"kyno_wildwheat",
	"kyno_rockflippable",
	"kyno_mushstump_natural",
}

TRANSLATE_TO_PREFABS["hof_plants_ocean"] = 
{
	"kyno_cucumber_ground", 
	"kyno_seaweeds_ocean", 
	"kyno_taroroot_ocean", 
	"kyno_seaweeds_ocean", 
	"kyno_waterycress_ocean",
}
	
local WSO = require("worldsettings_overrides")

local function OverrideTuningVariables(tuning)
	if tuning ~= nil then
		for k, v in pairs(tuning) do
			ORIGINAL_TUNING[k] = TUNING[k]
			TUNING[k] = v
		end
	end
end

WSO.Pre.hof_plants = function(difficulty)
	local tuning_vars =
	{
		never   = { HOF_RESOURCES = 0   },
		few     = { HOF_RESOURCES = .07 },
		-- default = { HOF_RESOURCES = .07 },
		many    = { HOF_RESOURCES = .09 },
		always  = { HOF_RESOURCES = .10 },
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.hof_plants_ocean = function(difficulty)
	local tuning_vars =
	{
		never   = { HOF_RESOURCES = 0   },
		few     = { HOF_RESOURCES = .07 },
		-- default = { HOF_RESOURCES = .07 },
		many    = { HOF_RESOURCES = .09 },
		always  = { HOF_RESOURCES = .10 },
	}
	
	OverrideTuningVariables(tuning_vars[difficulty])
end
	
for k, v in pairs(customizations) do
	v.name     = k
	
	v.category = v.category
	v.group    = v.group or "hof"
	
	v.value    = v.value or "default"
	v.desc     = v.desc  or "frequency_descriptions"
	v.world    = v.world or {"forest"}
end

return customizations