local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS
local sort_order = require("prefabs/fertilizer_nutrient_defs").SORTED_FERTILIZERS

local HOF_FERTILIZER_DEFS                   = {}

HOF_FERTILIZER_DEFS.ash                     = {nutrients  = TUNING.ASH_NUTRIENTS                                                   }
HOF_FERTILIZER_DEFS.kyno_mysterymeat        = { nutrients = TUNING.KYNO_MYSTERYMEAT_NUTRIENTS                                      }
HOF_FERTILIZER_DEFS.kyno_floatilizer        = { nutrients = TUNING.KYNO_FLOATILIZER_NUTRIENTS, uses = TUNING.KYNO_FLOATILIZER_USES }
HOF_FERTILIZER_DEFS.kyno_sap_spoiled        = { nutrients = TUNING.KYNO_SAP_SPOILED_NUTRIENTS                                      }
HOF_FERTILIZER_DEFS.wetgoop2                = { nutrients = TUNING.WETGOOP2_NUTRIENTS                                              }
HOF_FERTILIZER_DEFS.kyno_spoiled_fish_large = { nutrients = TUNING.KYNO_SPOILED_FISH_LARGE_NUTRIENTS                               }

local hof_sort_order                        =
{
	ash                                     = "spoiled_fish_small",
	kyno_mysterymeat                        = "spoiled_food",
	kyno_floatilizer                        = "rottenegg",
	kyno_sap_spoiled                        = "spoiled_fish",
	wetgoop2                                = "compost",
	kyno_spoiled_fish_large                 = "soil_amender_low",
}

for fertilizer, data in pairs(HOF_FERTILIZER_DEFS) do
	if data.inventoryimage == nil then
		data.inventoryimage = fertilizer..".tex"
	end

	if data.name == nil then
		data.name = string.upper(fertilizer)
	end

	if data.uses == nil then
		data.uses  = 1
	end

	if fertilizer and data then
		FERTILIZER_DEFS[fertilizer] = data
		local sort_data = hof_sort_order[fertilizer]
		
		if sort_data and type(sort_data) == "string" then
			for i, name in ipairs(sort_order) do
				if name == sort_data then
					table.insert(sort_order, i + 1, fertilizer)
					break
				end
			end
		elseif sort_data and type(sort_data) == "number" then
			table.insert(sort_order, sort_data, fertilizer)
		else
			table.insert(sort_order, fertilizer)
		end
	end
end