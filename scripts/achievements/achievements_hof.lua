local modName = "Heap-of-Foods"
local categoryName = "Hof"

local variables =
{
    numEatenFoods          = { net_type = net_shortint, value = 0     },
    numTradedWithPigElder  = { net_type = net_shortint, value = 0     },
    hasBeenInSerenityBiome = { net_type = net_bool,     value = false },
    hasBeenInSeasideBiome  = { net_type = net_bool,     value = false },
    hasBuiltAntChest       = { net_type = net_bool,     value = false },
    hasEatenCaramelCube    = { net_type = net_bool,     value = false },
    hasDrankAlcoholic      = { net_type = net_bool,     value = false },
    hasDrankPirateRum      = { net_type = net_bool,     value = false },
    hasDrankTequila        = { net_type = net_bool,     value = false },
    hasDrankCoffee         = { net_type = net_bool,     value = false },
    hasUsedGrinder         = { net_type = net_bool,     value = false },
    hasFlayedOther         = { net_type = net_bool,     value = false },
    hasCaughtPebble        = { net_type = net_bool,     value = false },
}

local preparedHofFoods      = require("hof_foodrecipes")
local preparedHofWarlyFoods = require("hof_foodrecipes_warly")

local allHofFoods = {}
for k,_ in pairs(preparedHofFoods)      do allHofFoods[k] = true end
for k,_ in pairs(preparedHofWarlyFoods) do allHofFoods[k] = true end

for k,_ in pairs(allHofFoods) do
    variables["hasCookedHof_" .. k] = { net_type = net_bool, value = false }
end

local edibleHofFoods = {}
for k,v in pairs(preparedHofFoods) do
    local blacklist =
    {
        bowlofgears   = true,
        duckyouglermz = true,
        soulstew      = true,
    }
    if not blacklist[k] then
        variables["hasEatenHof_" .. k] = { net_type = net_bool, value = false }
        edibleHofFoods[k] = true
    end
end

for k,v in pairs(preparedHofWarlyFoods) do
    variables["hasEatenHof_" .. k] = { net_type = net_bool, value = false }
    edibleHofFoods[k] = true
end

for k,v in pairs(preparedHofWarlyFoods) do
    variables["hasCookedWarlyHof_" .. k] = { net_type = net_bool, value = false }
end

local preparedHofJar = require("hof_foodrecipes_jar")
local preparedHofKeg = require("hof_foodrecipes_keg")

local allHofDrinks = {}
for k,_ in pairs(preparedHofJar) do allHofDrinks[k] = true end
for k,_ in pairs(preparedHofKeg) do allHofDrinks[k] = true end

for k,_ in pairs(allHofDrinks) do
    variables["hasBrewedHof_" .. k] = { net_type = net_bool, value = false }
end

local hofbooks =
{
    cookbook      = true,
    kyno_brewbook = true,
}

for k,v in pairs(hofbooks) do
    variables["hasCraftedHofBook_" .. k] = { net_type = net_bool, value = false }
end

local function BroadcastEvent(inst, range, event, data)
    local x,y,z = inst.Transform:GetWorldPosition()
    local players = FindPlayersInRange(x, y, z, range or 30)
    for i,v in ipairs(players) do
        v:PushEvent(event, data)
    end
end

local function IsNearPrefabs(inst, prefabList, radius)
    local x,y,z = inst:GetPosition():Get()
    local ents = TheSim:FindEntities(x,y,z, radius or TUNING.KAACHIEVEMENT.EXPLORATION.BROADCAST_RANGE) -- 30
    if type(prefabList) == "string" then prefabList = {prefabList} end
    for k,v in pairs(ents) do
        for _,prefab in pairs(prefabList) do
            if v.prefab == prefab then
                return true
            end
        end
    end
    return false
end

local function IsOnLand(inst)
    return TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition())
end

local function SetupWarlyFunctions(player)
    local manager = player.components.kaAchievementManager

    player:ListenForEvent("oneat", function(inst, data)
        local product = (data ~= nil and data.food ~= nil and data.food:HasTag("preparedfood")) and data.food.prefab or nil
        if product ~= nil then
            local varName = "hasEatenHof_" .. product
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "warlyhof1"}, {varName})
            end
        end
    end)

    player:ListenForEvent("learncookbookrecipe", function(inst, data)
        local varName = "hasCookedWarlyHof_" .. data.product
        if manager[varName] ~= nil then
            manager[varName] = true
            manager:DoAchieve({category = categoryName, name = "warlyhof2"}, {varName})
        end
    end)
end

local function SetupPlayerFunctions(player)
    local manager = player.components.kaAchievementManager

    for k,v in pairs(variables) do
        manager:RegisterVariable(k, v.value)
    end

    if player.prefab == "warly" then
        SetupWarlyFunctions(player)
    end

    player:ListenForEvent("oneat", function(inst, data)
        manager.numEatenFoods = manager.numEatenFoods + 1
        manager:DoAchieve({category = categoryName, name = "eatfoods"}, {"numEatenFoods"})

        local alcoholic = (data ~= nil and data.food ~= nil and data.food:HasTag("alcoholic_drink")) and data.food.prefab or nil
        if alcoholic ~= nil then
            local varName = "hasDrankAlcoholic"
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "drinkalcoholic"}, {"hasDrankAlcoholic"})
            end
        end

        local caramel = data.food.prefab == "gorge_caramel_cube" or nil
        if caramel ~= nil then
            local varName = "hasEatenCaramelCube"
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "caramelcube"}, {"hasEatenCaramelCube"})
            end
        end

		--[[
        local tequila = data.food.prefab == "twistedtequile" or nil
        if tequila ~= nil then
            local varName = "hasDrankTequila"
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "drinktequila"}, {"hasDrankTequila"})
            end
        end

        local piraterum = data.food.prefab == "piraterum" or nil
        if piraterum ~= nil then
            local varName = "hasDrankPirateRum"
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "drinkpiraterum"}, {"hasDrankPirateRum"})
            end
        end
		]]--

        local coffee = data.food.prefab == "coffee" or nil
        if coffee ~= nil then
            local varName = "hasDrankCoffee"
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "drinkcoffee"}, {"hasDrankCoffee"})
            end
        end
    end)

    player:ListenForEvent("onhop", function(inst)
        player:DoTaskInTime(1, function()
            if IsOnLand(player) then
                if IsNearPrefabs(player, {"kyno_meadowisland_sandhill", "kyno_meadowisland_pond"}) then
                    manager["hasBeenInSeasideBiome"] = true
                    manager:DoAchieve({category = categoryName, name = "seasidebiome"}, {"hasBeenInSeasideBiome"})
                elseif IsNearPrefabs(player, {"kyno_serenityisland_shop", "kyno_pond_salt"}) then
                    manager["hasBeenInSerenityBiome"] = true
                    manager:DoAchieve({category = categoryName, name = "serenitybiome"}, {"hasBeenInSerenityBiome"})
                end
            end
        end)
    end)

    player:ListenForEvent("changearea", function(inst, data)
        local id = data and data.id
        if id then
            if string.find(id, "StaticLayoutIsland:Seaside Island") then
                if IsNearPrefabs(player, {"kyno_meadowisland_sandhill", "kyno_meadowisland_pond"}) then
                    manager["hasBeenInSeasideBiome"] = true
                    manager:DoAchieve({category = categoryName, name = "seasidebiome"}, {"hasBeenInSeasideBiome"})
                end
            elseif string.find(id, "StaticLayoutIsland:Serenity Archipelago") then
                if IsNearPrefabs(player, {"kyno_serenityisland_shop", "kyno_pond_salt"}) then
                    manager["hasBeenInSerenityBiome"] = true
                    manager:DoAchieve({category = categoryName, name = "serenitybiome"}, {"hasBeenInSerenityBiome"})
                end
            end
        end

        local x,y,z = player:GetPosition():Get()
        local tile_at_point = TheWorld.Map:GetTileAtPoint(x, y, z)

        if IsLandTile(tile_at_point) then
            if IsNearPrefabs(player, {"kyno_meadowisland_sandhill", "kyno_meadowisland_pond"}) then
                manager["hasBeenInSeasideBiome"] = true
                manager:DoAchieve({category = categoryName, name = "seasidebiome"}, {"hasBeenInSeasideBiome"})
            end
            if IsNearPrefabs(player, {"kyno_serenityisland_shop", "kyno_pond_salt"}) then
                manager["hasBeenInSerenityBiome"] = true
                manager:DoAchieve({category = categoryName, name = "serenitybiome"}, {"hasBeenInSerenityBiome"})
            end
        end
    end)

    player:ListenForEvent("learncookbookrecipe", function(inst, data)
        if data and type(data.product) == "string" then
            local varName = "hasCookedHof_" .. data.product
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "hofcookbook"}, {varName})
            end
		end
    end)

	player:ListenForEvent("learnbrewbookrecipe", function(inst, data)
        if data and type(data.product) == "string" then
            local varName = "hasBrewedHof_" .. data.product
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "hofbrewbook"}, {varName})
            end
		end
    end)

    player:ListenForEvent("builditem", function(player, data)
        if data and data.item then
            local item = data.item
            local varName = "hasCraftedHofBook_" .. item.prefab
            if manager[varName] ~= nil then
                manager[varName] = true
                manager:DoAchieve({category = categoryName, name = "crafthofbooks"}, {varName})
            end

            local prototyper = data.prototyper
            if prototyper and prototyper.prefab == "kyno_mealgrinder" then
                manager["hasUsedGrinder"] = true
                manager:DoAchieve({category = categoryName, name = "grinder"}, {"hasUsedGrinder"})
            end
        end
    end)

    player:ListenForEvent("buildstructure", function(player, data)
        if data and data.item then
            local item = data.item
            if item.prefab == "kyno_antchest" then
                manager["hasBuiltAntChest"] = true
                manager:DoAchieve({category = categoryName, name = "honeydeposit"}, {"hasBuiltAntChest"})
            end
        end
    end)

    player:ListenForEvent("hof_TradedWithPigElder", function(inst, data)
        manager.numTradedWithPigElder = manager.numTradedWithPigElder + 1
        manager:DoAchieve({category = categoryName, name = "pigelder"}, {"numTradedWithPigElder"})
    end)

    player:ListenForEvent("hof_FlayOther", function(inst, data)
        manager["hasFlayedOther"] = true
        manager:DoAchieve({category = categoryName, name = "flayanimal"}, {"hasFlayedOther"})
    end)

    player:ListenForEvent("hof_CaughtCrab", function(inst)
        manager["hasCaughtPebble"] = true
        manager:DoAchieve({category = categoryName, name = "catchpebble"}, {"hasCaughtPebble"})
    end)
end

local function SetupPigElderFunctions(inst)
    local trader = inst.components.trader
    if trader then
        local old_onaccept = trader.onaccept
        trader.onaccept = function(inst, giver, item)
            if giver then
                giver:PushEvent("hof_TradedWithPigElder", {giver = giver, item = item})
            end
        old_onaccept(inst, giver, item)
        end
    end
end

local function SetupCrabTrapFunctions(inst)
    inst:ListenForEvent("harvesttrap", function(inst, data)
        print("harvesttrap", inst)
        local doer = data.doer
        if doer and doer:HasTag("player") then
            local trap = inst.components.trap
            print("trap", trap:GetDebugString())
            if trap.lootprefabs ~= nil and #trap.lootprefabs > 0 then
                for i, v in ipairs(trap.lootprefabs) do
                    print(i, v)
                    if v == "kyno_pebblecrab" then
                        doer:PushEvent("hof_CaughtCrab")
                    end
                end
            end
        end
    end)
end

_G[string.format("Register%sAchievements", categoryName)] = function(inst)
    if inst:HasTag("player") then
        local player = inst

        for k,v in pairs(variables) do
            assert(player.kaAchievementData[k] == nil,
                string.format("Variable name \"%s\" has already been used in \"player.kaAchievementData\".", k))
            player.kaAchievementData[k] = v.net_type(player.GUID, k)
        end
    end

    if not TheNet:GetIsClient() then
        if inst:HasTag("player") then
            SetupPlayerFunctions(inst)
        elseif inst.prefab == "kyno_serenityisland_shop" then
            SetupPigElderFunctions(inst)
        elseif inst.prefab == "kyno_crabtrap_installer" then
            SetupCrabTrapFunctions(inst)
        end
    end
end

local registerEntriesFuncName = string.format("Register%sAchievementEntries", categoryName)
_G[registerEntriesFuncName] = function(root)
    local function GetNumCookedFoods(data)
        local numDone, maxNum, candidates = KaGetNumDone(allHofFoods, function(k,v) return data["hasCookedHof_" .. k] end)
        candidates.extraAtlas = resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")
        return numDone, maxNum, candidates
    end

    local function GetNumBrewedDrinks(data)
        local numDone, maxNum, candidates = KaGetNumDone(allHofDrinks, function(k,v) return data["hasBrewedHof_" .. k] end)
        candidates.extraAtlas = resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")
        return numDone, maxNum, candidates
    end

    local function GetNumCraftedBooks(data)
        local numDone, maxNum, candidates = KaGetNumDone(hofbooks, function(k, v) return data["hasCraftedHofBook_" .. k] == true end)
        candidates.extraAtlas = resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")
        return numDone, maxNum, candidates
    end

    local function GetNumEatenEdibleFoods(data)
        local numDone, maxNum, candidates = KaGetNumDone(edibleHofFoods, function(k, v) return data["hasEatenHof_" .. k] == true end)
        candidates.extraAtlas = resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")
        return numDone, maxNum, candidates
    end

    local function GetNumCookedWarlyPreparedFoods(data)
        local numDone, maxNum, candidates = KaGetNumDone(preparedHofWarlyFoods, function(k, v) return data["hasCookedWarlyHof_" .. k] == true end)
        candidates.extraAtlas = resolvefilepath("images/inventoryimages/hof_inventoryimages.xml")
        return numDone, maxNum, candidates
    end

    local entries =
    {
        {
            name        = "serenitybiome",
            Record      = function(data) return data and data.hasBeenInSerenityBiome end,
            Check       = function(data) return data and data.hasBeenInSerenityBiome end,
        },
        {
            name        = "seasidebiome",
            Record      = function(data) return data and data.hasBeenInSeasideBiome end,
            Check       = function(data) return data and data.hasBeenInSeasideBiome end,
        },
        {
            name        = "eatfoods",
            Record      = function(data) return data and data.numEatenFoods end,
            Check       = function(data) return data and data.numEatenFoods and data.numEatenFoods >= 2000 or false end,
        },
        {
            name        = "hofcookbook",
            Candidates  =
                function(data)
                    local numDone, maxNum, candidates = GetNumCookedFoods(data)
                    return candidates
                end,
            Record      =
                function(data)
                    local numDone, maxNum = GetNumCookedFoods(data)
                    return subfmt(STRINGS.ACCOMPLISHMENTS.UI.PROGRESS_FMT, {num = numDone, max = maxNum})
                end,
            Check       =
                function(data)
                    local numDone, maxNum = GetNumCookedFoods(data)
                    return maxNum ~= 0 and numDone == maxNum
                end,
        },
        {
            name        = "hofbrewbook",
            Candidates  =
                function(data)
                    local numDone, maxNum, candidates = GetNumBrewedDrinks(data)
                    return candidates
                end,
            Record      =
                function(data)
                    local numDone, maxNum = GetNumBrewedDrinks(data)
                    return subfmt(STRINGS.ACCOMPLISHMENTS.UI.PROGRESS_FMT, {num = numDone, max = maxNum})
                end,
            Check       =
                function(data)
                    local numDone, maxNum = GetNumBrewedDrinks(data)
                    return maxNum ~= 0 and numDone == maxNum
                end,
        },
        {
            name        = "warlyhof1",
            Candidates  =
                function(data)
                    local numDone, maxNum, candidates = GetNumEatenEdibleFoods(data)
                    return candidates
                end,
            Record      =
                function(data)
                    local numDone, maxNum = GetNumEatenEdibleFoods(data)
                    return subfmt(STRINGS.ACCOMPLISHMENTS.UI.PROGRESS_FMT, {num = numDone, max = maxNum})
                end,
            Check       =
                function(data)
                    local numDone, maxNum = GetNumEatenEdibleFoods(data)
                    return maxNum ~= 0 and numDone == maxNum
                end,
        },
        {
            name        = "warlyhof2",
            Candidates  =
                function(data)
                    local numDone, maxNum, candidates = GetNumCookedWarlyPreparedFoods(data)
                    return candidates
                end,
            Record      =
                function(data)
                    local numDone, maxNum = GetNumCookedWarlyPreparedFoods(data)
                    return subfmt(STRINGS.ACCOMPLISHMENTS.UI.PROGRESS_FMT, {num = numDone, max = maxNum})
                end,
            Check       =
                function(data)
                    local numDone, maxNum = GetNumCookedWarlyPreparedFoods(data)
                    return maxNum ~= 0 and numDone == maxNum
                end,
        },
        {
            name        = "crafthofbooks",
            Candidates  =
                function(data)
                    local numDone, maxNum, candidates = GetNumCraftedBooks(data)
                    return candidates
                end,
            Record      =
                function(data)
                    local numDone, maxNum = GetNumCraftedBooks(data)
                    return subfmt(STRINGS.ACCOMPLISHMENTS.UI.PROGRESS_FMT, {num=numDone, max=maxNum})
                end,
            Check       =
                function(data)
                    local numDone, maxNum = GetNumCraftedBooks(data)
                    return maxNum ~= 0 and numDone == maxNum
                end,
        },
        {
            name        = "honeydeposit",
            Record      = function(data) return data and data.hasBuiltAntChest end,
            Check       = function(data) return data and data.hasBuiltAntChest or false end,
        },
        {
            name        = "caramelcube",
            Record      = function(data) return data and data.hasEatenCaramelCube end,
            Check       = function(data) return data and data.hasEatenCaramelCube or false end,
            isHidden    = true,
        },
        {
            name        = "drinkalcoholic",
            Record      = function(data) return data and data.hasDrankAlcoholic end,
            Check       = function(data) return data and data.hasDrankAlcoholic or false end,
        },
		--[[
        {
            name        = "drinkpiraterum",
            Record      = function(data) return data and data.hasDrankPirateRum end,
            Check       = function(data) return data and data.hasDrankPirateRum or false end,
            isHidden    = true,
        },
        {
            name        = "drinktequila",
            Record      = function(data) return data and data.hasDrankTequila end,
            Check       = function(data) return data and data.hasDrankTequila or false end,
            isHidden    = true,
        },
		]]--
        {
            name        = "drinkcoffee",
            Record      = function(data) return data and data.hasDrankCoffee end,
            Check       = function(data) return data and data.hasDrankCoffee or false end,
        },
        {
            name        = "pigelder",
            Record      = function(data) return data and data.numTradedWithPigElder end,
            Check       = function(data) return data and data.numTradedWithPigElder and data.numTradedWithPigElder > 0 end,
        },
        {
            name        = "grinder",
            Record      = function(data) return data and data.hasUsedGrinder end,
            Check       = function(data) return data and data.hasUsedGrinder end,
        },
        {
            name        = "flayanimal",
            Record      = function(data) return data and data.hasFlayedOther end,
            Check       = function(data) return data and data.hasFlayedOther end,
        },
        {
            name        = "catchpebble",
            Record      = function(data) return data and data.hasCaughtPebble end,
            Check       = function(data) return data and data.hasCaughtPebble end,
        },
    }

    local category = {}
    for k,v in pairs(entries) do
        print(modName, registerEntriesFuncName, k, v)
        category[k] = v
    end

    print(modName, registerEntriesFuncName, categoryName)
    root[categoryName] = category
end
