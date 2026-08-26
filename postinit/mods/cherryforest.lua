local _G = GLOBAL

-- Cherry Forest Mod Support for the Living Sandwich.
if TUNING.HOF_IS_CRF_ENABLED then
	local function CherryTreePostInit(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end

		if inst.components.workable ~= nil and inst.components.lootdropper ~= nil then
			local _onfinish = inst.components.workable.onfinish

			workable:SetOnFinishCallback(function(inst, worker)
				if worker ~= nil and worker.tagvar_luckywoodcutter then
					local log_bonus = TUNING.KYNO_WOODCUTTERBUFF_BONUS[inst.prefab]

					if log_bonus ~= nil and not inst:HasTag("burnt") then
						local amount = 0

						if type(log_bonus) == "table" then
							local stage = inst.components.growable ~= nil and inst.components.growable.stage or 1
							amount = log_bonus[stage] or 0
						else
							amount = log_bonus or 0
						end

						for i = 1, amount do
							inst.components.lootdropper:SpawnLootPrefab("log")
						end
					end
				end

				if _onfinish ~= nil then
					_onfinish(inst, worker)
				end
			end)
		end
	end

	local CHERRY_TREES =
	{
		"cherry_tree",
		"cherry_tree_white",
	}

	for k, v in pairs(CHERRY_TREES) do
		AddPrefabPostInit(v, CherryTreePostInit)
	end
end