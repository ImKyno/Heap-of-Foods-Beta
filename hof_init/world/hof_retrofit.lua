-- Common Dependencies.
local _G                = GLOBAL
local next              = _G.next
local require           = _G.require
local HOF_MAPUTIL       = require("map/hof_maputil")
local HOF_FOREST_DATA   = require("map/hof_retrofit_forest")

local _DoRetrofitting   = require("map/retrofit_savedata").DoRetrofitting

-- Fuck it. not relying on mod option to retrofit anymore, too many issues...
-- If we don't exist, spawn the damn thing already.
-- Thank you for your old retrofitting system, ADM. xoxo
require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)
	local dirty = false

	if savedata.ents == nil or next(savedata.ents) == nil then
		if TUNING.HOF_DEBUG_MODE then
			print("Retrofitting for Heap of Foods Mod - Looks like a New World. Skipping.")
		end

		return _DoRetrofitting(savedata, world_map, ...)
	end

	local function Exists(prefab)
		return savedata.ents ~= nil and savedata.ents[prefab] ~= nil
	end

	local function ApplyRetrofit(name, prefab_check, retrofit_fn)
		local prefab_list = type(prefab_check) == "table" and prefab_check or { prefab_check }

		for _, prefab in ipairs(prefab_list) do
			if Exists(prefab) then
				if TUNING.HOF_DEBUG_MODE then
					print(string.format("Retrofitting for Heap of Foods Mod - %s Already exists. Skipping.", name))
				end
				
				return false
			end
		end

		if TUNING.HOF_DEBUG_MODE then
			print(string.format("Retrofitting for Heap of Foods Mod - Generating %s...", name))
		end

		retrofit_fn(_G.TheWorld.Map, savedata)
		return true
	end

	local applied = {}

	if savedata.map ~= nil and savedata.map.prefab == "forest" then
		if ApplyRetrofit("Serenity Archipelago", "kyno_serenityisland_shop", HOF_FOREST_DATA.HofRetrofitting_SerenityIsland) then
			table.insert(applied, "Serenity Archipelago")
		end

		if ApplyRetrofit("Seaside Island", "kyno_meadowisland_shop", HOF_FOREST_DATA.HofRetrofitting_MeadowIsland) then
			table.insert(applied, "Seaside Island")
		end

		if ApplyRetrofit("Ocean Setpieces", "kyno_swordfish_spawner", HOF_FOREST_DATA.HofRetrofitting_OceanSetpieces) then
			table.insert(applied, "Ocean Setpieces")
		end
		
		if ApplyRetrofit("Fruit Tree Shop", "kyno_deciduousforest_shop", HOF_FOREST_DATA.HofRetrofitting_DeciduousForestShop) then
			table.insert(applied, "Fruit Tree Shop")
		end
		
		if ApplyRetrofit("Jellyfish Spawners", "kyno_jellyfish_rainbow_spawner", HOF_FOREST_DATA.HofRetrofitting_JellyfishSpawners) then
			table.insert(applied, "Jellyfish Spawners")
		end
		
		if ApplyRetrofit("Dogfish Spawners", "kyno_dogfish_spawner", HOF_FOREST_DATA.HofRetrofitting_DogfishSpawners) then
			table.insert(applied, "Dogfish Spawners")
		end
		
		if ApplyRetrofit("Puffernaut Spawners", "kyno_puffermonster_spawner", HOF_FOREST_DATA.HofRetrofitting_PufferSpawners) then
			table.insert(applied, "Puffernaut Spawners")
		end
		
		-- Needs to be after Jellyfish retrofit because it will not spawn new ones if before.
		if ApplyRetrofit("Octopus King Shop", "kyno_octopusking_ocean", HOF_FOREST_DATA.HofRetrofitting_OctopusKingShop) then
			table.insert(applied, "Octopus King Shop")
		end
		
		if ApplyRetrofit("Packim Baggims", { "packim", "kyno_packimbaggims", "kyno_packimbaggims_fishbone", "kyno_packimbaggims_fishbone_marker" }, 
		HOF_FOREST_DATA.HofRetrofitting_PackimBaggims) then
			table.insert(applied, "Packim Baggims")
		end
		
		if ApplyRetrofit("Hermit Wobster Dens", "kyno_wobster_den_monkeyisland", HOF_FOREST_DATA.HofRetrofitting_WobsterMonkeyIsland) then
			table.insert(applied, "Hermit Wobster Dens")
		end
		
		-- Not really required for any content, just something nice to have. Will leave it for new worlds only.
		--[[
		if ApplyRetrofit("Dina Memorial", "kyno_dinamemorial_marker", require("map/hof_retrofit_forest").HofRetrofitting_DinaMemorial) then
			table.insert(applied, "Dina Memorial")
		end
		]]--

		if HOF_MAPUTIL.RetrofitOceanLayouts() then
			table.insert(applied, "Ocean Topology Tags")
		end
	end

	if #applied > 0 then
		dirty = true
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
		
		rawset(_G, "HOF_RETROFIT_APPLIED", true)

		if TUNING.HOF_DEBUG_MODE then
			print("Retrofitting for Heap of Foods Mod - Applied Retrofits: " .. table.concat(applied, ", "))
		end
	else
		rawset(_G, "HOF_RETROFIT_APPLIED", false)

		if TUNING.HOF_DEBUG_MODE then
			print("Retrofitting for Heap of Foods Mod - World does not need Retrofit.")
		end
	end

	return _DoRetrofitting(savedata, world_map, ...)
end

--[[
require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)
	if savedata.ents == nil or _G.next(savedata.ents) == nil then
		print("Retrofitting for Heap of Foods Mod - Looks like a New World, does not need Retrofitting.")
		return _DoRetrofitting(savedata, world_map, ...)
	end
	
	local dirty = false
	local applied = {}

	local function Exists(prefab)
		return savedata.ents ~= nil and savedata.ents[prefab] ~= nil
	end

	local function ApplyRetrofit(name, prefab_check, retrofit_fn)
		if Exists(prefab_check) then
			print(string.format("Retrofitting for Heap of Foods Mod - %s already exists. Skipping.", name))
			return false
		else
			print(string.format("Retrofitting for Heap of Foods Mod - Generating %s.", name))
			retrofit_fn(_G.TheWorld.Map, savedata)
			return true
		end
	end

	if savedata.map ~= nil and savedata.map.prefab == "forest" then
	
		if ApplyRetrofit("Serenity Archipelago", "kyno_serenityisland_shop", require("map/hof_retrofit_forest").HofRetrofitting_SerenityIsland) then
			table.insert(applied, "Serenity Archipelago")
		end

		if ApplyRetrofit("Seaside Island", "kyno_meadowisland_shop", require("map/hof_retrofit_forest").HofRetrofitting_MeadowIsland) then
			table.insert(applied, "Seaside Island")
		end
		
		if ApplyRetrofit("Ocean Setpieces", "kyno_swordfish_spawner", require("map/hof_retrofit_forest").HofRetrofitting_OceanSetpieces) then
			table.insert(applied, "Ocean Setpieces")
		end
		
    end
	
	if #applied > 0 then
		dirty = true
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
		print("Retrofitting for Heap of Foods Mod - Retrofits applied: " .. table.concat(applied, ", "))
	else
		print("Retrofitting for Heap of Foods Mod - World does not need Retrofitting.")
	end

	return _DoRetrofitting(savedata, world_map, ...)
end
]]--