local _G                = GLOBAL
local OldDoRetrofitting = require("map/retrofit_savedata").DoRetrofitting

require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)
	local dirty = false

	if GetModConfigData("RETROFIT") == 1 and savedata.map ~= nil and savedata.map.prefab == "forest" then
		if savedata.ents ~= nil and savedata.ents.kyno_serenityisland_shop ~= nil then
			print("Retrofitting for Heap of Foods Mod - It seems the Serenity Archipelago already exists.")
		else
			print("Retrofitting for Heap of Foods Mod - Generating the Serenity Archipelago.")
			require("map/hof_retrofit_islands").HofRetrofitting_SerenityIsland(_G.TheWorld.Map, savedata)
		end
		
		if savedata.ents ~= nil and savedata.ents.kyno_meadowisland_pond ~= nil then
			print("Retrofitting for Heap of Foods Mod - It seems the Seaside Island already exists.")
		else
			print("Retrofitting for Heap of Foods Mod - Generating the Seaside Island.")
			require("map/hof_retrofit_islands").HofRetrofitting_MeadowIsland(_G.TheWorld.Map, savedata)
		end
		
		dirty = true
	end
	
	if dirty then
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
	end
		
	OldDoRetrofitting(savedata, world_map, ...)
end