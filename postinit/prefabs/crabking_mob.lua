local _G      = GLOBAL
local require = _G.require

require("hof_util")

-- Crab Guards and Crab Knights drop Crab Meat instead.
local function CrabKingMobPostInit(inst)
    _G.ReplaceLootTablePrefab(inst.prefab, "meat", "kyno_crabmeat")

    if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("crabking_mob",        CrabKingMobPostInit)
AddPrefabPostInit("crabking_mob_knight", CrabKingMobPostInit)