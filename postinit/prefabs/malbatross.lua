local _G = GLOBAL

-- Bee Queen drops the blueprint for the Salt Pack.
local function MalbatrossPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_foodsack_blueprint", 1.00)
	end
end

AddPrefabPostInit("malbatross", MalbatrossPostInit)