local TILE_SCALE = 4
local MAX_PLACEMENT_ATTEMPTS = 50

-- inst: Prefab in the world.
-- prefab_layout_x, prefab_layout_y: Prefab's position in the layout in world tiles.
-- layout_w, layout_h: Layout's width and height in world tiles.
-- room_id: Node Topology ID.
-- tags: MapTags for the Node.
local function AddPrefabTopologyNode(inst, prefab_layout_x, prefab_layout_y, layout_w, layout_h, room_id, tags)
	if not TheWorld or not TheWorld.topology then
		if TUNING.HOF_DEBUG_MODE then
			print("Heap of Foods Mod - Retrofitting MapTags - TheWorld.topology not found.")
		end

		return
	end

	for _, id in ipairs(TheWorld.topology.ids) do
		if id == room_id then
			if TUNING.HOF_DEBUG_MODE then
				print("Heap of Foods Mod - Retrofitting MapTags - Node '"..room_id.."' already exists. Skipping.")
			end

			return
		end
	end

	local prefab_world_x, _, prefab_world_z = inst.Transform:GetWorldPosition()

	local layout_origin_x = prefab_world_x - prefab_layout_x * TILE_SCALE
	local layout_origin_z = prefab_world_z - prefab_layout_y * TILE_SCALE

	local layout_center_x = layout_origin_x + (layout_w * TILE_SCALE) / 2
	local layout_center_z = layout_origin_z + (layout_h * TILE_SCALE) / 2

	local topology = TheWorld.topology
	local index = #topology.ids + 1

	topology.ids[index] = room_id
	topology.story_depths[index] = 0

	local node = {}
	node.area = layout_w * layout_h
	node.c = 1 -- Color?
	node.cent = { layout_center_x, layout_center_z }
	node.neighbours = {}
	node.poly = 
	{
		{ layout_origin_x, layout_origin_z },
		{ layout_origin_x + layout_w * TILE_SCALE, layout_origin_z },
		{ layout_origin_x + layout_w * TILE_SCALE, layout_origin_z + layout_h * TILE_SCALE },
		{ layout_origin_x, layout_origin_z + layout_h * TILE_SCALE }
	}
	
	node.tags = tags or {}
	node.type = NODE_TYPE.Default
	node.x = node.cent[1]
	node.y = node.cent[2]
	node.validedges = {}

	topology.nodes[index] = node

	if TUNING.HOF_DEBUG_MODE then
		print(string.format("Heap of Foods Mod - Retrofitting MapTags - Added Node: '%s' to position: (%.2f, %.2f)", room_id, node.x, node.y))
	end
end

-- inst: Prefab in the world
-- rel_x, rel_y: Prefab position inside the layout (tiles, tiled/lua file)
-- layout_w, layout_h: layout position (tiles)
local function GetLayoutInfoFromPrefab(inst, rel_x, rel_y, layout_w, layout_h)
	local prefab_world_x, _, prefab_world_z = inst.Transform:GetWorldPosition()

	local prefab_layout_world_x = rel_x * TILE_SCALE
	local prefab_layout_world_z = rel_y * TILE_SCALE

	-- (0,0) of the layout in the world.
	local layout_origin_x = prefab_world_x - prefab_layout_world_x
	local layout_origin_z = prefab_world_z - prefab_layout_world_z

    -- Layout center in the world.
	local layout_center_x = layout_origin_x + (layout_w * TILE_SCALE) / 2
	local layout_center_z = layout_origin_z + (layout_h * TILE_SCALE) / 2

	return 
	{
		origin = { x = layout_origin_x, z = layout_origin_z },
		center = { x = layout_center_x, z = layout_center_z },
		prefab = { x = prefab_world_x,  z = prefab_world_z  },
	}
end

local function RetrofitOceanLayouts()
	if TheWorld.topology == nil or TheWorld.topology.nodes == nil or TheWorld.topology.ids == nil then
		if TUNING.HOF_DEBUG_MODE then
			print("Retrofitting for Heap of Foods Mod - World Topology does not exist yet. Skipping.")
		end

		return false
	end

	local dirty = false

	local serenity_ids = 
	{
		"StaticLayoutIsland: SerenityIsland", -- Old
		"StaticLayoutIsland:SerenityIsland"   -- New
	}

	local meadow_ids = 
	{
		"StaticLayoutIsland: MeadowIsland",
		"StaticLayoutIsland:MeadowIsland"
	}

	local wreck_ids = 
	{
		"StaticLayoutIsland: OceanSetPieces",
		"StaticLayoutIsland:WreckSetPieces"
	}

	local function NodeNeedsRetrofit(node, expected_tags)
		for _, tag in ipairs(expected_tags) do
			if not table.contains(node.tags or {}, tag) then
				return true
			end
		end
		
		return false
	end

	for i, node in ipairs(TheWorld.topology.nodes) do
		local id = TheWorld.topology.ids[i]
		node.tags = node.tags or {}

		for _, sid in ipairs(serenity_ids) do
			if string.find(id, sid) and NodeNeedsRetrofit(node, {"SerenityArea"}) then
				table.insert(node.tags, "SerenityArea")
				dirty = true
			end
		end

		for _, mid in ipairs(meadow_ids) do
			if string.find(id, mid) and NodeNeedsRetrofit(node, {"MeadowArea"}) then
				table.insert(node.tags, "MeadowArea")
				dirty = true
			end
		end

		for _, wid in ipairs(wreck_ids) do
			if string.find(id, wid) and NodeNeedsRetrofit(node, {"WreckArea"}) then
				table.insert(node.tags, "WreckArea")
				dirty = true
			end
			
			if string.find(id, wid) and NodeNeedsRetrofit(node, {"LowMist"}) then
				table.insert(node.tags, "LowMist")
				dirty = true
			end
		end
	end

	if dirty then
		for i, node in ipairs(TheWorld.topology.nodes) do
			if table.contains(node.tags, "SerenityArea") or
			table.contains(node.tags, "MeadowArea") or
			table.contains(node.tags, "WreckArea") or
			table.contains(node.tags, "LowMist") then
				TheWorld.Map:RepopulateNodeIdTileMap(i, node.x, node.y, node.poly, 10000, 2.1)
			end
		end
	end

	return dirty
end

-- From retrofitforestmap_anr.lua
local function RetrofitNewContentPrefab(inst, prefab, min_space, dist_from_structures, canplacefn, candidtate_nodes, on_add_prefab)
	local attempt = 1
	local topology = TheWorld.topology

	while attempt <= MAX_PLACEMENT_ATTEMPTS do
		local area = nil
		
		if candidtate_nodes ~= nil then
			area = candidtate_nodes[math.random(#candidtate_nodes)]
		else
			area = topology.nodes[math.random(#topology.nodes)]
		end

		local points_x, points_y = TheWorld.Map:GetRandomPointsForSite(area.x, area.y, area.poly, 1)
		
		if #points_x == 1 and #points_y == 1 then
			local x = points_x[1]
			local z = points_y[1]

			if (canplacefn ~= nil and canplacefn(x, 0, z, prefab)) or
				(canplacefn == nil and TheWorld.Map:CanPlacePrefabFilteredAtPoint(x, 0, z, prefab)) then
				
				local ents = TheSim:FindEntities(x, 0, z, min_space)
				
				if #ents == 0 then
					if dist_from_structures ~= nil then
						ents = TheSim:FindEntities(x, 0, z, dist_from_structures, STRUCTURE_TAGS )
					end

					if #ents == 0 then
						local e = SpawnPrefab(prefab)
						
						e.Transform:SetPosition(x, 0, z)
						
						if on_add_prefab ~= nil then
							on_add_prefab(e)
						end
						
						break
					end
				end
			end
		end
		
		attempt = attempt + 1
	end
	
	return attempt <= MAX_PLACEMENT_ATTEMPTS
end

return 
{
    GetLayoutInfoFromPrefab  = GetLayoutInfoFromPrefab,
	AddPrefabTopologyNode    = AddPrefabTopologyNode,
	RetrofitOceanLayouts     = RetrofitOceanLayouts,
	RetrofitNewContentPrefab = RetrofitNewContentPrefab,
}