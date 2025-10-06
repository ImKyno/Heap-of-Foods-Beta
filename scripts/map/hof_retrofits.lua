-- Common Dependencies.
local hof_forest = require("map/hof_retrofit_forest")

local function HOF_DoRetrofitting(savedata, world_map)
	if not savedata or not savedata.map or savedata.map.prefab ~= "forest" then
		print("[HOF Retrofit] Save data inválido ou mundo não é 'forest'. Abortando.")
		return
	end

	local dirty = false
	local force = TUNING.HOF_RETROFIT_FORCE == true
	local applied = {}

	local function Exists(prefab)
		return savedata.ents and savedata.ents[prefab] ~= nil
	end

	local function ApplyRetrofit(name, prefab_check, retrofit_fn)
		if Exists(prefab_check) then
			print(string.format("[HOF Retrofit] %s já existe. Pulando retrofit.", name))
			return false
		else
			print(string.format("[HOF Retrofit] Gerando %s...", name))
			retrofit_fn(TheWorld.Map, savedata)
			return true
		end
	end

	if TUNING.HOF_RETROFIT == 1 or force then
		
		if ApplyRetrofit("Serenity Archipelago", "kyno_serenityisland_shop", hof_forest.HofRetrofitting_SerenityIsland) then
			table.insert(applied, "Serenity Archipelago")
			dirty = true
		end
		
		if ApplyRetrofit("Seaside Island", "kyno_meadowisland_shop", hof_forest.HofRetrofitting_MeadowIsland) then
			table.insert(applied, "Seaside Island")
			dirty = true
		end
		
		if ApplyRetrofit("Ocean Setpieces", "kyno_swordfish_spawner", hof_forest.HofRetrofitting_OceanSetpieces) then
			table.insert(applied, "Ocean Setpieces")
			dirty = true
		end
		
	end
	
	if dirty then
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
	end

	if #applied > 0 then
		print("[HOF Retrofit] Retrofits aplicados: " .. table.concat(applied, ", "))
	end
end

return HOF_DoRetrofitting