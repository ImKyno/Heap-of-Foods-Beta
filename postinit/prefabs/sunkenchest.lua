local _G = GLOBAL

-- Sunken Chest retains spoilage.
local function SunkenChestPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)
end

AddPrefabPostInit("sunkenchest", SunkenChestPostInit)