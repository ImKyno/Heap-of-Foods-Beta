local _G = GLOBAL

-- For trading turfs with the Elder.
local function TurfTraderPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
	end
end

AddPrefabPostInit("turf_road",      TurfTraderPostInit)
AddPrefabPostInit("turf_deciduous", TurfTraderPostInit)