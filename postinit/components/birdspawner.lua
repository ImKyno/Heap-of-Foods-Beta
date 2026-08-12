local _G            = GLOBAL
local require       = _G.require
local WORLD_TILES   = _G.WORLD_TILES
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Night Birds spawning logic.
local NIGHTBIRDS             = TUNING.HOF_NIGHTBIRDS
local NIGHTBIRDS_DELAY_MIN   = (TUNING.BIRD_SPAWN_DELAY.min or 5) + 5
local NIGHTBIRDS_DELAY_MAX   = (TUNING.BIRD_SPAWN_DELAY.max or 15) + 5
local NIGHTBIRDS_TASKS       = {}
local NIGHTBIRDS_SPAWN_MAX   = TUNING.BIRD_SPAWN_MAX or 4
local NIGHTBIRDS_SPAWN_DELAY = { MIN = NIGHTBIRDS_DELAY_MIN, MAX = NIGHTBIRDS_DELAY_MAX }

local BAIT_CANT_TAGS         = { "INLIMBO", "outofreach" }
local DANGER_RANGE           = 8
local SCARYTOPREY_TAGS       = { "scarytoprey" }
local NIGHTBIRD_TAGS         = { "nightbird" }

local function GetNightBirdPrefab()
	local available = {}

	for _, data in ipairs(NIGHTBIRDS) do
		if not data.winter or _G.TheWorld.state.iswinter then
			table.insert(available, data.prefab)
		end
	end

	if #available > 0 then
		return available[math.random(#available)]
	end
end

local function GetNightBirdSpawnPoint(spawner, pt)
	local function TestSpawnPoint(offset)
		local spawnpoint_x, spawnpoint_y, spawnpoint_z = (pt + offset):Get()

		if _G.IsOceanTile(spawnpoint_x, spawnpoint_y, spawnpoint_z) then
			return false
		end

		if _G.TheWorld.Map:IsPointInWagPunkArenaAndBarrierIsUp(spawnpoint_x, spawnpoint_y, spawnpoint_z) then
			return false
		end

		local allow_water = false

		local in_moonstorm = _G.TheWorld.net.components.moonstorms
		and _G.TheWorld.net.components.moonstorms:IsXZInMoonstorm(spawnpoint_x, spawnpoint_z)

		return _G.TheWorld.Map:IsPassableAtPoint(spawnpoint_x, spawnpoint_y, spawnpoint_z, allow_water)
		and #_G.TheSim:FindEntities(spawnpoint_x, 0, spawnpoint_z, 4, { "birdblocker" }) == 0
		and not in_moonstorm and not _G.TheWorld.GroundCreep:OnCreep(spawnpoint_x, spawnpoint_y, spawnpoint_z)
	end

	local theta = math.random() * _G.TWOPI
	local radius = 6 + math.random() * 6

	local resultoffset = _G.FindValidPositionByFan(theta, radius, 12, TestSpawnPoint)

	if resultoffset ~= nil then
		return pt + resultoffset
	end

	return nil
end

local function CanNightBirdSpawn()
	return _G.TheWorld.state.isnight and #NIGHTBIRDS > 0
end

local function SpawnNightBird(spawner, prefab, spawnpoint)
	if spawnpoint == nil then
		return
	end

	local x, y, z = spawnpoint:Get()

	if _G.IsOceanTile(x, y, z) then
		return
	end

	local final_x = x
	local final_z = z
	local bufferedaction = nil

	if TUNING.BIRD_TRAP_CHANCE ~= nil then
		local bait = _G.TheSim:FindEntities(x, 0, z, 15, nil, BAIT_CANT_TAGS)

		for _, v in pairs(bait) do
			local vx, vy, vz = v.Transform:GetWorldPosition()
			local danger_nearby = _G.TheSim:CountEntities(vx, vy, vz, DANGER_RANGE, SCARYTOPREY_TAGS) > 0

			if v.components.bait and not v:IsInLimbo() and not (v.components.inventoryitem and v.components.inventoryitem:IsHeld())
			and not danger_nearby and _G.TheWorld.Map:IsPassableAtPoint(vx, vy, vz) and not _G.IsOceanTile(vx, vy, vz) then
				final_x = vx
				final_z = vz
				bufferedaction = v
				break
			elseif v.components.trap and v.components.trap.isset
			and (not v.components.trap.targettag or prefab == v.components.trap.targettag) and not v.components.trap.issprung
			and math.random() < TUNING.BIRD_TRAP_CHANCE and not danger_nearby and not _G.IsOceanTile(vx, vy, vz) then
				final_x = vx
				final_z = vz
				break
			end
		end
	end

	if _G.IsOceanTile(final_x, 0, final_z) then
		return
	end

	local bird = _G.SpawnPrefab(prefab)

	if bird == nil then
		return
	end

	if math.random() < 0.5 and bird.Transform ~= nil then
		bird.Transform:SetRotation(180)
	end

	if bird:HasTag("bird") then
		y = 15
	else
		y = 0
	end

	if bufferedaction ~= nil then
		bird.bufferedaction = _G.BufferedAction(bird, bufferedaction, _G.ACTIONS.EAT)
	end

	bird.Physics:Teleport(final_x, y, final_z)
	spawner:StartTracking(bird)

	return bird
end

local function SpawnNightBirdForPlayer(spawner, player)
	if not CanNightBirdSpawn() then
		return
	end

	local pt = player:GetPosition()
	local bird_count = _G.TheSim:CountEntities(pt.x, pt.y, pt.z, 64, NIGHTBIRD_TAGS)

	if bird_count >= NIGHTBIRDS_SPAWN_MAX then
		return
	end

	local spawnpoint = GetNightBirdSpawnPoint(spawner, pt)

	if spawnpoint == nil then
		return
	end

	local prefab = GetNightBirdPrefab()

	if prefab ~= nil then
		SpawnNightBird(spawner, prefab, spawnpoint)
	end
end

local function ScheduleNightBirdSpawn(spawner, player)
	if not CanNightBirdSpawn() then
		NIGHTBIRDS_TASKS[player] = nil
		return
	end

	if NIGHTBIRDS_TASKS[player] ~= nil then
		return
	end

	local delay = GetRandomMinMax(NIGHTBIRDS_SPAWN_DELAY.MIN, NIGHTBIRDS_SPAWN_DELAY.MAX)

	NIGHTBIRDS_TASKS[player] = player:DoTaskInTime(delay, function()
		NIGHTBIRDS_TASKS[player] = nil

		if CanNightBirdSpawn() then
			SpawnNightBirdForPlayer(spawner, player)
			ScheduleNightBirdSpawn(spawner, player)
		end
	end)
end

local function CancelNightBirdSpawn(player)
	local nighttask = NIGHTBIRDS_TASKS[player]

	if nighttask ~= nil then
		nighttask:Cancel()
		NIGHTBIRDS_TASKS[player] = nil
	end
end

local function ToggleNightBirdSpawn(spawner)
	if CanNightBirdSpawn() then
		for _, player in ipairs(_G.AllPlayers) do
			ScheduleNightBirdSpawn(spawner, player)
		end
	else
		for player, _ in pairs(NIGHTBIRDS_TASKS) do
			CancelNightBirdSpawn(player)
		end
	end
end

AddClassPostConstruct("components/birdspawner", function(self)
	-- New birds will spawn when landing on these turfs.
	local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")

	if TUNING.HOF_DEBUG_MODE then
		print("Heap of Foods Mod - Birdspawner Component: BIRD_TYPES function:", BIRD_TYPES)
	end

	if BIRD_TYPES ~= nil then
		BIRD_TYPES[WORLD_TILES.QUAGMIRE_PARKFIELD] = { "quagmire_pigeon" }
		BIRD_TYPES[WORLD_TILES.QUAGMIRE_CITYSTONE] = { "quagmire_pigeon" }

		BIRD_TYPES[WORLD_TILES.MONKEY_GROUND]      = { "toucan", "toucan_chubby" }
		BIRD_TYPES[WORLD_TILES.HOF_TIDALMARSH]     = { "toucan", "toucan_chubby" }
		BIRD_TYPES[WORLD_TILES.HOF_FIELDS]         = { "kingfisher" }
	end

	self.inst:WatchWorldState("isnight", function()
		ToggleNightBirdSpawn(self)
	end)

	self.inst:ListenForEvent("ms_playerjoined", function(_, player)
		if CanNightBirdSpawn() then
			ScheduleNightBirdSpawn(self, player)
		end
	end, _G.TheWorld)

	self.inst:ListenForEvent("ms_playerleft", function(_, player)
		CancelNightBirdSpawn(player)
	end, _G.TheWorld)

	ToggleNightBirdSpawn(self)
end)