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
                        guaranteed_loot = { kyno_sodacan = 1 },
                        randomly_selected_loot =
                        {
                            { kyno_tomatocan = .50, kyno_beancan = .25, kyno_meatcan = .25 },
                        }
                    },
        traveler =  {
                        guaranteed_loot = {},
                        randomly_selected_loot =
                        {
                            { kyno_cokecan = .5, kyno_energycan = .5 },
                            { kyno_brewingrecipecard = 1 }
                        }
                    },
        fisher =    {
                        guaranteed_loot = { kyno_tunacan = 1 },
                        randomly_selected_loot =
                        {
                            { kyno_cokecan = .5, kyno_energycan = .5 },
                            { kyno_brewingrecipecard = 1 }
                        }
                    },
        miner =     {
                        guaranteed_loot = {},
                        randomly_selected_loot =
                        {
                            { kyno_sodacan = .50, kyno_cokecan = .25, kyno_energycan = .25 },
                        }
                    },
        splunker =  {
                        guaranteed_loot = {},
                        randomly_selected_loot =
                        {
                            { kyno_tomatocan = .50, kyno_beancan = .25, kyno_meatcan = .25 },
                        }
                    },
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