local _G = GLOBAL

-- Rockjaw drops Shark Fins.
local function SharkPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if not TUNING.HOF_IS_TCP_ENABLED then
		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:AddChanceLoot("kyno_shark_fin", 1.00)
		end
	end
end

AddPrefabPostInit("shark", SharkPostInit)