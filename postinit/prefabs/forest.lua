local _G = GLOBAL

local function ForestPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("sugarflyspawner")
	inst:AddComponent("waterfowlhunter")
	inst:AddComponent("retrofitforestmap_hof")
end

AddPrefabPostInit("forest", ForestPostInit)