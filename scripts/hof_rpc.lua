AddClientModRPCHandler("FishRegistry", "LearnFish", function(fish)
	local updater = ThePlayer and ThePlayer.components.fishregistryupdater
	
	if updater and fish then
		updater:LearnFish(fish)
	end
end)

AddClientModRPCHandler("FishRegistry", "LearnRoe", function(roe)
	local updater = ThePlayer and ThePlayer.components.fishregistryupdater
	
	if updater and roe then
		updater:LearnRoe(roe)
	end
end)

AddShardModRPCHandler("DailyRecipe", "SetForcedDailyRecipe", function(shardid, recipe)
	local shard = TheWorld.net

	if shard ~= nil and shard.components.dailyrecipe ~= nil then
		shard.components.dailyrecipe:SetForcedDailyRecipe(recipe, false)
	end
end)