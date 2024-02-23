require("constants")
require("mathutil")
require("map/terrain")

local obj_layout = require("map/object_layout")

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
end

local function HofRetrofitting_SerenityIsland(map, savedata)
	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents
	
	local add_fn = {fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
		local x = math.ceil((points_x[current_pos_idx] - width / 2) * TILE_SCALE)
		local y = math.ceil((points_y[current_pos_idx] - height / 2) * TILE_SCALE)
		if entitiesOut[prefab] == nil then
			entitiesOut[prefab] = {}
		end
		local save_data = {x = x, z = y}
		if prefab_data then
			if prefab_data.data then
				if type(prefab_data.data) == "function" then
					save_data["data"] = prefab_data.data()
				else
					save_data["data"] = prefab_data.data
				end
			end
			if prefab_data.id then
				save_data["id"] = prefab_data.id
			end
			if prefab_data.scenario then
				save_data["scenario"] = prefab_data.scenario
			end
		end
		table.insert(entitiesOut[prefab], save_data)
	end, args = {entitiesOut = entities, width = map_width, height = map_height, rand_offset = false, debug_prefab_list = nil}}
	
	local function TryToAddLayout(name, area_size)
		local layout = obj_layout.LayoutForDefinition(name)
		local tile_size = #layout.ground
		
		local function isvalidarea(_left, _top)
			for x = 0, area_size do
				for y = 0, area_size do
					if not IsOceanTile(map:GetTile(_left + x, _top + y)) then
						return false
					end
				end
			end
			
			return true
		end
		
		local candidates = {}
		local foundarea = false
		local num_steps = 50
		for x = 0, num_steps do
			for y = 0, num_steps do
				local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - area_size - 16) or 0)
				local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - area_size - 16) or 0)
				if isvalidarea(left, top) then
					table.insert(candidates, {top = top, left = left, distsq = VecUtil_LengthSq(left - map_width / 2, top - map_height / 2)})
				end
			end
		end
		
		if #candidates > 0 then
			local world_size = tile_size * 4
			table.sort(candidates, function(a, b) return a.distsq < b.distsq end)
			for _, candidate in ipairs(candidates) do
				local top, left = candidate.top, candidate.left
				local world_top, world_left = left * 4 - (map_width * 0.5 * 4), top * 4 - (map_height * 0.5 * 4)
				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, {"boat", "malbatross", "oceanfish_shoalspawner", "chester_eyebone", "glommerflower", "klaussackkey", "saltstack", "oceantree_pillar", "watertree_pillar"})
				if ents_to_remove ~= nil then
					print("   Removed "..tostring(#ents_to_remove).." entities for static layout:")
					for i = #ents_to_remove, 1, -1 do
						print ("   - "..tostring(ents_to_remove[i].prefab))
						table.remove(savedata.ents[ents_to_remove[i].prefab], ents_to_remove[i].index)
					end
					
					obj_layout.Place({left, top}, name, add_fn, nil, map)
					if layout.add_topology ~= nil then
						AddSquareTopology(topology, world_top, world_left, world_size, layout.add_topology.room_id, layout.add_topology.tags)
					end
					
					return true
				end
			end
		end
		
		return false
	end
	
	local success = TryToAddLayout("hof_serenityisland1", 53)
	
	if success then
		print("Retrofitting for Heap of Foods Mod - Added the Serenity Archipelago to the world.")
	else
		print("Retrofitting for Heap of Foods Mod - Failed to add the Serenity Archipelago to the world!")
	end
end

local function HofRetrofitting_MeadowIsland(map, savedata)
	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents
	
	local add_fn = {fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
		local x = math.ceil((points_x[current_pos_idx] - width / 2) * TILE_SCALE)
		local y = math.ceil((points_y[current_pos_idx] - height / 2) * TILE_SCALE)
		if entitiesOut[prefab] == nil then
			entitiesOut[prefab] = {}
		end
		local save_data = {x = x, z = y}
		if prefab_data then
			if prefab_data.data then
				if type(prefab_data.data) == "function" then
					save_data["data"] = prefab_data.data()
				else
					save_data["data"] = prefab_data.data
				end
			end
			if prefab_data.id then
				save_data["id"] = prefab_data.id
			end
			if prefab_data.scenario then
				save_data["scenario"] = prefab_data.scenario
			end
		end
		table.insert(entitiesOut[prefab], save_data)
	end, args = {entitiesOut = entities, width = map_width, height = map_height, rand_offset = false, debug_prefab_list = nil}}
	
	local function TryToAddLayout(name, area_size)
		local layout = obj_layout.LayoutForDefinition(name)
		local tile_size = #layout.ground
		
		local function isvalidarea(_left, _top)
			for x = 0, area_size do
				for y = 0, area_size do
					if not IsOceanTile(map:GetTile(_left + x, _top + y)) then
						return false
					end
				end
			end
			
			return true
		end
		
		local candidates = {}
		local foundarea = false
		local num_steps = 50
		for x = 0, num_steps do
			for y = 0, num_steps do
				local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - area_size - 16) or 0)
				local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - area_size - 16) or 0)
				if isvalidarea(left, top) then
					table.insert(candidates, {top = top, left = left, distsq = VecUtil_LengthSq(left - map_width / 2, top - map_height / 2)})
				end
			end
		end
		
		if #candidates > 0 then
			local world_size = tile_size * 4
			table.sort(candidates, function(a, b) return a.distsq < b.distsq end)
			for _, candidate in ipairs(candidates) do
				local top, left = candidate.top, candidate.left
				local world_top, world_left = left * 4 - (map_width * 0.5 * 4), top * 4 - (map_height * 0.5 * 4)
				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, {"boat", "malbatross", "oceanfish_shoalspawner", "chester_eyebone", "glommerflower", "klaussackkey", "saltstack", "oceantree_pillar", "watertree_pillar"})
				if ents_to_remove ~= nil then
					print("   Removed "..tostring(#ents_to_remove).." entities for static layout:")
					for i = #ents_to_remove, 1, -1 do
						print ("   - "..tostring(ents_to_remove[i].prefab))
						table.remove(savedata.ents[ents_to_remove[i].prefab], ents_to_remove[i].index)
					end
					
					obj_layout.Place({left, top}, name, add_fn, nil, map)
					if layout.add_topology ~= nil then
						AddSquareTopology(topology, world_top, world_left, world_size, layout.add_topology.room_id, layout.add_topology.tags)
					end
					
					return true
				end
			end
		end
		
		return false
	end
	
	local success = TryToAddLayout("hof_meadowisland1", 54)
	
	if success then
		print("Retrofitting for Heap of Foods Mod - Added the Seaside Island to the world.")
	else
		print("Retrofitting for Heap of Foods Mod - Failed to add the Seaside Island to the world!")
	end
end

return 
{
	HofRetrofitting_SerenityIsland = HofRetrofitting_SerenityIsland,
	HofRetrofitting_MeadowIsland   = HofRetrofitting_MeadowIsland,
}