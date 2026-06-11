local _G        = GLOBAL
local DF_COFFEE = GetModConfigData("COFFEEDROPRATE")

-- Dragonfly drops Coffee Plants.
local function DragonflyPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		for _ = 1, DF_COFFEE do
			inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		end
	end
end

AddPrefabPostInit("dragonfly", DragonflyPostInit)