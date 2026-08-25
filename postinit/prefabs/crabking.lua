local _G      = GLOBAL
local require = _G.require

require("hof_util")

-- Crab King and its claws drop Crab King Meat instead.
local function CrabKingPostInit(inst)
	_G.ReplaceLootTablePrefab(inst.prefab, "meat", "kyno_crabkingmeat")

	local function OnDeath(inst)
		if inst.components.lootdropper ~= nil then
			if inst.gemcount and (inst.gemcount.pearl > 0 or inst.gemcount.opal > 0) then
				inst:DoTaskInTime(1, function()
					inst.components.lootdropper:SpawnLootPrefab("kyno_opalpreciousapple") -- Guaranteed when pearled.
				end)
			else
				if math.random() < TUNING.KYNO_OPALPRECIOUSAPPLE_CHANCE then
					inst:DoTaskInTime(1, function()
						inst.components.lootdropper:SpawnLootPrefab("kyno_opalpreciousapple")
					end)
				end
			end
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:ListenForEvent("death", OnDeath)
end

AddPrefabPostInit("crabking",      CrabKingPostInit)
AddPrefabPostInit("crabking_claw", CrabKingPostInit)