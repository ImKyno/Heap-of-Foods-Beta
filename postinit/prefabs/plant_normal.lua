local _G = GLOBAL

local WEEDS =
{
	firenettles     = { build = "firenettles2",    symbol = "firenettles01"  },
	forgetmelots    = { build = "forgetmelots2",   symbol = "forgetmelots01" },
	tillweed        = { build = "tillweed2",       symbol = "tillweed01"     },
	kyno_icenettles = { build = "kyno_icenettles", symbol = "icenettles01"   },
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
			local weed = product ~= nil and WEEDS[product]

			if weed then
				inst.AnimState:OverrideSymbol("swap_grown", weed.build, weed.symbol)
			end
		end)
	end
end

AddPrefabPostInit("plant_normal",        PlantNormalPostInit)
AddPrefabPostInit("plant_normal_ground", PlantNormalPostInit)