require("tuning")

-- Complementary Mod Spices for Warly.
if TUNING.HOF_WARLYSPICES then
	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - Loading Spiced Foods with Modded Spices.")
	end

	local foods       = require("preparedfoods")
	local foods_w     = require("preparedfoods_warly")
	local foods_hof   = require("hof_foodrecipes")
	local foods_hof_w = require("hof_foodrecipes_warly")
	local foods_hof_s = require("hof_foodrecipes_seasonal")

	local hof_spicedfoods = {}

	local function oneaten_cure(inst, eater)
		eater:AddDebuff("kyno_spice_curebuff", "kyno_spice_curebuff")
	end

	local function oneaten_cold(inst, eater)
		eater:AddDebuff("kyno_spice_coldbuff", "kyno_spice_coldbuff")
	end

	local function oneaten_fire(inst, eater)
		eater:AddDebuff("kyno_spice_firebuff", "kyno_spice_firebuff")
	end

	local function oneaten_mind(inst, eater)
		eater:AddDebuff("kyno_spice_mindbuff", "kyno_spice_mindbuff")
	end

	local function oneaten_fed(inst, eater)
		eater:AddDebuff("kyno_spice_fedbuff", "kyno_spice_fedbuff")
	end

	local HOF_SPICES =
	{
		SPICE_CURE   = { oneatenfn = oneaten_cure, prefabs = { "kyno_spice_curebuff" }},
		SPICE_COLD   = { oneatenfn = oneaten_cold, prefabs = { "kyno_spice_coldbuff" }},
		SPICE_FIRE   = { oneatenfn = oneaten_fire, prefabs = { "kyno_spice_firebuff" }},
		SPICE_MIND   = { oneatenfn = oneaten_mind, prefabs = { "kyno_spice_mindbuff" }},
		SPICE_FED    = { oneatenfn = oneaten_fed,  prefabs = { "kyno_spice_fedbuff"  }},
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
			if not table.contains(TUNING.HOF_NOSPICE_FOODS, foodname) then
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
					newdata.official = false
					newdata.cookbook_category = fooddata.cookbook_category ~= nil and ("spiced_"..fooddata.cookbook_category) or nil

					hof_spicedfoods[newdata.name] = newdata

					if spicename == "spice_cure" then
						if newdata.perishtime then
							newdata.perishtime = newdata.perishtime * TUNING.KYNO_SPICE_CUREBUFF_PERISHTIME_RATE or 0
						end

						--[[
						if newdata.degrades_with_spoilage then
							newdata.degrades_with_spoilage = false
						end
						]]--
					end

					if spicename == "spice_cold" then
						if newdata.temperature == nil then
							newdata.temperature = TUNING.COLD_FOOD_BONUS_TEMP
							newdata.temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION
						elseif newdata.temperature > 0 then
							-- newdata.temperature = TUNING.COLD_FOOD_BONUS_TEMP
							newdata.temperatureduration = math.max(newdata.temperatureduration, TUNING.BUFF_FOOD_TEMP_DURATION)
						end
					end

					if spicename == "spice_fire" then
						if newdata.temperature == nil then
							newdata.temperature = TUNING.HOT_FOOD_BONUS_TEMP
							newdata.temperatureduration = TUNING.BUFF_FOOD_TEMP_DURATION
							newdata.nochill = true
						elseif newdata.temperature > 0 then
							-- newdata.temperature = TUNING.HOT_FOOD_BONUS_TEMP
							newdata.temperatureduration = math.max(newdata.temperatureduration, TUNING.BUFF_FOOD_TEMP_DURATION)
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
	end

	local recipes     = MergeMaps(foods, foods_w)
	local recipes_hof = MergeMaps(foods_hof, foods_hof_w, foods_hof_s)
	local spicedfoods = require("spicedfoods")

	GenerateSpicedFoods(recipes_hof) -- This only creates spiced foods with vanilla spices.

	GenerateHofSpicedFoods(recipes)
	GenerateHofSpicedFoods(recipes_hof)

	for k, data in pairs(spicedfoods) do
		if not table.contains(TUNING.HOF_NOSPICE_FOODS, data.basename) then
			for name, v in pairs(recipes_hof) do
				if data.basename == name then
					hof_spicedfoods[k] = data
				end
			end
		end
	end

	for name, data in pairs(spicedfoods) do
		if table.contains(TUNING.HOF_NOSPICE_FOODS, data.basename) then
			spicedfoods[name] = nil
		end
	end

	return hof_spicedfoods
else
	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - Loading Spiced Foods with vanilla spices only.")
	end

	local foods         = require("hof_foodrecipes")
	local foods_w       = require("hof_foodrecipes_warly")
	local foods_s       = require("hof_foodrecipes_seasonal")
	local recipes_hof   = MergeMaps(foods, foods_w, foods_s)

	local spicedfoods   = require("spicedfoods")

	GenerateSpicedFoods(recipes_hof)

	for k, data in pairs(spicedfoods) do
		if not table.contains(TUNING.HOF_NOSPICE_FOODS, data.basename) then
			for name, v in pairs(recipes_hof) do
				if data.basename == name then
					spicedfoods[k] = data
				end
			end
		end
	end

	for name, data in pairs(spicedfoods) do
		if table.contains(TUNING.HOF_NOSPICE_FOODS, data.basename) then
			spicedfoods[name] = nil
		end
	end

	return spicedfoods
end