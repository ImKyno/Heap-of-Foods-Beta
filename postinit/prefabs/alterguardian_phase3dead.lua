local _G = GLOBAL

local function AlterGuardianPhase3DeadPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_opalpreciousapple",  0.10)
	end
end

AddPrefabPostInit("alterguardian_phase3dead", AlterGuardianPhase3DeadPostInit)