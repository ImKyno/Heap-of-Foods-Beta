AddClientModRPCHandler("FishRegistry", "LearnFish", function(fish)
	local updater = ThePlayer and ThePlayer.components.fishregistryupdater
	
	if updater and fish then
		updater.fishregistry:LearnFish(fish)
	end
end)

AddClientModRPCHandler("FishRegistry", "LearnRoe", function(roe)
	local updater = ThePlayer and ThePlayer.components.fishregistryupdater
	
	if updater and roe then
		updater.fishregistry:LearnRoe(roe)
	end
end)