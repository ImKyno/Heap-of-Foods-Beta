local _G = GLOBAL

local function DeciduousTreePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.workable ~= nil and inst.components.lootdropper ~= nil then
		local _onfinish = inst.components.workable.onfinish

		inst.components.workable:SetOnFinishCallback(function(inst, worker)
			if worker ~= nil and worker.tagvar_luckywoodcutter then
				local log_bonus = TUNING.KYNO_WOODCUTTERBUFF_BONUS[inst.prefab]

				if log_bonus ~= nil and not inst:HasTag("burnt") then
					local amount = 0
					local loot = inst.monster and "livinglog" or "log"

					if type(log_bonus) == "table" then
						if inst.monster then
							amount = log_bonus[2] or 0
						else
							local stage = (inst.components.growable ~= nil and inst.components.growable.stage) or 1
							amount = log_bonus[stage] or 0
						end
					else
						amount = log_bonus or 0
					end

					for i = 1, amount do
						inst.components.lootdropper:SpawnLootPrefab(loot)
					end
				end
			end

			if _onfinish ~= nil then
				_onfinish(inst, worker)
			end
		end)
	end
end

AddPrefabPostInit("deciduoustree", DeciduousTreePostInit)