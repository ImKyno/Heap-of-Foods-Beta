local _G = GLOBAL

local HOF_FULLMOON = GetModConfigData("FULLMOONTRANS")

if HOF_FULLMOON then
	local FULLMOON_MUSHTREES =
	{	
		"mushtree_medium",
		"mushtree_small",
		"mushtree_tall",
	}

	for k, v in pairs(FULLMOON_MUSHTREES) do
		AddPrefabPostInit(v, function(inst)
			if not _G.TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("fullmoontransformer")
		end)
	end
end

local function MushTreePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.workable ~= nil and inst.components.lootdropper ~= nil then
		local _onfinish = inst.components.workable.onfinish

		inst.components.workable:SetOnFinishCallback(function(inst, worker)
			if worker ~= nil and worker.tagvar_luckywoodcutter then
				local log_bonus = TUNING.KYNO_WOODCUTTERBUFF_BONUS[inst.prefab]

				if log_bonus ~= nil and not inst:HasTag("burnt") then
					local amount = log_bonus[1] or log_bonus or 0

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

local MUSHTREES =
{
	"mushtree_small",
	"mushtree_medium",
	"mushtree_tall",
	"mushtree_tall_webbed",
	"mushtree_moon",
}

for k, v in pairs(MUSHTREES) do
	AddPrefabPostInit(v, MushTreePostInit)
end