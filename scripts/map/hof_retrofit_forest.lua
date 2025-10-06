require("constants")
require("mathutil")
require("map/terrain")

-- Using custom, becuase Klei has changed how it behaves
-- causing our island to be placed incorrectly.
-- local obj_layout = require("map/hof_object_layout")
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
	
	return index
end

local function AddTileNodeIdsForArea(world_map, node_index, left, top, size)
	for x = left, left + size do
		for y = top, top + size do
			world_map:SetTileNodeId(x, y, node_index)
		end
	end
end

local function HofRetrofitting_SerenityIsland(map, savedata)
	local obj_layout = require("map/object_layout")

	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents

	local add_fn = 
	{
		fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
			local x = (points_x[current_pos_idx] - width / 2.0) * TILE_SCALE
			local y = (points_y[current_pos_idx] - height / 2.0) * TILE_SCALE
				
			x = math.floor(x * 100) / 100.0
			y = math.floor(y * 100) / 100.0
			
			if entitiesOut[prefab] == nil then
				entitiesOut[prefab] = {}
			end
			
			local save_data = {x=x, z=y}
			
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
		end,
		
		args = { entitiesOut = entities, width = map_width, height = map_height, rand_offset = false, debug_prefab_list = nil }
	}
	
	local function is_rough_or_swell_ocean(_left, _top, tile_size)
		for x = 0, tile_size do
			for y = 0, tile_size do
				local tile = map:GetTile(_left + x, _top + y)
				
				if tile ~= WORLD_TILES.OCEAN_ROUGH and tile ~= WORLD_TILES.OCEAN_SWELL then
					return false
				end
			end
		end
		
		return true
	end

	local function TryToAddLayout(name, topology_delta)--, isvalidareafn)
		local layout = obj_layout.LayoutForDefinition(name)
		local tile_size = #layout.ground

		topology_delta = topology_delta or 1

		local candidtates = {}
		local foundarea = false
		local num_steps = math.floor((map_width - tile_size) / tile_size)
		
		for x = 0, num_steps do
			for y = 0, num_steps do
				local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - tile_size - 16) or 0)
				local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - tile_size - 16) or 0)

				table.insert(candidtates, {top = top, left = left})
			end
		end
		
		print("   " ..tostring(#candidtates) .. " candidtate locations")

		if #candidtates > 0 then
			local topology_size = (tile_size + (topology_delta * 2))
			local world_size = topology_size * TILE_SCALE

			shuffleArray(candidtates)
			
			for _, candidtate in ipairs(candidtates) do
				local top, left = candidtates[1].top, candidtates[1].left
				local world_top, world_left = (left - topology_delta) * TILE_SCALE - (map_width * 0.5 * TILE_SCALE), (top - topology_delta) * TILE_SCALE - (map_height * 0.5 * TILE_SCALE)
				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, 
				{
					"boat", "malbatross", "oceanfish_shoalspawner", "chester_eyebone", 
					"glommerflower", "klaussackkey", "crabking", "oceantree", "waterplant_base"
				})
				
				if ents_to_remove ~= nil then
					print("   Removed " .. tostring(#ents_to_remove) .. " entities for static layout:")
					
					for i = #ents_to_remove, 1, -1 do
						print ("   - " .. tostring(ents_to_remove[i].prefab) .. " " )
						table.remove(savedata.ents[ents_to_remove[i].prefab], ents_to_remove[i].index)
					end

					obj_layout.Place({left, top}, name, add_fn, nil, map)
					
					if layout.add_topology ~= nil then
						local topology_node_index = AddSquareTopology(topology, world_top, world_left, world_size, layout.add_topology.room_id, layout.add_topology.tags)
						AddTileNodeIdsForArea(map, topology_node_index, left + 1, top + 1, topology_size)
					end

					return true
				end
			end
		end
		
		return false
	end
	
	local success = TryToAddLayout("SerenityIsland", 1)
	
	if success then
		print("Retrofitting for Heap of Foods Mod - Added the Serenity Archipelago to the world.")
	else
		print("Retrofitting for Heap of Foods Mod - Failed to add the Serenity Archipelago to the world!")
	end
end

local function HofRetrofitting_MeadowIsland(map, savedata)
	local obj_layout = require("map/object_layout")

	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents

	local add_fn = 
	{
		fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
			local x = (points_x[current_pos_idx] - width / 2.0) * TILE_SCALE
			local y = (points_y[current_pos_idx] - height / 2.0) * TILE_SCALE
				
			x = math.floor(x * 100) / 100.0
			y = math.floor(y * 100) / 100.0
			
			if entitiesOut[prefab] == nil then
				entitiesOut[prefab] = {}
			end
			
			local save_data = {x=x, z=y}
			
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
		end,
		
		args = { entitiesOut = entities, width = map_width, height = map_height, rand_offset = false, debug_prefab_list = nil }
	}
	
	local function is_rough_or_swell_ocean(_left, _top, tile_size)
		for x = 0, tile_size do
			for y = 0, tile_size do
				local tile = map:GetTile(_left + x, _top + y)
				
				if tile ~= WORLD_TILES.OCEAN_ROUGH and tile ~= WORLD_TILES.OCEAN_SWELL then
					return false
				end
			end
		end
		
		return true
	end

	local function TryToAddLayout(name, topology_delta)--, isvalidareafn)
		local layout = obj_layout.LayoutForDefinition(name)
		local tile_size = #layout.ground

		topology_delta = topology_delta or 1

		local candidtates = {}
		local foundarea = false
		local num_steps = math.floor((map_width - tile_size) / tile_size)
		
		for x = 0, num_steps do
			for y = 0, num_steps do
				local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - tile_size - 16) or 0)
				local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - tile_size - 16) or 0)

				table.insert(candidtates, {top = top, left = left})
			end
		end
		
		print("   " ..tostring(#candidtates) .. " candidtate locations")

		if #candidtates > 0 then
			local topology_size = (tile_size + (topology_delta * 2))
			local world_size = topology_size * TILE_SCALE

			shuffleArray(candidtates)
			
			for _, candidtate in ipairs(candidtates) do
				local top, left = candidtates[1].top, candidtates[1].left
				local world_top, world_left = (left - topology_delta) * TILE_SCALE - (map_width * 0.5 * TILE_SCALE), (top - topology_delta) * TILE_SCALE - (map_height * 0.5 * TILE_SCALE)
				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, 
				{
					"boat", "malbatross", "oceanfish_shoalspawner", "chester_eyebone", 
					"glommerflower", "klaussackkey", "crabking", "oceantree", "waterplant_base"
				})
				
				if ents_to_remove ~= nil then
					print("   Removed " .. tostring(#ents_to_remove) .. " entities for static layout:")
					
					for i = #ents_to_remove, 1, -1 do
						print ("   - " .. tostring(ents_to_remove[i].prefab) .. " " )
						table.remove(savedata.ents[ents_to_remove[i].prefab], ents_to_remove[i].index)
					end

					obj_layout.Place({left, top}, name, add_fn, nil, map)
					
					if layout.add_topology ~= nil then
						local topology_node_index = AddSquareTopology(topology, world_top, world_left, world_size, layout.add_topology.room_id, layout.add_topology.tags)
						AddTileNodeIdsForArea(map, topology_node_index, left + 1, top + 1, topology_size)
					end

					return true
				end
			end
		end
		
		return false
	end
	
	local success = TryToAddLayout("MeadowIsland", 1)
	
	if success then
		print("Retrofitting for Heap of Foods Mod - Added the Seaside Island to the world.")
	else
		print("Retrofitting for Heap of Foods Mod - Failed to add the Seaside Island to the world!")
	end
end

local function HofRetrofitting_OceanSetpieces(map, savedata, max_count)
	max_count = max_count or 4

	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents

	local add_fn = {fn=function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
				local x = (points_x[current_pos_idx] - width/2.0)*TILE_SCALE
				local y = (points_y[current_pos_idx] - height/2.0)*TILE_SCALE
				
				x = math.floor(x*100)/100.0
				y = math.floor(y*100)/100.0
				
				if entitiesOut[prefab] == nil then
					entitiesOut[prefab] = {}
				end
				
				local save_data = {x=x, z=y}
				
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
			end,
			args={entitiesOut=entities, width=map_width, height=map_height, rand_offset = false, debug_prefab_list=nil}
		}

	local function is_rough_or_hazardous_ocean(_left, _top, tile_size)
		for x = 0, tile_size do
			for y = 0, tile_size do
				local tile = map:GetTile(_left + x, _top + y)
				
				if tile ~= WORLD_TILES.OCEAN_ROUGH and tile ~= WORLD_TILES.OCEAN_HAZARDOUS then
					return false
				end
			end
		end
		
		return true
	end
	
	local function is_rough_or_swell_ocean(_left, _top, tile_size)
		for x = 0, tile_size do
			for y = 0, tile_size do
				local tile = map:GetTile(_left + x, _top + y)
				
				if tile ~= WORLD_TILES.OCEAN_ROUGH and tile ~= WORLD_TILES.OCEAN_SWELL then
					return false
				end
			end
		end
		
		return true
	end

	local function TryToAddLayout(name, topology_delta, isvalidareafn)
		local layout = obj_layout.LayoutForDefinition(name)
		local tile_size = #layout.ground

		topology_delta = topology_delta or 1

		local candidtates = {}
		local foundarea = false
		local num_steps = math.floor((map_width - tile_size) / tile_size)
		
		for x = 0, num_steps do
			for y = 0, num_steps do
				local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - tile_size - 16) or 0)
				local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - tile_size - 16) or 0)
				
				if isvalidareafn(left, top, tile_size) then
					table.insert(candidtates, {top = top, left = left})
				end
			end
		end
		
		print("   " ..tostring(#candidtates) .. " candidtate locations")

		if #candidtates > 0 then
			local world_size = (tile_size + (topology_delta*2))*4

			shuffleArray(candidtates)
			
			for _, candidtate in ipairs(candidtates) do
				local top, left = candidtates[1].top, candidtates[1].left
				local world_top, world_left = (left-topology_delta)*4 - (map_width * 0.5 * 4), (top-topology_delta)*4 - (map_height * 0.5 * 4)

				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, {"boat", "malbatross", 
				"oceanfish_shoalspawner", "chester_eyebone", "glommerflower", "klaussackkey"})
				
				if ents_to_remove ~= nil then
					print("   Removed " .. tostring(#ents_to_remove) .. " entities for static layout:")
					
					for i = #ents_to_remove, 1, -1 do
						print ("   - " .. tostring(ents_to_remove[i].prefab) .. " " )
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

	local ocean_sets = 
	{
		rough_swell =
		{
			"hof_oceansetpiece_crates",
			"hof_oceansetpiece_crates2",
			"hof_oceansetpiece_seaweeds",
			"hof_oceansetpiece_taroroot",
			"hof_oceansetpiece_waterycress",
		},
		
		rough_hazardous = 
		{ 
			"hof_oceansetpiece_crates",
			"hof_oceansetpiece_crates2",
			"hof_oceansetpiece_graveyard1",
			"hof_oceansetpiece_graveyard2",
		},
	}

	for category, setlist in pairs(ocean_sets) do
		for _, set in ipairs(setlist) do
			local copies = math.random(1, max_count)
			
			for i = 1, copies do
				local success
                
				if category == "rough_swell" then
					success = TryToAddLayout(set, 0, is_rough_or_swell_ocean)
				else
                    success = TryToAddLayout(set, 0, is_rough_or_hazardous_ocean)
				end
				
				if success then
					print("Retrofitting for Heap of Foods Mod - Added Ocean Setpiece: "..set.." In Ocean Type: "..category.." to the world.")
                else
					print("Retrofitting for Heap of Foods Mod - Failed to add Ocean Setpieces to the world!")
				end
			end
		end
	end
end

return 
{
	HofRetrofitting_SerenityIsland = HofRetrofitting_SerenityIsland,
	HofRetrofitting_MeadowIsland   = HofRetrofitting_MeadowIsland,
	HofRetrofitting_OceanSetpieces = HofRetrofitting_OceanSetpieces,
}

--[[
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
				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, {"boat", "malbatross", 
				"oceanfish_shoalspawner", "chester_eyebone", "glommerflower", "klaussackkey", "saltstack", "oceantree_pillar", "watertree_pillar"})
				
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
	
	local success = TryToAddLayout("SerenityIsland", 53)
	
	if success then
		print("Retrofitting for Heap of Foods Mod - Added the Serenity Archipelago to the world.")
	else
		print("Retrofitting for Heap of Foods Mod - Failed to add the Serenity Archipelago to the world!")
	end
end
]]--