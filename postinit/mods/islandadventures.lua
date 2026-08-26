local _G = GLOBAL

-- Island Adventures Mod Support for the Living Sandwich.
if TUNING.HOF_IS_IAM_ENABLED and TUNING.HOF_IS_IAc_ENABLED then
	local function IslandAdventuresTreePostInit(inst)
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

						if type(log_bonus) == "table" then
							local stage = inst.components.growable ~= nil and inst.components.growable.stage or 1
							amount = log_bonus[stage] or 0
						else
							amount = log_bonus or 0
						end

						local living = inst.prefab == "livingjungletree" or inst.prefab == "livingjungletree_halloween"
						local loot = living and "livinglog" or "log"

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

	local IA_TREES =
	{
		"palmtree",
		"jungletree",
		"mangrovetree",

		"livingjungletree_halloween",
		"livingjungletree",
	}

	for k, v in pairs(IA_TREES) do
		AddPrefabPostInit(v, IslandAdventuresTreePostInit)
	end

	local function IslandAdventuresLeifPostInit(inst)
		local function OnDeath(inst, data)
			if data ~= nil and data.afflicter ~= nil and data.afflicter.tagvar_luckywoodcutter then
				local log_bonus = TUNING.KYNO_WOODCUTTERBUFF_BONUS[inst.prefab]
				local burnable = inst.components.burnable

				if log_bonus ~= nil and burnable ~= nil and not burnable:IsBurning() then
					local amount = log_bonus[1] or log_bonus or 0

					for i = 1, amount do
						inst.components.lootdropper:SpawnLootPrefab("livinglog")
					end
				end
			end
		end

		if not _G.TheWorld.ismastersim then
			return inst
		end

		inst:ListenForEvent("death", OnDeath)
	end

	AddPrefabPostInit("leif_palm", IslandAdventuresLeifPostInit)
end