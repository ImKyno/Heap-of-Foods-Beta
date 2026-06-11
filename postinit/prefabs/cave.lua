local _G = GLOBAL

local function CavePostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("retrofitcavemap_hof")
end

AddPrefabPostInit("cave", CavePostInit)