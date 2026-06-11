local _G = GLOBAL

local HOF_KEEPFOOD = GetModConfigData("KEEPFOOD")

-- Prevent food from spoiling in stations.
if HOF_KEEPFOOD then
	for k, v in pairs(TUNING.HOF_COOKPOTS) do
		AddPrefabPostInit(v, function(inst)
			if not _G.TheWorld.ismastersim then
				return inst
			end

			if inst.components.stewer ~= nil then
				inst.components.stewer.onspoil = function()
					inst.components.stewer.spoiltime = 1
					inst.components.stewer.targettime = _G.GetTime()
					inst.components.stewer.product_spoilage = 0
				end
			end
		end)
	end
end