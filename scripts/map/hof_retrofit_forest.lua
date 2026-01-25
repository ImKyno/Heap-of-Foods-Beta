require("constants")
require("mathutil")
require("map/terrain")

local HOF_MAPUTIL = require("map/hof_maputil")
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

	local function TryToAddLayout(name, area_size, topology_delta)
		local layout = obj_layout.LayoutForDefinition(name)
		local tile_size = #layout.ground

		topology_delta = topology_delta or 1
		
		local function isvalidareafn(_left, _top)
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

				if isvalidareafn(left, top) then
					table.insert(candidates, {top = top, left = left, distsq = VecUtil_LengthSq(left - map_width / 2, top - map_height / 2)})
				end
			end
		end
		
		print("   " ..tostring(#candidates) .. " candidtate locations")

		if #candidates > 0 then
			local world_size = tile_size * 4
			
			table.sort(candidates, function(a, b) return a.distsq < b.distsq end)
			
			for _, candidate in ipairs(candidates) do
				local top, left = candidate.top, candidate.left
				local world_top, world_left = left * 4 - (map_width * 0.5 * 4), top * 4 - (map_height * 0.5 * 4)
				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, 
				{
					"boat", "boat_ancient", "chester_eyebone", "glommerflower", "underwater_salvageable", "oceantree_pillar", 
					"watertree_pillar", "crabking", "crabking_spawner", "oceanwhirlbigportal", "oceanwhirlportal", "kyno_octopusking_ocean",
				})
				
				if ents_to_remove ~= nil then
					print("   Removed "..tostring(#ents_to_remove).." entities for static layout:")
					
					for i = #ents_to_remove, 1, -1 do
						print ("   - "..tostring(ents_to_remove[i].prefab))
						table.remove(savedata.ents[ents_to_remove[i].prefab], ents_to_remove[i].index)
					end
					
					obj_layout.Place({left, top}, name, add_fn, nil, map)
					
					if layout.add_topology ~= nil then
						AddSquareTopology(topology, world_top, world_left, world_size, "StaticLayoutIsland:DUMMY_SERENITY1", {"not_mainland"})
						AddSquareTopology(topology, world_top, world_left, world_size, "StaticLayoutIsland:DUMMY_SERENITY2", {"not_mainland"})
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
	
	local function TryToAddLayout(name, area_size, topology_delta)
		local layout = obj_layout.LayoutForDefinition(name)
		local tile_size = #layout.ground

		topology_delta = topology_delta or 1
		
		local function isvalidareafn(_left, _top)
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

				if isvalidareafn(left, top) then
					table.insert(candidates, {top = top, left = left, distsq = VecUtil_LengthSq(left - map_width / 2, top - map_height / 2)})
				end
			end
		end
		
		print("   " ..tostring(#candidates) .. " candidtate locations")

		if #candidates > 0 then
			local world_size = tile_size * 4
			
			table.sort(candidates, function(a, b) return a.distsq < b.distsq end)
			
			for _, candidate in ipairs(candidates) do
				local top, left = candidate.top, candidate.left
				local world_top, world_left = left * 4 - (map_width * 0.5 * 4), top * 4 - (map_height * 0.5 * 4)
				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, 
				{
					"boat", "boat_ancient", "chester_eyebone", "glommerflower", "underwater_salvageable", "oceantree_pillar", 
					"watertree_pillar", "crabking", "crabking_spawner", "oceanwhirlbigportal", "oceanwhirlportal", "kyno_octopusking_ocean",
				})
				
				if ents_to_remove ~= nil then
					print("   Removed "..tostring(#ents_to_remove).." entities for static layout:")
					
					for i = #ents_to_remove, 1, -1 do
						print ("   - "..tostring(ents_to_remove[i].prefab))
						table.remove(savedata.ents[ents_to_remove[i].prefab], ents_to_remove[i].index)
					end
					
					obj_layout.Place({left, top}, name, add_fn, nil, map)
					
					if layout.add_topology ~= nil then
						AddSquareTopology(topology, world_top, world_left, world_size, "StaticLayoutIsland:DUMMY_MEADOW1", {"not_mainland"})
						AddSquareTopology(topology, world_top, world_left, world_size, "StaticLayoutIsland:DUMMY_MEADOW2", {"not_mainland"})
						AddSquareTopology(topology, world_top, world_left, world_size, layout.add_topology.room_id, layout.add_topology.tags)
					end
					
					return true
				end
			end
		end
		
		return false
	end
	
	local success = TryToAddLayout("MeadowIsland", 53)
	
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

	local add_fn = 
	{
		fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
			local x = (points_x[current_pos_idx] - width/2.0) * TILE_SCALE
			local y = (points_y[current_pos_idx] - height/2.0) * TILE_SCALE
				
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

				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, 
				{
					"boat", "boat_ancient", "chester_eyebone", "glommerflower", "underwater_salvageable", "oceantree_pillar", 
					"watertree_pillar", "crabking", "crabking_spawner", "oceanwhirlbigportal", "oceanwhirlportal", "kyno_octopusking_ocean",
				})
				
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

local function HofRetrofitting_DeciduousForestShop(map, savedata)
	local obj_layout = require("map/object_layout")

	local VALID_ROOMS = 
	{
		"DeepDeciduous",
		"MagicalDeciduous",
		"DeciduousMole",
		"MolesvilleDeciduous",
		"DeciduousClearing",
		"PondyGrass",
		"PigKingdom", -- Required for Classic Worldgen.
	}

	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents
	
	local add_fn = 
	{
		fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
			local x = (points_x[current_pos_idx] - width / 2) * TILE_SCALE
			local y = (points_y[current_pos_idx] - height / 2) * TILE_SCALE
				
			x = math.floor(x * 100) / 100.0
			y = math.floor(y * 100) / 100.0
				
			if entitiesOut[prefab] == nil then
				entitiesOut[prefab] = {}
			end
				
			local save_data = { x = x, z = y }
				
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
		
		args = { entitiesOut = entities, width = map_width, height = map_height, rand_offset = false, debug_prefab_list = nil}
	}

	local shop_candidate_nodes = {}
	
	for node_index, id_string in ipairs(topology.ids) do
		for _, bg_string in ipairs(VALID_ROOMS) do
			if id_string:find(bg_string) then
				table.insert(shop_candidate_nodes, topology.nodes[node_index])
			end
		end
	end

	if #shop_candidate_nodes == 0 then
		print("Retrofitting for Heap of Foods Mod - Couldn't find a valid node!")
		return
	end

	local function PlaceLayoutAtNode(node, name)
		local layout = obj_layout.LayoutForDefinition(name)

		local area_size = 40
		local num_steps = 50
		local tile_size = #layout.ground

		local candidates = {}
		local valid_candidates = {}
		
		for x = 0, num_steps do
			for y = 0, num_steps do
				local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - area_size - 16) or 0)
				local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - area_size - 16) or 0)

				table.insert(candidates, {left = left, top = top, distsq = VecUtil_LengthSq(left - map_width / 2, top - map_height / 2), })
			end
		end
		
		print("Retrofitting for Heap of Foods Mod - Found " .. tostring(#candidates) .. " candidate locations.")

		local min_x, max_x, min_y, max_y = node.poly[1][1], node.poly[1][1], node.poly[1][2], node.poly[1][2]
		
		for _, point in ipairs(node.poly) do
			min_x = math.min(min_x, point[1])
			max_x = math.max(max_x, point[1])
			min_y = math.min(min_y, point[2])
			max_y = math.max(max_y, point[2])
		end

		for _, c in ipairs(candidates) do
			local wx = (c.left - map_width/2) * TILE_SCALE
			local wy = (c.top - map_height/2) * TILE_SCALE

			if wx >= min_x and wx <= max_x and wy >= min_y and wy <= max_y then
				table.insert(valid_candidates, c)
			end
		end

		print("Retrofitting for Heap of Foods Mod - " .. tostring(#valid_candidates) .. " candidates locations inside node.")

		if #valid_candidates == 0 then
			print("Retrofitting for Heap of Foods Mod - Couldn't find valid location inside biome.")
			return false
		end

		table.sort(valid_candidates, function(a, b)
			local da = VecUtil_LengthSq(a.left - node.x, a.top - node.y)
			local db = VecUtil_LengthSq(b.left - node.x, b.top - node.y)
		
			return da < db
		end)

		local candidate = valid_candidates[1]
		local left, top = candidate.left, candidate.top
		
		local function ClearLayoutArea(savedata, layout, pos)
			local left, top = pos[1], pos[2]

			local layout_w = #layout.ground[1] or 10
			local layout_h = #layout.ground or 10
			local radius = math.max(layout_w, layout_h) * TILE_SCALE * 0.6

			-- local world_x = left * TILE_SCALE - (map_width * TILE_SCALE * 0.5)
			-- local world_y = top * TILE_SCALE - (map_height * TILE_SCALE * 0.5)
			local world_x = (left - map_width / 2) * TILE_SCALE + (layout_w * TILE_SCALE) / 2
			local world_y = (top - map_height / 2) * TILE_SCALE + (layout_h * TILE_SCALE) / 2

			local blacklist = 
			{
				pigking = true,
				glommer = true,
				glommerflower = true,
				statueglommer = true,
				klaussackkey = true,
				chester_eyebone = true,
				insanityrock = true,
				sanityrock = true,
				lunarrift_portal = true,
				lunarrift_crystal_big = true,
			}
			
			print(string.format("Retrofitting for Heap of Foods Mod - Clearing area: (%.2f, %.2f), radius %.2f", world_x, world_y, radius))
			local ents_to_remove = FindEntsInArea(savedata.ents, world_x - radius, world_y - radius, radius * 2)

			if not ents_to_remove or #ents_to_remove == 0 then
				print("Retrofitting for Heap of Foods Mod - Nothing to clear in the area.")
				return
			end

			local removed = 0
			
			for i = #ents_to_remove, 1, -1 do
				local ent = ents_to_remove[i]
				
				if not blacklist[ent.prefab] then
					table.remove(savedata.ents[ent.prefab], ent.index)
					removed = removed + 1
					print("Retrofitting for Heap of Foods Mod - Removed: " .. tostring(ent.prefab))
				else
					print("Retrofitting for Heap of Foods Mod - Preserved: " .. tostring(ent.prefab))
				end
			end

			print("Retrofitting for Heap of Foods Mod - Area cleared. Removed entities: " .. tostring(removed))
		end

		ClearLayoutArea(savedata, layout, {left, top})
		obj_layout.Place({left, top}, name, add_fn, nil, map)
		
		print("Retrofitting for Heap of Foods Mod - Added Deciduous Forest Shop to the world.")
		return true
	end

	local node = shop_candidate_nodes[math.random(#shop_candidate_nodes)]

	if not PlaceLayoutAtNode(node, "FruitTreeShop") then
		print("Retrofitting for Heap of Foods Mod - Failed to add Deciduous Forest Shop to the world!")
	end
end

local function HofRetrofitting_DinaMemorial(map, savedata)
	local obj_layout = require("map/object_layout")

	local VALID_ROOMS = 
	{
		"BGForest", 
		"DeepForest", 
		"Forest", 
		"BGCrappyForest", 
		"CrappyDeepForest", 
		"CrappyForest",
		"SpiderForest", 
		"MoonbaseOne",
	}

	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents
	
	local add_fn = 
	{
		fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
			local x = (points_x[current_pos_idx] - width / 2) * TILE_SCALE
			local y = (points_y[current_pos_idx] - height / 2) * TILE_SCALE
				
			x = math.floor(x * 100) / 100.0
			y = math.floor(y * 100) / 100.0
				
			if entitiesOut[prefab] == nil then
				entitiesOut[prefab] = {}
			end
				
			local save_data = { x = x, z = y }
				
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
		
		args = { entitiesOut = entities, width = map_width, height = map_height, rand_offset = false, debug_prefab_list = nil}
	}

	local shop_candidate_nodes = {}
	
	for node_index, id_string in ipairs(topology.ids) do
		for _, bg_string in ipairs(VALID_ROOMS) do
			if id_string:find(bg_string) then
				table.insert(shop_candidate_nodes, topology.nodes[node_index])
			end
		end
	end

	if #shop_candidate_nodes == 0 then
		print("Retrofitting for Heap of Foods Mod - Couldn't find a valid node!")
		return
	end

	local function PlaceLayoutAtNode(node, name)
		local layout = obj_layout.LayoutForDefinition(name)

		local area_size = 20
		local num_steps = 30
		local tile_size = #layout.ground

		local candidates = {}
		local valid_candidates = {}
		
		for x = 0, num_steps do
			for y = 0, num_steps do
				local left = 8 + (x > 0 and ((x * math.floor(map_width / num_steps)) - area_size - 16) or 0)
				local top  = 8 + (y > 0 and ((y * math.floor(map_height / num_steps)) - area_size - 16) or 0)

				table.insert(candidates, {left = left, top = top, distsq = VecUtil_LengthSq(left - map_width / 2, top - map_height / 2), })
			end
		end
		
		print("Retrofitting for Heap of Foods Mod - Found " .. tostring(#candidates) .. " candidate locations.")

		local min_x, max_x, min_y, max_y = node.poly[1][1], node.poly[1][1], node.poly[1][2], node.poly[1][2]
		
		for _, point in ipairs(node.poly) do
			min_x = math.min(min_x, point[1])
			max_x = math.max(max_x, point[1])
			min_y = math.min(min_y, point[2])
			max_y = math.max(max_y, point[2])
		end

		for _, c in ipairs(candidates) do
			local wx = (c.left - map_width/2) * TILE_SCALE
			local wy = (c.top - map_height/2) * TILE_SCALE

			if wx >= min_x and wx <= max_x and wy >= min_y and wy <= max_y then
				table.insert(valid_candidates, c)
			end
		end

		print("Retrofitting for Heap of Foods Mod - " .. tostring(#valid_candidates) .. " candidates locations inside node.")

		if #valid_candidates == 0 then
			print("Retrofitting for Heap of Foods Mod - Couldn't find valid location inside biome.")
			return false
		end

		table.sort(valid_candidates, function(a, b)
			local da = VecUtil_LengthSq(a.left - node.x, a.top - node.y)
			local db = VecUtil_LengthSq(b.left - node.x, b.top - node.y)
		
			return da < db
		end)

		local candidate = valid_candidates[1]
		local left, top = candidate.left, candidate.top
		
		local function ClearLayoutArea(savedata, layout, pos)
			local left, top = pos[1], pos[2]

			local layout_w = #layout.ground[1] or 10
			local layout_h = #layout.ground or 10
			local radius = math.max(layout_w, layout_h) * TILE_SCALE * 0.6

			-- local world_x = left * TILE_SCALE - (map_width * TILE_SCALE * 0.5)
			-- local world_y = top * TILE_SCALE - (map_height * TILE_SCALE * 0.5)
			local world_x = (left - map_width / 2) * TILE_SCALE + (layout_w * TILE_SCALE) / 2
			local world_y = (top - map_height / 2) * TILE_SCALE + (layout_h * TILE_SCALE) / 2

			local blacklist = 
			{
				moonbase = true,
				livingtree = true,
				mandrake_planted = true,
				lunarrift_portal = true,
				lunarrift_crystal_big = true,
			}
			
			print(string.format("Retrofitting for Heap of Foods Mod - Clearing area: (%.2f, %.2f), radius %.2f", world_x, world_y, radius))
			local ents_to_remove = FindEntsInArea(savedata.ents, world_x - radius, world_y - radius, radius * 2)

			if not ents_to_remove or #ents_to_remove == 0 then
				print("Retrofitting for Heap of Foods Mod - Nothing to clear in the area.")
				return
			end

			local removed = 0
			
			for i = #ents_to_remove, 1, -1 do
				local ent = ents_to_remove[i]
				
				if not blacklist[ent.prefab] then
					table.remove(savedata.ents[ent.prefab], ent.index)
					removed = removed + 1
					print("Retrofitting for Heap of Foods Mod - Removed: " .. tostring(ent.prefab))
				else
					print("Retrofitting for Heap of Foods Mod - Preserved: " .. tostring(ent.prefab))
				end
			end

			print("Retrofitting for Heap of Foods Mod - Area cleared. Removed entities: " .. tostring(removed))
		end

		ClearLayoutArea(savedata, layout, {left, top})
		obj_layout.Place({left, top}, name, add_fn, nil, map)
		
		print("Retrofitting for Heap of Foods Mod - Added Dina Memorial to the world.")
		return true
	end

	local node = shop_candidate_nodes[math.random(#shop_candidate_nodes)]

	if not PlaceLayoutAtNode(node, "DinaMemorial") then
		print("Retrofitting for Heap of Foods Mod - Failed to add Dina Memorial to the world!")
	end
end

local function HofRetrofitting_OctopusKingShop(map, savedata)
	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents

	local add_fn = 
	{
		fn = function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
			local x = (points_x[current_pos_idx] - width/2.0) * TILE_SCALE
			local y = (points_y[current_pos_idx] - height/2.0) * TILE_SCALE
				
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

	local VALID_TILES = 
	{
		[WORLD_TILES.OCEAN_SWELL] = true,
		[WORLD_TILES.OCEAN_ROUGH] = true,
		[WORLD_TILES.OCEAN_HAZARDOUS] = true,
	}
	
	local function is_valid_ocean(_left, _top, tile_size)
		for x = 0, tile_size do
			for y = 0, tile_size do
				local tile = map:GetTile(_left + x, _top + y)
				
				if not VALID_TILES[tile] then
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

				local ents_to_remove = FindEntsInArea(savedata.ents, world_top - 5, world_left - 5, world_size + 10, 
				{
					"boat", "boat_ancient", "chester_eyebone", "glommerflower", "underwater_salvageable", "oceantree_pillar", 
					"watertree_pillar", "crabking", "crabking_spawner", "oceanwhirlbigportal", "oceanwhirlportal", "kyno_octopusking_ocean",
				})
				
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

	local success = TryToAddLayout("OctopusKingShop", 0, is_valid_ocean)

	if success then
		print("Retrofitting for Heap of Foods Mod - Added Yaarctopus Trading Post to the world.")
	else
		print("Retrofitting for Heap of Foods Mod - Failed to add Yaarctopus Trading Post to the world!")
	end
end

local function HofRetrofitting_JellyfishSpawners(map, savedata)
	local PREFABS_DATA = 
	{
		{
			prefab = "kyno_jellyfish_spawner",
			max_to_spawn = 25,
			min_distance = 40,
			
			valid_tiles = 
			{
				WORLD_TILES.OCEAN_COASTAL,
				WORLD_TILES.OCEAN_SWELL,
				WORLD_TILES.OCEAN_ROUGH,
			},
		},
		{
			prefab = "kyno_jellyfish_rainbow_spawner",
			max_to_spawn = 15,
			min_distance = 40,
			
			valid_tiles = 
			{
				WORLD_TILES.OCEAN_SWELL,
				WORLD_TILES.OCEAN_ROUGH,
				WORLD_TILES.OCEAN_HAZARDOUS,
			},
		},
	}

	local function IsValidOceanTile(tile, valid_tiles)
		for _, valid in ipairs(valid_tiles) do
			if tile == valid then
				return true
			end
		end
		
		return false
	end

	local function IsFarFromOthers(x, z, points, min_dist)
		for _, p in ipairs(points) do
			if VecUtil_LengthSq(p.x - x, p.z - z) < (min_dist * min_dist) then
				return false
			end
		end
		
		return true
	end

	local width = savedata.map.width
	local height = savedata.map.height
	local entities = savedata.ents

	for _, data in ipairs(PREFABS_DATA) do
		local prefab = data.prefab
		local max_to_spawn = data.max_to_spawn
		local min_distance = data.min_distance
		local valid_tiles = data.valid_tiles
		local valid_positions = {}
		local attempts = 0
		local max_attempts = max_to_spawn * 50

		print(string.format("Retrofitting for Heap of Foods Mod - Placing '%s' randomly at the ocean.", prefab))

		while #valid_positions < max_to_spawn and attempts < max_attempts do
			attempts = attempts + 1

			local x = math.random(1, width)
			local y = math.random(1, height)
			local tile = map:GetTile(x, y)

			if IsValidOceanTile(tile, valid_tiles) then
				local wx = (x - width / 2) * TILE_SCALE
				local wz = (y - height / 2) * TILE_SCALE

				if IsFarFromOthers(wx, wz, valid_positions, min_distance) then
					table.insert(valid_positions, { x = wx, z = wz })
				end
			end
		end

		print(string.format("Retrofitting for Heap of Foods Mod - %d valid positions found '%s' after %d attempts.", #valid_positions, prefab, attempts))

		if entities[prefab] == nil then
			entities[prefab] = {}
		end

		for _, pos in ipairs(valid_positions) do
			table.insert(entities[prefab], { x = pos.x, z = pos.z })
		end

		print(string.format("Retrofitting for Heap of Foods Mod - Added %d '%s' to the world.", #valid_positions, prefab))
	end
end

local function HofRetrofitting_DogfishSpawners(map, savedata)
	local prefab_to_spawn = "kyno_dogfish_spawner"
	local max_to_spawn = 30
	local min_distance = 60

	local VALID_TILES =
	{
		WORLD_TILES.OCEAN_COASTAL,
		WORLD_TILES.OCEAN_SWELL,
		WORLD_TILES.OCEAN_ROUGH,
		WORLD_TILES.OCEAN_HAZARDOUS,
	}

	local function IsValidOceanTile(tile)
		for _, valid in ipairs(VALID_TILES) do
			if tile == valid then
				return true
			end
		end
		
		return false
	end

	local function IsFarFromOthers(x, z, points, min_dist)
		for _, p in ipairs(points) do
			if VecUtil_LengthSq(p.x - x, p.z - z) < (min_dist * min_dist) then
				return false
			end
		end
		
		return true
	end

	local width = savedata.map.width
	local height = savedata.map.height
	local entities = savedata.ents

	local valid_positions = {}
	local attempts = 0
	local max_attempts = max_to_spawn * 50

	print("Retrofitting for Heap of Foods Mod - Placing '".. prefab_to_spawn .. "' randomly at the ocean.")

	while #valid_positions < max_to_spawn and attempts < max_attempts do
		attempts = attempts + 1

		local x = math.random(1, width)
		local y = math.random(1, height)
		local tile = map:GetTile(x, y)

		if IsValidOceanTile(tile) then
			local wx = (x - width / 2) * TILE_SCALE
			local wz = (y - height / 2) * TILE_SCALE

			if IsFarFromOthers(wx, wz, valid_positions, min_distance) then
				table.insert(valid_positions, {x = wx, z = wz})
			end
		end
	end

	print(string.format("Retrofitting for Heap of Foods Mod - %d valid positions found after %d attempts.", #valid_positions, attempts))

	if entities[prefab_to_spawn] == nil then
		entities[prefab_to_spawn] = {}
	end

	for _, pos in ipairs(valid_positions) do
		table.insert(entities[prefab_to_spawn], { x = pos.x, z = pos.z })
	end

	print(string.format("Retrofitting for Heap of Foods Mod - Added %d '%s' to the world.", #valid_positions, prefab_to_spawn))
end

local function HofRetrofitting_PufferSpawners(map, savedata)
	local prefab_to_spawn = "kyno_puffermonster_spawner"
	local max_to_spawn = 30
	local min_distance = 60

	local VALID_TILES =
	{
		WORLD_TILES.OCEAN_COASTAL,
		WORLD_TILES.OCEAN_SWELL,
		WORLD_TILES.OCEAN_ROUGH,
		WORLD_TILES.OCEAN_HAZARDOUS,
	}

	local function IsValidOceanTile(tile)
		for _, valid in ipairs(VALID_TILES) do
			if tile == valid then
				return true
			end
		end
		
		return false
	end

	local function IsFarFromOthers(x, z, points, min_dist)
		for _, p in ipairs(points) do
			if VecUtil_LengthSq(p.x - x, p.z - z) < (min_dist * min_dist) then
				return false
			end
		end
		
		return true
	end

	local width = savedata.map.width
	local height = savedata.map.height
	local entities = savedata.ents

	local valid_positions = {}
	local attempts = 0
	local max_attempts = max_to_spawn * 50

	print("Retrofitting for Heap of Foods Mod - Placing '".. prefab_to_spawn .. "' randomly at the ocean.")

	while #valid_positions < max_to_spawn and attempts < max_attempts do
		attempts = attempts + 1

		local x = math.random(1, width)
		local y = math.random(1, height)
		local tile = map:GetTile(x, y)

		if IsValidOceanTile(tile) then
			local wx = (x - width / 2) * TILE_SCALE
			local wz = (y - height / 2) * TILE_SCALE

			if IsFarFromOthers(wx, wz, valid_positions, min_distance) then
				table.insert(valid_positions, {x = wx, z = wz})
			end
		end
	end

	print(string.format("Retrofitting for Heap of Foods Mod - %d valid positions found after %d attempts.", #valid_positions, attempts))

	if entities[prefab_to_spawn] == nil then
		entities[prefab_to_spawn] = {}
	end

	for _, pos in ipairs(valid_positions) do
		table.insert(entities[prefab_to_spawn], { x = pos.x, z = pos.z })
	end

	print(string.format("Retrofitting for Heap of Foods Mod - Added %d '%s' to the world.", #valid_positions, prefab_to_spawn))
end

local function HofRetrofitting_PackimBaggims(map, savedata)
	local VALID_ROOMS =
	{
		"MeadowArea",
		"MeadowIsland",
	}

	local topology = savedata.map.topology
	local map_width = savedata.map.width
	local map_height = savedata.map.height
	local entities = savedata.ents

	local prefab_to_spawn = "kyno_packimbaggims_fishbone"
	local marker_to_spawn = "kyno_packimbaggims_fishbone_marker"
	
	if entities[marker_to_spawn] ~= nil then
		print("Retrofitting for Heap of Foods Mod - Packim Baggims Fishbone found. Skipping.")
		return
	end

	local candidate_nodes = {}
	
	for node_index, id_string in ipairs(topology.ids) do
		for _, bg_string in ipairs(VALID_ROOMS) do
			if id_string:find(bg_string) then
				table.insert(candidate_nodes, topology.nodes[node_index])
			end
		end
	end

	if #candidate_nodes == 0 then
		print("Retrofitting for Heap of Foods Mod - Couldn't find any valid nodes!")
		return
	end

	local node = candidate_nodes[math.random(#candidate_nodes)]
	
	if not node then
		print("Retrofitting for Heap of Foods Mod - Couldn't pick a valid node!")
		return
	end

	local wx = node.x
	local wy = node.y

	if entities[prefab_to_spawn] == nil then
		entities[prefab_to_spawn] = {}
	end
	
	if entities[marker_to_spawn] == nil then
		entities[marker_to_spawn] = {}
	end

	table.insert(entities[prefab_to_spawn], { x = wx, z = wy })
	table.insert(entities[marker_to_spawn], { x = wx, z = wy })
	
	print(string.format("Retrofitting for Heap of Foods Mod - Spawned '%s' (Fishbone) at (%.2f, %.2f)", prefab_to_spawn, wx, wy))
end

local function HofRetrofitting_WobsterMonkeyIsland(map, savedata)
	local TARGET_PREFAB = "monkeyqueen"
	local SPAWN_PREFAB  = "kyno_wobster_den_monkeyisland"
	local RADIUS        = 60
	local MAX_TO_SPAWN  = 5
	local MAX_ATTEMPTS  = 50
	local SAFE_DOCK_DIST = 8
	
	local VALID_TILES = 
	{
		WORLD_TILES.OCEAN_COASTAL,
		WORLD_TILES.OCEAN_SWELL,
		WORLD_TILES.OCEAN_ROUGH,
		WORLD_TILES.OCEAN_HAZARDOUS,
	}

	local function IsValidTile(tile)
		for _, valid in ipairs(VALID_TILES) do
			if tile == valid then
				return true
			end
		end
		
		return false
	end

	local width = savedata.map.width
	local height = savedata.map.height
	local entities = savedata.ents
	
	local dock_positions = {}
	local step = 2
	
	for y = 1, height, step do
		for x = 1, width, step do
			if map:GetTile(x, y) == WORLD_TILES.MONKEY_DOCK then
				local wx = (x - width / 2) * TILE_SCALE
				local wz = (y - height / 2) * TILE_SCALE
				table.insert(dock_positions, { x = wx, z = wz })
			end
		end
	end
	
	print(string.format("Retrofitting for Heap of Foods Mod - Found %d MONKEY_DOCK tiles.", #dock_positions))

	local function IsFarFromDocks(x, z)
		for _, dock in ipairs(dock_positions) do
			if VecUtil_LengthSq(dock.x - x, dock.z - z) < (SAFE_DOCK_DIST * SAFE_DOCK_DIST) then
				return false
			end
		end
		
		return true
	end

	local targets = entities[TARGET_PREFAB]

	if not targets or #targets == 0 then
		print(string.format("Retrofitting for Heap of Foods Mod - Couldn't find '%s' in the world!", TARGET_PREFAB))
		return
	end

	print(string.format("Retrofitting for Heap of Foods Mod - Found %d instances of '%s'", #targets, TARGET_PREFAB))

	if entities[SPAWN_PREFAB] == nil then
		entities[SPAWN_PREFAB] = {}
	end

	local total_spawned = 0

	for _, target in ipairs(targets) do
		if total_spawned >= MAX_TO_SPAWN then
			break
		end

		local base_x, base_z = target.x, target.z

		for i = 1, MAX_ATTEMPTS do
			if total_spawned >= MAX_TO_SPAWN then
				break
			end

			local angle = math.random() * 2 * PI
			local dist = math.random() * RADIUS
			local wx = base_x + math.cos(angle) * dist
			local wz = base_z + math.sin(angle) * dist

			local tile_x = math.floor(wx / TILE_SCALE + width / 2)
			local tile_y = math.floor(wz / TILE_SCALE + height / 2)
			local tile = map:GetTile(tile_x, tile_y)

			if IsValidTile(tile) and IsFarFromDocks(wx, wz) then
				table.insert(entities[SPAWN_PREFAB], { x = wx, z = wz })
				total_spawned = total_spawned + 1
				
				print(string.format("Retrofitting for Heap of Foods Mod - '%s' placed near '%s' (%.1f, %.1f)", SPAWN_PREFAB, TARGET_PREFAB, wx, wz))
			end
		end
	end

	print(string.format("Retrofitting for Heap of Foods Mod - %d '%s' Added.", total_spawned, SPAWN_PREFAB))
end

return 
{
	HofRetrofitting_SerenityIsland      = HofRetrofitting_SerenityIsland,
	HofRetrofitting_MeadowIsland        = HofRetrofitting_MeadowIsland,
	HofRetrofitting_OceanSetpieces      = HofRetrofitting_OceanSetpieces,
	HofRetrofitting_DeciduousForestShop = HofRetrofitting_DeciduousForestShop,
	HofRetrofitting_DinaMemorial        = HofRetrofitting_DinaMemorial,
	HofRetrofitting_OctopusKingShop     = HofRetrofitting_OctopusKingShop,
	HofRetrofitting_JellyfishSpawners   = HofRetrofitting_JellyfishSpawners,
	HofRetrofitting_DogfishSpawners     = HofRetrofitting_DogfishSpawners,
	HofRetrofitting_PufferSpawners      = HofRetrofitting_PufferSpawners,
	HofRetrofitting_PackimBaggims       = HofRetrofitting_PackimBaggims,
	HofRetrofitting_WobsterMonkeyIsland = HofRetrofitting_WobsterMonkeyIsland,
}