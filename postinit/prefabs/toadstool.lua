local _G      = GLOBAL
local require = _G.require

require("hof_util")

-- Toadstool drops Poison Frog Legs instead.
local function ToadstoolPostInit(inst)
	_G.ReplaceLootTablePrefab(inst.prefab, "froglegs", "kyno_poison_froglegs")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 0.50)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap", 0.25)
	end
end

local function ToadstoolDarkPostInit(inst)
	_G.ReplaceLootTablePrefab(inst.prefab, "froglegs", "kyno_poison_froglegs")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 0.50)
		inst.components.lootdropper:AddChanceLoot("kyno_sporecap_dark", 0.25)
	end
end

AddPrefabPostInit("toadstool",      ToadstoolPostInit)
AddPrefabPostInit("toadstool_dark", ToadstoolDarkPostInit)