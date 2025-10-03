return Class(function(self, inst)
	assert(TheWorld.ismastersim, "RetrofitForestMap_Hof should not exist on client")
	
	self.inst = inst
	
	local function RetrofitIslands()
		local node_indices = {}
	
		for k, v in ipairs(TheWorld.topology.ids) do
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
		local house = TheSim:FindFirstEntityWithTag("sammyhouse")
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

		for k, v in pairs(Ents) do
			if count >= max_count then
				break
			end

			if v.prefab == "kyno_meadowisland_mermhut" then
				ReplacePrefab(v, "kyno_meadowisland_fishermermhut")
				count = count + 1
			end
		end
	end
	
	local function RetrofitSammyShop()
		local newshop = TheSim:FindFirstEntityWithTag("mermhouse_seaside")
		local sammyhouse = TheSim:FindFirstEntityWithTag("sammyhouse") -- Don't let them have more shops.
		local sammywagon = TheSim:FindFirstEntityWithTag("sammywagon")
	
		if newshop ~= nil and not sammyhouse then 
			ReplacePrefab(newshop, "kyno_meadowisland_shop")
			SpawnSammyWagon()
		end
	
		-- In case the world has the shop but not the wagon.
		if not sammywagon and sammyhouse then
			SpawnSammyWagon()
		end
	end
	
	local function RetrofitOceanSetPieces()
		local node_indices = {}
	
		for k, v in ipairs(TheWorld.topology.ids) do
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

	function self:OnPostInit()
		local isforest = TheWorld.worldprefab == "forest"
		local iscave = TheWorld.worldprefab == "cave"
		
		if isforest then
			if TUNING.HOF_RETROFIT == 1 then
				local success = RetrofitIslands()
				
				if success then
					TheWorld.Map:RetrofitNavGrid()
					ChangeFoodConfigs("RETROFIT", 0)
					ChangeFoodConfigs("RETROFIT_FORCE", false)
					self.requiresreset = true
				end
			elseif TUNING.HOF_RETROFIT == 2 then
				local success = RetrofitSammyShop() -- RetrofitMermhuts()
			
				if success then
					ChangeFoodConfigs("RETROFIT", 0)
					ChangeFoodConfigs("RETROFIT_FORCE", false)
				end
			end
		end
		
		if self.requiresreset and not (TheWorld.components.retrofitforestmap_anr and TheWorld.components.retrofitforestmap_anr.requiresreset) and
		not (TheWorld.components.retrofitcavemap_anr and TheWorld.components.retrofitcavemap_anr.requiresreset) then
			print("Retrofitting for Heap of Foods Mod - Worldgen retrofitting requires the server to save and restart to fully take effect.")
			print("Restarting server in 30 seconds...")

			inst:DoTaskInTime(5,  function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 25})) end)
			inst:DoTaskInTime(10, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 20})) end)
			inst:DoTaskInTime(15, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 15})) end)
			inst:DoTaskInTime(20, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 10})) end)
			inst:DoTaskInTime(22, function() TheWorld:PushEvent("ms_save") end)
			inst:DoTaskInTime(25, function() TheNet:Announce(subfmt(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT, {time = 5})) end)
			inst:DoTaskInTime(29, function() TheNet:Announce(STRINGS.UI.HUD.RETROFITTING_ANNOUNCEMENT_NOW) end)
			inst:DoTaskInTime(30, function() TheNet:SendWorldRollbackRequestToServer(0) end)
		end
	end
	
	function self:OnSave()
		return {}
	end
	
	function self:OnLoad(data)

	end
end)