-- Gives all Mod Ingredients for the Mod recipes.
function c_hofingredients()
    local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
        player.components.inventory:Equip(c_spawn("krampus_sack", nil, true))
		c_give("cookbook",         nil, true)
        c_give("kyno_syrup", 		40, true)
        c_give("kyno_flour", 		40, true)
        c_give("kyno_spotspice", 	40, true)
        c_give("kyno_bacon", 		40, true)
        c_give("gorge_bread", 		40, true)
		c_give("kyno_white_cap",    40, true)
		c_give("kyno_aloe",         40, true)
		c_give("kyno_radish",       40, true)
		c_give("kyno_fennel",       40, true)
		c_give("kyno_sweetpotato",  40, true)
		c_give("kyno_lotus_flower", 40, true)
		c_give("kyno_seaweeds",     40, true)
		c_give("kyno_limpets",      40, true)
		c_give("kyno_taroroot",     40, true)
		c_give("kyno_parznip",      40, true)
		c_give("kyno_cucumber",     40, true)
		c_give("kyno_waterycress",  40, true)
		c_give("kyno_turnip",       40, true)
		c_give("kyno_roe_pondfish", 40, true)
		c_give("kyno_gummybug",     40, true)
		c_give("kyno_beanbugs",     40, true)
		c_give("kyno_mussel",       40, true)
		c_give("kyno_shark_fin",    40, true)
		c_give("kyno_coffeebeans",  40, true)
    end
end

-- Gives all the Shipwrecked foods.
function c_hofswfoods()
	local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
		c_give("coffee", 				40, true)
		c_give("bisque",           	 	40, true)
		c_give("jellyopop",         	40, true)
		c_give("musselbouillabaise", 	40, true)
		c_give("sharkfinsoup",          40, true)
		c_give("sweetpotatosouffle",    40, true)
		c_give("tropicalbouillabaisse", 40, true)
	end
end

-- Gives all the Hamlet foods.
function c_hofhamfoods()
	local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
		c_give("feijoada",				40, true)
		c_give("gummy_cake",			40, true)
		c_give("hardshell_tacos", 		40, true)
		c_give("icedtea",				40, true)
		c_give("tea",					40, true)
		c_give("nettlelosange",			40, true)
		c_give("snakebonesoup",			40, true)
		c_give("steamedhamsandwich",	40, true)
	end
end

-- Gives all the Other-related foods.
function c_hofotherfoods()
	local player = ConsoleCommandPlayer()
	
	if player ~= nil then
		c_select(player)
		
		c_give("bubbletea",				40, true)
		c_give("frenchonionsoup",		40, true)
		c_give("slaw",					40, true)
		c_give("lotusbowl",				40, true)
		c_give("poi",					40, true)
		c_give("jellybean_sanity",		40, true)
		c_give("jellybean_hunger",		40, true)
		c_give("jellybean_super",		40, true)
		c_give("cucumbersalad",			40, true)
		c_give("waterycressbowl",		40, true)
		c_give("bowlofgears",			40, true)
		c_give("longpigmeal",			40, true)
		c_give("duckyouglermz",			40, true)
	end
end

-- Give all the Mod vegetables.
function c_hofveggies()
	local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
        player.components.inventory:Equip(c_spawn("krampus_sack", nil, true))
		c_give("kyno_aloe",               40, true)
		c_give("kyno_aloe_cooked",        40, true)
		c_give("kyno_aloe_seeds",         40, true)
		c_give("kyno_cucumber",           40, true)
		c_give("kyno_cucumber_cooked",    40, true)
		c_give("kyno_cucumber_seeds",     40, true)
		c_give("kyno_fennel",             40, true)
		c_give("kyno_fennel_cooked",      40, true)
		c_give("kyno_fennel_seeds",       40, true)
		c_give("kyno_parznip",            40, true)
		c_give("kyno_parznip_eaten",      40, true)
		c_give("kyno_parznip_cooked",     40, true)
		c_give("kyno_parznip_seeds",      40, true)
		c_give("kyno_radish",             40, true)
		c_give("kyno_radish_cooked",      40, true)
		c_give("kyno_radish_seeds",       40, true)
		c_give("kyno_rice",               40, true)
		c_give("kyno_rice_cooked",        40, true)
		c_give("kyno_rice_seeds",         40, true)
		c_give("kyno_sweetpotato",        40, true)
		c_give("kyno_sweetpotato_cooked", 40, true)
		c_give("kyno_sweetpotato_seeds",  40, true)
		c_give("kyno_turnip",             40, true)
		c_give("kyno_turnip_cooked",      40, true)
		c_give("kyno_turnip_seeds",       40, true)
		c_give("firenettles_seeds",       40, true)
		c_give("forgetmelots_seeds",      40, true)
		c_give("tillweed_seeds",          40, true)
	end
end

-- Quick command for testing Coffee Bushes and Coffee.
function c_hoftestcoffee()
	local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
		c_give("shovel", 			   	   nil, true)
		c_give("dug_kyno_coffeebush",		10, true)
		c_give("ash",                       40, true)
		c_give("kyno_coffeebeans_cooked",   40, true)
		c_give("coffee",                    40, true)
	end
end

-- Quick command for testing foods on Crock Pots.
function c_hofcrockpots()
	local player = ConsoleCommandPlayer()
	
	local x, y, z = player.Transform:GetWorldPosition()
	local n = 12
	local sector = 2*math.pi/n
	
	for i = 1, n, 1 do
		local crockpot = SpawnPrefab("cookpot")
		
		if crockpot then
			crockpot.Transform:SetPosition(x + 5 * math.cos(i * sector), y, z + 5 * math.sin(i * sector))
		end
	end
end

-- Quick command for testing foods on Warly's Crock Pots.
function c_hofwarlycrockpots()
	local player = ConsoleCommandPlayer()
	
	local x, y, z = player.Transform:GetWorldPosition()
	local n = 12
	local sector = 2*math.pi/n
	
	for i = 1, n, 1 do
		local crockpot = SpawnPrefab("portablecookpot")
		
		if crockpot then
			crockpot.Transform:SetPosition(x + 4 * math.cos(i * sector), y, z + 4 * math.sin(i * sector))
		end
	end
end

-- Quick Test on Serenity Archipelago stuff.
function c_hofserenityisland()
    local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
		local islandshop = c_findnext("kyno_serenityisland_shop")
		
		player.Physics:Teleport(islandshop.Transform:GetWorldPosition())
        player.components.inventory:Equip(c_spawn("krampus_sack", nil, true))
		c_give("kyno_slaughtertool",			 nil, true)
		c_give("kyno_sapbucket_installer",        10, true)
		c_give("kyno_saltrack_installer",         10, true)
		c_give("kyno_crabtrap_installer",          1, true)
		c_give("kyno_sugartree_bud",              40, true)
		c_give("kyno_sugartree_petals",           40, true)
		c_give("kyno_crabmeat",                   40, true)
		c_give("kyno_crabmeat_cooked",            40, true)
		c_give("kyno_salmonfish",                nil, true)
	end
end

-- Quick Test on Seaside Island stuff.
function c_hofmeadowisland()
	local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
		local shop = c_findnext("kyno_meadowisland_shop")
		
		player.Physics:Teleport(shop.Transform:GetWorldPosition())
        player.components.inventory:Equip(c_spawn("krampus_sack", nil, true))
		c_give("kyno_piko",        nil, true) 
		c_give("kyno_piko_orange", nil, true)
		c_give("kyno_kokonut",     40,  true)
		c_give("moonglassaxe",     nil, true)
	end
end
		
-- Quick command for testing foods on Wooden Kegs and Preserves Jars.
function c_hofkegs()
	local player = ConsoleCommandPlayer()
	
	local x, y, z = player.Transform:GetWorldPosition()
	local n = 12
	local sector = 2*math.pi/n
	
	for i = 1, n, 1 do
		local crockpot = SpawnPrefab("kyno_woodenkeg")
		
		if crockpot then
			crockpot.Transform:SetPosition(x + 5 * math.cos(i * sector), y, z + 5 * math.sin(i * sector))
		end
	end
end

function c_hofjars()
	local player = ConsoleCommandPlayer()
	
	local x, y, z = player.Transform:GetWorldPosition()
	local n = 12
	local sector = 2*math.pi/n
	
	for i = 1, n, 1 do
		local crockpot = SpawnPrefab("kyno_preservesjar")
		
		if crockpot then
			crockpot.Transform:SetPosition(x + 5 * math.cos(i * sector), y, z + 5 * math.sin(i * sector))
		end
	end
end

-- Quick command to test Monster Foods.
function c_hofmonsterfoods()
	local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
        player.components.inventory:Equip(c_spawn("krampus_sack", nil, true))
		c_give("cookbook",         nil, true)
        c_give("monsterlasagna", 	40, true)
        c_give("monstertartare", 	40, true)
        c_give("monstermuffin", 	40, true)
        c_give("duriansoup", 		40, true)
        c_give("duriansplit", 		40, true)
		c_give("durianchicken",     40, true)
		c_give("durianmeated",      40, true)
		c_give("wobstermonster",    40, true)
		c_give("spidercake",        40, true)
    end
end	

-- Gives all dryable items.
function c_hofdryables()
	local player = ConsoleCommandPlayer()
	
    if player ~= nil then
        c_select(player)
		
		player.components.inventory:Equip(c_spawn("krampus_sack", nil, true))
		c_give("red_cap",                   40, true)
		c_give("green_cap",                 40, true)
		c_give("blue_cap",                  40, true)
		c_give("moon_cap",                  40, true)
		c_give("plantmeat",                 20, true)
		c_give("kyno_humanmeat",            20, true)
		c_give("kyno_crabmeat",             20, true)
		c_give("kyno_crabkingmeat",         20, true)
		c_give("kyno_poison_froglegs",      40, true)
		c_give("kyno_seaweeds",             40, true)
		c_give("kyno_jellyfish_dried",      20, true)
		c_give("kyno_fishmeat_small_dried", 40, true)
		c_give("kyno_fishmeat_dried",       20, true)
	end
end

-- Gives all fish roe items.
function c_hoffishroes()
	local player = ConsoleCommandPlayer()
	
	if player ~= nil then
		c_select(player)
		
		player.components.inventory:Equip(c_spawn("krampus_sack", nil, true))
		c_give("kyno_roe_pondfish",             40, true)
		c_give("kyno_roe_pondeel",              40, true)
		c_give("kyno_roe_wobster",              20, true)
		c_give("kyno_roe_wobster_monkeyisland", 20, true)
		c_give("kyno_roe_wobster_moonglass",    20, true)
		c_give("kyno_roe_neonfish",             20, true)
		c_give("kyno_roe_pierrotfish",          40, true)
		c_give("kyno_roe_grouper",              20, true)
		c_give("kyno_roe_tropicalfish",         40, true)
		c_give("kyno_roe_jellyfish",            40, true)
		c_give("kyno_roe_jellyfish_rainbow",    40, true)
		c_give("kyno_roe_salmonfish",           40, true)
		c_give("kyno_roe_koi",                  40, true)
		c_give("kyno_roe_antchovy",             40, true)
		c_give("kyno_roe_oceanfish_small_1",    40, true)
		c_give("kyno_roe_oceanfish_small_2",    40, true)
		c_give("kyno_roe_oceanfish_small_3",    40, true)
		c_give("kyno_roe_oceanfish_small_4",    40, true)
		c_give("kyno_roe_oceanfish_small_5",    40, true)
		c_give("kyno_roe_oceanfish_small_6",    40, true)
		c_give("kyno_roe_oceanfish_small_7",    40, true)
		c_give("kyno_roe_oceanfish_small_8",    40, true)
		c_give("kyno_roe_oceanfish_small_9",    40, true)
		c_give("kyno_roe_oceanfish_medium_1",   20, true)
		c_give("kyno_roe_oceanfish_medium_2",   20, true)
		c_give("kyno_roe_oceanfish_medium_3",   20, true)
		c_give("kyno_roe_oceanfish_medium_4",   20, true)
		c_give("kyno_roe_oceanfish_medium_5",   20, true)
		c_give("kyno_roe_oceanfish_medium_6",   20, true)
		c_give("kyno_roe_oceanfish_medium_7",   20, true)
		c_give("kyno_roe_oceanfish_medium_8",   20, true)
		c_give("kyno_roe_oceanfish_medium_9",   20, true)
		c_give("kyno_roe_oceanfish_pufferfish", 40, true)
		c_give("kyno_roe_oceanfish_sturgeon",   20, true)
	end
end

-- In case someone needs to spawn Sammy's Wagon.
function c_hofsammywagon()
	local player = ConsoleCommandPlayer()
	
	local house = TheSim:FindFirstEntityWithTag("sammyhouse")
	
	if house then
		local mermcart = SpawnPrefab("kyno_meadowisland_mermcart")
		
		local x, y, z = house.Transform:GetWorldPosition()
		
		local theta = -3 -- -3
		local radius = 4 -- 4
		local x = x + radius * math.cos(theta)
		local z = z - radius * math.sin(theta)

		mermcart.Transform:SetPosition(x, 0, z)
		
		TheNet:Announce("Successfully spawned: Sammy's Wagon. Near: Sammy's Emporium.")
	else
		TheNet:Announce("Could not spawn: Sammy's Wagon. Reason: Missing Sammy's Emporium.")
		TheNet:Announce("Please Retrofit your world at Mod Configuration using option: Mermhuts.")
	end
end

local function _SpawnLayout_AddFn(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
    local x = (points_x[current_pos_idx] - width/2.0)  * TILE_SCALE
    local y = (points_y[current_pos_idx] - height/2.0) * TILE_SCALE

    x = math.floor(x*100) / 100.0
    y = math.floor(y*100) / 100.0

    prefab_data.x = x
    prefab_data.z = y

    prefab_data.prefab = prefab

    local ent = SpawnSaveRecord(prefab_data)

    ent:LoadPostPass(Ents, FunctionOrValue(prefab_data.data))

    if ent.components.scenariorunner ~= nil then
        ent.components.scenariorunner:Run()
    end
end

local obj_layout = require("map/object_layout")
local LAYOUT_CANT_TAGS = { "player", "INLIMBO", "FX", "multiplayer_portal", "irreplaceable" } -- Add any other tag in here if needed.

-- Testing Setpieces.
-- If its not working for you consider using: require("debugcommands") d_spawnlayout("layoutname")
function c_hofspawnlayout(name)
    local layout  = obj_layout.LayoutForDefinition(name)
    local map_width, map_height = TheWorld.Map:GetSize()

    local add_fn = 
	{
        fn = _SpawnLayout_AddFn,
        args = {entitiesOut={}, width=map_width, height=map_height, rand_offset=false}
    }

    local offset = 3 --layout.ground ~= nil and (#layout.ground / 2) or 0
    local size = layout.ground ~= nil and (#layout.ground * TILE_SCALE) or nil

    local pos  = ConsoleWorldPosition()
    local x, z = TheWorld.Map:GetTileCoordsAtPoint(pos:Get())

    if size ~= nil then
        for i, ent in ipairs(TheSim:FindEntities(pos.x, 0, pos.z, size, nil, LAYOUT_CANT_TAGS)) do
            ent:Remove()
        end
    end

    obj_layout.Place({x-offset, z-offset}, name, add_fn, nil, TheWorld.Map)
end

function c_hofareaaware(start)
	local player = ConsoleCommandPlayer()
	
	if player ~= nil then
		if player.areatask ~= nil then
			player.areatask:Cancel()
			player.areatask = nil
		end
		
		if start then
			player.areatask = player:DoPeriodicTask(1, function()
				print(player.components.areaaware:GetDebugString())
			end)
			
			TheNet:Announce("Areaaware Debugging Started.")
		else
			if player.areatask ~= nil then
				player.areatask:Cancel()
				player.areatask = nil
			end
			
			TheNet:Announce("Areaaware Debugging Stopped.")
		end
	end
end

-- A Recursive function that locates a setpiece + prefab serving as
-- starting point to remove everything around it including world tiles.
-- Feel free to copy this function and modify to your own needs!

-- We are replacing tiles with WORLD_TILES.OCEAN_ROUGH, but it can be any tile, really.
-- This function also makes use of Flood Fill with some helpers to "jump" gaps and find 
-- the nearest correspondent tile to remove, its nice for setpieces that are "archipelagos".

-- c_hofremoveisland("SerenityIsland", "serenity_marker", 3, true)
-- c_hofremoveisland("MeadowIsland", "meadow_marker", 1)
function c_hofremoveisland(layoutname, marker_tag, max_jump, floodagain)
	-- require("tilemanager")

	local map = TheWorld.Map
	local map_width, map_height = map:GetSize()
	max_jump = max_jump or 3

	local center_prefabs =
	{
		"kingfisher",
		"kyno_chicken2",
		"kyno_chicken2_herd",
		"kyno_cookware_elder",
		"kyno_flup_spawner",
		"kyno_koi",
		"kyno_kokonuttree",
		"kyno_limpetrock",
		"kyno_lotus_ocean",
		"kyno_meadow_cc_marker",
		"kyno_meadowflup_spawner",
		"kyno_meadowisland_crate",
		"kyno_meadowisland_fishermermhut",
		"kyno_meadowisland_mermcart",
		"kyno_meadowisland_mermfisher",
		"kyno_meadowisland_mermhut",
		"kyno_meadowisland_pikotree",
		"kyno_meadowisland_pond",
		"kyno_meadowisland_sandhill",
		"kyno_meadowisland_seller",
		"kyno_meadowisland_shop",
		"kyno_meadowisland_tree",
		"kyno_neonfish",
		"kyno_pebblecrab",
		"kyno_pebblecrab_spawner",
		"kyno_pierrotfish",
		"kyno_pineapplebush",
		"kyno_pond_salt",
		"kyno_repairtool",
		"kyno_salmonfish",
		"kyno_serenity_cc_marker",
		"kyno_serenityisland_crate",
		"kyno_serenityisland_decor",
		"kyno_serenityisland_decor2",
		"kyno_serenityisland_rock1",
		"kyno_serenityisland_rock2",
		"kyno_serenityisland_rock3",
		"kyno_serenityisland_shop",
		"kyno_spotbush",
		"kyno_sugarfly",
		"kyno_sugartree",
		"kyno_sugartree_flower",
		"kyno_sweetpotato_ground",
		"kyno_tropicalfish",
		"kyno_wildwheat",
		"toucan",
	}

	local prefabs_to_remove =
	{
		"blue_mushroom",
		"cave_fern",
		"cookingrecipecard",
		"dead_sea_bones",
		"farm_hoe",
		"farm_plant_kyno_rice",
		"fertilizer",
		"firepit",
		"flower",
		"flower_planted",
		"grass",
		"green_mushroom",
		"kingfisher",
		"kyno_chicken2",
		"kyno_chicken2_herd",
		"kyno_cookware_elder",
		"kyno_flup_spawner",
		"kyno_koi",
		"kyno_kokonuttree",
		"kyno_limpetrock",
		"kyno_lotus_ocean",
		"kyno_meadow_cc_marker",
		"kyno_meadowflup_spawner",
		"kyno_meadowisland_crate",
		"kyno_meadowisland_fishermermhut",
		"kyno_meadowisland_mermcart",
		"kyno_meadowisland_mermfisher",
		"kyno_meadowisland_mermhut",
		"kyno_meadowisland_pikotree",
		"kyno_meadowisland_pond",
		"kyno_meadowisland_sandhill",
		"kyno_meadowisland_seller",
		"kyno_meadowisland_shop",
		"kyno_meadowisland_tree",
		"kyno_neonfish",
		"kyno_pebblecrab",
		"kyno_pebblecrab_spawner",
		"kyno_pierrotfish",
		"kyno_pineapplebush",
		"kyno_pond_salt",
		"kyno_repairtool",
		"kyno_salmonfish",
		"kyno_serenity_cc_marker",
		"kyno_serenityisland_crate",
		"kyno_serenityisland_crate_spawner",
		"kyno_serenityisland_decor",
		"kyno_serenityisland_decor2",
		"kyno_serenityisland_rock1",
		"kyno_serenityisland_rock2",
		"kyno_serenityisland_rock3",
		"kyno_serenityisland_shop",
		"kyno_spotbush",
		"kyno_sugarfly",
		"kyno_sugartree",
		"kyno_sugartree_flower",
		"kyno_sweetpotato_ground",
		"kyno_tropicalfish",
		"lightning_rod",
		"mandrake_planted",
		"plantregistryhat",
		"quagmire_pigeon",
		"red_mushroom",
		"reeds",
		"rock1",
		"rock_flintless",
		"rocks",
		"saltrock",
		"sapling",
		"seastack",
		"toucan",
		"waterplant",
		"waterplant_baby",
        "kyno_wildwheat",
    }

    local tiles_to_replace = 
	{
		WORLD_TILES.QUAGMIRE_CITYSTONE,
		WORLD_TILES.QUAGMIRE_PARKFIELD,
		WORLD_TILES.OCEAN_BRINEPOOL,
		WORLD_TILES.SAVANNA,
		WORLD_TILES.ROCKY,
		WORLD_TILES.FOREST,
		WORLD_TILES.MONKEY_GROUND,
		WORLD_TILES.ROAD,
		WORLD_TILES.FARMING_SOIL,
		WORLD_TILES.HOF_FIELDS,
		WORLD_TILES.HOF_TIDALMARSH,
	}

	local marker = TheSim:FindFirstEntityWithTag(marker_tag)
	
	if not marker or not marker:IsValid() then
		print("Marker '"..marker_tag.."' not found!")
		return
	end

	local px, py, pz = marker.Transform:GetWorldPosition()

	local layout_ents = TheSim:FindEntities(px, py, pz, 200, nil, {"player", "FX", "INLIMBO"})
	local filtered = {}
	
	for _, ent in ipairs(layout_ents) do
		if ent:IsValid() and ent.prefab ~= nil then
			for _, name in ipairs(center_prefabs) do
				if ent.prefab == name then
					table.insert(filtered, ent)
					break
				end
			end
		end
	end
	
	if #filtered > 0 then
		local sum_x, sum_z = 0, 0
		
		for _, ent in ipairs(filtered) do
			local ex, _, ez = ent.Transform:GetWorldPosition()
			
			sum_x = sum_x + ex
			sum_z = sum_z + ez
		end
		
		px = sum_x / #filtered
		pz = sum_z / #filtered
    end

	local cx, cz = map:GetTileCoordsAtPoint(px, 0, pz)
	local visited = {}
	
	local function FloodFillAdvanced(x, z, base_tile)
		local key = x..","..z
		
		if visited[key] then 
			return 
		end
        
		if x < 0 or z < 0 or x >= map_width or z >= map_height then 
			return 
		end

		local current_tile = map:GetTile(x, z)
		local match = false
		
		for _, t in ipairs(tiles_to_replace) do
			if current_tile == t then
				match = true
				break
			end
		end
		
		if not match then 
			return 
		end

		visited[key] = true
		map:SetTile(x, z, WORLD_TILES.OCEAN_ROUGH)

		local dirs = {{1,0},{-1,0},{0,1},{0,-1}}
        
		for _, d in ipairs(dirs) do
			FloodFillAdvanced(x + d[1], z + d[2], current_tile)
		end

		for dx = -max_jump, max_jump do
			for dz = -max_jump, max_jump do
				if math.abs(dx) + math.abs(dz) > 1 then
					local nx, nz = x + dx, z + dz
					
					if not visited[nx..","..nz] and map:GetTile(nx, nz) == current_tile then
						FloodFillAdvanced(nx, nz, current_tile)
					end
				end
			end
		end
	end

	FloodFillAdvanced(cx, cz, map:GetTile(cx, cz))
	
	if floodagain then
		for dx = -max_jump*5, max_jump*5 do
			for dz = -max_jump*5, max_jump*5 do
				local nx, nz = cx + dx, cz + dz
			
				if nx >= 0 and nz >= 0 and nx < map_width and nz < map_height then
					local tile = map:GetTile(nx, nz)

					for _, t in ipairs(tiles_to_replace) do
						if tile == t and not visited[nx..","..nz] then
							FloodFillAdvanced(nx, nz, tile)
						end
					end
				end
			end
		end
	end

	local ents = TheSim:FindEntities(px, py, pz, 150, nil, {"player", "FX", "INLIMBO"})
	local removed_ents = 0
	
	for _, ent in ipairs(ents) do
		if ent and ent:IsValid() and ent.prefab then
			for _, prefab_name in ipairs(prefabs_to_remove) do
				if ent.prefab == prefab_name then
					ent:Remove()
					removed_ents = removed_ents + 1
					break
				end
			end
		end
	end
	
	-- Can't this be removed by this function already?
	TheNet:SendRemoteExecute('c_removeall("kyno_pebblecrab_spawner")')
	TheNet:SendRemoteExecute('c_removeall("kyno_meadowflup_spawner")')
	TheNet:Announce(layoutname.." Successfully removed. Please save and restart the world to perform Retrofitting.")
	print("Heap of Foods Mod - Island Removed! | Prefabs removed: "..removed_ents)
end

-- Deprecated stuff. Reference only.
--[[
local function SpawnSammyWagon()
		local house = TheSim:FindFirstEntityWithTag("sammyhouse")
		local mermcart = SpawnPrefab("kyno_meadowisland_mermcart")
	
		local x, y, z = house.Transform:GetWorldPosition()
	
		local theta = -3 -- -3
		local radius = 4 -- 4
		local x = x + radius * math.cos(theta)
		local z = z - radius * math.sin(theta)
	
		mermcart.Transform:SetPosition(x, 0, z)
	end
	
	-- Deprecated. Use Wurt to build Fishermerm Huts.
	local function RetrofitMermhuts()
		local count = 0
		local max_count = 3

		for k, v in pairs(Ents) do
			if count >= max_count then
				break
			end

			if v.prefab == "kyno_meadowisland_mermhut" then
				ReplacePrefab(v, "kyno_meadowisland_fishermermhut")
				count = count + 1
			end
		end
	end
	
	-- Deprecated. Old worlds without this prefab will be Retrofitted.
	local function RetrofitSammyShop()
		local newshop = TheSim:FindFirstEntityWithTag("mermhouse_seaside")
		local sammyhouse = TheSim:FindFirstEntityWithTag("sammyhouse") -- Don't let them have more shops.
		local sammywagon = TheSim:FindFirstEntityWithTag("sammywagon")
	
		if newshop ~= nil and not sammyhouse then 
			ReplacePrefab(newshop, "kyno_meadowisland_shop")
			SpawnSammyWagon()
		end

		if not sammywagon and sammyhouse then
			SpawnSammyWagon()
		end
	end
]]--

function c_hoftestclothing(item)
	local player = ConsoleCommandPlayer()
    
	if player ~= nil then
		local prefabs = 
		{
			"wilson", 
			"willow", 
			"wolfgang", 
			"wendy", 
			"wx78", 
			"wickerbottom", 
			"woodie", 
			"waxwell", 
			"wes", 
			"wathgrithr", 
			"webber", 
			"winona",
			"wortox", 
			"wormwood", 
			"warly", 
			"wurt", 
			"walter", 
			"wanda",
		}

		local columns = 3
		local spacing = 2
		local offset  = 4

		local px, py, pz = player.Transform:GetWorldPosition()
		local facing_angle = player.Transform:GetRotation() * DEGREES

		local ox = math.cos(facing_angle) * offset
		local oz = -math.sin(facing_angle) * offset

		for i, prefab in ipairs(prefabs) do
			local row = math.floor((i - 1) / columns)
			local col = (i - 1) % columns

			local x = px + ox + col * spacing
			local z = pz + oz + row * spacing

			local character = c_spawn(prefab)
			character.Transform:SetPosition(x, py, z)

			local equipment = c_spawn(item)
			character.components.inventory:Equip(equipment)
		end
	end
end

function c_hoftestfishregistry(who)
	local player = UserToPlayer(who) or ConsoleCommandPlayer()
    
	local FISHES = require("hof_fishregistrydefs").FISHREGISTRY_FISH_DEFS
	local ROES = require("hof_fishregistrydefs").FISHREGISTRY_ROE_DEFS

	local MAX_SLOTS = 9
	local SLOT_COUNT = 0
	local treasurechest = nil

	if player ~= nil then
		local x, y, z = player.Transform:GetWorldPosition()
		local offset = 0

		c_select(player)
		
		player.components.inventory:Equip(c_spawn("krampus_sack",         nil, true))
		player.components.inventory:Equip(c_spawn("kyno_fishregistryhat", nil, true))

		local function SpawnNewChest()
			treasurechest = SpawnPrefab("treasurechest")
			treasurechest.Transform:SetPosition(x + offset, y, z)
		
			SLOT_COUNT = 0
			offset = offset + 2
		end

		local function GivePrefab(prefab)
			if SLOT_COUNT >= MAX_SLOTS then
				SpawnNewChest()
			end

			if treasurechest ~= nil and treasurechest.components.container ~= nil then
				local item = SpawnPrefab(prefab)
				item.Transform:SetPosition(treasurechest.Transform:GetWorldPosition())
				
				if item ~= nil then
					treasurechest.components.container:GiveItem(item)
					SLOT_COUNT = SLOT_COUNT + 1
				end
			end
		end

		SpawnNewChest()

		for fish_prefab, _ in pairs(FISHES) do
			GivePrefab(fish_prefab)
		end

		for roe_prefab, _ in pairs(ROES) do
			GivePrefab(roe_prefab)
		end
	end
end