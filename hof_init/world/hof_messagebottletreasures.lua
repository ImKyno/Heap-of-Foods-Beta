-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local UpvalueHacker     = require("hof_upvaluehacker")

local messagebottletreasures = require("messagebottletreasures")
local weighted_treasure_contents = UpvalueHacker.GetUpvalue(messagebottletreasures.GetPrefabs, "weighted_treasure_contents")

for treasureprefab, weighted_lists in pairs(weighted_treasure_contents) do
    local lookuptable =
    {
        saltminer = {
                        guaranteed_loot = {},
                        randomly_selected_loot =
                        {
                            { kyno_beancan = .25, kyno_meatcan = .25, kyno_tomatocan = .25 },
                        }
                    },
        traveler =  {
                        guaranteed_loot = { nukashine_sugarfree = {1, 3} },
                        randomly_selected_loot =
                        {
                            { kyno_cokecan = .25, kyno_energycan = .25 },
                            { kyno_brewingrecipecard = 1 },
                        }
                    },
        fisher =    {
                        guaranteed_loot = { kyno_fishpackage = 1 },
                        randomly_selected_loot =
                        {
                            { kyno_cokecan = .25, kyno_tunacan = .50 },
                            { kyno_brewingrecipecard = 1 },
                        }
                    },
        miner =     {
                        guaranteed_loot = {},
                        randomly_selected_loot =
                        {
                            { kyno_sodacan = .25 }, 
							{ kyno_tuncan = .25 }, 
							{ kyno_energycan = .25 },
                        }
                    },
        splunker =  {
                        guaranteed_loot = { kyno_sodacan = 1, kyno_meatcan = 1 },
                        randomly_selected_loot =
                        {
                            { kyno_tomatocan = .25 }, 
							{ kyno_beancan = .25 },
                        }
                    },
					--[[
		hof_cook =  {
						guaranteed_loot = { kyno_cookware_kit_hanger = 1, kyno_cookware_kit_grill = 1, kyno_cookware_kit_small_grill = 1, kyno_cookware_kit_oven = 1, kyno_cookware_kit_syrup = 1 },
						randomly_selected_loot =
						{
							{ charcoal = .33 },
							{ saltrock = .40 },
						}
					},
		hof_tools = {
						guaranteed_loot = { kyno_sapbucket_installer = 1, kyno_crabtrap_installer = 1, kyno_saltrack_installer = 1, kyno_slaughtertool = 1 },
						randomly_selected_loot =
						{
							{ kyno_bucket_empty = .65 },
						}
					},
		hof_food =  {
						guaranteed_loot = { kyno_oil = {2, 6}, kyno_sugar = {2, 8}, kyno_flour = {1, 5}, kyno_beanbugs = {1, 3}, kyno_gummybug = {1, 3} },
						randomly_selected_loot = 
						{
							{ kyno_pineapple = .33, kyno_taroroot = .33, kyno_lotus_flower = .33 }, 
							{ kyno_waterycress = .33, kyno_seaweeds = .33, kyno_limpets = .33 },
						}
					},
		hof_mobs =  {
						guaranteed_loot = { kyno_chicken2 = {1, 3}, kyno_piko = {1, 3}, kyno_piko_orange = {1, 2} },
						randomly_selected_loot =
						{
							{ kyno_sugarfly = .75 },
						}
					},
		hof_misc =  {
						guaranteed_loot = { kyno_kokonut = {1, 3}, kyno_sugartree_bud = {1, 3}, kyno_oaktree_pod = {1, 3}, kyno_sugartree_petals = {4, 6} },
						randomly_selected_loot =
						{
							{ acorn = .20 },
						}
					},
					]]--
    }

    if treasureprefab == "sunkenchest" then
        if weighted_lists ~= nil and type(weighted_lists) == "table" and _G.next(weighted_lists) ~= nil then
            for weighted_list, _--[[weight]] in pairs(weighted_lists) do
                local preset = ""

                -- Identify which preset it is.
                if weighted_list.guaranteed_loot["cookiecuttershell"] then
                    preset = "saltminer"
                elseif weighted_list.guaranteed_loot["cane"] then
                    preset = "traveler"
                elseif weighted_list.guaranteed_loot["malbatross_feather"] then
                    preset = "fisher"
                elseif weighted_list.guaranteed_loot["cutstone"] then
                    preset = "miner"
                elseif weighted_list.guaranteed_loot["thulecite"] then
                    preset = "splunker"
                end

                if preset ~= "" and lookuptable[preset] then
                    local tbl = lookuptable[preset]

                    weighted_list.guaranteed_loot["scrapbook_page"] = nil

                    for prefab,value in pairs(tbl.guaranteed_loot) do
                        weighted_list.guaranteed_loot[prefab] = value
                    end

                    for prefab,randomtable in pairs(tbl.randomly_selected_loot) do
                        table.insert(weighted_list.randomly_selected_loot, 1, randomtable)
                    end
                end
            end
        end
    end
end