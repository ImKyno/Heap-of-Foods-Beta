local _G = GLOBAL

local HOF_FULLMOON = GetModConfigData("FULLMOONTRANS")

-- Mushrooms that turn into Mushtrees during Full Moon nights.
if HOF_FULLMOON then
	local MUSHROOMS = 
	{
		red_mushroom =
		{
			transform_prefab = "mushtree_medium",
			chance           = TUNING.KYNO_FULLMOONTRANSFORMER_CHANCE_HIGH,
			revert_chance    = 1.00,
			delay            = 10,
			fx_prefab        = "small_puff",
		},
	
		green_mushroom =
		{
			transform_prefab = "mushtree_small",
			chance           = TUNING.KYNO_FULLMOONTRANSFORMER_CHANCE_MED,
			revert_chance    = 1.00,
			delay            = 10,
			fx_prefab        = "small_puff",
		},
	
		blue_mushroom =
		{
			transform_prefab = "mushtree_tall",
			chance           = TUNING.KYNO_FULLMOONTRANSFORMER_CHANCE_LOW,
			revert_chance    = 1.00,
			delay            = 10,
			fx_prefab        = "small_puff",
		},
	}

	for prefab, data in pairs(MUSHROOMS) do
		AddPrefabPostInit(prefab, function(inst)
			if not _G.TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("fullmoontransformer")
			inst.components.fullmoontransformer.transform_prefab = data.transform_prefab
			inst.components.fullmoontransformer.chance = data.chance
			inst.components.fullmoontransformer.delay = data.delay
			inst.components.fullmoontransformer.fx_prefab = data.fx_prefab
		end)
	end
end