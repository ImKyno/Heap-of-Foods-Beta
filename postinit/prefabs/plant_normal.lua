local _G = GLOBAL

local WEEDS =
{
	firenettles  = true,
	forgetmelots = true,
	tillweed     = true,
}

-- Allows Wickerbottom's book to grow some plants.
local function PlantNormalPostInit(inst)
	inst:AddTag("plant")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.crop ~= nil then
		local _OnMatured = inst.components.crop.onmatured

		if _OnMatured == nil then
			return
		end

		inst.components.crop:SetOnMatureFn(function(inst)
			if _OnMatured then
				_OnMatured(inst)
			end

			local product = inst.components.crop.product_prefab

			if WEEDS[product] then
				inst.AnimState:OverrideSymbol("swap_grown", product.."2", product.."01")
			end
		end)
	end
end

AddPrefabPostInit("plant_normal",        PlantNormalPostInit)
AddPrefabPostInit("plant_normal_ground", PlantNormalPostInit)