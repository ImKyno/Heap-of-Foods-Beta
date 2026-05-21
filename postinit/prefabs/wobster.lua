local _G = GLOBAL

-- Trappable for Ocean Trap.
-- "oceanfish" and "smalloceancreature" tags are inconsistent.
local function WobsterPostInit(inst)
	inst:AddTag("smalloceanfish")
	inst:AddTag("canbetrapped")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("wobster_sheller",   WobsterPostInit)
AddPrefabPostInit("wobster_moonglass", WobsterPostInit)