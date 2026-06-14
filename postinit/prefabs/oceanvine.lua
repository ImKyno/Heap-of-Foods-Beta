local _G = GLOBAL

local function OceanVinePostInit(inst)
	inst:AddTag("pickable_tall")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("oceanvine", OceanVinePostInit)