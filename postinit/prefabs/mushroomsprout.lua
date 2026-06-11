local _G = GLOBAL

-- Toadstool's Sporecaps drops special Mushrooms.
local function MushroomSproutPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("lootdropper")

	if inst.components.workable ~= nil then
		local _onfinish = inst.components.workable.onfinish

		inst.components.workable:SetOnFinishCallback(function(inst, worker)
			if _onfinish ~= nil then
				_onfinish(inst, worker)
			end

			if worker ~= nil and worker:IsValid() then
				local loot_data = inst._custom_loot or
				{
					main_loot    = nil,
					extra_loot   = nil,
					extra_chance = 0,
				}

				if loot_data.main_loot then
					inst.components.lootdropper:SpawnLootPrefab(loot_data.main_loot)
				end

				if loot_data.extra_loot and math.random() < loot_data.extra_chance then
					inst.components.lootdropper:SpawnLootPrefab(loot_data.extra_loot)
				end
			end
		end)
	end
end

local MUSHROOM_SPROUTS =
{
	{
		name         = "mushroomsprout",
		main_loot    = "kyno_sporecap",
		extra_loot   = "kyno_sporecap",
		extra_chance = TUNING.KYNO_SPORECAP_DROP_CHANCE,
	},
	{
		name         = "mushroomsprout_dark",
		main_loot    = "kyno_sporecap_dark",
		extra_loot   = "kyno_sporecap_dark",
		extra_chance = TUNING.KYNO_SPORECAP_DARK_DROP_CHANCE,
	},
}

for _, v in ipairs(MUSHROOM_SPROUTS) do
	AddPrefabPostInit(v.name, function(inst)
		inst._custom_loot =
		{
			main_loot    = v.main_loot,
			extra_loot   = v.extra_loot,
			extra_chance = v.extra_chance,
		}

		MushroomSproutPostInit(inst)
	end)
end