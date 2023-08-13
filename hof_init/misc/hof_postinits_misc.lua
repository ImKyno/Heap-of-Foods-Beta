-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab

require("hof_debugcommands")

-- Commands for testing.
AddClassPostConstruct("screens/consolescreen", function(self)
	if self.console_edit then
		local hof_commands = 
		{
			"hofingredients", 
			"hofswfoods",
			"hofhamfoods",
			"hofotherfoods",
			"hoftestcoffee",
			"hofcrockpots",
			"hofwarlycrockpots",
			"hoflayout",
			"hofserenityisland",
			"hofmeadowisland",
			"hofkegs",
			"hofjars",
			"hofretrofitserenityisland",
			"hofretrofitmeadowisland",
			"hofmonsterfoods",
		}
		local dictionary = self.console_edit.prediction_widget.word_predictor.dictionaries[3]
		for k, word in pairs(hof_commands) do
			table.insert(dictionary.words, word)
		end
	end
end)

-- Favorite Mod Foods.
AddPrefabPostInit("wilson", function(inst)
    inst:AddTag("wislanhealer")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("caviar", TUNING.AFFINITY_15_CALORIES_HUGE)
		-- inst.components.foodaffinity:AddPrefabAffinity("wine_dragonfruit", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("willow", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("feijoada", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("pickles_pepper", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wolfgang", function(inst)
    inst:AddTag("mightyman")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_potato_soup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("pickles_potato", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wendy", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("icedtea", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_fig", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wx78", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("bowlofgears", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wickerbottom", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("tea", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("teagreen", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("woodie", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_sliders", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("beer", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("waxwell", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_crab_roll", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("teared", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wes", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("sharkfinsoup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("tartarsauce", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wathgrithr", function(inst)
	inst:AddTag("animal_butcher")

	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_pot_roast", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mead", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("webber", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("steamedhamsandwich", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("winona", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("coffee", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("paleale", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wortox", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("jellyopop", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_pomegranate", TUNING.AFFINITY_15_CALORIES_HUGE)
    end

    if inst.components.eater ~= nil then
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.PREPAREDSOUL, FOODGROUP.OMNI })
    end
end)

AddPrefabPostInit("wormwood", function(inst)
	inst:AddTag("PREPAREDPOOP_eater")

	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gummy_cake", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_kokonut", TUNING.AFFINITY_15_CALORIES_HUGE)
    end

    if inst.components.eater ~= nil then
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI, FOODTYPE.PREPAREDPOOP })
    end
end)

AddPrefabPostInit("wurt", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_vegetable_soup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("pickles_cucumber", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
	
	if inst.components.locomotor ~= nil then
		inst.components.locomotor:SetFasterOnGroundTile(WORLD_TILES.HOF_TIDALMARSH, true)
	end
end)

AddPrefabPostInit("walter", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_hamburger", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise_chicken", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wanda", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_candy", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise_nightmare", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wonkey", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("coconutwater", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_banana", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

-- Ashes are Now a Fertilizer. Also using the Nutrients of Manure as placeholder for now, check "ash.lua".
local function AshPostinit(inst)
	local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

    local function GetFertilizerKey(inst)
        return inst.prefab
    end

    local function fertilizerresearchfn(inst)
        return inst:GetFertilizerKey()
    end

    MakeDeployableFertilizerPristine(inst)

    inst:AddTag("fertilizerresearchable")
	
    inst.GetFertilizerKey = GetFertilizerKey

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("coffeefertilizer2")

    inst:AddComponent("fertilizerresearchable")
    inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.SPOILEDFOOD_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.SPOILEDFOOD_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.SPOILEDFOOD_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.ash.nutrients)

    MakeDeployableFertilizer(inst)
end

AddPrefabPostInit("ash", AshPostinit)

-- Sludge is a fertilizer too.
local function SludgePostinit(inst)
	local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

    local function GetFertilizerKey(inst)
        return inst.prefab
    end

    local function fertilizerresearchfn(inst)
        return inst:GetFertilizerKey()
    end

    MakeDeployableFertilizerPristine(inst)

    inst:AddTag("fertilizerresearchable")
	
    inst.GetFertilizerKey = GetFertilizerKey

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fertilizerresearchable")
    inst.components.fertilizerresearchable:SetResearchFn(fertilizerresearchfn)

    inst:AddComponent("fertilizer")
    inst.components.fertilizer.fertilizervalue = TUNING.ROTTENEGG_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.ROTTENEGG_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.ROTTENEGG_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.wetgoop2.nutrients)

    MakeDeployableFertilizer(inst)
end

AddPrefabPostInit("wetgoop2", SludgePostinit)

-- Prevent Food From Spoiling In Stations.
local KEEP_FOOD_K = GetModConfigData("HOF_KEEPFOOD")
if KEEP_FOOD_K == 1 then
    local cooking_stations = {
        "cookpot",
        "portablecookpot",
        "archive_cookpot",
        "kyno_cookware_syrup",
        "kyno_cookware_small",
        "kyno_cookware_big",
        "kyno_cookware_elder",
        "kyno_cookware_small_grill",
        "kyno_cookware_grill",
        "kyno_cookware_oven_small_casserole",
        "kyno_cookware_oven_casserole",
    }

    for k,v in pairs(cooking_stations) do
        AddPrefabPostInit(v, function(inst)
            if inst.components.stewer then
                inst.components.stewer.onspoil = function()
                    inst.components.stewer.spoiltime = 1
                    inst.components.stewer.targettime = _G.GetTime()
                    inst.components.stewer.product_spoilage = 0
                end
            end
        end)
    end
end

-- For using Salt on Crock Pot foods.
AddComponentPostInit("edible", function(self, inst)
    if not inst.components.saltable and inst:HasTag("preparedfood") then
        inst:AddComponent("saltable")
    end
end)

-- Speed boost for the White Stone Road.
AddComponentPostInit("locomotor", function(inst)
	local QUGSM = inst.UpdateGroundSpeedMultiplier
	
	inst.UpdateGroundSpeedMultiplier = function(self)
	QUGSM(self)
	if self.wasoncreep == false and self:FasterOnRoad() and
	_G.TheWorld.Map:GetTileAtPoint(self.inst.Transform:GetWorldPosition()) == WORLD_TILES.QUAGMIRE_CITYSTONE then
			self.groundspeedmultiplier = self.fastmultiplier
		end
	end
end)

-- inst.components.debuffable:RemoveAllDebuffs()
AddComponentPostInit("debuffable", function(self)
    function self:RemoveAllDebuffs()
        for name, _ in pairs(self.debuffs) do
            self:RemoveDebuff(name)
        end
    end
end)