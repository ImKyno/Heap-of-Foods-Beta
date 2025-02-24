require("tuning")
require("cooking")

local foods       = require("preparedfoods")
local foods_w     = require("preparedfoods_warly")
local foods_hof   = require("hof_foodrecipes")
local foods_hof_w = require("hof_foodrecipes_warly")
local foods_hof_s = require("hof_foodrecipes_seasonal")

local hof_spicedfoods = {}

local function oneaten_cold(inst, eater)
    eater:AddDebuff("kyno_freezebuff", "kyno_freezebuff")
end

local function oneaten_fire(inst, eater)
	eater:AddDebuff("kyno_firebuff", "kyno_firebuff")
end

local HOF_SPICES =
{	
	SPICE_CURE   = {},
	SPICE_COLD   = { oneatenfn = oneaten_cold, prefabs = { "kyno_freezebuff" } },
	SPICE_FIRE   = { oneatenfn = oneaten_fire, prefabs = { "kyno_firebuff"   } },
	SPICE_MIND   = {},
	SPICE_FED    = {},
}

local anim_state_override_symbol = AnimState.OverrideSymbol
function AnimState:OverrideSymbol(symbol, override_build, override_symbol, ...)
    if symbol == "swap_garnish" and override_build == "spices" and HOF_SPICES[override_symbol:upper()] then
        override_build = "kyno_spices"
    end
	
    return anim_state_override_symbol(self, symbol, override_build, override_symbol, ...)
end

function GenerateHofSpicedFoods(foods)
    for foodname, fooddata in pairs(foods) do
        for spicenameupper, spicedata in pairs(HOF_SPICES) do
            local newdata = shallowcopy(fooddata)
            local spicename = string.lower(spicenameupper)
			
            if foodname == "wetgoop" then
                newdata.test = function(cooker, names, tags) return names[spicename] end
                newdata.priority = -10
            else
                newdata.test = function(cooker, names, tags) return names[foodname] and names[spicename] end
                newdata.priority = 100
            end
			
            newdata.cooktime = .12
            newdata.stacksize = nil
            newdata.spice = spicenameupper
            newdata.basename = foodname
            newdata.name = foodname.."_"..spicename
            newdata.floater = {"med", nil, {0.85, 0.7, 0.85}}
			newdata.official = true
			newdata.cookbook_category = fooddata.cookbook_category ~= nil and ("spiced_"..fooddata.cookbook_category) or nil

            hof_spicedfoods[newdata.name] = newdata
			
			if spicename == "spice_cure" then
				if newdata.perishtime then
					newdata.perishtime = newdata.perishtime * TUNING.KYNO_PRESERVERBUFF_PERISHTIME or 0
					newdata.degrades_with_spoilage = false
				end
			end
			
			if spicename == "spice_cold" then
                if newdata.temperature == nil then
                    newdata.temperature = TUNING.COLD_FOOD_BONUS_TEMP
                    newdata.temperatureduration = TUNING.FOOD_TEMP_LONG
                elseif newdata.temperature > 0 then
                    newdata.temperatureduration = math.max(newdata.temperatureduration, TUNING.FOOD_TEMP_LONG)
                end
            end
			
			if spicename == "spice_fire" then
                if newdata.temperature == nil then
                    newdata.temperature = TUNING.HOT_FOOD_BONUS_TEMP
                    newdata.temperatureduration = TUNING.FOOD_TEMP_LONG
                    newdata.nochill = true
                elseif newdata.temperature > 0 then
                    newdata.temperatureduration = math.max(newdata.temperatureduration, TUNING.FOOD_TEMP_LONG)
                    newdata.nochill = true
                end
            end

            if spicedata.prefabs ~= nil then
                newdata.prefabs = newdata.prefabs ~= nil and ArrayUnion(newdata.prefabs, spicedata.prefabs) or spicedata.prefabs
            end
			
            if spicedata.oneatenfn ~= nil then
                if newdata.oneatenfn ~= nil then
                    local oneatenfn_old = newdata.oneatenfn
                    newdata.oneatenfn = function(inst, eater)
                        spicedata.oneatenfn(inst, eater)
                        oneatenfn_old(inst, eater)
                    end
                else
                    newdata.oneatenfn = spicedata.oneatenfn
                end
            end

        end
    end
end

local spicedfoods = require("spicedfoods")
GenerateSpicedFoods(MergeMaps(foods_hof, foods_hof_w, foods_hof_s)) -- This only creates spiced foods with vanilla spices.

for k, data in pairs(spicedfoods) do
    for name, v in pairs(MergeMaps(foods_hof, foods_hof_w, foods_hof_s)) do
        if data.basename == name then
            hof_spicedfoods[k] = data
        end
    end
end

GenerateHofSpicedFoods(MergeMaps(foods, foods_w))
GenerateHofSpicedFoods(MergeMaps(foods_hof, foods_hof_w, foods_hof_s))

return hof_spicedfoods