-- Common Dependencies.
local _G      = GLOBAL
local next    = _G.next
local require = _G.require
local HOF_MAPUTIL = require("map/hof_maputil")

local _DoRetrofitting = require("map/retrofit_savedata").DoRetrofitting

-- Fuck it. not relying on mod option to retrofit anymore, too many issues...
-- If we don't exist, spawn the damn thing already.
-- Thank you for your old retrofitting system, ADM. xoxo
require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)
	local dirty = false

	if savedata.ents == nil or next(savedata.ents) == nil then
        print("Retrofitting for Heap of Foods Mod - Looks like a New World. Skipping.")
		return _DoRetrofitting(savedata, world_map, ...)
	end
	
	local function Exists(prefab)
		return savedata.ents ~= nil and savedata.ents[prefab] ~= nil
	end

	local function ApplyRetrofit(name, prefab_check, retrofit_fn)
		if Exists(prefab_check) then
			print(string.format("Retrofitting for Heap of Foods Mod - %s Already exists. Skipping.", name))
			return false
		else
			print(string.format("Retrofitting for Heap of Foods Mod - Generating %s...", name))
			retrofit_fn(_G.TheWorld.Map, savedata)
			return true
		end
	end

	local applied = {}

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

		if HOF_MAPUTIL.RetrofitOceanLayouts() then
			table.insert(applied, "Ocean Topology Tags")
		end
	end

	if #applied > 0 then
		dirty = true
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
		
		rawset(_G, "HOF_RETROFIT_APPLIED", true)
		print("Retrofitting for Heap of Foods Mod - Applied Retrofits: " .. table.concat(applied, ", "))
	else
		rawset(_G, "HOF_RETROFIT_APPLIED", false)
		print("Retrofitting for Heap of Foods Mod - World does not need Retrofit.")
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