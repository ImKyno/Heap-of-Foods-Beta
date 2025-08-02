return Class(function(self, inst)

	assert(TheWorld.ismastersim, "SugarflySpawner should not exist on client")

	self.inst = inst

	local _activeplayers = {}
	local _scheduledtasks = {}
	local _worldstate = TheWorld.state
	local _updating = false
	local _sugarflies = {}
	local _maxsugarflies = TUNING.MAX_KYNO_SUGARFLIES

	local FLOWER_TAGS = { "sugarflower" }
	local SUGARFLY_TAGS = { "sugarfly" }

	local function GetSpawnPoint(player)
		local rad = 25
		local mindistance = 36
		local x, y, z = player.Transform:GetWorldPosition()
		local flowers = TheSim:FindEntities(x, y, z, rad, FLOWER_TAGS)

		for i, v in ipairs(flowers) do
			while v ~= nil and player:GetDistanceSqToInst(v) <= mindistance do
				table.remove(flowers, i)
				v = flowers[i]
			end
		end

		return next(flowers) ~= nil and flowers[math.random(1, #flowers)] or nil
	end

	local function SpawnSugarflyForPlayer(player, reschedule)
		local pt = player:GetPosition()
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 64, SUGARFLY_TAGS)
		if #ents < _maxsugarflies then
			local spawnflower = GetSpawnPoint(player)
			if spawnflower ~= nil then
				local sugarfly = SpawnPrefab("kyno_sugarfly")
				if sugarfly.components.pollinator ~= nil then
					sugarfly.components.pollinator:Pollinate(spawnflower)
				end
				sugarfly.components.homeseeker:SetHome(spawnflower)
				sugarfly.Physics:Teleport(spawnflower.Transform:GetWorldPosition())
			end
		end
		_scheduledtasks[player] = nil
		reschedule(player)
	end

	local function ScheduleSpawn(player, initialspawn)
		if _scheduledtasks[player] == nil then
			local basedelay = initialspawn and 0.3 or 10
			_scheduledtasks[player] = player:DoTaskInTime(basedelay + math.random() * 10, SpawnSugarflyForPlayer, ScheduleSpawn)
		end
	end

	local function CancelSpawn(player)
		if _scheduledtasks[player] ~= nil then
			_scheduledtasks[player]:Cancel()
			_scheduledtasks[player] = nil
		end
	end

	local function ToggleUpdate(force)
		if _worldstate.isday and not _worldstate.iswinter and _maxsugarflies > 0 then
			if not _updating then
				_updating = true
				for i, v in ipairs(_activeplayers) do
					ScheduleSpawn(v, true)
				end
			elseif force then
				for i, v in ipairs(_activeplayers) do
					CancelSpawn(v)
					ScheduleSpawn(v, true)
				end
			end
		elseif _updating then
			_updating = false
			for i, v in ipairs(_activeplayers) do
				CancelSpawn(v)
			end
		end
	end

	local function AutoRemoveTarget(inst, target)
		if _sugarflies[target] ~= nil and target:IsAsleep() then
			target:Remove()
		end
	end

	local function OnTargetSleep(target)
		inst:DoTaskInTime(0, AutoRemoveTarget, target)
	end

	local function OnPlayerJoined(src, player)
		for i, v in ipairs(_activeplayers) do
			if v == player then
				return
			end
		end
		table.insert(_activeplayers, player)
		if _updating then
			ScheduleSpawn(player, true)
		end
	end

	local function OnPlayerLeft(src, player)
		for i, v in ipairs(_activeplayers) do
			if v == player then
				CancelSpawn(player)
				table.remove(_activeplayers, i)
				return
			end
		end
	end

	for i, v in ipairs(AllPlayers) do
		table.insert(_activeplayers, v)
	end

	inst:WatchWorldState("isday", ToggleUpdate)
	inst:WatchWorldState("iswinter", ToggleUpdate)
	inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, TheWorld)
	inst:ListenForEvent("ms_playerleft", OnPlayerLeft, TheWorld)

	function self:OnPostInit()
		ToggleUpdate(true)
	end

	function self:SpawnModeNever()
		-- Depreciated.
	end

	function self:SpawnModeLight()
		-- Depreciated.
	end

	function self:SpawnModeMed()
		-- Depreciated.
	end

	function self:SpawnModeHeavy()
		-- Depreciated.
	end

	function self.StartTrackingFn(target)
		if _sugarflies[target] == nil then
			local restore = target.persists and 1 or 0
			target.persists = false
			if target.components.homeseeker == nil then
				target:AddComponent("homeseeker")
			else
				restore = restore + 2
			end
			_sugarflies[target] = restore
			inst:ListenForEvent("entitysleep", OnTargetSleep, target)
		end
	end

	function self:StartTracking(target)
		self.StartTrackingFn(target)
	end

	function self.StopTrackingFn(target)
		local restore = _sugarflies[target]
		if restore ~= nil then
			target.persists = restore == 1 or restore == 3
			if restore < 2 then
				target:RemoveComponent("homeseeker")
			end
			_sugarflies[target] = nil
			inst:RemoveEventCallback("entitysleep", OnTargetSleep, target)
		end
	end

	function self:StopTracking(target)
		self.StopTrackingFn(target)
	end

	function self:GetDebugString()
		local numsugarflies = 0
		
		for k, v in pairs(_sugarflies) do
			numsugarflies = numsugarflies + 1
		end
	
		return string.format("updating:%s sugarflies:%d/%d", tostring(_updating), numsugarflies, _maxsugarflies) 
	end
end)
