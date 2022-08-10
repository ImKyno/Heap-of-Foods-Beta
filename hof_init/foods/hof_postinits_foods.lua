-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab

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
	
	local function CoffeePostinit(inst)
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
				eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
				eater:DoTaskInTime(COFFEE_DURATION, function()
					eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
				end)
			end
		end

		inst:AddTag("honeyed")
		
		if not _G.TheWorld.ismastersim then
			return inst
		end

		if inst.components.edible ~= nil then
			inst.components.edible:SetOnEatenFn(OnEatCoffee)
		end
	end 

    for k,v in pairs(coffee_speedbuff) do
        AddPrefabPostInit(v, CoffeePostinit)
    end
	
	local function CoffeeBeansPostinit(inst)
		local function OnEatBeans(inst, eater)
            if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
                return
            elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
                eater.coffeebuff_duration = TUNING.KYNO_COFFEEBUFF_DURATION_SMALL
                eater.components.debuffable:AddDebuff("kyno_coffeebuff", "kyno_coffeebuff")
            else
                eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
                eater:DoTaskInTime(TUNING.KYNO_COFFEEBUFF_DURATION_SMALL, function()
                    eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
                end)
            end
        end
		
		if not _G.TheWorld.ismastersim then
			return inst
		end

        if inst.components.edible ~= nil then
            inst.components.edible:SetOnEatenFn(OnEatBeans)
        end
	end

    AddPrefabPostInit("kyno_coffeebeans_cooked", CoffeeBeansPostinit)
end

-- Foliage can be cooked into Cooked Foliage.
AddPrefabPostInit("foliage", function(inst)
    inst:AddTag("cookable")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("cookable")
    inst.components.cookable.product = "kyno_foliage_cooked"
end)

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

-- Lazy Fix for Glermz's special dish.
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
	
	local function BouillabaissePostinit(inst)
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
			eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
			eater:DoTaskInTime(COFFEE_DURATION, function()
				eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
				end)
			end
        end
		
		if not _G.TheWorld.ismastersim then
			return inst
		end

        if inst.components.edible ~= nil then
			inst.components.edible:SetOnEatenFn(OnEatBouillabaisse)
		end
	end

    for k,v in pairs(bouillabaisse_speedbuff) do
        AddPrefabPostInit(v, BouillabaissePostinit)
    end
end

-- Make Whenever Someone Eats the Shark Fin Soup a Krampus Spawns.
local sharkfinsoup_debuff = {
    "sharkfinsoup",
    "sharkfinsoup_spice_garlic",
    "sharkfinsoup_spice_sugar",
    "sharkfinsoup_spice_chili",
    "sharkfinsoup_spice_salt",
}

local function SharkFinSoupPostinit(inst)
	local function OnEatSharkSoup(inst, eater)
		SpawnPrefab("krampuswarning_lvl3").Transform:SetPosition(inst.Transform:GetWorldPosition())
		local krampus = SpawnPrefab("krampus")
		local pt = _G.Vector3(inst.Transform:GetWorldPosition()) + _G.Vector3(15,0,15)

		krampus.Transform:SetPosition(pt:Get())
		local angle = eater.Transform:GetRotation()*(3.14159/180)
		local sp = (math.random()+1) * -1
		krampus.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, -sp*math.sin(angle))
	end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(OnEatSharkSoup)
	end
end

for k,v in pairs(sharkfinsoup_debuff) do
    AddPrefabPostInit(v, SharkFinSoupPostinit)
end

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

-- Parsnip will not be entirely consumed when the player eats it. Instead it will become a eaten version!
local function ParznipPostinit(inst)
	local function OnEatenParznip(inst, eater)
		local parsnipeaten = SpawnPrefab("kyno_parznip_eaten")
		if eater.components.inventory and eater:HasTag("player") and not eater.components.health:IsDead()
			and not eater:HasTag("playerghost") then eater.components.inventory:GiveItem(parsnipeaten) 
		end
	end
	
	if inst.components.edible ~= nil then
        inst.components.edible:SetOnEatenFn(OnEatenParznip)
	end
end

AddPrefabPostInit("kyno_parznip", ParznipPostinit)

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

VanillaFood.butterflymuffin.test = function(cooker, names, tags)
	return (names.butterflywings or names.moonbutterflywings or names.kyno_sugarflywings) and not tags.meat and tags.veggie and tags.veggie >= 0.5
end 

-- Make Whenever Someone Eats the Eyeball Soup a Deerclops Spawns.
local eyeballsoup_debuff = {
    "eyeballsoup",
    "eyeballsoup_spice_garlic",
    "eyeballsoup_spice_sugar",
    "eyeballsoup_spice_chili",
    "eyeballsoup_spice_salt",
}

local function EyeballSoupPostinit(inst)
	local function OnEatEyeballSoup(inst, eater)
		SpawnPrefab("deerclopswarning_lvl4").Transform:SetPosition(inst.Transform:GetWorldPosition())
		_G.TheWorld.components.deerclopsspawner:SummonMonster(eater)
	end
	
	if not _G.TheWorld.ismastersim then
        return inst
    end

	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(OnEatEyeballSoup)
	end
end

for k,v in pairs(eyeballsoup_debuff) do
    AddPrefabPostInit(v, EyeballSoupPostinit)
end

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

-- Wortox gets the full stats of Soul Stew.

local function SoulStewPostinit(inst)
	local function OnEatSoulStew(inst, eater)
        if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
            return
		elseif eater:HasTag("soulstealer") then
            -- Needs to be half because the food already give some stats.
            eater.components.health:DoDelta(TUNING.SOULSTEW_HEALTH)
            eater.components.hunger:DoDelta(TUNING.SOULSTEW_HUNGER)
            eater.components.sanity:DoDelta(TUNING.SOULSTEW_SANITY)
        end
    end

    inst:AddTag("soulstew")

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("soul") -- Required for eating.
    if inst.components.edible ~= nil then
        inst.components.edible:SetOnEatenFn(OnEatSoulStew)
    end
end

AddPrefabPostInit("soulstew", SoulStewPostinit)

-- Make Whenever Someone Eats the Fortune Cookie, they say a quote.
local fortunecookie_debuff = {
    "fortunecookie",
    "fortunecookie_spice_garlic",
    "fortunecookie_spice_sugar",
    "fortunecookie_spice_chili",
    "fortunecookie_spice_salt",
}

local function FortuneCookiePostinit(inst)
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
	
	if not _G.TheWorld.ismastersim then
        return inst
    end

	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(OnEatFortuneCookie)
	end
end

for k,v in pairs(fortunecookie_debuff) do
    AddPrefabPostInit(v, FortuneCookiePostinit)
end

-- Cornocupia gives back the Beefalo Horn.
local hornocupia_debuff = {
    "hornocupia",
    "hornocupia_spice_garlic",
    "hornocupia_spice_sugar",
    "hornocupia_spice_chili",
    "hornocupia_spice_salt",
}

local function HornocupiaPostinit(inst)
	local function OnEatenHornocupia(inst, eater)
		local horn = SpawnPrefab("horn")
		if eater.components.inventory and eater:HasTag("player") and not eater.components.health:IsDead()
			and not eater:HasTag("playerghost") then eater.components.inventory:GiveItem(horn) 
		end
	end
	
	if not _G.TheWorld.ismastersim then
        return inst
    end

	if inst.components.edible ~= nil then
		inst.components.edible:SetOnEatenFn(OnEatenHornocupia)
	end
end

for k,v in pairs(hornocupia_debuff) do
    AddPrefabPostInit(v, HornocupiaPostinit)
end

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

local juice_foods = {
    "juice_carrot",
    "juice_corn",
    "juice_eggplant",
    "juice_pumpkin",
    "juice_lichen",
    "juice_cactus",
    "juice_garlic",
    "juice_asparagus",
    "juice_onion",
    "juice_tomato",
    "juice_potato",
    "juice_pepper",
    "juice_redcap",
    "juice_greencap",
    "juice_bluecap",
    "juice_mooncap",
    "juice_kelp",
    "juice_avocado",
    "juice_whitecap",
    "juice_aloe",
    "juice_radish",
    "juice_sweetpotato",
    "juice_lotus",
    "juice_seaweeds",
    "juice_taroroot",
    "juice_waterycress",
    "juice_cucumber",
    "juice_parznip",
    "juice_turnip",
    "juice_fennel",
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

for k,v in pairs(juice_foods) do
    AddPrefabPostInit(v, function(inst)
		inst.AnimState:SetScale(1.20, 1.20, 1.20)
	
        if not _G.TheWorld.ismastersim then
            return inst
        end

        if inst.components.inspectable ~= nil then
            inst.components.inspectable.nameoverride = "KYNO_JUICE"
        end
    end)
end

-- This will prevent some characters from drinking Alcoholic-like drinks.
local ALCOHOLIC_DRINKS = GetModConfigData("HOF_ALCOHOLICDRINKS")
if ALCOHOLIC_DRINKS == 1 then
	local restricted_characters = {
		"wendy",
		"webber",
		"wurt",
		"walter",
		"wilba", -- What? Yeah, modded characters be like.
	}
	
	for k,v in pairs(restricted_characters) do
		AddPrefabPostInit(v, function(inst)
			inst:AddTag("no_alcoholic_drinker")
		end)
	end
	
	AddComponentPostInit("eater", function(self)
		local oldPrefersToEat = self.PrefersToEat
		function self:PrefersToEat(inst)
			print("Heap of Foods: Changing PrefersToEat Eater component function")
			oldPrefersToEat(self, inst)
			print("Heap of Foods: PrefersToEat changed")
			if inst.prefab == "winter_food4" and self.inst:HasTag("player") then
				return false
			elseif inst:HasTag("alcoholic_drink") and self.inst:HasTag("no_alcoholic_drinker") then
				return false
			elseif self.preferseatingtags ~= nil then
				local preferred = false
				for i, v in ipairs(self.preferseatingtags) do
					if inst:HasTag(v) then
						preferred = true
						break
					end
				end
				if not preferred then
					return false
				end
			end
			return self:TestFood(inst, self.preferseating)
		end
	end)
end

-- Beer and Pale Ale gives attack buff at the cost of lower speed.
local function BeerPostinit(inst)
	local function OnEatBeer(inst, eater)
        if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
            return
        elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
            eater.strengthbuff_duration = TUNING.KYNO_ALCOHOL_DURATION_SMALL
            eater.components.debuffable:AddDebuff("kyno_strengthbuff", "kyno_strengthbuff")
            if eater.components.talker then
                eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_POPBUFF"))
            end
        else
            eater:AddTag("groggy")
            eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_strengthbuff", TUNING.KYNO_ALCOHOL_SPEED)
            eater.components.combat.externaldamagemultipliers:SetModifier(eater, TUNING.KYNO_ALCOHOL_STRENGTH_SMALL)
            eater:DoTaskInTime(TUNING.KYNO_ALCOHOL_DURATION_SMALL, function()
                eater:RemoveTag("groggy")
                eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_strengthbuff")
                eater.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end)
        end
    end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.edible ~=nil then
        inst.components.edible:SetOnEatenFn(OnEatBeer)
    end
end

local function PaleAlePostinit(inst)
	local function OnEatPaleAle(inst, eater)
        if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
            return
        elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
            eater.strengthbuff_duration = TUNING.KYNO_ALCOHOL_DURATION_MEDSMALL
            eater.components.debuffable:AddDebuff("kyno_strengthbuff", "kyno_strengthbuff")
            if eater.components.talker then
                eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_POPBUFF"))
            end
        else
            eater:AddTag("groggy")
            eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_strengthbuff", TUNING.KYNO_ALCOHOL_SPEED)
            eater.components.combat.externaldamagemultipliers:SetModifier(eater, TUNING.KYNO_ALCOHOL_STRENGTH_MEDSMALL)
            eater:DoTaskInTime(TUNING.KYNO_ALCOHOL_DURATION_MEDSMALL, function()
                eater:RemoveTag("groggy")
                eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_strengthbuff")
                eater.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end)
        end
    end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.edible ~= nil then
        inst.components.edible:SetOnEatenFn(OnEatPaleAle)
    end
end

AddPrefabPostInit("beer", BeerPostinit)
AddPrefabPostInit("paleale", PaleAlePostinit)

-- Mead gives damage reduction buff at the cost of lower speed.
local function MeadPostinit(inst)
	local function OnEatMead(inst, eater)
        if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
            return
        elseif eater.components.debuffable and eater.components.debuffable:IsEnabled() then
            eater.dmgreductionbuff_duration = TUNING.KYNO_ALCOHOL_DURATION_SMALL
            eater.components.debuffable:AddDebuff("kyno_dmgreductionbuff", "kyno_dmgreductionbuff")
            if eater.components.talker then
                eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_POPBUFF"))
            end
        else
            eater:AddTag("groggy")
            eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_dmgreductionbuff", .70)
            eater.components.health.externalabsorbmodifiers:SetModifier(eater, TUNING.BUFF_PLAYERABSORPTION_MODIFIER)
            eater:DoTaskInTime(TUNING.KYNO_ALCOHOL_DURATION_SMALL, function()
                eater:RemoveTag("groggy")
                eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_strengthbuff")
                eater.components.health.externalabsorbmodifiers:RemoveModifier(eater)
            end)
        end
    end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

    if inst.components.edible ~= nil then
        inst.components.edible:SetOnEatenFn(OnEatMead)
    end
end

AddPrefabPostInit("mead", MeadPostinit)