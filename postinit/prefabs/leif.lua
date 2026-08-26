local _G = GLOBAL

local function LeifPostInit(inst)
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

local LEIFS =
{
	"leif",
	"leif_sparse",
}

for k, v in pairs(LEIFS) do
	AddPrefabPostInit(v, LeifPostInit)
end