local oldretrofit = require("map/retrofit_savedata").DoRetrofitting

require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)

	if GetModConfigData("HOF_RETROFIT") == 1 and savedata.map ~= nil and savedata.map.prefab == "forest" then
		print("Retrofitting for Heap of Foods Mod - Generating the Serenity Archipelago")
		require("map/hof_retrofit_serenityisland").HofRetrofitting_SerenityIsland(_G.TheWorld.Map, savedata)
		dirty = true
	end
	
	if GetModConfigData("HOF_RETROFIT") == 2 and savedata.map ~= nil and savedata.map.prefab == "forest" then
		print("Retrofitting for Heap of Foods Mod - Generating the Seaside Island")
		require("map/hof_retrofit_meadowisland").HofRetrofitting_MeadowIsland(_G.TheWorld.Map, savedata)
		dirty = true
	end
		
	return oldretrofit(savedata, world_map, ...)
end