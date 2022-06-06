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
		c_give("kyno_roe",          40, true)
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
		c_give("caviar",                40, true)
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

-- Testing Setpieces.
function c_hoflayout(name, offset)
	local player = ConsoleCommandPlayer()
	local obj_layout = require("map/object_layout")
    local entities = {}
    local map_width, map_height = TheWorld.Map:GetSize()
    local add_fn = {
        fn=function(prefab, points_x, points_y, current_pos_idx, entitiesOut, width, height, prefab_list, prefab_data, rand_offset)
        print("adding, ", prefab, points_x[current_pos_idx], points_y[current_pos_idx])
            local x = (points_x[current_pos_idx] - width/2.0)*TILE_SCALE
            local y = (points_y[current_pos_idx] - height/2.0)*TILE_SCALE
            x = math.floor(x*100)/100.0
            y = math.floor(y*100)/100.0
            SpawnPrefab(prefab).Transform:SetPosition(x, 0, y)
        end,
        args={entitiesOut=entities, width=map_width, height=map_height, rand_offset = false, debug_prefab_list=nil}
    }

    local x, y, z = ConsoleWorldPosition():Get()
    x, z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    offset = offset or 3
    obj_layout.Place({math.floor(x) - 3, math.floor(z) - 3}, name, add_fn, nil, TheWorld.Map)
end

-- Quick Test on Serenity Archipelago Stuff.
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