return Class(function(self, inst)
	assert(TheWorld.ismastersim, "RetrofitCaveMap_Hof should not exist on client")

	self.inst = inst
	self.requiresreset = false

	local HOF_MAPUTIL = require("map/hof_maputil")

	local function IsOldWorld()
		local no_cavetubertree = TheSim:FindFirstEntityWithTag("cavetubertree")      == nil -- kyno_cavetubertree
		local no_eldermandrake = TheSim:FindFirstEntityWithTag("eldermandrakehouse") == nil -- kyno_eldermandrakehouse

		return (no_cavetubertree and no_eldermandrake)
	end

	function self:OnPostInit()
		local iscave = TheWorld.worldprefab == "cave"

		if not iscave then
			return
		end

		if not IsOldWorld() then
			if TUNING.HOF_DEBUG_MODE then
				print("Retrofitting for Heap of Foods Mod - Looks like a New World. Skipping.")
			end

			return
		end

		local dirty_prefabs = rawget(_G, "HOF_RETROFIT_APPLIED") == true

		if dirty_prefabs then
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