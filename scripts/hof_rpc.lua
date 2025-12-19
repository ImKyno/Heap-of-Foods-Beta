AddClientModRPCHandler("FishRegistry", "LearnFish", function(fish)
	local updater = ThePlayer and ThePlayer.components.fishregistryupdater
	
	if updater and fish then
		updater.fishregistry:LearnFish(fish)
	end
end)