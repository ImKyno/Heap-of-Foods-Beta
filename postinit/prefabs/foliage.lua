local _G = GLOBAL

local function FoliagePostInit(inst)
	inst:AddTag("cookable")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if not inst.components.cookable then
		inst:AddComponent("cookable")
		inst.components.cookable.product = "kyno_foliage_cooked"
	else
		inst.components.cookable.product = "kyno_foliage_cooked"
	end
end

AddPrefabPostInit("foliage", FoliagePostInit)