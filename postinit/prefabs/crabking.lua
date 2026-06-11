local _G      = GLOBAL
local require = _G.require

require("hof_util")

-- Crab King and its claws drop Crab King Meat instead.
local function CrabKingPostInit(inst)
    _G.ReplaceLootTablePrefab(inst.prefab, "meat", "kyno_crabkingmeat")

    if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("crabking",      CrabKingPostInit)
AddPrefabPostInit("crabking_claw", CrabKingPostInit)