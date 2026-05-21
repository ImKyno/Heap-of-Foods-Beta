local _G = GLOBAL

-- Depths Worms drops Worm Bones.
local function WormPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_worm_bone", 0.40)
		inst.components.lootdropper:AddChanceLoot("kyno_worm_bone", 0.20)
	end
end

AddPrefabPostInit("worm", WormPostInit)