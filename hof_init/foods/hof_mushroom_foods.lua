local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("hof_upvaluehacker")

-- Mushrooms that turn into Mushtrees during Full Moon nights.
local MUSHROOMS = 
{
	red_mushroom =
	{
		transform_prefab = "mushtree_medium",
		chance = 0.30,
		revert_chance = 1.00,
		delay = 10,
		fx_prefab = "small_puff",
	},
	
	green_mushroom =
	{
		transform_prefab = "mushtree_small",
        chance = 0.20,
		revert_chance = 1.00,
		delay = 10,
		fx_prefab = "small_puff",
	},
	
	blue_mushroom =
	{
		transform_prefab = "mushtree_tall",
		chance = 0.10,
		revert_chance = 1.00,
		delay = 10,
		fx_prefab = "small_puff",
	},
}

for prefab_name, data in pairs(MUSHROOMS) do
	AddPrefabPostInit(prefab_name, function(inst)
		if not _G.TheWorld.ismastersim then
			return
		end

		inst:AddComponent("fullmoontransformer")
		inst.components.fullmoontransformer.transform_prefab = data.transform_prefab
		inst.components.fullmoontransformer.chance = data.chance
		inst.components.fullmoontransformer.delay = data.delay
		inst.components.fullmoontransformer.fx_prefab = data.fx_prefab
	end)
end

local MUSHTREES =
{	
	"mushtree_medium",
	"mushtree_small",
	"mushtree_tall",
}

for k, v in pairs(MUSHTREES) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return
		end

		inst:AddComponent("fullmoontransformer")
	end)
end

-- Toadstool's Sporecaps drops special Mushrooms.
local function MushroomSproutPostInit(inst)
	if not _G.TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	if inst.components.workable ~= nil then
		local _onfinish = inst.components.workable.onfinish

		inst.components.workable:SetOnFinishCallback(function(inst, worker)
			if _onfinish ~= nil then
				_onfinish(inst, worker)
			end

			if worker ~= nil and worker:IsValid() then
				local loot_data = inst._custom_loot or 
				{
					main_loot = nil,
					extra_loot = nil,
					extra_chance = 0,
				}

				if loot_data.main_loot then
					inst.components.lootdropper:SpawnLootPrefab(loot_data.main_loot)
				end

				if loot_data.extra_loot and math.random() < loot_data.extra_chance then
					inst.components.lootdropper:SpawnLootPrefab(loot_data.extra_loot)
				end
			end
		end)
	end
end

local mushroomsprouts = 
{
	{
		name = "mushroomsprout",
		main_loot = "kyno_sporecap",
		extra_loot = "kyno_sporecap",
		extra_chance = 0.25,
	},
	{
		name = "mushroomsprout_dark",
		main_loot = "kyno_sporecap_dark",
		extra_loot = "kyno_sporecap_dark",
		extra_chance = 0.1,
	},
}

for _, v in ipairs(mushroomsprouts) do
	AddPrefabPostInit(v.name, function(inst)
		inst._custom_loot = 
		{
			main_loot = v.main_loot,
			extra_loot = v.extra_loot,
			extra_chance = v.extra_chance,
		}
		
		MushroomSproutPostInit(inst)
	end)
end

-- Make Sporecaps plantable at Mushroom Planter.
local function MushroomFarmPostInit(inst)
	local CUSTOM_MUSHROOMS = 
	{
		kyno_sporecap = 
		{ 
			skill = "wormwood_mushroomplanter_ratebonus2",
			build = "mushroom_farm_kyno_sporecap_build",
		},
		
		kyno_sporecap_dark = 
		{
			skill = "wormwood_mushroomplanter_ratebonus2",
			build = "mushroom_farm_kyno_sporecap_dark_build",
		},
	}

	local function DoCustomSymbol(inst, product)
		if not product then
			return
		end
		
		local custom_mushroom = CUSTOM_MUSHROOMS[product]
	
		if custom_mushroom and custom_mushroom.build then
			inst.AnimState:OverrideSymbol("swap_mushroom", custom_mushroom.build, "swap_mushroom")
		end
	end

	local function StartCustomGrowing(inst, giver, item)
		if not inst.components.harvestable then
			return
		end

		local grower_skilltreeupdater = giver.components.skilltreeupdater
		local planter_is_improved = grower_skilltreeupdater and grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_upgrade")

		local max_produce = planter_is_improved and 6 or 4
		local grow_time_percent = 1.0

		if grower_skilltreeupdater then
			if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus2") then
				grow_time_percent = TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2
			elseif grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus1") then
				grow_time_percent = TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_1
			end
		end

		local grow_time = grow_time_percent * TUNING.MUSHROOMFARM_FULL_GROW_TIME

		DoCustomSymbol(inst, item.prefab)

		inst.components.harvestable:SetProduct(item.prefab, max_produce)
		inst.components.harvestable:SetGrowTime(grow_time / max_produce)
		inst.components.harvestable:Grow()

		_G.TheWorld:PushEvent("itemplanted", { doer = giver, pos = inst:GetPosition() })
	end
	
	local _accepttest
	
	local function CustomAcceptTest(inst, item, giver, ...)
		if item == nil then
			return false 
		end

		local custom_mushroom = CUSTOM_MUSHROOMS[item.prefab]
    
		if custom_mushroom then
			local grower_skilltreeupdater = giver.components.skilltreeupdater
        
			if grower_skilltreeupdater and grower_skilltreeupdater:IsActivated(custom_mushroom.skill) then
				return true
			else
				return false, "MUSHROOMFARM_NOMOONALLOWED"
			end
		end
		
		return _accepttest(inst, item, giver, ...)
	end

	if not _G.TheWorld.ismastersim then
		return
	end

	if inst.components.trader ~= nil then
		_accepttest = inst.components.trader.test
		inst.components.trader.test = CustomAcceptTest
		
		local _onaccept = inst.components.trader.onaccept
    
		inst.components.trader.onaccept = function(inst, giver, item, ...)
			local custom_mushroom = CUSTOM_MUSHROOMS[item.prefab]

			if custom_mushroom then
				local skilltreeupdater = giver.components.skilltreeupdater
            
				if skilltreeupdater and skilltreeupdater:IsActivated(custom_mushroom.skill) then
					StartCustomGrowing(inst, giver, item)
					return
				end
			end

			if _onaccept then
				_onaccept(inst, giver, item, ...)
			end
		end
	end

	if inst.components.harvestable ~= nil then
		local _onharvestfn = inst.components.harvestable.onharvestfn
		
		inst.components.harvestable:SetOnHarvestFn(function(inst, picker, ...)
			if _onharvestfn then
				_onharvestfn(inst, picker, ...)
			end

			if CUSTOM_MUSHROOMS[inst.components.harvestable.product] then
				-- DO SOMETHING COOL?
				--[[
				if math.random() <= TUNING.KYNO_SPORECAP_SPORECLOUD_CHANCE then
					inst.components.lootdropper:SpawnLootPrefab("sporecloud")
				end
				]]--
			end
		end)
	end
	
	local _OnLoad = inst.OnLoad

	inst.OnLoad = function(inst, data)
		if _OnLoad then
			_OnLoad(inst, data)
		end
		
		if data and data.product and CUSTOM_MUSHROOMS[data.product] then
			DoCustomSymbol(inst, data.product)
		end
	end
end

AddPrefabPostInit("mushroom_farm", MushroomFarmPostInit)