-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local ACTIONS 			= _G.ACTIONS
local STRINGS			= _G.STRINGS
local SpawnPrefab		= _G.SpawnPrefab
local UpvalueHacker     = require("hof_upvaluehacker")

require("hof_mainfunctions")

-- Retrofitting Stuff for old worlds.
local function RetrofitIslands()
	local TheWorld = _G.TheWorld

    local node_indices = {}
	
    for k, v in ipairs(_G.TheWorld.topology.ids) do
		if string.find(v, "Serenity Archipelago") then
            table.insert(node_indices, k)
        end
		
        if string.find(v, "Seaside Island") then
            table.insert(node_indices, k)
        end
    end
	
    if #node_indices == 0 then
        return false
    end

    local tags = {"serenityarea", "meadowarea"}
	
    for k, v in ipairs(node_indices) do
        if TheWorld.topology.nodes[v].tags == nil then
            TheWorld.topology.nodes[v].tags = {}
        end
		
        for i, tag in ipairs(tags) do
            if not table.contains(TheWorld.topology.nodes[v].tags, tag) then
                table.insert(TheWorld.topology.nodes[v].tags, tag)
            end
        end
    end
	
    for i, node in ipairs(TheWorld.topology.nodes) do
		if table.contains(node.tags, "serenityarea") then
            TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
        end
	
        if table.contains(node.tags, "meadowarea") then
            TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
        end
    end

    return true
end

local function RetrofitMermhuts()
	local newshop = _G.TheSim:FindFirstEntityWithTag("mermhouse_seaside")
	
	if newshop ~= nil then 
		_G.ReplacePrefab(newshop, "kyno_meadowisland_sammyhouse")
	end
	
	local count = 0
    local max_count = 3

    for k, v in pairs(_G.Ents) do
        if count >= max_count then
            break
        end

        if v.prefab == "kyno_meadowisland_mermhut" then
            _G.ReplacePrefab(v, "kyno_meadowisland_fishermermhut")
            count = count + 1
        end
    end
end

AddComponentPostInit("retrofitforestmap_anr", function(self)
	local oldonpostinit_forest = self.OnPostInit

    function self:OnPostInit(...)
		if GetModConfigData("RETROFIT") == 1 then
			local success = RetrofitIslands()
			
			if success then
				_G.TheWorld.Map:RetrofitNavGrid()
				_G.ChangeFoodConfigs("RETROFIT", 0)
				self.requiresreset = true
			end
			
		elseif GetModConfigData("RETROFIT") == 2 then
			local success = RetrofitMermhuts()
			
			if success then
				_G.ChangeFoodConfigs("RETROFIT", 0)
			end
		end 
		
        return oldonpostinit_forest(self, ...)
    end
end)