local _G            = GLOBAL
local require       = _G.require
local WORLD_TILES   = _G.WORLD_TILES
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Night Birds spawning logic.
local NIGHTBIRDS             = TUNING.HOF_NIGHTBIRDS
local NIGHTBIRDS_TASKS       = {}
local NIGHTBIRDS_SPAWN_MAX   = TUNING.BIRD_SPAWN_MAX
local NIGHTBIRDS_SPAWN_DELAY = { MIN = TUNING.BIRD_SPAWN_DELAY.min, MAX = TUNING.BIRD_SPAWN_DELAY.max }

local BAIT_CANT_TAGS         = { "INLIMBO", "outofreach" }
local DANGER_RANGE           = 8
local SCARYTOPREY_TAGS       = { "scarytoprey" }
local NIGHTBIRD_TAGS         = { "nightbird" }

local function CanNightBirdSpawn()
	return _G.TheWorld.state.isnight and #NIGHTBIRDS > 0
end

local function SpawnNightBird(spawner, prefab, spawnpoint)
	local bird = _G.SpawnPrefab(prefab)

	if bird == nil then
		return
	end

	if math.random() < 0.5 and bird.Transform ~= nil then
		bird.Transform:SetRotation(180)
	end

	if bird:HasTag("bird") then
		spawnpoint.y = 15
	end

	if bird.components.eater ~= nil then
		local bait = _G.TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, 15, nil, BAIT_CANT_TAGS)

		for _, v in pairs(bait) do
			local x, y, z = v.Transform:GetWorldPosition()
			local danger_nearby = _G.TheSim:CountEntities(x, y, z, DANGER_RANGE, SCARYTOPREY_TAGS) > 0

			if bird.components.eater:CanEat(v) and not v:IsInLimbo() and v.components.bait
			and not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) and not danger_nearby
			and (_G.TheWorld.Map:IsPassableAtPoint(x, y, z) or bird.components.floater ~= nil) then
				spawnpoint.x = x
				spawnpoint.z = z

				bird.bufferedaction = _G.BufferedAction(bird, v, _G.ACTIONS.EAT)
				break
			elseif v.components.trap and v.components.trap.isset
			and (not v.components.trap.targettag or bird:HasTag(v.components.trap.targettag))
			and not v.components.trap.issprung and math.random() < TUNING.BIRD_TRAP_CHANCE and not danger_nearby then
				spawnpoint.x = x
				spawnpoint.z = z
				break
			end
		end
	end

	bird.Physics:Teleport(spawnpoint:Get())
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

	local spawnpoint = spawner:GetSpawnPoint(pt)

	if spawnpoint == nil then
		return
	end

	local prefab = NIGHTBIRDS[math.random(#NIGHTBIRDS)]
	SpawnNightBird(spawner, prefab, spawnpoint)
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

	BIRD_TYPES[WORLD_TILES.QUAGMIRE_PARKFIELD] = { "quagmire_pigeon" }
	BIRD_TYPES[WORLD_TILES.QUAGMIRE_CITYSTONE] = { "quagmire_pigeon" }

	BIRD_TYPES[WORLD_TILES.MONKEY_GROUND]      = { "toucan", "toucan_chubby" }
	BIRD_TYPES[WORLD_TILES.HOF_TIDALMARSH]     = { "toucan", "toucan_chubby" }
	BIRD_TYPES[WORLD_TILES.HOF_FIELDS]         = { "kingfisher" }

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