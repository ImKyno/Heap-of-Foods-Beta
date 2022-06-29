------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Favorite Mod Foods.
AddPrefabPostInit("wilson", function(inst)
	inst:AddTag("wislanhealer")
	
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("caviar", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("willow", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("feijoada", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)
	
AddPrefabPostInit("wolfgang", function(inst)
	inst:AddTag("mightyman")
	
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_potato_soup", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("wendy", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("icedtea", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("wx78", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("bowlofgears", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("wickerbottom", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("tea", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("woodie", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_sliders", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("waxwell", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_crab_roll", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("wes", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("sharkfinsoup", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("wathgrithr", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_pot_roast", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("webber", function(inst)
	inst:AddTag("animal_butcher")
	
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("steamedhamsandwich", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("winona", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("coffee", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("wortox", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("jellyopop", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
	
	if inst.components.eater ~= nil then
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.PREPAREDSOUL, FOODGROUP.OMNI })
    end
end)

AddPrefabPostInit("wormwood", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gummy_cake", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
	
	if inst.components.eater ~= nil then
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.POOP, FOODGROUP.OMNI })
    end
end)

AddPrefabPostInit("wurt", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_vegetable_soup", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("walter", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_hamburger", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)

AddPrefabPostInit("wanda", function(inst)
	if inst.components.foodaffinity then
		inst.components.foodaffinity:AddPrefabAffinity("gorge_candy", TUNING.AFFINITY_15_CALORIES_HUGE)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fix For Spiced Coffee. There you go Terra B. :glzSIP:
local COFFEE_SPEED = GetModConfigData("HOF_COFFEESPEED")
local COFFEE_DURATION = GetModConfigData("HOF_COFFEEDURATION")
if COFFEE_SPEED == 1 then
	local coffee_speedbuff = {
		"coffee",
		"coffee_spice_garlic",
		"coffee_spice_sugar",
		"coffee_spice_chili",
		"coffee_spice_salt",
	}

	for k,v in pairs(coffee_speedbuff) do
		AddPrefabPostInit(v, function(inst)
			local spiced_buffs = {SPICE_CHILI = "buff_attack", SPICE_GARLIC = "buff_playerabsorption", SPICE_SUGAR = "buff_workeffectiveness"}
			local function OnEatCoffee(inst, eater)
				if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
				return
			elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
				eater.coffeebuff_duration = COFFEE_DURATION
				eater.components.debuffable:AddDebuff("kyno_coffeebuff", "kyno_coffeebuff")
			local spiced_buff = spiced_buffs[inst.components.edible.spice]
				if spiced_buff then
					eater.components.debuffable:AddDebuff(spiced_buff, spiced_buff)
				end
				if eater.components.talker then 
					eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF"))
				end
			else
				eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", 1.83)
				eater:DoTaskInTime(COFFEE_DURATION, function()
					eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
				end)
			end
		end	
	
			inst:AddTag("honeyed")
		
			if inst.components.edible then
				inst.components.edible:SetOnEatenFn(OnEatCoffee)
			end
		end)
	end
	
	AddPrefabPostInit("kyno_coffeebeans_cooked", function(inst)
		local function OnEatBeans(inst, eater)
			if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
				return
			elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
				eater.coffeebuff_duration = 30
				eater.components.debuffable:AddDebuff("kyno_coffeebuff", "kyno_coffeebuff")
			else
				eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", 1.83)
				eater:DoTaskInTime(30, function()
					eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
				end)
			end
		end
		
		if inst.components.edible then
			inst.components.edible:SetOnEatenFn(OnEatBeans)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ashes are Now a Fertilizer. Also using the Nutrients of Manure as placeholder for now, check "ash.lua".
AddPrefabPostInit("ash", function(inst)
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
    inst.components.fertilizer.fertilizervalue = TUNING.POOP_FERTILIZE
    inst.components.fertilizer.soil_cycles = TUNING.POOP_SOILCYCLES
    inst.components.fertilizer.withered_cycles = TUNING.POOP_WITHEREDCYCLES
    inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.poop.nutrients)

    MakeDeployableFertilizer(inst)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Rockjaws Drops Shark Fin.
AddPrefabPostInit("shark", function(inst)
	if _G.TheWorld.ismastersim and not _G.KnownModIndex:IsModEnabled("workshop-2174681153") then
		inst.components.lootdropper:AddChanceLoot("kyno_shark_fin", 1.00) 
	end
end)

-- Cookie Cutters Drops Mussel.
AddPrefabPostInit("cookiecutter", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_mussel", 0.50) 
end)

-- Beefalos Drops Bean Bugs.
AddPrefabPostInit("beefalo", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_beanbugs", 1.00) 
	inst.components.lootdropper:AddChanceLoot("kyno_beanbugs", 0.50) 
end)

AddPrefabPostInit("babybeefalo", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_beanbugs", 0.10) 
end)

-- Catcoon Drops Gummy Slug
AddPrefabPostInit("catcoon", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_gummybug", 0.35) 
end)

-- Some Birds Spawns Roe Periodically.
AddPrefabPostInit("puffin", function(inst)
	if inst.components.periodicspawner ~= nil then
		inst.components.periodicspawner:SetPrefab("kyno_roe")
		inst.components.periodicspawner:SetDensityInRange(20, 2)
		inst.components.periodicspawner:SetMinimumSpacing(8)
	end
end)

AddPrefabPostInit("robin_winter", function(inst)
	if inst.components.periodicspawner ~= nil then
		inst.components.periodicspawner:SetPrefab("kyno_roe")
		inst.components.periodicspawner:SetDensityInRange(20, 2)
		inst.components.periodicspawner:SetMinimumSpacing(8)
	end
end)

AddPrefabPostInit("canary", function(inst)
	if inst.components.periodicspawner ~= nil then
		inst.components.periodicspawner:SetPrefab("kyno_roe")
		inst.components.periodicspawner:SetDensityInRange(20, 2)
		inst.components.periodicspawner:SetMinimumSpacing(8)
	end
end)

-- If T.A.P is enabled, make sure Cormorant Spawns Roe too.
if _G.KnownModIndex:IsModEnabled("workshop-2428854303") then
	AddPrefabPostInit("cormorant", function(inst)
		if inst.components.periodicspawner ~= nil then
			inst.components.periodicspawner:SetPrefab("kyno_roe")
			inst.components.periodicspawner:SetDensityInRange(20, 2)
			inst.components.periodicspawner:SetMinimumSpacing(8)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Theorically Tea Cool Down and Turns into Iced Tea.
AddPrefabPostInit("tea", function(inst)
	if inst.components.perishable ~= nil then
		inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "icedtea"
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- It's Cursed. Players Have a Chance to Drop Long Pig. Except WX-78, Wurt, Wortox and Wormwood.
local HUMANMEATY = GetModConfigData("HOF_HUMANMEAT")
if HUMANMEATY == 1 then
	local longpig_characters = {
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

	for k,v in pairs(longpig_characters) do
		AddPrefabPostInit(v, function(inst)
			local function ondeath_longpig(inst)
				if math.random()<0.90 then
					SpawnPrefab("kyno_humanmeat").Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
			end		
		
			if not _G.TheWorld.ismastersim then
				return inst
			end
	
			inst:ListenForEvent("death", ondeath_longpig)
		end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Pig King Trades Some Items.
local function BushTrader(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "dug_kyno_spotbush" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "dug_kyno_spotbush" }
	end
end

local function WheatTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "dug_kyno_wildwheat" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "dug_kyno_wildwheat" }
	end
end

local function SweetTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sweetpotato_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_sweetpotato_seeds" }
	end
end

local function RadishTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_radish_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_radish_seeds" }
	end
end

local function FennelTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_fennel_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_fennel_seeds" }
	end
end

local function AloeTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_aloe_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_aloe_seeds" }
	end
end

local function LimpetTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_limpets" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_limpets" }
	end
end

local function TaroTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_taroroot" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_taroroot" }
	end
end

local function LotusTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_lotus_flower" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_lotus_flower" }
	end
end

local function CressTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_waterycress" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_waterycress" }
	end
end

local function CucumberTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_cucumber_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_cucumber_seeds" }
	end
end

local function WeedTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_seaweeds_root" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_seaweeds_root" }
	end
end

local function ParsnipTrader(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_parznip_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_parznip_seeds" }
	end
end

local function TurnipTrader(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_turnip_seeds" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_turnip_seeds" }
	end
end

local function KokonutTrader(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_kokonut" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_kokonut" }
	end
end

local function BananaTrader(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inventoryitem ~= nil and not inst.components.tradable then
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_banana" }
	else
		inst.components.tradable.goldvalue = 1
		inst.components.tradable.tradefor = { "kyno_banana" }
	end
end

AddPrefabPostInit("dug_berrybush", 			BushTrader)
AddPrefabPostInit("dug_berrybush2", 		BushTrader)
AddPrefabPostInit("dug_berrybush_juicy", 	BushTrader)
AddPrefabPostInit("dug_grass", 				WheatTrader)
AddPrefabPostInit("potato_seeds", 			SweetTrader)
AddPrefabPostInit("carrot_seeds", 			RadishTrader)
AddPrefabPostInit("durian_seeds", 			FennelTrader)
AddPrefabPostInit("asparagus_seeds", 		AloeTrader)
AddPrefabPostInit("cutlichen", 				LimpetTrader)
AddPrefabPostInit("eggplant", 				TaroTrader)
AddPrefabPostInit("butterfly", 				LotusTrader)
AddPrefabPostInit("succulent_picked", 		CressTrader)
AddPrefabPostInit("watermelon_seeds", 		CucumberTrader)
AddPrefabPostInit("kelp", 					WeedTrader)
AddPrefabPostInit("pumpkin_seeds", 			ParsnipTrader)
AddPrefabPostInit("garlic_seeds", 			TurnipTrader)
AddPrefabPostInit("pomegranate_seeds",		KokonutTrader)
AddPrefabPostInit("cave_banana",            BananaTrader)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Foliage can be cooked into Cooked Foliage.
AddPrefabPostInit("foliage", function(inst)
	inst:AddTag("cookable")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "kyno_foliage_cooked"
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mod Options.
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
	
	local brewing_stations = {
		"kyno_woodenkeg",
		"kyno_preservesjar",
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
	
	for k,v in pairs(brewing_stations) do
		AddPrefabPostInit(v, function(inst)
			if inst.components.brewer then
				inst.components.brewer.onspoil = function() 
					inst.components.brewer.spoiltime = 1
					inst.components.brewer.targettime = _G.GetTime()
					inst.components.brewer.product_spoilage = 0
				end
			end
		end)
	end
end

-- Dragonfly Drops Coffee Plants.
local DF_COFFEE = GetModConfigData("HOF_COFFEEDROPRATE")
if DF_COFFEE == 1 then
	AddPrefabPostInit("dragonfly", function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end	
		
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
	end)
elseif DF_COFFEE == 2 then
	AddPrefabPostInit("dragonfly", function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end	
		
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
	end)
elseif DF_COFFEE == 3 then
	AddPrefabPostInit("dragonfly", function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end	
		
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
	end)
elseif DF_COFFEE == 4 then
	AddPrefabPostInit("dragonfly", function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end	
		
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00) 
		inst.components.lootdropper:AddChanceLoot("dug_kyno_coffeebush", 1.00)
	end)
end

-- Wigfrid Can't Drink Coffee.
local FRIDA_COFFEE = GetModConfigData("HOF_COFFEEGOODIES")
if FRIDA_COFFEE == 0 then
	local coffee_wathgrithr = {
		"coffee",
		"coffee_spice_garlic",
		"coffee_spice_sugar",
		"coffee_spice_chili",
		"coffee_spice_salt",
	}
	
	for k,v in pairs(coffee_wathgrithr) do
		AddPrefabPostInit(v, function(inst)
			if inst.components.edible ~= nil then
				inst.components.edible.foodtype = FOODTYPE.VEGGIE
			end
		end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Lazy Fix!
AddPrefabPostInit("duckyouglermz", function(inst)
	local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS
	
	inst.AnimState:SetScale(.95, .95, .95)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddTag("heal_fertilize")
	inst:AddTag("slowfertilize")
		
	inst:AddComponent("fertilizer")
	inst.components.fertilizer.fertilizervalue = TUNING.SOILAMENDER_FERTILIZE_HIGH
	inst.components.fertilizer.soil_cycles = TUNING.SOILAMENDER_SOILCYCLES_HIGH
	inst.components.fertilizer.withered_cycles = TUNING.SOILAMENDER_WITHEREDCYCLES_HIGH
	inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.soil_amender_fermented.nutrients)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Some items are a bit huge when dropped...
local function ResizeThisItem(inst)
	inst.AnimState:SetScale(.75, .75, .75)
end

local resize_items = {
	"kyno_radish_cooked",
	"kyno_cucumber",
	"kyno_parznip_cooked",
	"kyno_turnip_cooked",
	"kyno_turnip_ground",
	"cucumbersalad",
}

for k,v in pairs(resize_items) do
	AddPrefabPostInit(v, ResizeThisItem)
end

AddPrefabPostInit("cucumbersalad", function(inst)
	inst.AnimState:SetScale(1.5, 1.5, 1.5)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fix For Spiced Tropical Bouillabaisse.
local COFFEE_SPEED = GetModConfigData("HOF_COFFEESPEED")
if COFFEE_SPEED == 1 then
	local bouillabaisse_speedbuff = {
		"tropicalbouillabaisse",
		"tropicalbouillabaisse_spice_garlic",
		"tropicalbouillabaisse_spice_sugar",
		"tropicalbouillabaisse_spice_chili",
		"tropicalbouillabaisse_spice_salt",
	}

	for k,v in pairs(bouillabaisse_speedbuff) do
		AddPrefabPostInit(v, function(inst)
			local spiced_buffs = {SPICE_CHILI = "buff_attack", SPICE_GARLIC = "buff_playerabsorption", SPICE_SUGAR = "buff_workeffectiveness"}
			local function OnEatBouillabaisse(inst, eater)
				if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
				return
			elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
				eater.tropicalbuff_duration = COFFEE_DURATION
				eater.components.debuffable:AddDebuff("kyno_coffeebuff", "kyno_coffeebuff")
			local spiced_buff = spiced_buffs[inst.components.edible.spice]
				if spiced_buff then
					eater.components.debuffable:AddDebuff(spiced_buff, spiced_buff)
				end
				if eater.components.talker then 
					eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF"))
				end
			else
				eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", 1.83)
				eater:DoTaskInTime(COFFEE_DURATION, function()
					eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
				end)
			end
		end
	
		if inst.components.edible then
				inst.components.edible:SetOnEatenFn(OnEatBouillabaisse)
			end
		end)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Make Whenever Someone Eats the Shark Fin Soup a Krampus Spawns.
local sharkfinsoup_debuff = {
	"sharkfinsoup",
	"sharkfinsoup_spice_garlic",
	"sharkfinsoup_spice_sugar",
	"sharkfinsoup_spice_chili",
	"sharkfinsoup_spice_salt",
}

for k,v in pairs(sharkfinsoup_debuff) do
	AddPrefabPostInit(v, function(inst)
		local function OnEatSharkSoup(inst, eater)
			SpawnPrefab("krampuswarning_lvl3").Transform:SetPosition(inst.Transform:GetWorldPosition())
			local krampus = SpawnPrefab("krampus")
			local pt = _G.Vector3(inst.Transform:GetWorldPosition()) + _G.Vector3(15,0,15)

			krampus.Transform:SetPosition(pt:Get())
			local angle = eater.Transform:GetRotation()*(3.14159/180)
			local sp = (math.random()+1) * -1
			krampus.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, -sp*math.sin(angle))
		end
		
		if inst.components.edible then
			inst.components.edible:SetOnEatenFn(OnEatSharkSoup)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- For using Salt on Crock Pot foods.
AddComponentPostInit("edible", function(self, inst)
    if not inst.components.saltable and inst:HasTag("preparedfood") then
        inst:AddComponent("saltable")
    end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Sea Cucumber doesn't have a proper "cooked" animation, so I'll just make it non cookable.
AddPrefabPostInit("kyno_cucumber", function(inst)
	inst:RemoveTag("cookable")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
		
	if inst.components.cookable ~= nil then
		inst:RemoveComponent("cookable")
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Parsnip will not be entirely consumed when the player eats it. Instead it will become a eaten version!
local function OnEatenParznip(inst, eater)
	local parsnipeaten = SpawnPrefab("kyno_parznip_eaten")
	if eater.components.inventory and eater:HasTag("player") and not eater.components.health:IsDead() 
	and not eater:HasTag("playerghost") then eater.components.inventory:GiveItem(parsnipeaten) end
end

AddPrefabPostInit("kyno_parznip", function(inst)
	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(OnEatenParznip)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Strings and lazy fix for the Winter's Feast foods.
local FS = 1.4
AddPrefabPostInit("festive_berrysauce", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "BERRYSAUCE"
	end
end)

AddPrefabPostInit("festive_bibingka", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "BIBINGKA"
	end
end)

AddPrefabPostInit("festive_cabbagerolls", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "CABBAGEROLLS"
	end
end)

AddPrefabPostInit("festive_fishdish", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "FESTIVEFISH"
	end
end)

AddPrefabPostInit("festive_goodgravy", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "GRAVY"
	end
end)

AddPrefabPostInit("festive_latkes", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "LATKES"
	end
end)

AddPrefabPostInit("festive_lutefisk", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "LUTEFISK"
	end
end)

AddPrefabPostInit("festive_mulledpunch", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "MULLEDDRINK"
	end
end)

AddPrefabPostInit("festive_panettone", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "PANETTONE"
	end
end)

AddPrefabPostInit("festive_pavlova", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "PAVLOVA"
	end
end)

AddPrefabPostInit("festive_pickledherring", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "PICKLEDHERRING"
	end
end)

AddPrefabPostInit("festive_polishcookies", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "POLISHCOOKIE"
	end
end)

AddPrefabPostInit("festive_pumpkinpie", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "PUMPKINPIE"
	end
end)

AddPrefabPostInit("festive_roastedturkey", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "ROASTTURKEY"
	end
end)

AddPrefabPostInit("festive_stuffing", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "STUFFING"
	end
end)

AddPrefabPostInit("festive_sweetpotato", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "SWEETPOTATO"
	end
end)

AddPrefabPostInit("festive_tamales", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TAMALES"
	end
end)

AddPrefabPostInit("festive_tourtiere", function(inst)
	inst.AnimState:SetScale(FS, FS, FS)

	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TOURTIERE"
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Strident Trident Tweak for new ocean plants.
AddPrefabPostInit("trident", function(inst)	
	local INITIAL_LAUNCH_HEIGHT = 0.1
	local SPEED = 8
	local function launch_away(inst, position)
		local ix, iy, iz = inst.Transform:GetWorldPosition()
		inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)

		local px, py, pz = position:Get()
		local angle = (180 - inst:GetAngleToPoint(px, py, pz)) * DEGREES
		local sina, cosa = math.sin(angle), math.cos(angle)
		inst.Physics:SetVel(SPEED * cosa, 4 + SPEED, SPEED * sina)
	end

	local function DoWaterExplosionEffectNew(inst, affected_entity, owner, position)
		if affected_entity.components.health then
			local ae_combat = affected_entity.components.combat
			if ae_combat then
				ae_combat:GetAttacked(owner, TUNING.TRIDENT.SPELL.DAMAGE, inst)
			else
				affected_entity.components.health:DoDelta(-TUNING.TRIDENT.SPELL.DAMAGE, nil, inst.prefab, nil, owner)
			end
		elseif affected_entity.components.oceanfishable ~= nil then
			if affected_entity.components.weighable ~= nil then
				affected_entity.components.weighable:SetPlayerAsOwner(owner)
			end

			local projectile = affected_entity.components.oceanfishable:MakeProjectile()

			local ae_cp = projectile.components.complexprojectile
			if ae_cp then
				ae_cp:SetHorizontalSpeed(16)
				ae_cp:SetGravity(-30)
				ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
				ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))

				local v_position = affected_entity:GetPosition()
				local launch_position = v_position + (v_position - position):Normalize() * SPEED
				ae_cp:Launch(launch_position, projectile)
			else
				launch_away(projectile, position)
			end
		elseif affected_entity.prefab == "bullkelp_plant" or affected_entity.prefab == "kyno_lotus_ocean" or 
		affected_entity.prefab == "kyno_seaweeds_ocean" or affected_entity.prefab == "kyno_taroroot_ocean" or 
		affected_entity.prefab == "kyno_waterycress_ocean" then
			local ae_x, ae_y, ae_z = affected_entity.Transform:GetWorldPosition()

			if affected_entity.components.pickable and affected_entity.components.pickable:CanBePicked() then
				local product = affected_entity.components.pickable.product
				local loot = SpawnPrefab(product)
				if loot ~= nil then
					loot.Transform:SetPosition(ae_x, ae_y, ae_z)
					if loot.components.inventoryitem ~= nil then
						loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
					end
					if loot.components.stackable ~= nil
							and affected_entity.components.pickable.numtoharvest > 1 then
						loot.components.stackable:SetStackSize(affected_entity.components.pickable.numtoharvest)
					end
					launch_away(loot, position)
				end
			end
		
			if affected_entity.prefab == "bullkelp_plant" then
				local uprooted_kelp_plant = SpawnPrefab("bullkelp_root")
				if uprooted_kelp_plant ~= nil then
					uprooted_kelp_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_kelp_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
				end
			end
			if affected_entity.prefab == "kyno_lotus_ocean" then
				local uprooted_lotus_plant = SpawnPrefab("kyno_lotus_flower")
				if uprooted_lotus_plant ~= nil then
					uprooted_lotus_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_lotus_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
				end
			end
			if affected_entity.prefab == "kyno_seaweeds_ocean" then
				local uprooted_seaweeds_plant = SpawnPrefab("kyno_seaweeds_root")
				if uprooted_seaweeds_plant ~= nil then
					uprooted_seaweeds_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_seaweeds_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
				end
			end
			if affected_entity.prefab == "kyno_taroroot_ocean" then
				local uprooted_taroroot_plant = SpawnPrefab("kyno_taroroot")
				if uprooted_taroroot_plant ~= nil then
					uprooted_taroroot_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_taroroot_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
				end
			end
			if affected_entity.prefab == "kyno_waterycress_ocean" then
				local uprooted_waterycress_plant = SpawnPrefab("kyno_waterycress")
				if uprooted_waterycress_plant ~= nil then
					uprooted_waterycress_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
					launch_away(uprooted_waterycress_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
				end
			end
			
			affected_entity:Remove()
		elseif affected_entity.components.inventoryitem ~= nil then
			launch_away(affected_entity, position)
			affected_entity.components.inventoryitem:SetLanded(false, true)
		elseif affected_entity.waveactive then
			affected_entity:DoSplash()
		elseif affected_entity.components.workable ~= nil and affected_entity.components.workable:GetWorkAction() == ACTIONS.MINE then
			affected_entity.components.workable:WorkedBy(owner, TUNING.TRIDENT.SPELL.MINES)
		end
	end
	
	if not _G.TheWorld.ismastersim then
		return
    end
	
	inst.DoWaterExplosionEffect = DoWaterExplosionEffectNew
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Make some vanilla foods compatible with the mod ingredients.
local VanillaFood = require("preparedfoods")
VanillaFood.bananapop.test = function(cooker, names, tags) 
	return (names.cave_banana or names.cave_banana_cooked or names.kyno_banana or names.kyno_banana_cooked) 
	and tags.frozen and names.twigs and not tags.meat and not tags.fish and (tags.inedible and tags.inedible <= 2) 
end

VanillaFood.frozenbananadaiquiri.test = function(cooker, names, tags)
	return (names.cave_banana or names.cave_banana_cooked or names.kyno_banana or names.kyno_banana_cooked)
	and (tags.frozen and tags.frozen >= 1)
end

VanillaFood.bananajuice.test = function(cooker, names, tags)
	return ((names.cave_banana or names.kyno_banana or 0) + (names.cave_banana_cooked or names.kyno_banana_cooked or 0) >= 2)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Splumonkeys and Splumonkey Pods drops Bananas.
AddPrefabPostInit("monkey", function(inst)
	_G.SetSharedLootTable('monkey',
	{
		{'smallmeat',     1.0},
		{'cave_banana',   1.0},
		{'beardhair',     1.0},
		{'nightmarefuel', 0.5},
		-- 50% when in Nightmare.
		{'kyno_banana',   0.5},
	})

	local MONKEYLOOT = {"smallmeat", "cave_banana"}
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:SetLoot(MONKEYLOOT)
	inst.components.lootdropper:AddChanceLoot("kyno_banana", 0.20) 
end)
	
AddPrefabPostInit("monkeybarrel", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_banana", 1.00) 
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Make Whenever Someone Eats the Eyeball Soup a Deerclops Spawns.
local eyeballsoup_debuff = {
	"eyeballsoup",
	"eyeballsoup_spice_garlic",
	"eyeballsoup_spice_sugar",
	"eyeballsoup_spice_chili",
	"eyeballsoup_spice_salt",
}

for k,v in pairs(eyeballsoup_debuff) do
	AddPrefabPostInit(v, function(inst)
		local function OnEatEyeballSoup(inst, eater)
			if not inst:IsOnValidGround() then
				local splash = SpawnPrefab("splash_ocean")
				local pt = _G.Vector3(inst.Transform:GetWorldPosition()) + _G.Vector3(20,0,20)
				splash.Transform:SetPosition(pt:Get())
			else
				SpawnPrefab("deerclopswarning_lvl4").Transform:SetPosition(inst.Transform:GetWorldPosition())
				local deer = SpawnPrefab("deerclops")
				local pt = _G.Vector3(inst.Transform:GetWorldPosition()) + _G.Vector3(20,0,20)

				deer.Transform:SetPosition(pt:Get())
				local angle = eater.Transform:GetRotation()*(3.14159/180)
				local sp = (math.random()+1) * -1
				deer.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, -sp*math.sin(angle))
			end
		end
		
		if inst.components.edible then
			inst.components.edible:SetOnEatenFn(OnEatEyeballSoup)
		end
	end)
end

-- Just to make sure Deerclops drown if it spawns on water.
AddPrefabPostInit("deerclops", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("drownable")
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Nuts drops from Twiggy Trees.
AddPrefabPostInit("twiggytree", function(inst)
	if inst.components.workable ~= nil then
		local onfinish_old_t = inst.components.workable.onfinish
		inst.components.workable:SetOnFinishCallback(function(inst, chopper)
			if inst.components.lootdropper ~= nil then
				inst.components.lootdropper:AddChanceLoot("kyno_twiggynuts", 0.50)
			end
			if onfinish_old_t ~= nil then
				onfinish_old_t(inst, chopper)
			end
		end)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Foods that will have their action "Eat" replaced to "Drink".
local drinkable_foods = {
	"winter_food8",
	"goatmilk",
	"kyno_syrup",
	"coffee",
	"icedtea",
	"bubbletea",
	"tea",
	"figjuice",
	"coconutwater",
	"milk_box",
	"watercup",
}

for k,v in pairs(drinkable_foods) do
	AddPrefabPostInit(v, function(inst)
		inst:AddTag("drinkable_food")
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Crows transforms into Pigeons when landing on Pink Park Turf.
AddPrefabPostInit("crow", function(inst)
	inst:DoTaskInTime(1/30, function(inst)
	local TileAtPosition = _G.TheWorld.Map:GetTileAtPoint(inst:GetPosition():Get())
		if TileAtPosition == WORLD_TILES.PINKPARK or TileAtPosition == WORLD_TILES.STONECITY then
			
			inst.AnimState:SetBuild("quagmire_pigeon_build")
			
			inst:SetPrefabName("quagmire_pigeon")
			inst.nameoverride = "quagmire_pigeon"
			inst.trappedbuild = "quagmire_pigeon_build"
	
			if not _G.TheWorld.ismastersim then
				return inst
			end
			
			inst.components.inventoryitem.onpickupfn = function(inst, doer)
				inst:Remove()
				local bird = SpawnPrefab("quagmire_pigeon")
				doer.components.inventory:GiveItem(bird)
				return true
			end
		end
	end)
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Speed boost for the White Stone Road.
AddComponentPostInit("locomotor", function(inst)
	local oldspeed = inst.UpdateGroundSpeedMultiplier
	inst.UpdateGroundSpeedMultiplier = function(self)
		oldspeed(self)
		if self.wasoncreep == false and self:FasterOnRoad() and 
			_G.TheWorld.Map:GetTileAtPoint(self.inst.Transform:GetWorldPosition()) == WORLD_TILES.STONECITY then
			self.groundspeedmultiplier = self.fastmultiplier
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Animals that can be killed with the Slaughter Tools.
local slaughterable_animals = {
	"koalefant_winter",
	"koalefant_summer",
	"beefalo",
	"spat",
	"lightninggoat",
}

for k,v in pairs(slaughterable_animals) do
	AddPrefabPostInit(v, function(inst)
		inst:RemoveTag("slaughterable")
		
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		inst:AddTag("slaughterable")
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Colour Cubes and Music for the Serenitea Archipelago.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=2625422345
--[[
local SERENITY_CC = GetModConfigData("serenity_cc")
if SERENITY_CC == 1 then
	local function MakeSerenityArea(inst)
		_G.TheWorld:PushEvent("overridecolourcube", resolvefilepath("images/colourcubesimages/quagmire_cc.tex"))
	end

	local function RemoveSerenityArea(inst)
		_G.TheWorld:PushEvent("overridecolourcube", nil)
	end

	AddPrefabPostInit("world", function(inst)
		inst:DoTaskInTime(0, function(inst)
			if _G.TheWorld.topology then
				for i, node in ipairs(_G.TheWorld.topology.nodes) do
					if table.contains(node.tags, "serenityarea") then
						if node.area_emitter == nil then
							if node.area == nil then
								node.area = 1
							end
						end
					end
				end	
			end
		end)
	end)

	AddComponentPostInit("playervision", function(self)
		self.inst:DoTaskInTime(0, function()
			self.canchange = true
			self.inst:ListenForEvent("changearea", function(inst, area)
				if self.canchange then
					if area and area.tags and table.contains(area.tags, "serenityarea") then
						MakeSerenityArea(self.inst)
					else
						RemoveSerenityArea(self.inst)
					end
				end
			end)

			self.inst:DoTaskInTime(0, function()
				local node, node_index = _G.TheWorld.Map:FindVisualNodeAtPoint(self.inst.Transform:GetWorldPosition())
				if node_index then
					self.inst:PushEvent("changearea", node and {
						id = _G.TheWorld.topology.ids[node_index],
						type = node.type,
						center = node.cent,
						poly = node.poly,
						tags = node.tags,
					}
					or nil)
				end
			end)
		end)
	end)
end
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Retrofitting Stuff for old worlds.
require("hof_settings")
local SERENITYISLAND = GetModConfigData("HOF_SERENITYISLAND")

local function RetrofitSerenityIsland()
	local node_indices = {}
	for k, v in ipairs(_G.TheWorld.topology.ids) do
		if string.find(v, "Serenity Archipelago") then
			table.insert(node_indices, k)
		end
	end
	if #node_indices == 0 then
		return false
	end
	
	local tags = {"serenityarea"}
	for k, v in ipairs(node_indices) do
		if _G.TheWorld.topology.nodes[v].tags == nil then
			_G.TheWorld.topology.nodes[v].tags = {}
		end
		for i, tag in ipairs(tags) do
			if not table.contains(_G.TheWorld.topology.nodes[v].tags, tag) then
				table.insert(_G.TheWorld.topology.nodes[v].tags, tag)
			end
		end
	end
	for i, node in ipairs(_G.TheWorld.topology.nodes) do
		if table.contains(node.tags, "serenityarea") then
			_G.TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
		end
	end
	
	return true
end

AddComponentPostInit("retrofitforestmap_anr", function(self)
	oldonpostinit = self.OnPostInit
	
	function self:OnPostInit(...)
		if SERENITYISLAND == 1 then
			local success = RetrofitSerenityIsland()
			if success then
				_G.ChangeFoodConfigs("HOF_SERENITYISLAND", 0)
				self.requiresreset = true
			end
		end
		
		return oldonpostinit(self, ...)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- For Installing the new Cookware on the Fire Pits.
AddPrefabPostInit("firepit", function(inst)
	local function GetFirepit(inst)
		if not inst.firepit or not inst.firepit:IsValid() or not inst.firepit.components.fueled then
			local x,y,z = inst.Transform:GetWorldPosition()
			local ents = _G.TheSim:FindEntities(x,y,z, 0.01)
			inst.firepit = nil
			for k,v in pairs(ents) do
				if v.prefab == 'firepit' then
					inst.firepit = v
					break
				end
			end
		end
		return inst.firepit
	end

	local function ChangeGrillFireFX(inst)
	local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("firepit_has_grill")
			firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
		end
	end
	
	local function ChangeOvenFireFX(inst)
	local firepit = GetFirepit(inst)
		if firepit then
			firepit:AddTag("firepit_has_oven")
			firepit.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
		end
	end

	local function TestItem(inst, item, giver)
		-- Hanger / Cookingpot / Large Cookingpot / Syrup Pot / Grill / Large Grill.
		if item.components.inventoryitem and item:HasTag("firepit_installer") then
			return true -- Install the contents.
		else
			giver.components.talker:Say(GetString(giver, "ANNOUNCE_FIREPITINSTALL_FAIL"))
		end
	end

	local function OnGetItemFromPlayer(inst, giver, item)
		-- Hanger / Cookingpot / Large Cookingpot / Syrup Pot.
		if item.components.inventoryitem ~= nil and item:HasTag("pot_hanger_installer") then
			SpawnPrefab("kyno_cookware_hanger").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/pot_hanger")
			inst.components.trader.enabled = false -- Don't accept new items!
		end
		-- Grill / Large Grill.
		if item.components.inventoryitem ~= nil and item:HasTag("grill_big_installer") then
			SpawnPrefab("kyno_cookware_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_big")
			inst.components.trader.enabled = false
			ChangeGrillFireFX(inst)
		end
		if item.components.inventoryitem ~= nil and item:HasTag("grill_small_installer") then
			SpawnPrefab("kyno_cookware_small_grill").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/grill_small")
			inst.components.trader.enabled = false
			ChangeGrillFireFX(inst)
		end
		-- Oven / Small Casserole Dish / Large Casserole Dish.
		if item.components.inventoryitem ~= nil and item:HasTag("oven_installer") then
			SpawnPrefab("kyno_cookware_oven").Transform:SetPosition(inst.Transform:GetWorldPosition())
			inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/craft/oven")
			inst.components.trader.enabled = false
			ChangeOvenFireFX(inst) -- Yeah, the same.
		end
	end
	
	inst:AddTag("serenity_installable")
	
	if not _G.TheWorld.ismastersim then
        return inst
    end
	
	if inst:HasTag("firepit_has_grill") then
		inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
	end
	
	if inst:HasTag("firepit_has_oven") then
		inst.components.burnable:OverrideBurnFXBuild("quagmire_oven_fire")
	end
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Small fix for the natural spawning Mushroom Stump.
local mushstumps = {
	"kyno_mushstump_natural",
	"kyno_mushstump_cave",
}

for k,v in pairs(mushstumps) do
	AddPrefabPostInit(v, function(inst)
		inst:AddTag("mushroom_stump_natural")
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Crab King and its claws Drops Crab Meat instead of Meat.
-- Update this if Klei updates their counterparts!
AddPrefabPostInit("crabking", function(inst)
	_G.SetSharedLootTable("hof_crabking",
	{
		{"chesspiece_crabking_sketch",  1.00},
		{"trident_blueprint",           1.00},
		{"kyno_crabmeat",               1.00},
		{"kyno_crabmeat",               1.00},
		{"kyno_crabmeat",               1.00},
		{"kyno_crabmeat",               1.00},
		{"kyno_crabmeat",               1.00},
		{"kyno_crabmeat",               1.00},
		{"kyno_crabmeat",               1.00},
		{"singingshell_octave5",        1.00},
		{"singingshell_octave5",        1.00},
		{"singingshell_octave5",        1.00},
		{"singingshell_octave5",        1.00},
		{"singingshell_octave5",        0.50},
		{"singingshell_octave5",        0.25},
		{"singingshell_octave4",        1.00},
		{"singingshell_octave4",        1.00},
		{"singingshell_octave4",        1.00},
		{"singingshell_octave4",        0.50},
		{"singingshell_octave4",        0.25},
		{"singingshell_octave3",        1.00},
		{"singingshell_octave3",        1.00},
		{"singingshell_octave3",        0.50},
		{"barnacle",                    1.00},
		{"barnacle",                    1.00},
		{"barnacle",                    1.00},
		{"barnacle",                    0.25},
		{"barnacle",                    0.25},
		{"barnacle",                    0.25},
		{"barnacle",                    0.25},
	})

	if not _G.TheWorld.ismastersim then
		return inst
	end	
	
	inst.components.lootdropper:SetChanceLootTable("hof_crabking")
end)

AddPrefabPostInit("crabking_claw", function(inst)
	_G.SetSharedLootTable("hof_crabking_claw",
	{
		{"kyno_crabmeat",               1.00},
	})

	if not _G.TheWorld.ismastersim then
		return inst
	end	
	
	inst.components.lootdropper:SetChanceLootTable("hof_crabking_claw")
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Small fix for the Watery Crate and Freshwater Fishing Rod.
AddPrefabPostInit("kyno_watery_crate", function(inst)
	inst:AddTag("not_serenity_crate")
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Wortox gets the full stats of Soul Stew.
AddPrefabPostInit("soulstew", function(inst)
	local function OnEatSoulStew(inst, eater)
		if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
			return
		elseif eater:HasTag("soulstealer") then
			-- Needs to be half because the food already give some stats.
			eater.components.health:DoDelta(5)
			eater.components.hunger:DoDelta(31.25)
			eater.components.sanity:DoDelta(-5)
		end
	end

	inst:AddTag("soulstew")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("soul") -- Required for eating.
	if inst.components.edible then
		inst.components.edible:SetOnEatenFn(OnEatSoulStew)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Make Whenever Someone Eats the Fortune Cookie, they say a quote.
local fortunecookie_debuff = {
	"fortunecookie",
	"fortunecookie_spice_garlic",
	"fortunecookie_spice_sugar",
	"fortunecookie_spice_chili",
	"fortunecookie_spice_salt",
}

for k,v in pairs(fortunecookie_debuff) do
	AddPrefabPostInit(v, function(inst)
		local function OnEatFortuneCookie(inst, eater)
			if math.random() < 0.01 then
				if math.random() < 0.50 then
					eater.components.health:DoDelta(999)
					eater.components.hunger:DoDelta(999)
					eater.components.sanity:DoDelta(999)
					if eater.components.talker then 
						eater.components.talker:Say(STRINGS.FORTUNE_COOKIE_BAD[math.random(#STRINGS.FORTUNE_COOKIE_GOOD)])
					end
				else 
					eater.components.health:SetPercent(.2)
					eater.components.hunger:DoDelta(-999)
					eater.components.sanity:DoDelta(-999)
					if eater.components.talker then 
						eater.components.talker:Say(STRINGS.FORTUNE_COOKIE_BAD[math.random(#STRINGS.FORTUNE_COOKIE_BAD)])
					end
				end
			else
				if eater.components.talker then 
					eater.components.talker:Say(STRINGS.FORTUNE_COOKIE_QUOTES[math.random(#STRINGS.FORTUNE_COOKIE_QUOTES)])
				end
			end
		end
		
		if inst.components.edible then
			inst.components.edible:SetOnEatenFn(OnEatFortuneCookie)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cornocupia gives back the Beefalo Horn.
local hornocupia_debuff = {
	"hornocupia",
	"hornocupia_spice_garlic",
	"hornocupia_spice_sugar",
	"hornocupia_spice_chili",
	"hornocupia_spice_salt",
}

for k,v in pairs(hornocupia_debuff) do
	AddPrefabPostInit(v, function(inst)
		local function OnEatenHornocupia(inst, eater)
			local horn = SpawnPrefab("horn")
			if eater.components.inventory and eater:HasTag("player") and not eater.components.health:IsDead() 
			and not eater:HasTag("playerghost") then eater.components.inventory:GiveItem(horn) end
		end

		if inst.components.edible ~= nil then
			inst.components.edible:SetOnEatenFn(OnEatenHornocupia)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Animals that can be milked with the Bucket.
local milkable_animals = {
	"koalefant_winter",
	"koalefant_summer",
	"beefalo",
	"deer",
	"spat",
}
for k,v in pairs(milkable_animals) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("milkable2")
		-- Beefalo.
		if inst.prefab == "beefalo" then
			inst.components.milkable2:SetUp("kyno_milk_beefalo")
		end
		-- Koalefants.
		if inst.prefab == "koalefant_summer" or "koalefant_winter" then
			inst.components.milkable2:SetUp("kyno_milk_koalefant")
		end
		-- No-Eyed Deer.
		if inst.prefab == "deer" then
			inst.components.milkable2:SetUp("kyno_milk_deer")
		end
		-- Ewecus.
		if inst.prefab == "spat" then
			inst.components.milkable2:SetUp("kyno_milk_spat")
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Make every "same" recipe has the same quotes.
local jelly_foods = {
	"jelly_berries",
	"jelly_berries_juicy",
	"jelly_pomegranate",
	"jelly_dragonfruit",
	"jelly_cave_banana",
	"jelly_durian",
	"jelly_watermelon",
	"jelly_fig",
	"jelly_banana",
	"jelly_kokonut",
	"jelly_glowberry",
}	

local mayo_foods = {
	"mayonnaise",
	"mayonnaise_chicken",
	"mayonnaise_tallbird",
	"mayonnaise_nightmare",
}

local pickles_foods = {
	"pickles_carrot",
	"pickles_corn",
	"pickles_eggplant",
	"pickles_pumpkin",
	"pickles_lichen",
	"pickles_cactus",
	"pickles_garlic",
	"pickles_asparagus",
	"pickles_onion",
	"pickles_tomato",
	"pickles_potato",
	"pickles_pepper",
	"pickles_redcap",
	"pickles_greencap",
	"pickles_bluecap",
	"pickles_mooncap",
	"pickles_kelp",
	"pickles_avocado",
	"pickles_whitecap",
	"pickles_aloe",
	"pickles_radish",
	"pickles_sweetpotato",
	"pickles_lotus",
	"pickles_seaweeds",
	"pickles_taroroot",
	"pickles_waterycress",
	"pickles_cucumber",
	"pickles_parznip",
	"pickles_turnip",
	"pickles_fennel",
}	

for k,v in pairs(jelly_foods) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "KYNO_JELLY"
		end	
	end)
end

for k,v in pairs(mayo_foods) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "KYNO_MAYONNAISE"
		end	
	end)
end

for k,v in pairs(pickles_foods) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "KYNO_PICKLES"
		end	
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Beer and Pale Ale gives attack buff at the cost of lower speed.
AddPrefabPostInit("beer", function(inst)
	local function OnEatBeer(inst, eater)
		if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
			return
		elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
			eater.strengthbuff_duration = 480
			eater.components.debuffable:AddDebuff("kyno_strengthbuff", "kyno_strengthbuff")
			if eater.components.talker then 
				eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_POPBUFF"))
			end
		else
			eater:AddTag("groggy")
			eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_strengthbuff", .70)
			eater.components.combat.externaldamagemultipliers:SetModifier(eater, 1.2)
			eater:DoTaskInTime(480, function()
				eater:RemoveTag("groggy")
				eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_strengthbuff")
				eater.components.combat.externaldamagemultipliers:RemoveModifier(inst)
			end)
		end
	end
		
	if inst.components.edible then
		inst.components.edible:SetOnEatenFn(OnEatBeer)
	end
end)

AddPrefabPostInit("paleale", function(inst)
	local function OnEatPaleAle(inst, eater)
		if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
			return
		elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
			eater.strengthbuff_duration = 520
			eater.components.debuffable:AddDebuff("kyno_strengthbuff", "kyno_strengthbuff")
			if eater.components.talker then 
				eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_POPBUFF"))
			end
		else
			eater:AddTag("groggy")
			eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_strengthbuff", .70)
			eater.components.combat.externaldamagemultipliers:SetModifier(eater, 1.5)
			eater:DoTaskInTime(520, function()
				eater:RemoveTag("groggy")
				eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_strengthbuff")
				eater.components.combat.externaldamagemultipliers:RemoveModifier(inst)
			end)
		end
	end
		
	if inst.components.edible then
		inst.components.edible:SetOnEatenFn(OnEatPaleAle)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Mead gives damage reduction buff at the cost of lower speed.
AddPrefabPostInit("mead", function(inst)
	local function OnEatMead(inst, eater)
		if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
			return
		elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
			eater.dmgreductionbuff_duration = 480
			eater.components.debuffable:AddDebuff("kyno_dmgreductionbuff", "kyno_dmgreductionbuff")
			if eater.components.talker then 
				eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_POPBUFF"))
			end
		else
			eater:AddTag("groggy")
			eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_dmgreductionbuff", .70)
			eater.components.health.externalabsorbmodifiers:SetModifier(eater, TUNING.BUFF_PLAYERABSORPTION_MODIFIER)
			eater:DoTaskInTime(480, function()
				eater:RemoveTag("groggy")
				eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_strengthbuff")
				eater.components.health.externalabsorbmodifiers:RemoveModifier(eater)
			end)
		end
	end
		
	if inst.components.edible then
		inst.components.edible:SetOnEatenFn(OnEatMead)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------