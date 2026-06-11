local _G = GLOBAL

-- Make Fish Food a valid fuel for the Fish Hatchery.
local function ChumPostInit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if not inst.components.fuel then
		inst:AddComponent("fuel")
	end
	
	if inst.components.fuel ~= nil then
		inst.components.fuel.fueltype = _G.FUELTYPE.FISHFOOD
		inst.components.fuel.fuelvalue = TUNING.HUGE_FUEL
	end
end

AddPrefabPostInit("chum", ChumPostInit)