local _G = GLOBAL

local function EvergreenPostInit(inst)
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

					for i = 1, amount do
						inst.components.lootdropper:SpawnLootPrefab("log")
					end
				end
			end

			if inst.prefab == "twiggytree" then
				if inst.components.growable ~= nil then
					local stage = inst.components.growable:GetStage()
					local chance = 0
					local amount = 1

					if stage == 1 then
						chance = 0.50
					elseif stage == 2 then
						chance = 1.00
					elseif stage == 3 then
						chance = 1.00
						amount = 2
					end

					if math.random() < chance then
						for i = 1, amount do
							inst.components.lootdropper:SpawnLootPrefab("kyno_twiggynuts")
						end
					end
				end
			end

			if _onfinish ~= nil then
				_onfinish(inst, worker)
			end
		end)
	end
end

local EVERGREENS =
{
	"evergreen",
	"evergreen_sparse",
	"twiggytree",
}

for k, v in pairs(EVERGREENS) do
	AddPrefabPostInit(v, EvergreenPostInit)
end