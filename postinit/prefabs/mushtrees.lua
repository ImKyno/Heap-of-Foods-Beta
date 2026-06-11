local _G = GLOBAL

local HOF_FULLMOON = GetModConfigData("FULLMOONTRANS")

if HOF_FULLMOON then
	local MUSHTREES =
	{	
		"mushtree_medium",
		"mushtree_small",
		"mushtree_tall",
	}

	for k, v in pairs(MUSHTREES) do
		AddPrefabPostInit(v, function(inst)
			if not _G.TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("fullmoontransformer")
		end)
	end
end