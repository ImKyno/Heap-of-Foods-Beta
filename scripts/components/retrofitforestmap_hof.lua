return Class(function(self, inst)
	assert(TheWorld.ismastersim, "RetrofitForestMap_Hof should not exist on client")

	self.inst = inst
	self.requiresreset = false
	
	local HOF_MAPUTIL = require("map/hof_maputil")
	
	local function IsOldWorld()
		local no_serenity   = TheSim:FindFirstEntityWithTag("serenity_pigelder")       == nil -- kyno_serenityisland_shop
		local no_meadow     = TheSim:FindFirstEntityWithTag("sammyhouse")              == nil -- kyno_meadowisland_shop
		local no_oceanfish  = TheSim:FindFirstEntityWithTag("swordfishspawner")        == nil -- kyno_swordfish_spawner
		local no_jellyfish  = TheSim:FindFirstEntityWithTag("jellyfishspawner")        == nil -- kyno_jellyfish_spawner
		local no_jellyfish2 = TheSim:FindFirstEntityWithTag("jellyfishrainbowspawner") == nil -- kyno_jellyfish_rainbow_spawner
		local no_dogfish    = TheSim:FindFirstEntityWithTag("dogfishspawner")          == nil -- kyno_dogfish_spawner
		local no_puffer     = TheSim:FindFirstEntityWithTag("puffermonsterspawner")    == nil -- kyno_puffermonster_spawner
		local no_antchovy   = TheSim:FindFirstEntityWithTag("antchovyspawner")         == nil -- kyno_antchovy_spawner
		local no_octopus    = TheSim:FindFirstEntityWithTag("octopuskingtrader")       == nil -- kyno_octopusking_ocean

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

		return (no_serenity and no_meadow and no_oceanfish and no_jellyfish and no_jellyfish2
		and no_dogfish and no_puffer and no_antchovy and no_octopus) or has_old_ids
	end

	function self:OnPostInit()
		local isforest = TheWorld.worldprefab == "forest"
    
		if not isforest then 
			return 
		end

		if not IsOldWorld() then
			if TUNING.HOF_DEBUG_MODE then
				print("Retrofitting for Heap of Foods Mod - Looks like a New World. Skipping.")
			end

			return
		end

		local dirty_topology = HOF_MAPUTIL.RetrofitOceanLayouts()
		local dirty_prefabs = rawget(_G, "HOF_RETROFIT_APPLIED") == true

		if dirty_prefabs then
			if TUNING.HOF_DEBUG_MODE then
				print("Retrofitting for Heap of Foods Mod - World needs to Restart! (World Topology:", dirty_topology, ", Prefabs:", dirty_prefabs, ")")
			end

			TheWorld.Map:RetrofitNavGrid()
			self.requiresreset = true
		else
			if TUNING.HOF_DEBUG_MODE then
				print("Retrofitting for Heap of Foods Mod - World does not need to Restart.")
			end
		end

		if self.requiresreset and
		not (TheWorld.components.retrofitforestmap_anr and TheWorld.components.retrofitforestmap_anr.requiresreset) and
		not (TheWorld.components.retrofitcavemap_anr and TheWorld.components.retrofitcavemap_anr.requiresreset) then

			if TUNING.HOF_DEBUG_MODE then
				print("Retrofitting for Heap of Foods Mod - World Retrofitting requires the server to save and restart to fully take effect.")
				print("Restarting server in 30 seconds...")
			end

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
