------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Dependencies.
local _G 				= GLOBAL
local STRINGS 			= _G.STRINGS
local TILE_SCALE 		= _G.TILE_SCALE
local HALF_TILE_SCALE 	= TILE_SCALE / 2.0

if not _G.TheNet:GetIsServer() then
    return
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Prefabs and Trackers.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=2522835221
-- All credtis to the original creator, I just implemented to here and updated, the original version is missing content.
local DO_REGROWTH = GetModConfigData("do_regrowth")
if DO_REGROWTH == 1 then
	simpleregrowth = {
		spawner_aloe_frequency 					= 50,
		spawner_radish_frequency				= 50,
		spawner_sweetpotato_frequency			= 50,
		spawner_turnip_frequency				= 50,
		spawner_cucumber_frequency				= 50,
		spawner_wildwheat_frequency				= 50,
		spawner_limpetrock_frequency			= 50,
		spawner_spotbush_frequency				= 50,
		spawner_sweetflower_frequency			= 50,
		spawner_cave_fern_frequency				= 50, -- For the Fern on the Serenity Archipelago.
		spawner_rockflippable_frequency			= 50,
		spawner_mushstump_natural_frequency		= 50,
		spawner_lotus_frequency					= 50,
		spawner_seaweeds_frequency				= 50,
		spawner_taroroot_frequency				= 50,
		spawner_waterycress_frequency			= 50,
		spawner_fennel_frequency				= 50,
		spawner_parznip_frequency				= 50,
		spawner_parznip_big_frequency			= 50,
		spawner_rockflippable_cave_frequency 	= 50,
		spawner_mushstump_cave_frequency		= 50,
		spawner_turnip_cave_frequency			= 50,
		spawner_watery_crate_frequency			= 50,
		spawner_aspargos_frequency				= 50,
		spawner_aspargos_cave_frequency			= 50,
		-- spawner_pineapple_frequency				= 50,
	}

	local prefabcountonground, nonwinterspawners, winteronlyspawners = {}, {}, {}

	local function AddPrefabTracker(prefab, add_counter)
		prefabcountonground[prefab] = 0
		AddPrefabPostInit(prefab, function(ent)
			ent.simpleregrowth = {}
			if add_counter then
				ent.simpleregrowth.add_prefabcountonground = ent:DoTaskInTime(0, function()
				if not ent.components.inventoryitem or not ent.components.inventoryitem.owner then
					prefabcountonground[prefab] = prefabcountonground[prefab] + 1
					ent.simpleregrowth.onground = true
				end
				ent.simpleregrowth.add_prefabcountonground = nil
			end)
		
			ent:ListenForEvent("onremove", function()
				if ent.simpleregrowth.onground then
					prefabcountonground[prefab] = prefabcountonground[prefab] - 1
				end
				ent.simpleregrowth = nil
			end)
			
			ent:ListenForEvent("ondropped", function()
				if ent.simpleregrowth.add_prefabcountonground then
					ent.simpleregrowth.add_prefabcountonground:Cancel()
				end
				ent.simpleregrowth.add_prefabcountonground = ent:DoTaskInTime(0, function()
					prefabcountonground[prefab] = prefabcountonground[prefab] + 1
					ent.simpleregrowth.add_prefabcountonground = nil
				end)
				ent.simpleregrowth.onground = true
				ent.simpleregrowth.playerowned = true
			end)
		
			ent:ListenForEvent("onpickup", function()
				if ent.simpleregrowth.onground then
					prefabcountonground[prefab] = prefabcountonground[prefab] - 1
					ent.simpleregrowth.onground = nil
						if ent.simpleregrowth.playerowned then
							ent.simpleregrowth.playerowned = nil
						end
					end
				end)
			end
		
			local onsave, onload = ent.OnSave, ent.OnLoad
				ent.OnSave = function(inst, data)
				data.simpleregrowth = {}
				if ent.simpleregrowth.playerowned then
					data.simpleregrowth.playerowned = ent.simpleregrowth.playerowned
				end
				if ent.simpleregrowth.ismodded then
					data.simpleregrowth.ismodded = ent.simpleregrowth.ismodded
				end
				if onsave then
					onsave(inst, data)
				end
			end
		
			ent.OnLoad = function(inst, data)
				if data and data.simpleregrowth then	
					if data.simpleregrowth.playerowned then
						ent.simpleregrowth.playerowned = data.simpleregrowth.playerowned
					end
					if data.simpleregrowth.ismodded then
						ent.simpleregrowth.ismodded = data.simpleregrowth.ismodded
					end
				end
				if onload then
					onload(inst, data)
				end
			end
		end)
	end

	local function TilesAdjacentTo(tilex, tiley, tile, depth)
		local count, searched = 0, {}
		local function deep_search(x, y)
			if not searched[x] then
				searched[x] = {}
			elseif searched[x][y] then
				return
			end
			searched[x][y] = true
			if _G.TheWorld.Map:GetTile(x, y) == tile then
				count = count + 1
				if count < depth then
					deep_search(x - 1, y - 1)
					deep_search(x - 1, y)
					deep_search(x - 1, y + 1)
					deep_search(x, y - 1)
					deep_search(x, y + 1)
					deep_search(x + 1, y - 1)
					deep_search(x + 1, y)
					deep_search(x + 1, y + 1)
				end
			end
		end
	
		deep_search(tilex, tiley)
		return count
	end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Prefabs that will regrow in the world.
	if simpleregrowth.spawner_aloe_frequency > 0 then
		AddPrefabTracker("kyno_aloe_ground", true)
		nonwinterspawners["kyno_aloe_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_aloe_frequency,
			amount 		= 3,
			maxcount 	= 71,
			tile 		= GROUND.GRASS,
		}
	end

	if simpleregrowth.spawner_radish_frequency > 0 then
		AddPrefabTracker("kyno_radish_ground", true)
		nonwinterspawners["kyno_radish_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_aloe_frequency,
			amount 		= 3,
			maxcount 	= 71,
			tile 		= GROUND.DECIDUOUS,
		}
	end

	if simpleregrowth.spawner_sweetpotato_frequency > 0 then
		AddPrefabTracker("kyno_sweetpotato_ground", true)
		nonwinterspawners["kyno_sweetpotato_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_aloe_frequency,
			amount 		= 3,
			maxcount 	= 81,
			tile 		= GROUND.FOREST,
		}
	end

	if simpleregrowth.spawner_turnip_frequency > 0 then
		AddPrefabTracker("kyno_turnip_ground", true)
		nonwinterspawners["kyno_turnip_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_aloe_frequency,
			amount 		= 3,
			maxcount 	= 81,
			tile 		= GROUND.MARSH,
		}
	end

	if simpleregrowth.spawner_cucumber_frequency > 0 then
		AddPrefabTracker("kyno_cucumber_ground", true)
		nonwinterspawners["kyno_cucumber_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_aloe_frequency,
			amount 		= 3,
			maxcount 	= 81,
			tile 		= GROUND.OCEAN_ROUGH,
		}
	end

	if simpleregrowth.spawner_wildwheat_frequency > 0 then
		AddPrefabTracker("kyno_wildwheat", true)
		nonwinterspawners["kyno_wildwheat"] = 
		{
			frequency 	= simpleregrowth.spawner_wildwheat_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile 		= GROUND.SAVANNA,
		}
	end

	if simpleregrowth.spawner_limpetrock_frequency > 0 then
		AddPrefabTracker("kyno_limpetrock", true)
		nonwinterspawners["kyno_limpetrock"] = 
		{
			frequency 	= simpleregrowth.spawner_limpetrock_frequency,
			amount 		= 3,
			maxcount 	= 11,
			tile 		= GROUND.QUAGMIRE_CITYSTONE,
		}
	end

	if simpleregrowth.spawner_spotbush_frequency > 0 then
		AddPrefabTracker("kyno_spotbush", true)
		nonwinterspawners["kyno_spotbush"] = 
		{
			frequency 	= simpleregrowth.spawner_spotbush_frequency,
			amount 		= 3,
			maxcount 	= 55,
			tile 		= GROUND.QUAGMIRE_PARKFIELD,
		}
	end

	if simpleregrowth.spawner_sweetflower_frequency > 0 then
		AddPrefabTracker("kyno_sugartree_flower", true)
		nonwinterspawners["kyno_sugartree_flower"] = 
		{
			frequency 	= simpleregrowth.spawner_sweetflower_frequency,
			amount 		= 3,
			maxcount 	= 72,
			tile 		= GROUND.QUAGMIRE_PARKFIELD,
		}
	end

	if simpleregrowth.spawner_cave_fern_frequency > 0 then
		AddPrefabTracker("cave_fern", true)
		nonwinterspawners["cave_fern"] = 
		{
			frequency 	= simpleregrowth.spawner_cave_fern_frequency,
			amount 		= 3,
			maxcount 	= 63,
			tile 		= GROUND.QUAGMIRE_PARKFIELD,
		}
	end

	if simpleregrowth.spawner_rockflippable_frequency > 0 then
		AddPrefabTracker("kyno_rockflippable", true)
		nonwinterspawners["kyno_rockflippable"] = 
		{
			frequency 	= simpleregrowth.spawner_rockflippable_frequency,
			amount 		= 3,
			maxcount 	= 91,
			tile 		= GROUND.SAVANNA, GROUND.ROCKY, GROUND.DECIDUOUS,
		}
	end

	if simpleregrowth.spawner_mushstump_natural_frequency > 0 then
		AddPrefabTracker("kyno_mushstump_natural", true)
		nonwinterspawners["kyno_mushstump_natural"] = 
		{
			frequency 	= simpleregrowth.spawner_mushstump_natural_frequency,
			amount 		= 3,
			maxcount 	= 81,
			tile 		= GROUND.FOREST,
		}
	end

	if simpleregrowth.spawner_lotus_frequency > 0 then
		AddPrefabTracker("kyno_lotus_ocean", true)
		nonwinterspawners["kyno_lotus_ocean"] = 
		{
			frequency 	= simpleregrowth.spawner_lotus_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile 		= GROUND.OCEAN_COASTAL,
		}
	end

	if simpleregrowth.spawner_seaweeds_frequency > 0 then
		AddPrefabTracker("kyno_seaweeds_ocean", true)
		nonwinterspawners["kyno_seaweeds_ocean"] = {
			frequency 	= simpleregrowth.spawner_seaweeds_frequency,
			amount 		= 3,
			maxcount 	= 131,
			tile 		= GROUND.OCEAN_COASTAL,
		}
	end

	if simpleregrowth.spawner_taroroot_frequency > 0 then
		AddPrefabTracker("kyno_taroroot_ocean", true)
		nonwinterspawners["kyno_taroroot_ocean"] = {
			frequency 	= simpleregrowth.spawner_taroroot_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile = GROUND.OCEAN_SWELL,
		}
	end

	if simpleregrowth.spawner_fennel_frequency > 0 then
		AddPrefabTracker("kyno_fennel_ground", true)
		nonwinterspawners["kyno_fennel_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_fennel_frequency,
			amount 		= 3,
			maxcount 	= 81,
			tile 		= GROUND.SINKHOLE,
		}
	end

	if simpleregrowth.spawner_parznip_frequency > 0 then
		AddPrefabTracker("kyno_parznip_ground", true)
		nonwinterspawners["kyno_parznip_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_parznip_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile 		= GROUND.MUD, GROUND.CAVE,
		}
	end

	if simpleregrowth.spawner_parznip_big_frequency > 0 then
		AddPrefabTracker("kyno_parznip_big", true)
		nonwinterspawners["kyno_parznip_big"] = 
		{
			frequency 	= simpleregrowth.spawner_parznip_big_frequency,
			amount 		= 3,
			maxcount 	= 81,
			tile 		= GROUND.MUD, GROUND.CAVE,
		}
	end

	if simpleregrowth.spawner_rockflippable_cave_frequency > 0 then
		AddPrefabTracker("kyno_rockflippable_cave", true)
		nonwinterspawners["kyno_rockflippable_cave"] = 
		{
			frequency 	= simpleregrowth.spawner_rockflippable_cave_frequency,
			amount 		= 3,
			maxcount 	= 85,
			tile 		= GROUND.UNDERROCK, GROUND.CAVE, GROUND.ROCKY,
		}
	end

	if simpleregrowth.spawner_mushstump_cave_frequency > 0 then
		AddPrefabTracker("kyno_mushstump_cave", true)
		nonwinterspawners["kyno_mushstump_cave"] = 
		{
			frequency 	= simpleregrowth.spawner_mushstump_cave_frequency,
			amount 		= 3,
			maxcount 	= 71,
			tile 		= GROUND.FUNGUSGREEN,
		}
	end

	if simpleregrowth.spawner_turnip_cave_frequency > 0 then
		AddPrefabTracker("kyno_turnip_cave", true)
		nonwinterspawners["kyno_turnip_cave"] = 
		{
			frequency 	= simpleregrowth.spawner_turnip_cave_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile 		= GROUND.MARSH,
		}
	end

	if simpleregrowth.spawner_watery_crate_frequency > 0 then
		AddPrefabTracker("kyno_watery_crate", true)
		nonwinterspawners["kyno_watery_crate"] = 
		{
			frequency 	= simpleregrowth.spawner_watery_crate_frequency,
			amount 		= 3,
			maxcount 	= 131,
			tile 		= GROUND.OCEAN_COASTAL, GROUND.OCEAN_ROUGH, GROUND.OCEAN_SWELL, GROUND.OCEAN_COASTAL_SHORE, GROUND.OCEAN_HAZARDOUS,
			GROUND.OCEAN_BRINEPOOL_SHORE, GROUND.OCEAN_COASTAL, GROUND.OCEAN_WATERLOG,
		}
	end
	
	if simpleregrowth.spawner_aspargos_frequency > 0 then
		AddPrefabTracker("kyno_aspargos_ground", true)
		nonwinterspawners["kyno_aspargos_ground"] = 
		{
			frequency 	= simpleregrowth.spawner_aspargos_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile 		= GROUND.GRASS, GROUND.FOREST
		}
	end
	
	if simpleregrowth.spawner_aspargos_cave_frequency > 0 then
		AddPrefabTracker("kyno_aspargos_cave", true)
		nonwinterspawners["kyno_aspargos_cave"] = 
		{
			frequency 	= simpleregrowth.spawner_aspargos_cave_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile 		= GROUND.GRASS, GROUND.FOREST, GROUND.SINKHOLE,
		}
	end
	--[[
	if simpleregrowth.spawner_pineapple_frequency > 0 then
		AddPrefabTracker("kyno_pineapplebush", true)
		nonwinterspawners["kyno_pineapplebush"] = 
		{
			frequency 	= simpleregrowth.spawner_pineapple_frequency,
			amount 		= 3,
			maxcount 	= 101,
			tile 		= GROUND.GRASS, GROUND.FOREST, 
		}
	end	
	]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Prefab Spawners.
	AddPrefabPostInit(STRINGS.NAMES.MIGRATION_PORTAL and "world" or "forest", function(ent)
		if ent.ismastersim then
			local worldwidth, worldheight, halfworldwidth, halfworldheight, worldsquarelength, tiles, tickage, segage, ticktime, segtime, lastsegused, maxprefabcount = 0, 0, 0, 0, 0, {}, 0, 0, 0, 0, 0, {}

			local function UpdateTime()
				ticktime = math.floor(_G.TheWorld.state.time * TUNING.TOTAL_DAY_TIME + 0.5)
				tickage = math.floor(_G.TheWorld.state.cycles * TUNING.TOTAL_DAY_TIME + 0.5) + ticktime
				segage = math.floor(tickage / TUNING.SEG_TIME + 0.5)
				segtime = math.floor(ticktime / TUNING.SEG_TIME + 0.5)
			end
		
			local function Spawn(prefab, amount, tile)
				if amount == 0 or prefabcountonground[prefab] + amount >= maxprefabcount[prefab] or not tiles[tile] or #tiles[tile] <= 1 then
					return
				end
			
				local spawned = 0
				while spawned < amount do
					local idx = math.random(#tiles[tile])
					local tilex, tiley = tiles[tile][idx].tilex, tiles[tile][idx].tiley
					if _G.TheWorld.Map:GetTile(tilex, tiley) ~= tile then
						table.insert(tiles[_G.TheWorld.Map:GetTile(tilex, tiley)], { tilex = x, tiley = y })
						repeat
					
						table.remove(tiles[tile], idx)
						if #tiles[tile] <= 1 then
							tiles[tile] = nil
							break
						end
					
						idx = math.random(#tiles[tile])
						tilex, tiley = tiles[tile][idx].tilex, tiles[tile][idx].tiley
						until _G.TheWorld.Map:GetTile(tilex, tiley) == tile
						if not tiles[tile] then
							break
						end
					end
				
					tilex, tiley = tiles[tile][idx].tilex, tiles[tile][idx].tiley
					local point = _G.Vector3((tilex - halfworldwidth) * TILE_SCALE - HALF_TILE_SCALE + math.random() * TILE_SCALE, 0, (tiley - halfworldheight) * TILE_SCALE - HALF_TILE_SCALE + math.random() * TILE_SCALE)
					local ent = _G.SpawnPrefab(prefab)
					ent.Transform:SetPosition(point:Get())
					spawned = spawned + 1
				end
			
				if spawned > 0 then
					print("[Heap of Foods Regrowth] Spawned ".. spawned.."x of "..prefab.." at seg "..segtime.." (tick: "..ticktime..") of day "..math.floor(tickage / TUNING.TOTAL_DAY_TIME) + 1)
				end
			end
		
			local function DoNextTick()
				UpdateTime()
				if ticktime % TUNING.SEG_TIME == 0 and segage ~= lastsegused then
					if _G.TheWorld.state.iswinter then
						for prefab, spawner in pairs(winteronlyspawners) do
							if segage % spawner.frequency == 0 then
								Spawn(prefab, math.random(1, spawner.amount), spawner.tile)
							end
						end
					else
						for prefab, spawner in pairs(nonwinterspawners) do
							if segage % spawner.frequency == 0 then
								Spawn(prefab, math.random(1, spawner.amount), spawner.tile)
							end
						end
					end
					lastsegused = segage
				end
			end

			local onsave, onload = ent.OnSave, ent.OnLoad
				ent.OnSave = function(inst, data)
				if lastsegused then
					data.lastsegused = lastsegused
				end
				if onsave then
					onsave(inst, data)
				end
			end
		
			ent.OnLoad = function(inst, data)
			if data and data.lastsegused then
				lastsegused = data.lastsegused or 0
					if onload then
						onload(inst, data)
					end
				end
			end

			ent:DoTaskInTime(0, function()
				worldwidth, worldheight = _G.TheWorld.Map:GetSize()
				halfworldwidth, halfworldheight = worldwidth / 2.0, worldheight / 2.0
				worldsquarelength = worldwidth * worldheight
				for x = 0, worldwidth do
					for y = 0, worldheight do
						local tile = _G.TheWorld.Map:GetTile(x, y)
							if not tiles[tile] then
								tiles[tile] = {}
							end
							table.insert(tiles[tile], { tilex = x, tiley = y })
						end
					end
					print("[Heap of Foods Regrowth]")
					print("   ...World: w: "..worldwidth..", h: "..worldheight..", square length: "..worldsquarelength)
						
					local function load_prefabs(spawners)
						for prefab, spawner in pairs(spawners) do
						if spawner.amount then
							spawner.amount = math.ceil(spawner.amount / 180625 * worldsquarelength)
						end
						if spawner.maxcount then
							spawner.maxcount = math.ceil(spawner.maxcount /180625 * worldsquarelength)
						end
						if not maxprefabcount[prefab] then
							maxprefabcount[prefab] = spawner.maxcount
							print("   ...spawner: "..prefab..": maxcount: "..spawner.maxcount..", amount: "..(spawner.amount or "?")..", current: "..(prefabcountonground[prefab] or "?"))
						end
					end
				end
				load_prefabs(nonwinterspawners)
				load_prefabs(winteronlyspawners)
				ent:DoPeriodicTask(1, function()
					DoNextTick()
				end)
			end)
		end
	end)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------