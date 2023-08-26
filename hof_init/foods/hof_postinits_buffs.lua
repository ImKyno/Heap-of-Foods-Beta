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
local COFFEE_SPEED    = GetModConfigData("HOF_COFFEESPEED")
local COFFEE_DURATION = GetModConfigData("HOF_COFFEEDURATION")
local GIANT_SPAWNING  = GetModConfigData("HOF_GIANTSPAWNING")

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
			SPICE_CHILI    = "buff_attack", 
			SPICE_GARLIC   = "buff_playerabsorption", 
			SPICE_SUGAR    = "buff_workeffectiveness"
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
				if inst.components.eater ~= nil then
					eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
					eater:DoTaskInTime(COFFEE_DURATION, function(inst, eater)
						eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
					
						if eater.components.talker and eater:HasTag("player") then
							eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF_END"))
						end
					end)
				end
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
			SPICE_CHILI    = "buff_attack", 
			SPICE_GARLIC   = "buff_playerabsorption", 
			SPICE_SUGAR    = "buff_workeffectiveness"
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
				if inst.components.eater ~= nil then
					eater.components.locomotor:SetExternalSpeedMultiplier(eater, "kyno_coffeebuff", TUNING.KYNO_COFFEEBUFF_SPEED)
					eater:DoTaskInTime(COFFEE_DURATION, function(inst, eater)
						eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "kyno_coffeebuff")
					
						if eater.components.talker and eater:HasTag("player") then
							eater.components.talker:Say(_G.GetString(eater, "ANNOUNCE_KYNO_COFFEEBUFF_END"))
						end	
					end)
				end
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

if GIANT_SPAWNING == 1 then
	local eyeballspaghetti_bossbuff = 
	{
        "eyeballspaghetti",
        "eyeballspaghetti_spice_garlic",
        "eyeballspaghetti_spice_sugar",
        "eyeballspaghetti_spice_chili",
        "eyeballspaghetti_spice_salt",
    }
	
	local gummybeargers_bossbuff =
	{
		"gummybeargers",
        "gummybeargers_spice_garlic",
        "gummybeargers_spice_sugar",
        "gummybeargers_spice_chili",
        "gummybeargers_spice_salt",
	}
	
	local function EyeballspaghettiPostinit(inst)
		local spiced_buffs = 
		{
			SPICE_CHILI    = "buff_attack", 
			SPICE_GARLIC   = "buff_playerabsorption", 
			SPICE_SUGAR    = "buff_workeffectiveness"
		}
		
		local function OnEatEyeballspaghetti(inst, eater)
			if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
				return
			elseif eater.components.eater ~= nil then
				local function DeerclopsSpawnPoint(pt)
					if not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
						pt = FindNearbyLand(pt, 1) or pt
					end
				
					local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 40, 12, true)
					if offset ~= nil then
						offset.x = offset.x + pt.x
						offset.z = offset.z + pt.z
						return offset
					end
				end
			
				local spawn_pt = DeerclopsSpawnPoint(eater:GetPosition())
				if spawn_pt ~= nil and not _G.TheSim:FindFirstEntityWithTag("deerclops") then
					_G.SpawnPrefab("deerclopswarning_lvl4").Transform:SetPosition(inst.Transform:GetWorldPosition())
				
					local deerclops = _G.SpawnPrefab("deerclops")
					deerclops.Physics:Teleport(spawn_pt:Get())
				end
				
			local spiced_buff = spiced_buffs[inst.components.edible.spice]
				if spiced_buff then
					eater.components.debuffable:AddDebuff(spiced_buff, spiced_buff)
				end
			else
				if inst.components.eater ~= nil then
					local function DeerclopsSpawnPoint(pt)
						if not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
							pt = FindNearbyLand(pt, 1) or pt
						end
				
						local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 40, 12, true)
						if offset ~= nil then
							offset.x = offset.x + pt.x
							offset.z = offset.z + pt.z
							return offset
						end
					end
			
					local spawn_pt = DeerclopsSpawnPoint(eater:GetPosition())
					if spawn_pt ~= nil and not _G.TheSim:FindFirstEntityWithTag("deerclops") then
						_G.SpawnPrefab("deerclopswarning_lvl4").Transform:SetPosition(inst.Transform:GetWorldPosition())
					
						local deerclops = _G.SpawnPrefab("deerclops")
						deerclops.Physics:Teleport(spawn_pt:Get())
					end
				end
			end
		end
		
		if not _G.TheWorld.ismastersim then
			return inst
		end

        if inst.components.edible ~= nil then
			inst.components.edible:SetOnEatenFn(OnEatEyeballspaghetti)
		end
	end

    for k,v in pairs(eyeballspaghetti_bossbuff) do
        AddPrefabPostInit(v, EyeballspaghettiPostinit)
    end
	
	local function GummyBeargersPostinit(inst)
		local spiced_buffs = 
		{
			SPICE_CHILI    = "buff_attack", 
			SPICE_GARLIC   = "buff_playerabsorption", 
			SPICE_SUGAR    = "buff_workeffectiveness"
		}
		
		local function OnEatGummyBeargers(inst, eater)
			if not eater.components.health or eater.components.health:IsDead() or eater:HasTag("playerghost") then
				return
			elseif eater.components.eater ~= nil then
				local function BeargerSpawnPoint(pt)
					if not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
						pt = FindNearbyLand(pt, 1) or pt
					end
				
					local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 40, 12, true)
					if offset ~= nil then
						offset.x = offset.x + pt.x
						offset.z = offset.z + pt.z
						return offset
					end
				end
			
				local spawn_pt = BeargerSpawnPoint(eater:GetPosition())
				if spawn_pt ~= nil and not _G.TheSim:FindFirstEntityWithTag("bearger") then
					_G.SpawnPrefab("beargerwarning_lvl4").Transform:SetPosition(inst.Transform:GetWorldPosition())
				
					local bearger = _G.SpawnPrefab("bearger")
					bearger.Physics:Teleport(spawn_pt:Get())
				end
				
			local spiced_buff = spiced_buffs[inst.components.edible.spice]
				if spiced_buff then
					eater.components.debuffable:AddDebuff(spiced_buff, spiced_buff)
				end
			else
				if inst.components.eater ~= nil then
					local function BeargerSpawnPoint(pt)
						if not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
							pt = FindNearbyLand(pt, 1) or pt
						end
				
						local offset = FindWalkableOffset(pt, math.random() * 2 * PI, 40, 12, true)
						if offset ~= nil then
							offset.x = offset.x + pt.x
							offset.z = offset.z + pt.z
							return offset
						end
					end
			
					local spawn_pt = BeargerSpawnPoint(eater:GetPosition())
					if spawn_pt ~= nil and not _G.TheSim:FindFirstEntityWithTag("bearger") then
						_G.SpawnPrefab("beargerwarning_lvl4").Transform:SetPosition(inst.Transform:GetWorldPosition())
					
						local bearger = _G.SpawnPrefab("bearger")
						bearger.Physics:Teleport(spawn_pt:Get())
					end
				end
			end
		end
		
		if not _G.TheWorld.ismastersim then
			return inst
		end

        if inst.components.edible ~= nil then
			inst.components.edible:SetOnEatenFn(OnEatGummyBeargers)
		end
	end

    for k,v in pairs(gummybeargers_bossbuff) do
        AddPrefabPostInit(v, GummyBeargersPostinit)
    end
end