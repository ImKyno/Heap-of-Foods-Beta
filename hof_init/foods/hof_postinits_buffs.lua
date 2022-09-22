-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab

-- What is this for? I'm very lazy to sort things out and fix them, and this file is a lazy way
-- to do the things. I could write it all again but I won't (right now) Feel free to improve this
-- for me and I'll gladly give you all the credits. I'm dying and can't bother to make it better.

-- Fix For Spiced Coffee. There you go Terra B. :glzSIP:
local COFFEE_SPEED = GetModConfigData("HOF_COFFEESPEED")
local COFFEE_DURATION = GetModConfigData("HOF_COFFEEDURATION")

if COFFEE_SPEED == 1 then
    local coffee_speedbuff = 
	{
        "coffee",
        "coffee_spice_garlic",
        "coffee_spice_sugar",
        "coffee_spice_chili",
        "coffee_spice_salt",
    }
	
	local bouillabaisse_speedbuff = 
	{
        "tropicalbouillabaisse",
        "tropicalbouillabaisse_spice_garlic",
        "tropicalbouillabaisse_spice_sugar",
        "tropicalbouillabaisse_spice_chili",
        "tropicalbouillabaisse_spice_salt",
    }
	
	local function CoffeePostinit(inst)
		local spiced_buffs = 
		{
			SPICE_CHILI = "buff_attack", 
			SPICE_GARLIC = "buff_playerabsorption", 
			SPICE_SUGAR = "buff_workeffectiveness"
		}
		
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
				
				if eater.components.talker and eater:HasTag("player") then
					eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF_START"))
				end
			else
				eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
				eater:DoTaskInTime(COFFEE_DURATION, function(inst, eater)
					eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
					
					if eater.components.talker and eater:HasTag("player") then
						eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF_END"))
					end
				end)
			end
		end
		
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
	
	local function BouillabaissePostinit(inst)
		local spiced_buffs = 
		{
			SPICE_CHILI = "buff_attack", 
			SPICE_GARLIC = "buff_playerabsorption", 
			SPICE_SUGAR = "buff_workeffectiveness"
		}
		
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
				
				if eater.components.talker and eater:HasTag("player") then
					eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF_START"))
				end
			else
				eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
				eater:DoTaskInTime(COFFEE_DURATION, function(inst, eater)
					eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
					
					if eater.components.talker and eater:HasTag("player") then
						eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF_END"))
					end	
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