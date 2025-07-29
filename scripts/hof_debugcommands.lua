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
		c_give("red_cap",              40, true)
		c_give("green_cap",            40, true)
		c_give("blue_cap",             40, true)
		c_give("moon_cap",             40, true)
		c_give("plantmeat",            20, true)
		c_give("kyno_humanmeat",       20, true)
		c_give("kyno_crabmeat",        20, true)
		c_give("kyno_crabkingmeat",    20, true)
		c_give("kyno_poison_froglegs", 40, true)
		c_give("kyno_seaweeds",        40, true)
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