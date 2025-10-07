-- Common Dependencies.
local _G      = GLOBAL
local require = _G.require

local _DoRetrofitting = require("map/retrofit_savedata").DoRetrofitting

-- Fuck it. not relying on mod option to retrofit shit anymore, too many issues...
-- If we don't exist, spawn the damn thing already.
require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)
	local dirty = false

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

	local applied = {}

	if savedata.map ~= nil and savedata.map.prefab == "forest" then
	
		if ApplyRetrofit("Serenity Archipelago", "kyno_serenityisland_shop", require("map/hof_retrofit_forest").HofRetrofitting_SerenityIsland) then
			table.insert(applied, "Serenity Archipelago")
			dirty = true
		end

		if ApplyRetrofit("Seaside Island", "kyno_meadowisland_shop", require("map/hof_retrofit_forest").HofRetrofitting_MeadowIsland) then
			table.insert(applied, "Seaside Island")
			dirty = true
		end
		
		if ApplyRetrofit("Ocean Setpieces", "kyno_swordfish_spawner", require("map/hof_retrofit_forest").HofRetrofitting_OceanSetpieces) then
			table.insert(applied, "Ocean Setpieces")
			dirty = true
		end
		
    end
	
	if dirty then
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
	end

	if #applied > 0 then
		print("Retrofitting for Heap of Foods Mod - Retrofits applied: " .. table.concat(applied, ", "))
	else
		print("Retrofitting for Heap of Foods Mod - World does not need Retrofitting.")
	end

	_DoRetrofitting(savedata, world_map, ...)
end