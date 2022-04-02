local _G 				= GLOBAL
local oldretrofit 		= require("map/retrofit_savedata").DoRetrofitting
local SERENITYISLAND 	= GetModConfigData("serenity_island")

require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)
	if SERENITYISLAND == 1 then
		print("Retrofitting for Heap of Foods Mod - Generating the Serenity Archipelago")
		require("map/hof_retrofit_serenityisland").HofRetrofitting_SerenityIsland(_G.TheWorld.Map, savedata)
		dirty = true
	end
		
	return oldretrofit(savedata, world_map, ...)
end