return Class(function(self, inst)
	assert(TheWorld.ismastersim, "WaterfowlHunter should not exist on client")

	local _world = TheWorld
	local _worldstate = _world.state
	
	local HUNT_UPDATE = 2

	local _dirt_prefab = "kyno_whale_ocean_bubbles"
	local _track_prefab = "kyno_whale_ocean_track"
	local _beast_prefabs = { "kyno_whale_blue_ocean" }

	local _alternate_beast_prefabs = 
	{
		-- White Whale during Winter and Summer.
		function(beasts)
			if _worldstate.iswinter or _worldstate.issummer then
				table.insert(beasts, "kyno_whale_white_ocean")
			end
		end,
	
		-- Marotter Den during rain.
		function(beasts)
			if TUNING.OTTERDEN_ENABLED then
				if _worldstate.israining then
					table.insert(beasts, "boat_otterden")
				end
			end
		end,
	
		-- Malbatross if he is not found.
		--[[
		function(beasts)
			local malbatross = TheSim:FindFirstEntityWithTag("malbatross")
			local malbatross_timer = _world.components.timer:TimerExists("malbatross_timetospawn2")
	
			if not malbatross and malbatross_timer then
				table.insert(beasts, "malbatross")
			end
		end
		]]--
	}

	local _spawnoverride = nil

	self.inst = inst

	local _activeplayers = {}
	local _activehunts = {}

	local _validtiles = 
	{
		[WORLD_TILES.OCEAN_SWELL] = true,
		[WORLD_TILES.OCEAN_ROUGH] = true,
		[WORLD_TILES.OCEAN_HAZARDOUS] = true,
		[WORLD_TILES.OCEAN_WATERLOG] = true,
	}

	local OnUpdateHunt
	local ResetHunt

	local function GetMaxHunts()
		return #_activeplayers
	end

	local function RemoveDirt(hunt)
		assert(hunt)
	
		if hunt.lastdirt ~= nil then
			inst:RemoveEventCallback("onremove", hunt.lastdirt._ondirtremove, hunt.lastdirt)
		
			hunt.lastdirt:Remove()
			hunt.lastdirt = nil
		end
	end

	local function StopHunt(hunt)
		assert(hunt)

		RemoveDirt(hunt)

		if hunt.hunttask ~= nil then
			hunt.hunttask:Cancel()
			hunt.hunttask = nil
		end
	end

	local function BeginHunt(hunt)
		assert(hunt)
	
		hunt.hunttask = inst:DoPeriodicTask(HUNT_UPDATE, OnUpdateHunt, nil, hunt)
	end

	local function StopCooldown(hunt)
		assert(hunt)
	
		if hunt.cooldowntask ~= nil then
			hunt.cooldowntask:Cancel()
			hunt.cooldowntask = nil
			hunt.cooldowntime = nil
		end
	end

	local function OnCooldownEnd(inst, hunt)
		assert(hunt)

		StopCooldown(hunt)
		StopHunt(hunt)

		BeginHunt(hunt)
	end

	local function RemoveHunt(hunt)
		StopHunt(hunt)
	
		for i, v in ipairs(_activehunts) do
			if v == hunt then
				table.remove(_activehunts, i)
				return
			end
		end
	
		assert(false)
	end

	local function StartCooldown(inst, hunt, cooldown)
		assert(hunt)
	
		local cooldown = cooldown or TUNING.WATERFOWLHUNT_COOLDOWN + TUNING.WATERFOWLHUNT_COOLDOWN_DEVIATION * (math.random() * 2 - 1)

		StopHunt(hunt)
		StopCooldown(hunt)

		if #_activehunts > GetMaxHunts() then
			RemoveHunt(hunt)
			return
		end

		if cooldown and cooldown > 0 then
			hunt.activeplayer = nil
			hunt.lastdirt = nil
			hunt.lastdirttime = nil

			hunt.cooldowntask = inst:DoTaskInTime(cooldown, OnCooldownEnd, hunt)
			hunt.cooldowntime = GetTime() + cooldown
		end
	end

	local function StartHunt()
		local newhunt =
		{
			lastdirt = nil,
			direction = nil,
			activeplayer = nil,
		}
		
		table.insert(_activehunts, newhunt)
		inst:DoTaskInTime(1, StartCooldown, newhunt)
		
		return newhunt
	end

	local function IsValidWater(pt)
		-- return true
		local x, y, z = pt.x, 0, pt.z

		if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
			return false
		end

		if TheWorld.Map:GetPlatformAtPoint(x, z) ~= nil then
			return false
		end

		local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
		return _validtiles[tile] == true
	end

	local function GetSpawnPoint(pt, radius, hunt)
		local angle = hunt.direction
	
		if angle then
			local offset = Vector3(radius * math.cos( angle ), 0, -radius * math.sin( angle ))
			local spawn_point = pt + offset

			if IsValidWater(spawn_point) then
				return spawn_point
			end
		end
	end

	local function SpawnDirt(pt, hunt)
		assert(hunt)

		local spawn_pt = GetSpawnPoint(pt, TUNING.WATERFOWLHUNT_SPAWN_DIST, hunt)
	
		if spawn_pt ~= nil then
			local spawned = SpawnPrefab(_dirt_prefab)
		
			if spawned ~= nil then
				spawned.Transform:SetPosition(spawn_pt:Get())
				
				hunt.lastdirt = spawned
				hunt.lastdirttime = GetTime()

				spawned._ondirtremove = function()
					hunt.lastdirt = nil
					ResetHunt(hunt)
				end
			
				inst:ListenForEvent("onremove", spawned._ondirtremove, spawned)

				return true
			end
		end

		return false
	end

	local function GetRunAngle(pt, angle, radius)
		local offset, result_angle = FindSwimmableOffset(pt, angle, radius, 14, true, false, IsValidWater)
		return result_angle
	end

	local function GetNextSpawnAngle(pt, direction, radius)
		local base_angle = direction or math.random() * TWOPI
		local deviation = math.random(-TUNING.WATERFOWLHUNT_TRACK_ANGLE_DEVIATION, TUNING.WATERFOWLHUNT_TRACK_ANGLE_DEVIATION) * DEGREES

		local start_angle = base_angle + deviation
		return GetRunAngle(pt, start_angle, radius)
	end

	local function StartDirt(hunt,position)
		assert(hunt)

		RemoveDirt(hunt)

		local pt = position

		hunt.numtrackstospawn = math.random(TUNING.WATERFOWLHUNT_MIN_TRACKS, TUNING.WATERFOWLHUNT_MAX_TRACKS)
		hunt.trackspawned = 0
		hunt.direction = GetNextSpawnAngle(pt, nil, TUNING.WATERFOWLHUNT_SPAWN_DIST)
	
		if hunt.direction ~= nil then
			local spawnRelativeTo = pt
		
			if SpawnDirt(spawnRelativeTo, hunt) then
				-- print("WaterfowlHunter - Spawned Track.")
			end
		end
	end

	local function IsNearHunt(player)
		for i, hunt in ipairs(_activehunts) do
			if hunt.lastdirt ~= nil and player:IsNear(hunt.lastdirt, TUNING.MIN_JOINED_HUNT_DISTANCE) then
				return true
			end
		end
	
		return false
	end

	ResetHunt = function(hunt, washedaway)
		assert(hunt)

		if hunt.activeplayer ~= nil then
			hunt.activeplayer:PushEvent("oceanhuntlosttrail", { washedaway = washedaway })
		end

		StartCooldown(inst, hunt, TUNING.WATERFOWLHUNT_RESET_TIME)
	end

	OnUpdateHunt = function(inst, hunt)
		assert(hunt)

		if hunt.lastdirttime ~= nil then
			if hunt.trackspawned >= 1 then
				local wet = _worldstate.wetness > 15 or _worldstate.israining
			
				local lastdirttime = GetTime() - hunt.lastdirttime
				local maxtime = (wet and 1.25 or 1.25) * TUNING.SEG_TIME
				
				if lastdirttime > maxtime then
					local playerIsInOtherHunt = false
				
					for i, v in ipairs(_activehunts) do
						if v ~= hunt and v.activeplayer and hunt.activeplayer then
							if v.activeplayer == hunt.activeplayer then
								playerIsInOtherHunt = true
							end
						end
					end

					if playerIsInOtherHunt then
						StartCooldown(inst, hunt)
					else
						ResetHunt(hunt, wet)
					end

					return
				end
			end
		end

		if hunt.lastdirt == nil then
			local huntingPlayers = {}
		
			for i, v in ipairs(_activehunts) do
				if v.activeplayer then
					huntingPlayers[v.activeplayer] = true
				end
			end

			local eligiblePlayers = {}
		
			for i, v in ipairs(_activeplayers) do
				if not huntingPlayers[v] and not IsNearHunt(v) then
					table.insert(eligiblePlayers, v)
				end
			end
		
			if #eligiblePlayers == 0 then
				return
			end
		
			local player = eligiblePlayers[math.random(1, #eligiblePlayers)]
			local position = player:GetPosition()
		
			StartDirt(hunt, position)
		else
			local x, y, z = hunt.lastdirt.Transform:GetWorldPosition()

			if not IsAnyPlayerInRange(x, y, z, TUNING.WATERFOWLHUNT_MAX_DISTANCE) then
				StartCooldown(inst, hunt, .1)
			end
		end
	end

	local function GetAlternateBeastChance()
		local day = _worldstate.cycles
		local chance = Lerp(TUNING.WATERFOWLHUNT_ALTERNATE_BEAST_CHANCE_MIN, TUNING.WATERFOWLHUNT_ALTERNATE_BEAST_CHANCE_MAX, day / 100)
	
		return math.clamp(chance, TUNING.WATERFOWLHUNT_ALTERNATE_BEAST_CHANCE_MIN, TUNING.WATERFOWLHUNT_ALTERNATE_BEAST_CHANCE_MAX)
	end

	local function GetRandomBeastPrefab(t)
		local valid = {}
	
		for k, v in ipairs(t) do
			if type(v) == "string" then
				table.insert(valid, v)
			elseif type(v) == "function" then
				v(valid)
			end
		end
	
		return #valid > 0 and valid[math.random(#valid)] or nil
	end

	local function SpawnHuntedBeast(hunt, pt)
		assert(hunt)

		local spawn_pt = GetSpawnPoint(pt, TUNING.WATERFOWLHUNT_BEAST_SPAWN_DIST, hunt)
	
		if spawn_pt ~= nil then
			hunt.huntedbeast = SpawnPrefab(
				_spawnoverride or
				(math.random() <= GetAlternateBeastChance() and GetRandomBeastPrefab(_alternate_beast_prefabs)) or
				GetRandomBeastPrefab(_beast_prefabs)
			)

			if hunt.huntedbeast ~= nil then
				hunt.huntedbeast.Physics:Teleport(spawn_pt:Get())
				hunt.huntedbeast:PushEvent("spawnedforhunt")
				
				inst:DoTaskInTime(2, function()
					if hunt.huntedbeast ~= nil then
						hunt.huntedbeast = nil
					end
					
					StartCooldown(inst, hunt)
				end)

				--[[
				local function OnBeastDeath()
					inst:RemoveEventCallback("onremove", OnBeastDeath, hunt.huntedbeast)
					hunt.huntedbeast = nil
				
					StartCooldown(inst, hunt)
				end

				inst:ListenForEvent("death", OnBeastDeath, hunt.huntedbeast)
				inst:ListenForEvent("onremove", OnBeastDeath, hunt.huntedbeast)
				]]--
			
				return true
			end
		end

		return false
	end

	local function SpawnBubble(num, pt, direction)
		local bubble = SpawnPrefab(_track_prefab)
		local offset = Vector3((num * 5) * math.cos(direction), 0, -(num * 5) * math.sin(direction))
	
		bubble.Transform:SetPosition((pt + offset):Get())
	end

	local function HintDirection(pt, direction)
		for i = 0, 3 do
			inst:DoTaskInTime(i * 1.33 + 0.5, function() SpawnBubble(i, pt, direction) end)
		end
	end

	local function SpawnTrack(spawn_pt, hunt)
		if spawn_pt then
			local next_angle = GetNextSpawnAngle(spawn_pt, hunt.direction, TUNING.WATERFOWLHUNT_SPAWN_DIST)
		
			if next_angle ~= nil then
				local spawned = SpawnPrefab(_track_prefab)
			
				if spawned ~= nil then
					spawned.Transform:SetPosition(spawn_pt:Get())
					hunt.direction = next_angle

					spawned.Transform:SetRotation(hunt.direction / DEGREES - 90)
					hunt.trackspawned = hunt.trackspawned + 1

					return true
				end
			end
		end

		return false
	end

	local function KickOffHunt()
		if #_activehunts < GetMaxHunts() then
			StartHunt()
		end
	end

	local function OnPlayerJoined(src, player)
		for i, v in ipairs(_activeplayers) do
			if v == player then
				return
			end
		end
	
		table.insert(_activeplayers, player)
		KickOffHunt()
	end

	local function OnPlayerLeft(src, player)
		for i, v in ipairs(_activeplayers) do
			if v == player then
				table.remove(_activeplayers, i)
				return
			end
		end
	end

	for i, v in ipairs(AllPlayers) do
		OnPlayerJoined(self, v)
	end

	inst:ListenForEvent("ms_playerjoined", OnPlayerJoined, _world)
	inst:ListenForEvent("ms_playerleft", OnPlayerLeft, _world)

	function self:OnDirtInvestigated(pt, doer)
		assert(doer)

		local hunt = nil
	
		for i, v in ipairs(_activehunts) do
			if v.lastdirt ~= nil and v.lastdirt:GetPosition() == pt then
				hunt = v
				inst:RemoveEventCallback("onremove", v.lastdirt._ondirtremove, v.lastdirt)
				break
			end
		end

		if hunt == nil then
			return
		end

		hunt.activeplayer = doer

		if hunt.numtrackstospawn ~= nil and hunt.numtrackstospawn > 0 then
			if SpawnTrack(pt, hunt) then
				if hunt.trackspawned < hunt.numtrackstospawn then
					if SpawnDirt(pt, hunt) then
						HintDirection(pt, hunt.direction)
					else
						ResetHunt(hunt)
					end
				elseif hunt.trackspawned == hunt.numtrackstospawn then
					if SpawnHuntedBeast(hunt, pt) then
						HintDirection(pt, hunt.direction)
						
						if hunt.activeplayer ~= nil then
							hunt.activeplayer:PushEvent("oceanhuntbeastnearby")
						end
					
						StopHunt(hunt)
					else
						ResetHunt(hunt)
					end
				end
			else
				ResetHunt(hunt)
			end
		end
	end

	function self:AddBeast(prefab)
		table.insert(_beast_prefabs, prefab)
	end

	function self:AddAlternateBeast(prefab)
		table.insert(_alternate_beast_prefabs, prefab)
	end

	function self:LongUpdate(dt)
		for i, hunt in ipairs(_activehunts) do
			if hunt.cooldowntask ~= nil and hunt.cooldowntime ~= nil then
				hunt.cooldowntask:Cancel()
				hunt.cooldowntask = nil
				hunt.cooldowntime = hunt.cooldowntime - dt
				hunt.cooldowntask = inst:DoTaskInTime(hunt.cooldowntime - GetTime(), OnCooldownEnd, hunt)
			end
		end
	end

	function self:ForceHunt()
		if #_activehunts >= GetMaxHunts() then
			local hunt = _activehunts[1]
		
			StopHunt(hunt)
			StopCooldown(hunt)
		
			RemoveHunt(hunt)
		end
	
		StartHunt()
	end

	function self:GetDebugString()
		local str = ""
	
		for i, hunt in ipairs(_activehunts) do
			str = str.." Cooldown: ".. (hunt.cooldowntime and string.format("%2.2f", math.max(1, hunt.cooldowntime - GetTime())) or "-")
		
			if not hunt.lastdirt then
				str = str.." No last dirt."
				-- str = str.." Distance: ".. (playerdata.distance and string.format("%2.2f", playerdata.distance) or "-")
				-- str = str.."/"..tostring(TUNING.MIN_HUNT_DISTANCE)
			else
				str = str.." Dirt"
				-- str = str.." Distance: ".. (playerdata.distance and string.format("%2.2f", playerdata.distance) or "-")
				-- str = str.."/"..tostring(TUNING.MAX_DIRT_DISTANCE)
			end
		end
	
		return str
	end
end)