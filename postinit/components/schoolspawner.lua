local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

local function GetTopologyBaseID(topology_id)
	if topology_id == nil then
		return nil
	end

	return topology_id:match("^([^:]+)")
end

local function IsAllowed(value, current)
	if value == nil then
		return true
	end

	if current == nil then
		return false
	end

	local current_base = GetTopologyBaseID(current)

	if type(value) == "table" then
		for _, allowed in ipairs(value) do
			if allowed == current
				or allowed == current_base then

				return true
			end
		end

		return false
	end

	return value == current or value == current_base
end

local function GetTopologyIDAtPoint(point)
	if point == nil then
		return nil
	end

	local x, y, z = point:Get()

	return _G.TheWorld.Map:GetTopologyIDAtPoint(x, y, z)
end

local function GetTopologyNodeCentroids(topology_ids)
	local topology = _G.TheWorld.topology

	if topology == nil or topology.nodes == nil or topology.ids == nil then
		return {}
	end

	local centroids = {}

	for node_index, node in ipairs(topology.nodes) do
		local topology_id = topology.ids[node_index]

		if topology_id ~= nil and IsAllowed(topology_ids, topology_id) and node.cent ~= nil then
			centroids[#centroids + 1] =
			{ 
				center = _G.Vector3(node.cent.x, 0, node.cent.z),
				node_index = node_index,
				topology_id = topology_id,
			}
		end
	end

	return centroids
end

local function GetValidTopologyNodeCentroids(topology_ids)
	local nodes = GetTopologyNodeCentroids(topology_ids)
	local valid_nodes = {}

	for _, data in ipairs(nodes) do
		local center = data.center
		local x, y, z = center:Get()
		local percent_ocean = _G.TheWorld.Map:CalcPercentOceanTilesAtPoint(x, y, z, 25)

		if percent_ocean > 0 then
			valid_nodes[#valid_nodes + 1] = data
		else
		end
	end

	return valid_nodes
end

local function GetRandomTopologyNodeCentroid(topology_ids)
	local nodes = GetValidTopologyNodeCentroids(topology_ids)

	if #nodes == 0 then
		return nil
	end

	local selected = nodes[math.random(#nodes)]
	local x, y, z = selected.center:Get()

	return selected.center
end

local function FindSpawnPointAroundTopologyNode(topology_ids)
	local center = GetRandomTopologyNodeCentroid(topology_ids)

	if center == nil then
		return nil
	end

	local cx, cy, cz = center:Get()

	local function TestSpawnPoint(offset)
		local point = center + offset
		local x, y, z = point:Get()

		if not _G.TheWorld.Map:IsOceanAtPoint(x, y, z) then
			return false
		end

		local topology_id = _G.TheWorld.Map:GetTopologyIDAtPoint(x, y, z)

		if not IsAllowed(topology_ids, topology_id) then
			return false
		end

		return true
	end

	local theta = math.random() * _G.TWOPI

	local resultoffset = _G.FindValidPositionByFan(theta, 5 + math.random() * 4, 8, TestSpawnPoint)
	or _G.FindValidPositionByFan(theta, 10 + math.random() * 4, 12, TestSpawnPoint)
	or _G.FindValidPositionByFan(theta, 15 + math.random() * 4, 16, TestSpawnPoint)

	if resultoffset == nil then
		return nil
	end

	local spawnpoint = center + resultoffset
	local sx, sy, sz = spawnpoint:Get()
	local topology_id = _G.TheWorld.Map:GetTopologyIDAtPoint(sx, sy, sz)

	return spawnpoint
end

-- NOTE: Vaniila fishes don't need any of these requirements.
local function SchoolAllowed(schooldata, spawnpoint)
	if schooldata == nil then
		return false
	end

	-- Set a phase of the day as requirement.
	if schooldata.schoolphases ~= nil then
		local current_phase = _G.TheWorld.state.phase

		if not IsAllowed(schooldata.schoolphases, current_phase) then
			return false
		end
	end

	-- Set a phase of the moon as requirement.
	if schooldata.schoolmoonphases ~= nil then
		local current_moonphase = _G.TheWorld.state.moonphase

		if not IsAllowed(schooldata.schoolmoonphases, current_moonphase) then
			return false
		end
	end

	-- Set a biome as requirement, usually defined by its room names/topology IDs.
	if schooldata.schoolbiomes ~= nil then
		if spawnpoint == nil then
			return false
		end

		local topology_id = GetTopologyIDAtPoint(spawnpoint)

		if not IsAllowed(schooldata.schoolbiomes, topology_id) then
			return false
		end
	end

	return true
end

AddComponentPostInit("schoolspawner", function(self)
	local SpawnSchool = self.SpawnSchool

	local _PickSchool = UpvalueHacker.GetUpvalue(SpawnSchool, "PickSchool")

	if _PickSchool ~= nil then
		local function PickSchool(spawnpoint, ...)
			local schooldata = _PickSchool(spawnpoint, ...)

			if schooldata == nil then
				return nil
			end

			local topology_id = GetTopologyIDAtPoint(spawnpoint)

			if SchoolAllowed(schooldata, spawnpoint) then
				return schooldata
			end

			return nil
		end

		UpvalueHacker.SetUpvalue(SpawnSchool, PickSchool, "PickSchool")

		local _GetSpawnPoint = self.GetSpawnPoint

		self.GetSpawnPoint = function(inst, pt)
			local vanilla_spawnpoint = _GetSpawnPoint(inst, pt)

			if vanilla_spawnpoint == nil then
				return nil
			end

			local schooldata = _PickSchool(vanilla_spawnpoint)

			if schooldata == nil then
				return vanilla_spawnpoint
			end

			if schooldata.schoolbiomes == nil then
				return vanilla_spawnpoint
			end

			local spawnpoint = FindSpawnPointAroundTopologyNode(schooldata.schoolbiomes)

			if spawnpoint == nil then
				return nil
			end

			if not SchoolAllowed(schooldata, spawnpoint) then
				return nil
			end

			return spawnpoint
		end
	end
end)