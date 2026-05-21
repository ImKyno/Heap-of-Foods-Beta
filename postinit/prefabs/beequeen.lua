local _G = GLOBAL

-- Bee Queen drops the blueprint for the Honey Deposit.
local function BeeQueenPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_antchest_blueprint", 1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         1.00)
		inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         0.33)
		inst.components.lootdropper:AddChanceLoot("kyno_nectar_pod",         0.33)
	end
end

AddPrefabPostInit("beequeen", BeeQueenPostInit)