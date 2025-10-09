-- What is this? Just a blank prefab serving as a marker for Colour Cubes.
-- This is because sometimes other ocean content override our MapTags and 
-- that make playervision change areas, meaning Colour Cubes stop working
-- even though you are still in the same place.

local assets =
{

}

local function commonfn(islandname, tag)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst:AddTag(tag)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")

	return inst
end

local function serenity_marker()
	return commonfn("SerenityIsland", "serenity_cc_marker")
end

local function meadow_marker()
	return commonfn("MeadowIsland", "meadow_cc_marker")
end

local function dina_marker()
	return commonfn("DinaMemorial", "dina_cc_marker")
end

return Prefab("kyno_serenity_cc_marker", serenity_marker, assets),
Prefab("kyno_meadow_cc_marker", meadow_marker, assets),
Prefab("kyno_dinamemorial_marker", dina_marker, assets)