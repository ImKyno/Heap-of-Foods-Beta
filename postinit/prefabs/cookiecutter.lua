local _G = GLOBAL

-- Cookie Cutters drops Mussels.
local function CookieCutterPostInit(inst)
	-- Trappable for Ocean Trap.
	-- "oceanfish" and "smalloceancreature" tags are inconsistent.
	inst:AddTag("smalloceanfish")
	inst:AddTag("canbetrapped")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("kyno_mussel", 0.50)
	end
end

AddPrefabPostInit("cookiecutter", CookieCutterPostInit)