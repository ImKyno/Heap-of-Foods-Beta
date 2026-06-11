local _G = GLOBAL

-- Prime Mate has very small chance of dropping Pirate Rum.
local function PrimeMatePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("piraterum", 0.10)
	end
end

AddPrefabPostInit("prime_mate", PrimeMatePostInit)