require("constants")
require("mathutil")
require("map/terrain")

local HOF_MAPUTIL = require("map/hof_maputil")
local obj_layout = require("map/object_layout")

local CAVE_BLACKLIST  =
{
	atrium_key        = true,
	glommer           = true,
	glommerflower     = true,
	klaussackkey      = true,
	chester           = true,
	chester_eyebone   = true,
	hutch             = true,
	hutch_fishbowl    = true,
	insanityrock      = true,
	sanityrock        = true,
	wormhole          = true,
	tentacle_pillar   = true,
	shadowrift_portal = true,
}

local function FindEntsInArea(entities, left, top, size, blocking_prefabs)
	local right, bottom = left + size, top + size

	local ents_in_area = {}

	for prefab, ents in pairs(entities) do
		for i, e in ipairs(ents) do
			if e.x > left and e.x < right and e.z > top and e.z < bottom then
				if table.contains(blocking_prefabs, prefab) then
					return nil
				end

				table.insert(ents_in_area, {prefab = prefab, index = i})
			end
		end
	end

	return ents_in_area
end

local function PointInPolygon(px, pz, poly)
	local inside = false
	local j = #poly

	for i = 1, #poly do
		local xi, zi = poly[i][1], poly[i][2]
		local xj, zj = poly[j][1], poly[j][2]

		if ((zi > pz) ~= (zj > pz)) and (px < (xj - xi) * (pz - zi) / (zj - zi) + xi) then
			inside = not inside
		end

		j = i
	end

	return inside
end

local function AddSquareTopology(topology, left, top, size, room_id, tags)
	local index = #topology.ids + 1
	topology.ids[index] = room_id
	topology.story_depths[index] = 0

	local node = {}
	node.area = size * size
	node.c = 1
	node.cent = {left + (size / 2), top + (size / 2)}
	node.neighbours = {}
	node.poly =
	{
		{left, top},
		{left + size, top},
		{left + size, top + size},
		{left, top + size}
	}
	node.tags  = tags
	node.type = NODE_TYPE.Default
	node.x = node.cent[1]
	node.y = node.cent[2]
	node.validedges = {}
	topology.nodes[index] = node

	return index
end

local function AddTileNodeIdsForArea(world_map, node_index, left, top, size)
	for x = left, left + size do
		for y = top, top + size do
			world_map:SetTileNodeId(x, y, node_index)
		end
	end
end

local function HofRetrofitting_CaveTuberTrees(map, savedata)
	local PREFABS_DATA =
	{
		{
			prefab = "kyno_cavetubertree",
			max_to_spawn = 100,
			min_distance = 8,

			valid_rooms =
			{
				"BatCave",
				"BattyCave",
				"FernyBatCave",
				"BGBatCaveRoom",
			},

			valid_tiles =
			{
				WORLD_TILES.CAVE, -- Sometimes it spawns outside bat biomes, this should fix that.
			},
		},
	}

	local topology = savedata.map.topology
	local entities = savedata.ents

	local function IsFarFromOthers(x, z, points, min_dist)
		for _, p in ipairs(points) do
			if VecUtil_LengthSq(p.x - x, p.z - z) < (min_dist * min_dist) then
				return false
			end
		end

		return true
	end

	local function IsValidTile(tile, valid_tiles)
		if valid_tiles == nil then
			return true
		end

		for _, valid_tile in ipairs(valid_tiles) do
			if tile == valid_tile then
				return true
			end
		end

		return false
	end

	local function GetValidNodes(valid_rooms)
		local nodes = {}

		for node_index, id_string in ipairs(topology.ids) do
			for _, room in ipairs(valid_rooms) do
				if id_string:find(room) then
					table.insert(nodes, topology.nodes[node_index])
					break
				end
			end
		end

		return nodes
	end

	local function GetNodeBounds(node)
		local min_x, max_x = node.poly[1][1], node.poly[1][1]
		local min_z, max_z = node.poly[1][2], node.poly[1][2]

		for _, point in ipairs(node.poly) do
			min_x = math.min(min_x, point[1])
			max_x = math.max(max_x, point[1])

			min_z = math.min(min_z, point[2])
			max_z = math.max(max_z, point[2])
		end

		return min_x, max_x, min_z, max_z
	end

	local function IsPointInsideNode(x, z, node)
		local min_x, max_x, min_z, max_z = GetNodeBounds(node)
		return x >= min_x and x <= max_x and z >= min_z and z <= max_z
	end

	for _, data in ipairs(PREFABS_DATA) do
		local prefab = data.prefab
		local max_to_spawn = data.max_to_spawn
		local min_distance = data.min_distance
		local valid_rooms = data.valid_rooms
		local valid_tiles = data.valid_tiles

		local valid_positions = {}
		local valid_nodes = GetValidNodes(valid_rooms)

		if #valid_nodes > 0 then
			local attempts = 0
			local max_attempts = max_to_spawn * 100

			print(string.format("Retrofitting for Heap of Foods Mod - Placing '%s' randomly in valid rooms.", prefab))

			while #valid_positions < max_to_spawn and attempts < max_attempts do
				attempts = attempts + 1

				local node = valid_nodes[math.random(#valid_nodes)]

				local min_x, max_x, min_z, max_z = GetNodeBounds(node)

				local wx = math.random() * (max_x - min_x) + min_x
				local wz = math.random() * (max_z - min_z) + min_z

				if IsPointInsideNode(wx, wz, node) then
					local tile = map:GetTileAtPoint(wx, 0, wz)

					if map:IsValidTileAtPoint(wx, 0, wz)
					and map:IsVisualGroundAtPoint(wx, 0, wz)
					and IsValidTile(tile, valid_tiles)
					and IsFarFromOthers(wx, wz, valid_positions, min_distance) then
						table.insert(valid_positions,
						{
							x = wx,
							z = wz,
						})
					end
				end
			end

			print(string.format(
				"Retrofitting for Heap of Foods Mod - Found %d valid positions for '%s' after %d attempts.",
				#valid_positions,
				prefab,
				attempts
			))

			if entities[prefab] == nil then
				entities[prefab] = {}
			end

			for _, pos in ipairs(valid_positions) do
				table.insert(entities[prefab],
				{
					x = pos.x,
					z = pos.z,
				})
			end

			print(string.format("Retrofitting for Heap of Foods Mod - Added %d '%s' to the world.", #valid_positions, prefab))
		else
			print(string.format("Retrofitting for Heap of Foods Mod - Couldn't find valid rooms for '%s'.", prefab))
		end
	end
end

-- Since FungusNoise is not a guaranteed room in caves this might fail to retrofit...
-- But I guess it's whatever since you can craft the houses anyway.
local function HofRetrofitting_ElderMandrakeHouses(map, savedata)
	local PREFABS_DATA =
	{
		{
			prefab = "kyno_eldermandrakehouse",
			max_to_spawn = 25,
			min_distance = 15,

			valid_rooms =
			{
				"FungusNoiseForest",
				"FungusNoiseMeadow",
			},

			valid_tiles =
			{
				WORLD_TILES.DIRT,
				WORLD_TILES.UNDERROCK,
				WORLD_TILES.FUNGUS,
				WORLD_TILES.FUNGUSRED,
				WORLD_TILES.FUNGUSGREEN,
			},
		},
	}

	local topology = savedata.map.topology
	local entities = savedata.ents

	local function IsFarFromOthers(x, z, points, min_dist)
		for _, p in ipairs(points) do
			if VecUtil_LengthSq(p.x - x, p.z - z) < (min_dist * min_dist) then
				return false
			end
		end

		return true
	end

	local function IsValidTile(tile, valid_tiles)
		if valid_tiles == nil then
			return true
		end

		for _, valid_tile in ipairs(valid_tiles) do
			if tile == valid_tile then
				return true
			end
		end

		return false
	end

	local function GetValidNodes(valid_rooms)
		local nodes = {}

		for node_index, id_string in ipairs(topology.ids) do
			for _, room in ipairs(valid_rooms) do
				if id_string:find(room) then
					table.insert(nodes, topology.nodes[node_index])
					break
				end
			end
		end

		return nodes
	end

	local function GetNodeBounds(node)
		local min_x, max_x = node.poly[1][1], node.poly[1][1]
		local min_z, max_z = node.poly[1][2], node.poly[1][2]

		for _, point in ipairs(node.poly) do
			min_x = math.min(min_x, point[1])
			max_x = math.max(max_x, point[1])

			min_z = math.min(min_z, point[2])
			max_z = math.max(max_z, point[2])
		end

		return min_x, max_x, min_z, max_z
	end

	local function IsPointInsideNode(x, z, node)
		local min_x, max_x, min_z, max_z = GetNodeBounds(node)
		return x >= min_x and x <= max_x and z >= min_z and z <= max_z
	end

	for _, data in ipairs(PREFABS_DATA) do
		local prefab = data.prefab
		local max_to_spawn = data.max_to_spawn
		local min_distance = data.min_distance
		local valid_rooms = data.valid_rooms
		local valid_tiles = data.valid_tiles

		local valid_positions = {}
		local valid_nodes = GetValidNodes(valid_rooms)

		if #valid_nodes > 0 then
			local attempts = 0
			local max_attempts = max_to_spawn * 100

			print(string.format("Retrofitting for Heap of Foods Mod - Placing '%s' randomly in valid rooms.", prefab))

			while #valid_positions < max_to_spawn and attempts < max_attempts do
				attempts = attempts + 1

				local node = valid_nodes[math.random(#valid_nodes)]

				local min_x, max_x, min_z, max_z = GetNodeBounds(node)

				local wx = math.random() * (max_x - min_x) + min_x
				local wz = math.random() * (max_z - min_z) + min_z

				if IsPointInsideNode(wx, wz, node) then
					local tile = map:GetTileAtPoint(wx, 0, wz)

					if map:IsValidTileAtPoint(wx, 0, wz)
					and map:IsVisualGroundAtPoint(wx, 0, wz)
					and IsValidTile(tile, valid_tiles)
					and IsFarFromOthers(wx, wz, valid_positions, min_distance) then
						table.insert(valid_positions,
						{
							x = wx,
							z = wz,
						})
					end
				end
			end

			print(string.format(
				"Retrofitting for Heap of Foods Mod - Found %d valid positions for '%s' after %d attempts.",
				#valid_positions,
				prefab,
				attempts
			))

			if entities[prefab] == nil then
				entities[prefab] = {}
			end

			for _, pos in ipairs(valid_positions) do
				table.insert(entities[prefab],
				{
					x = pos.x,
					z = pos.z,
				})
			end

			print(string.format("Retrofitting for Heap of Foods Mod - Added %d '%s' to the world.", #valid_positions, prefab))
		else
			print(string.format("Retrofitting for Heap of Foods Mod - Couldn't find valid rooms for '%s'.", prefab))
		end
	end
end

return
{
	HofRetrofitting_CaveTuberTrees      = HofRetrofitting_CaveTuberTrees,
	HofRetrofitting_ElderMandrakeHouses = HofRetrofitting_ElderMandrakeHouses,
}