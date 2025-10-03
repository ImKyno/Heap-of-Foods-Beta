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
		if string.find(v, "SerenityIsland") then
            table.insert(node_indices, k)
        end
		
        if string.find(v, "MeadowIsland") then
            table.insert(node_indices, k)
        end
    end
	
    if #node_indices == 0 then
        return false
    end

    local tags = {"SerenityArea", "MeadowArea"}
	
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
		if table.contains(node.tags, "SerenityArea") then
            TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
        end
	
        if table.contains(node.tags, "MeadowArea") then
            TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
        end
    end

    return true
end

local function SpawnSammyWagon()
	local house = _G.TheSim:FindFirstEntityWithTag("sammyhouse")
	local mermcart = SpawnPrefab("kyno_meadowisland_mermcart")
	
	local x, y, z = house.Transform:GetWorldPosition()
	
	local theta = -3 -- -3
	local radius = 4 -- 4
	local x = x + radius * math.cos(theta)
	local z = z - radius * math.sin(theta)
	
	mermcart.Transform:SetPosition(x, 0, z)
end

-- Deprecated. Use Wurt to build Fishermerm Huts.
local function RetrofitMermhuts()
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

local function RetrofitSammyShop()
	local newshop = _G.TheSim:FindFirstEntityWithTag("mermhouse_seaside")
	local sammyhouse = _G.TheSim:FindFirstEntityWithTag("sammyhouse") -- Don't let them have more shops.
	local sammywagon = _G.TheSim:FindFirstEntityWithTag("sammywagon")
	
	if newshop ~= nil and not sammyhouse then 
		_G.ReplacePrefab(newshop, "kyno_meadowisland_shop")
		SpawnSammyWagon()
	end
	
	-- In case the world has the shop but not the wagon.
	if not sammywagon and sammyhouse then
		SpawnSammyWagon()
	end
end

local function RetrofitOceanSetPieces()
	local TheWorld = _G.TheWorld

    local node_indices = {}
	
    for k, v in ipairs(_G.TheWorld.topology.ids) do
		if string.find(v, "WreckArea") then
            table.insert(node_indices, k)
        end
		
		if string.find(v, "LowMist") then
            table.insert(node_indices, k)
        end
    end
	
    if #node_indices == 0 then
        return false
    end

    local tags = {"WreckArea", "LowMist"}
	
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
		if table.contains(node.tags, "WreckArea") then
            TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
        end
		
		if table.contains(node.tags, "LowMist") then
            TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
        end
    end

    return true
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
			local success = RetrofitSammyShop() -- RetrofitMermhuts()
			
			if success then
				_G.ChangeFoodConfigs("RETROFIT", 0)
			end
		elseif GetModConfigData("RETROFIT") == 3 then
			local success = RetrofitOceanSetPieces()
			
			if success ~= nil then
				_G.TheWorld.Map:RetrofitNavGrid()
				_G.ChangeFoodConfigs("RETROFIT", 0)
				self.requiresreset = true
			end
		end
		
        return oldonpostinit_forest(self, ...)
    end
end)