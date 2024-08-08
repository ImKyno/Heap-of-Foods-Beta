-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab
local cooking           = require("cooking")

require("hof_debugcommands")

local HOF_HUMANMEAT = GetModConfigData("HOF_HUMANMEAT")
local HOF_KEEPFOOD  = GetModConfigData("HOF_KEEPFOOD")

-- Favorite Mod Foods.
AddPrefabPostInit("wilson", function(inst)
    inst:AddTag("wislanhealer")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("caviar", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("wine_dragonfruit", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("willow", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("feijoada",       TUNING.AFFINITY_15_CALORIES_HUGE)
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
		inst.components.foodaffinity:AddPrefabAffinity("pickles_potato",    TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wendy", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("icedtea",   TUNING.AFFINITY_15_CALORIES_HUGE)
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
        inst.components.foodaffinity:AddPrefabAffinity("tea",      TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("teagreen", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("woodie", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_sliders", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("beer",          TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("waxwell", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_crab_roll", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("teared",          TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wes", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("sharkfinsoup", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("tartarsauce",  TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wathgrithr", function(inst)
	inst:AddTag("animal_butcher")

	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_pot_roast", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mead",            TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("webber", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("steamedhamsandwich", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise",         TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("winona", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("coffee",  TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("paleale", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wortox", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("jellyopop",         TUNING.AFFINITY_15_CALORIES_HUGE)
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
        inst.components.foodaffinity:AddPrefabAffinity("gummy_cake",    TUNING.AFFINITY_15_CALORIES_HUGE)
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
        inst.components.foodaffinity:AddPrefabAffinity("duriansoup",    1.93)
		inst.components.foodaffinity:AddPrefabAffinity("jelly_durian",  1.93)
		inst.components.foodaffinity:AddPrefabAffinity("wine_durian",   1.93)
		inst.components.foodaffinity:AddPrefabAffinity("duriansplit",   1.93)
		inst.components.foodaffinity:AddPrefabAffinity("duriansoup",    1.93)
		inst.components.foodaffinity:AddPrefabAffinity("durianchicken", 1.93)
		inst.components.foodaffinity:AddPrefabAffinity("monstermuffin", 1.33)
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
        inst.components.foodaffinity:AddPrefabAffinity("gorge_hamburger",    TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("mayonnaise_chicken", TUNING.AFFINITY_15_CALORIES_HUGE)
    end
end)

AddPrefabPostInit("wanda", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.foodaffinity ~= nil then
        inst.components.foodaffinity:AddPrefabAffinity("gorge_candy", TUNING.AFFINITY_15_CALORIES_HUGE)
		inst.components.foodaffinity:AddPrefabAffinity("nukacola",    TUNING.AFFINITY_15_CALORIES_HUGE)
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

-- Players Have a Chance to Drop Long Pig. Except WX-78, Wurt, Wortox and Wormwood.
if HOF_HUMANMEAT then
    local longpig_characters =
	{
        "wilson",
        "willow",
        "wolfgang",
        "wendy",
        "wickerbottom",
        "woodie",
        "waxwell",
        "wes",
        "webber",
        "wathgrithr",
        "winona",
        "warly",
        "walter",
        "wanda",
    }

	local function LongPigPostinit(inst)
		local function OnDeathLongPig(inst)
			if math.random() < 0.33 then
				local x, y, z = inst.Transform:GetWorldPosition()
				local humanmeat = SpawnPrefab("kyno_humanmeat")
				
				if humanmeat ~= nil then
					if humanmeat.Physics ~= nil then
						local speed = 1 + math.random()
						local angle = math.random() * 1 * PI
						humanmeat.Physics:Teleport(x, y + 1, z)
						humanmeat.Physics:SetVel(speed * math.cos(angle), speed * 0.5, speed * math.sin(angle))
					else
						humanmeat.Transform:SetPosition(x, y, z)
					end
				end
			end
		end

		if not _G.TheWorld.ismastersim then
			return inst
		end

		inst:ListenForEvent("death", OnDeathLongPig)
	end

    for k,v in pairs(longpig_characters) do
        AddPrefabPostInit(v, LongPigPostinit)
    end
end

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

-- Prevent Food From Spoiling In Stations.
if HOF_KEEPFOOD then
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