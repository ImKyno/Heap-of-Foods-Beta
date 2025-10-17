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
local HOF_COFFEEBUFF_ENABLED = GetModConfigData("COFFEESPEED")
local HOF_GIANTSPAWNING      = GetModConfigData("GIANTSPAWNING")

if HOF_COFFEEBUFF_ENABLED then
    local CoffeeFood = _G.MergeMaps(require("hof_foodrecipes"), require("hof_foodrecipes_warly"), require("hof_brewrecipes_keg"))
	
	CoffeeFood.coffee.oneatenfn = function(inst, eater)
		eater:AddDebuff("kyno_coffeebuff", "kyno_coffeebuff")
	end
	
	CoffeeFood.tropicalbouillabaisse.oneatenfn = function(inst, eater)
		eater:AddDebuff("kyno_coffeebuff", "kyno_coffeebuff")
	end
	
	CoffeeFood.coffee_mocha.oneatenfn = function(inst, eater)
		eater:AddDebuff("kyno_mochabuff", "kyno_mochabuff")
	end
	
	CoffeeFood.tiramisu.oneatenfn = function(inst, eater)
		eater:AddDebuff("kyno_tiramisubuff", "kyno_tiramisubuff")
		eater:AddDebuff("buff_moistureimmunity", "buff_moistureimmunity")
	end
	
	local function CookedCoffeeBeansPostInit(inst)
		local function OnEaten(inst, eater)
			eater:AddDebuff("kyno_coffeebeansbuff", "kyno_coffeebeansbuff")
		end
		
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.edible ~= nil then
			inst.components.edible:SetOnEatenFn(OnEaten)
		end
	end
	
	AddPrefabPostInit("kyno_coffeebeans_cooked", CookedCoffeeBeansPostInit)
	
	local function GoldenApplePostInit(inst)
		local function OnEaten(inst, eater)
			if eater:HasTag("plantkin") then
				if eater.components.health ~= nil and not eater.components.health:IsDead() then
					eater.components.health:DoDelta(100)
				end
			end
		
			eater:AddDebuff("kyno_goldenapplebuff", "kyno_goldenapplebuff")
			eater:AddDebuff("kyno_coffeealtbuff", "kyno_coffeealtbuff")
		end
		
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.edible ~= nil then
			inst.components.edible:SetOnEatenFn(OnEaten)
		end
	end
	
	AddPrefabPostInit("kyno_goldenapple", GoldenApplePostInit)
end

if HOF_GIANTSPAWNING then
	local eyeballspaghetti_bossbuff =
	{
        "eyeballspaghetti",
        "eyeballspaghetti_spice_garlic",
        "eyeballspaghetti_spice_sugar",
        "eyeballspaghetti_spice_chili",
        "eyeballspaghetti_spice_salt",
		
		"eyeballspaghetti_spice_cure",
		"eyeballspaghetti_spice_fed",
		"eyeballspaghetti_spice_cold",
		"eyeballspaghetti_spice_fire",
		"eyeballspaghetti_spice_mind",
    }

	local gummybeargers_bossbuff =
	{
		"gummybeargers",
        "gummybeargers_spice_garlic",
        "gummybeargers_spice_sugar",
        "gummybeargers_spice_chili",
        "gummybeargers_spice_salt",
		
		"gummybeargers_spice_cure",
		"gummybeargers_spice_fed",
		"gummybeargers_spice_cold",
		"gummybeargers_spice_fire",
		"gummybeargers_spice_mind",
	}

	local function EyeballspaghettiPostinit(inst)
		local spiced_buffs =
		{
			SPICE_CHILI    = "buff_attack",
			SPICE_GARLIC   = "buff_playerabsorption",
			SPICE_SUGAR    = "buff_workeffectiveness",
			
			SPICE_CURE     = "kyno_preserverbuff",
			SPICE_COLD     = "kyno_freezebuff",
			SPICE_FIRE     = "kyno_firebuff",
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

    for k, v in pairs(eyeballspaghetti_bossbuff) do
        AddPrefabPostInit(v, EyeballspaghettiPostinit)
    end

	local function GummyBeargersPostinit(inst)
		local spiced_buffs =
		{
			SPICE_CHILI    = "buff_attack",
			SPICE_GARLIC   = "buff_playerabsorption",
			SPICE_SUGAR    = "buff_workeffectiveness",
			
			SPICE_CURE     = "kyno_preserverbuff",
			SPICE_COLD     = "kyno_freezebuff",
			SPICE_FIRE     = "kyno_firebuff",
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

    for k, v in pairs(gummybeargers_bossbuff) do
        AddPrefabPostInit(v, GummyBeargersPostinit)
    end
end