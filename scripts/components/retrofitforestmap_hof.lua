return Class(function(self, inst)
	assert(TheWorld.ismastersim, "RetrofitForestMap_Hof should not exist on client")

	self.inst = inst
	self.requiresreset = false
	
	local HOF_MAPUTIL = require("map/hof_maputil")
	
	local function IsOldWorld()
		local no_serenity  = TheSim:FindFirstEntityWithTag("kyno_serenityisland_shop") == nil
		local no_meadow    = TheSim:FindFirstEntityWithTag("kyno_meadowisland_shop") == nil
		local no_oceanfish = TheSim:FindFirstEntityWithTag("kyno_swordfish_spawner") == nil

		local has_old_ids = false
		
		if TheWorld.topology and TheWorld.topology.ids then
			for _, id in ipairs(TheWorld.topology.ids) do
				if string.find(id, "StaticLayoutIsland: MeadowIsland") 
				or string.find(id, "StaticLayoutIsland: SerenityIsland") 
				or string.find(id, "StaticLayoutIsland: OceanSetPieces") then
					has_old_ids = true
					break
				end
			end
		end

		return (no_serenity and no_meadow and no_oceanfish) or has_old_ids
	end

	function self:OnPostInit()
		local isforest = TheWorld.worldprefab == "forest"
    
		if not isforest then 
			return 
		end

		if not IsOldWorld() then
			print("Retrofitting for Heap of Foods Mod - Looks like a New World. Skipping.")
			return
		end

		local dirty_topology = HOF_MAPUTIL.RetrofitOceanLayouts()
		local dirty_prefabs = rawget(_G, "HOF_RETROFIT_APPLIED") == true

		if dirty_prefabs then
			print("(Topologia:", dirty_topology, ", Prefabs:", dirty_prefabs, ")")
			TheWorld.Map:RetrofitNavGrid()
			self.requiresreset = true
		else
			print("[HOF Retrofit] Nenhuma alteração necessária. Sem reset.")
		end

		if self.requiresreset and
		not (TheWorld.components.retrofitforestmap_anr and TheWorld.components.retrofitforestmap_anr.requiresreset) and
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
