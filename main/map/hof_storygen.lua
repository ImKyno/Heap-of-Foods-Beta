local MapData =
{
	["DinaMemorial_Spawner"]    = true,
	["FruitTreeShop_Spawner"]   = true,
}

local MapTags =
{
	["SerenityArea"] = function(tagdata)
		return "TAG", "SerenityArea"
	end,

	["MeadowArea"] = function(tagdata)
		return "TAG", "MeadowArea"
	end,

	["WreckArea"] = function(tagdata)
		return "TAG", "WreckArea"
	end,

	["LowMist"] = function(tagdata)
		return "TAG", "LowMist"
	end,

	["FruitTreeArea"] = function(tagdata)
		return "TAG", "FruitTreeArea"
	end,

	["MemorialArea"] = function(tagdata)
		return "TAG", "MemorialArea"
	end,

	["OctopusArea"] = function(tagdata)
		return "TAG", "OctopusArea"
	end,

	["SunkenForestArea"] = function(tagdata)
		return "TAG", "SunkenForestArea"
	end,

	["DinaMemorial_Spawner"] = function(tagdata, level)
		if tagdata["DinaMemorial_Spawner"] == false then
			return
		end

		tagdata["DinaMemorial_Spawner"] = false

		return "STATIC", "DinaMemorial"
	end,

	["FruitTreeShop_Spawner"] = function(tagdata, level)
		if tagdata["FruitTreeShop_Spawner"] == false then
			return
		end

		tagdata["FruitTreeShop_Spawner"] = false

		return "STATIC", "FruitTreeShop"
	end,
}

-- Used to create new tags for worldgen.
AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
	for tag, v in pairs(MapData) do
		self.map_tags.TagData[tag] = v
	end

	for tag, v in pairs(MapTags) do
		self.map_tags.Tag[tag] = v
	end
end)